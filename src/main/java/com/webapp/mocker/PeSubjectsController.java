package com.webapp.mocker;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

import com.webapp.mocker.User;
import com.webapp.mocker.UserRepository;
import com.webapp.mocker.models.AnswerOption;
import com.webapp.mocker.models.AnswerOptionRepository;
import com.webapp.mocker.models.MockTest;
import com.webapp.mocker.models.MockTestRepository;
import com.webapp.mocker.models.Question;
import com.webapp.mocker.models.QuestionRepository;
import com.webapp.mocker.models.Topic;
import com.webapp.mocker.models.TopicRepository;
import com.webapp.mocker.models.UserMockTestAttempt;
import com.webapp.mocker.models.UserMockTestAttemptRepository;
import com.webapp.mocker.models.UserPurchaseRepository;
import com.webapp.mocker.models.UserTestAccessRepository;
import com.webapp.mocker.models.UserUnlockedTestRepository;
import com.webapp.mocker.models.UserUnlockedTest;

import jakarta.servlet.http.HttpSession;

@Controller
public class PeSubjectsController {
    @Autowired
    private TopicRepository topicRepository;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private UserTestAccessRepository userTestAccessRepository;
    @Autowired
    private UserPurchaseRepository userPurchaseRepository;
    @Autowired
    private MockTestRepository mockTestRepository;
    @Autowired
    private UserMockTestAttemptRepository userMockTestAttemptRepository;
    @Autowired
    private QuestionRepository questionRepository;
    @Autowired
    private AnswerOptionRepository answerOptionRepository;
    @Autowired
    private UserUnlockedTestRepository userUnlockedTestRepository;

    @GetMapping("/pe-subjects")
    public String showPeSubjects(Model model, HttpSession session) {
        String username = (String) session.getAttribute("username");
        User user = null;
        boolean isLoggedIn = false;
        
        if (username != null) {
            user = userRepository.findByUsername(username);
            isLoggedIn = true;
        }

        System.out.println("DEBUG: username=" + username + ", isLoggedIn=" + isLoggedIn + ", user=" + (user != null ? user.getName() : "null"));

        if (user == null && username == null) {
            // Only use demo user for guests
            user = userRepository.findByUsername("demo");
            if (user == null) {
                user = new User();
                user.setUsername("demo");
                user.setName("Demo User");
                user.setEmail("demo@example.com");
                user.setPassword("demo");
                user = userRepository.save(user);
            }
        }
        
        if (user == null) {
            model.addAttribute("topics", new ArrayList<>());
            model.addAttribute("error", "User not found. Please log in again.");
            model.addAttribute("isLoggedIn", false);
            return "pe-subjects-dashboard";
        }
        
        // Cache topics by subject
        List<Topic> topics = topicRepository.findBySubject("Physical Education");
        model.addAttribute("topics", topics);
        model.addAttribute("user", user);
        model.addAttribute("isLoggedIn", isLoggedIn);
        return "pe-subjects-dashboard";
    }

