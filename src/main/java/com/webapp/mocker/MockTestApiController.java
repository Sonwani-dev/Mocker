package com.webapp.mocker;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.webapp.mocker.models.AnswerOption;
import com.webapp.mocker.models.AnswerOptionRepository;
import com.webapp.mocker.models.MockTest;
import com.webapp.mocker.models.MockTestRepository;
import com.webapp.mocker.models.Question;
import com.webapp.mocker.models.QuestionRepository;
import com.webapp.mocker.models.UserAnswer;
import com.webapp.mocker.models.UserAnswerRepository;
import com.webapp.mocker.models.UserMockTestAttempt;
import com.webapp.mocker.models.UserMockTestAttemptRepository;

@RestController
@RequestMapping("/api/mocktest")
public class MockTestApiController {
	@Autowired
	private MockTestRepository mockTestRepository;
	@Autowired
	private QuestionRepository questionRepository;
	@Autowired
	private AnswerOptionRepository answerOptionRepository;
	@Autowired
	private UserMockTestAttemptRepository userMockTestAttemptRepository;
	@Autowired
	private UserAnswerRepository userAnswerRepository;

	@GetMapping("/{mockTestId}/config")
	public ResponseEntity<?> getConfig(@PathVariable Long mockTestId) {
		MockTest mt = mockTestRepository.findById(mockTestId).orElse(null);
		if (mt == null) {
			return ResponseEntity.notFound().build();
		}
		Map<String, Object> config = new HashMap<>();
		config.put("mockTestId", mt.getId());
		config.put("durationMinutes", mt.getDurationMinutes() != null ? mt.getDurationMinutes() : 30);
		config.put("numberOfQuestions", mt.getNumberOfQuestions() != null ? mt.getNumberOfQuestions() : 25);
		config.put("testNumber", mt.getTestNumber());
		config.put("topicId", mt.getTopic() != null ? mt.getTopic().getId() : null);
		config.put("topicName", mt.getTopic() != null ? mt.getTopic().getName() : null);
		return ResponseEntity.ok(config);
	}

	@Transactional(readOnly = true)
	@GetMapping("/{mockTestId}/questions")
	public ResponseEntity<?> getQuestions(@PathVariable Long mockTestId) {
		List<Question> questions = questionRepository.findByMockTestIdAndActiveTrueOrderByOrderIndexAsc(mockTestId);
		if (questions.isEmpty()) {
			return ResponseEntity.ok(List.of());
		}
		List<Long> qIds = new ArrayList<>();
		for (Question q : questions) { qIds.add(q.getId()); }
		List<AnswerOption> allOptions = answerOptionRepository.findByQuestionIdInOrderByQuestionIdAscOrderIndexAsc(qIds);
		Map<Long, List<Map<String, Object>>> optionsByQ = new HashMap<>();
		for (AnswerOption opt : allOptions) {
			optionsByQ.computeIfAbsent(opt.getQuestion().getId(), k -> new ArrayList<>())
				.add(Map.of(
					"optionId", opt.getId(),
					"text", opt.getText()
				));
		}
		List<Map<String, Object>> payload = new ArrayList<>();
		for (Question q : questions) {
			Map<String, Object> qDto = new HashMap<>();
			qDto.put("questionId", q.getId());
			qDto.put("text", q.getText());
			qDto.put("explanation", q.getExplanation());
			qDto.put("options", optionsByQ.getOrDefault(q.getId(), List.of()));
			payload.add(qDto);
		}
		return ResponseEntity.ok(payload);
	}