    @GetMapping("/mocktest/start/{mockTestId}")
    public String startMockTest(@PathVariable Long mockTestId, HttpSession session, Model model) {
        String username = (String) session.getAttribute("username");
        User user = null;
        if (username != null) {
            user = userRepository.findByUsername(username);
        }
        if (user == null && username == null) {
            user = userRepository.findByUsername("demo");
            if (user == null) {
                user = new User();
                user.setUsername("demo");
                user.setName("Demo User");
                user.setEmail("demo@example.com");
                user.setPassword("demo");
                user = userRepository.save(user);
            }
        }
        if (user == null) {
            model.addAttribute("message", "User not found. Please log in again.");
            return "access-denied";
        }
        MockTest mockTest = mockTestRepository.findById(mockTestId).orElse(null);
        if (mockTest == null) {
            model.addAttribute("message", "Mock test not found.");
            return "access-denied";
        }
        // Enforce per-topic plan-based unlock counts and user-driven unlock
        Topic topic = mockTest.getTopic();
        int totalTestsInTopic = mockTestRepository.findByTopicIdOrderByTestNumberAsc(topic.getId()).size();
        int allowedTests = computeAllowedTestsForUserAndTopic(user, topic, totalTestsInTopic);
        boolean unlocked = false;
        if (user != null) {
            UserUnlockedTest already = userUnlockedTestRepository.findByUserIdAndMockTestId(user.getId(), mockTest.getId());
            unlocked = already != null;
        }
        if (!unlocked) {
            model.addAttribute("message", "You do not have access to this mock test. Please upgrade for more access.");
            return "access-denied";
        }
        // Validation: test must have questions, the configured count must match,
        // and each question must have options with exactly one correct option
        List<Question> questions = questionRepository.findByMockTestIdOrderByOrderIndexAsc(mockTestId);
        boolean valid = !questions.isEmpty();
        if (valid) {
            for (Question q : questions) {
                List<AnswerOption> opts = answerOptionRepository.findByQuestionIdOrderByOrderIndexAsc(q.getId());
                long correctCount = opts.stream().filter(o -> Boolean.TRUE.equals(o.getIsCorrect())).count();
                if (opts.isEmpty() || correctCount != 1) { valid = false; break; }
            }
        }
        if (valid && mockTest.getNumberOfQuestions() != null && mockTest.getNumberOfQuestions() != questions.size()) {
            valid = false;
        }
        if (!valid) {
            model.addAttribute("message", "This test is not configured correctly. Please contact admin.");
            return "access-denied";
        }

        // Provide topic and test info to the view
        model.addAttribute("topicName", mockTest.getTopic() != null ? mockTest.getTopic().getName() : "");
        model.addAttribute("testNumber", mockTest.getTestNumber());
        model.addAttribute("topicId", mockTest.getTopic() != null ? mockTest.getTopic().getId() : null);
        // Provide duration and question count to the view from the mock test configuration
        Integer durationMinutes = mockTest.getDurationMinutes() != null ? mockTest.getDurationMinutes() : 30;
        Integer numberOfQuestions = mockTest.getNumberOfQuestions() != null ? mockTest.getNumberOfQuestions() : 25;
        model.addAttribute("durationMinutes", durationMinutes);
        model.addAttribute("numberOfQuestions", numberOfQuestions);
        model.addAttribute("rulesText", "Please follow the test rules:\n- Do not refresh the page\n- One question at a time\n- Timer cannot be paused\n- No back navigation");
        model.addAttribute("theoryText", mockTest.getTheoryText() != null ? mockTest.getTheoryText() : "This test covers fundamentals and concepts relevant to the topic. Read carefully before starting.");
        model.addAttribute("mockTestId", mockTestId);
        model.addAttribute("userId", user.getId());
        return "test-demo";
    }

    @GetMapping("/mocktest/analysis")
    public String showAnalysis() {
        return "mocktest-analysis";
    }
    
    @GetMapping("/leaderboard")
    public String showLeaderboard() {
        return "leaderboard";
    }

    @PostMapping("/mocktest/unlock")
    public String unlockMockTest(@RequestParam Long mockTestId, HttpSession session, Model model) {
        String username = (String) session.getAttribute("username");
        User user = null;
        if (username != null) {
            user = userRepository.findByUsername(username);
        }
        if (user == null && username == null) {
            user = userRepository.findByUsername("demo");
            if (user == null) {
                user = new User();
                user.setUsername("demo");
                user.setName("Demo User");
                user.setEmail("demo@example.com");
                user.setPassword("demo");
                user = userRepository.save(user);
            }
        }
        if (user == null) {
            model.addAttribute("message", "User not found. Please log in again.");
            return "access-denied";
        }
        MockTest mockTest = mockTestRepository.findById(mockTestId).orElse(null);
        if (user == null || mockTest == null) {
            model.addAttribute("message", "Invalid request.");
            return "access-denied";
        }
        Topic topic = mockTest.getTopic();
        int totalTestsInTopic = mockTestRepository.findByTopicIdOrderByTestNumberAsc(topic.getId()).size();
        int allowed = computeAllowedTestsForUserAndTopic(user, topic, totalTestsInTopic);
        List<UserUnlockedTest> existing = userUnlockedTestRepository.findByUserIdAndTopicId(user.getId(), topic.getId());
        if (existing.size() >= allowed) {
            return "redirect:/pricing";
        }
        if (userUnlockedTestRepository.findByUserIdAndMockTestId(user.getId(), mockTestId) == null) {
            UserUnlockedTest rec = new UserUnlockedTest();
            rec.setUser(user);
            rec.setTopic(topic);
            rec.setMockTest(mockTest);
            userUnlockedTestRepository.save(rec);
        }
        return "redirect:/topic/" + topic.getId() + "/mocktests";
    }