	@PostMapping("/answer")
	public ResponseEntity<?> checkAnswer(@RequestBody Map<String, Object> body) {
		Long questionId = body.get("questionId") instanceof Number ? ((Number) body.get("questionId")).longValue() : null;
		Long optionId = body.get("optionId") instanceof Number ? ((Number) body.get("optionId")).longValue() : null;
		Long attemptId = body.get("attemptId") instanceof Number ? ((Number) body.get("attemptId")).longValue() : null;
		if (questionId == null || optionId == null) {
			return ResponseEntity.badRequest().body(Map.of("error", "questionId and optionId are required"));
		}
		AnswerOption selected = answerOptionRepository.findById(optionId).orElse(null);
		if (selected == null || selected.getQuestion() == null || !Objects.equals(selected.getQuestion().getId(), questionId)) {
			return ResponseEntity.badRequest().body(Map.of("error", "Invalid option for question"));
		}
		// Find correct option id for the question
		List<AnswerOption> options = answerOptionRepository.findByQuestionIdOrderByOrderIndexAsc(questionId);
		Long correctOptionId = null;
		for (AnswerOption o : options) {
			if (Boolean.TRUE.equals(o.getIsCorrect())) { correctOptionId = o.getId(); break; }
		}
		Question q = questionRepository.findById(questionId).orElse(null);
		boolean correct = Boolean.TRUE.equals(selected.getIsCorrect());
		// Persist user answer if attemptId provided
		if (attemptId != null) {
			UserMockTestAttempt attempt = userMockTestAttemptRepository.findById(attemptId).orElse(null);
			if (attempt != null) {
				UserAnswer ua = new UserAnswer();
				ua.setAttempt(attempt);
				ua.setQuestion(q);
				ua.setSelectedOption(selected);
				ua.setIsCorrect(correct);
				userAnswerRepository.save(ua);
			}
		}
		return ResponseEntity.ok(Map.of(
			"correct", correct,
			"correctOptionId", correctOptionId,
			"explanation", q != null ? q.getExplanation() : null
		));
	}

	@PostMapping("/complete")
	public ResponseEntity<?> completeAttempt(@RequestBody Map<String, Object> body) {
		Long userId = body.get("userId") instanceof Number ? ((Number) body.get("userId")).longValue() : null;
		Long mockTestId = body.get("mockTestId") instanceof Number ? ((Number) body.get("mockTestId")).longValue() : null;
		Integer correct = body.get("correct") instanceof Number ? ((Number) body.get("correct")).intValue() : null;
		Integer total = body.get("total") instanceof Number ? ((Number) body.get("total")).intValue() : null;
		if (userId == null || mockTestId == null || correct == null || total == null) {
			return ResponseEntity.badRequest().body(Map.of("error", "userId, mockTestId, correct, total required"));
		}
		UserMockTestAttempt attempt = userMockTestAttemptRepository.findByUserIdAndMockTestId(userId, mockTestId);
		if (attempt == null) {
			attempt = new UserMockTestAttempt();
			com.webapp.mocker.User u = new com.webapp.mocker.User();
			u.setId(userId);
			attempt.setUser(u);
			MockTest mt = new MockTest();
			mt.setId(mockTestId);
			attempt.setMockTest(mt);
		}
		attempt.setAttempted(true);
		attempt.setCorrectCount(correct);
		attempt.setTotalQuestions(total);
		attempt.setPercent(total > 0 ? (int)Math.round((correct * 100.0) / total) : 0);
		userMockTestAttemptRepository.save(attempt);

		// Update overall completion percent for the mock test (simple average of all attempted users)
		try {
			List<UserMockTestAttempt> attempts = userMockTestAttemptRepository.findByMockTestIdAndAttemptedTrue(mockTestId);
			int sum = 0;
			int count = 0;
			for (UserMockTestAttempt a : attempts) {
				if (a.getPercent() != null) { sum += a.getPercent(); count++; }
			}
			MockTest mt = mockTestRepository.findById(mockTestId).orElse(null);
			if (mt != null) {
				mt.setCompletionPercent(count > 0 ? Math.round(sum / (float) count) : 0);
				mockTestRepository.save(mt);
			}
		} catch (Exception ignored) {}

		return ResponseEntity.ok(Map.of("status", "ok"));
	}
}