    @GetMapping("/topic/{topicId}/mocktests")
    public String showMockTestsForTopic(@PathVariable Long topicId, Model model, HttpSession session) {
        String username = (String) session.getAttribute("username");
        User user = null;
        boolean isLoggedIn = false;
        if (username != null) {
            user = userRepository.findByUsername(username);
            isLoggedIn = true;
        }
        if (user == null && username == null) {
            user = userRepository.findByUsername("demo");
            if (user == null) {
                user = new User();
                user.setUsername("demo");
                user.setName("Demo User");
                user.setEmail("demo@example.com");
                user.setPassword("demo");
                user = userRepository.save(user);
            }
        }
        if (user == null) {
            model.addAttribute("error", "User not found. Please log in again.");
            return "access-denied";
        }
        Topic topic = topicRepository.findById(topicId).orElse(null);
        if (topic == null) {
            model.addAttribute("error", "Topic not found.");
            return "access-denied";
        }
        List<MockTest> mockTests = mockTestRepository.findByTopicIdOrderByTestNumberAsc(topicId);
        List<Map<String, Object>> mockTestCards = new ArrayList<>();
        
        // Track completed tests for unlocking logic
        Set<Integer> completedTestNumbers = new HashSet<>();
        
        // Determine plan-based allowed tests and randomly unlock that many per user/topic
        int allowedTests = computeAllowedTestsForUserAndTopic(user, topic, mockTests.size());
        // Use user-stored unlocked tests; if none, start with none and let user unlock manually
        Set<Integer> randomlyUnlocked = new HashSet<>();
        if (user != null) {
            List<UserUnlockedTest> unlocked = userUnlockedTestRepository.findByUserIdAndTopicId(user.getId(), topic.getId());
            for (UserUnlockedTest u : unlocked) {
                randomlyUnlocked.add(u.getMockTest().getTestNumber());
            }
        }

        for (MockTest mockTest : mockTests) {
            Map<String, Object> card = new HashMap<>();
            card.put("id", mockTest.getId());
            card.put("testNumber", mockTest.getTestNumber());
            String displayName = "Mock Test " + mockTest.getTestNumber();
            card.put("name", displayName);
            card.put("description", mockTest.getDescription());
            
            // Check if test is completed based on completion percent
            boolean completed = mockTest.getCompletionPercent() != null && mockTest.getCompletionPercent() > 0;
            card.put("completed", completed);
            
            // Use live data from database
            if (completed) {
                card.put("score", mockTest.getCompletionPercent());
                completedTestNumbers.add(mockTest.getTestNumber());
            }
            
            // Determine user attempted status
            boolean attempted = false;
            Integer overallPercent = null;
            try {
                UserMockTestAttempt attempt = userMockTestAttemptRepository.findByUserIdAndMockTestId(user.getId(), mockTest.getId());
                if (attempt != null && attempt.isAttempted()) {
                    attempted = true;
                    overallPercent = attempt.getPercent();
                }
            } catch (Exception ignored) {}
            card.put("attempted", attempted);
            if (attempted && overallPercent != null) {
                card.put("score", overallPercent);
            }

            // Add duration and questions data
            card.put("durationMinutes", mockTest.getDurationMinutes() != null ? mockTest.getDurationMinutes() : 30);
            card.put("numberOfQuestions", mockTest.getNumberOfQuestions() != null ? mockTest.getNumberOfQuestions() : 25);
            
            // Unlock logic: unlock exactly a random subset sized by allowedTests
            boolean unlocked = randomlyUnlocked.contains(mockTest.getTestNumber());
            card.put("unlocked", unlocked);
            
            mockTestCards.add(card);
        }
        model.addAttribute("topic", topic);
        model.addAttribute("user", user);
        model.addAttribute("isLoggedIn", isLoggedIn);
        model.addAttribute("mockTests", mockTestCards);
        return "mocktest-list";
    }

    private int computeAllowedTestsForUserAndTopic(User user, Topic topic, int totalTests) {
        if (user == null) return Math.max(topic.getFreeUnlockedTests() != null ? topic.getFreeUnlockedTests() : 1, 0);
        List<com.webapp.mocker.models.UserPurchase> purchases = userPurchaseRepository.findActivePurchasesByUserId(user.getId());
        String planName = null;
        if (purchases != null && !purchases.isEmpty() && purchases.get(0).getPlan() != null) {
            planName = purchases.get(0).getPlan().getName();
        }
        Integer free = topic.getFreeUnlockedTests() != null ? topic.getFreeUnlockedTests() : 1;
        Integer silver = topic.getSilverUnlockedTests() != null ? topic.getSilverUnlockedTests() : totalTests;
        Integer gold = topic.getGoldUnlockedTests() != null ? topic.getGoldUnlockedTests() : totalTests;
        Integer platinum = topic.getPlatinumUnlockedTests() != null ? topic.getPlatinumUnlockedTests() : totalTests;
        if (planName != null) {
            if ("Platinum".equalsIgnoreCase(planName)) return Math.min(platinum, totalTests);
            if ("Gold".equalsIgnoreCase(planName)) return Math.min(gold, totalTests);
            if ("Silver".equalsIgnoreCase(planName)) return Math.min(silver, totalTests);
            return Math.min(free, totalTests);
        }
        if (user.isPremium()) return Math.min(silver, totalTests);
        return Math.min(free, totalTests);
    }

    private Set<Integer> selectRandomTestNumbersForUserTopic(User user, Topic topic, List<MockTest> tests, int allowed) {
        // Deprecated: now user chooses which tests to unlock; return empty set
        return new HashSet<>();
    }
} 