package com.webapp.mocker;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import com.webapp.mocker.models.Topic;
import com.webapp.mocker.models.TopicRepository;
import java.util.*;
import com.webapp.mocker.User;
import com.webapp.mocker.UserRepository;
import com.webapp.mocker.models.UserTestAccessRepository;
import com.webapp.mocker.models.UserTestAccess;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.PathVariable;
import jakarta.servlet.http.HttpSession;
import com.webapp.mocker.models.UserPurchaseRepository;
import com.webapp.mocker.models.PremiumPlan;
import com.webapp.mocker.models.UserPurchase;
import com.webapp.mocker.models.MockTest;
import com.webapp.mocker.models.MockTestRepository;
import com.webapp.mocker.models.UserMockTestAttempt;
import com.webapp.mocker.models.UserMockTestAttemptRepository;

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

    @GetMapping("/pe-subjects")
    public String showPeSubjects(Model model, HttpSession session) {
        String username = (String) session.getAttribute("username");
        User user = null;
        if (username != null) {
            user = userRepository.findByUsername(username);
        }
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
            return "pe-subjects-dashboard";
        }
        List<Topic> topics = topicRepository.findBySubject("Physical Education");
        model.addAttribute("topics", topics);
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
        // Check if user has access to this mock test
        List<UserPurchase> activePurchases = userPurchaseRepository.findActivePurchasesByUserId(user.getId());
        boolean hasPaid = !activePurchases.isEmpty();
        boolean unlocked = hasPaid ? (mockTest.getTestNumber() <= 20) : (mockTest.getTestNumber() <= 2);
        if (!unlocked) {
            model.addAttribute("message", "You do not have access to this mock test. Please upgrade for more access.");
            return "access-denied";
        }
        // Check if already attempted
        UserMockTestAttempt attempt = userMockTestAttemptRepository.findByUserIdAndMockTestId(user.getId(), mockTestId);
        if (attempt != null && attempt.isAttempted()) {
            model.addAttribute("message", "You have already attempted this mock test.");
            return "access-denied";
        }
        // Mark as attempted
        if (attempt == null) {
            attempt = new UserMockTestAttempt();
            attempt.setUser(user);
            attempt.setMockTest(mockTest);
        }
        attempt.setAttempted(true);
        userMockTestAttemptRepository.save(attempt);
        // Show a sample question (replace with real logic as needed)
        model.addAttribute("question", "What is the full form of PE?");
        model.addAttribute("options", List.of("Physical Education", "Public Exam", "Private Entity", "Physical Exercise"));
        model.addAttribute("mockTestId", mockTestId);
        return "test-demo";
    }

    @GetMapping("/topic/{topicId}/mocktests")
    public String showMockTestsForTopic(@PathVariable Long topicId, Model model, HttpSession session) {
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
            model.addAttribute("error", "User not found. Please log in again.");
            return "access-denied";
        }
        Topic topic = topicRepository.findById(topicId).orElse(null);
        if (topic == null) {
            model.addAttribute("error", "Topic not found.");
            return "access-denied";
        }
        List<MockTest> mockTests = mockTestRepository.findByTopicIdOrderByTestNumberAsc(topicId);
        List<UserPurchase> activePurchases = userPurchaseRepository.findActivePurchasesByUserId(user.getId());
        boolean hasPaid = !activePurchases.isEmpty();
        // Get all attempts for this user and topic
        List<UserMockTestAttempt> attempts = userMockTestAttemptRepository.findByUserIdAndMockTest_TopicId(user.getId(), topicId);
        Map<Long, UserMockTestAttempt> attemptMap = new HashMap<>();
        for (UserMockTestAttempt attempt : attempts) {
            attemptMap.put(attempt.getMockTest().getId(), attempt);
        }
        List<Map<String, Object>> mockTestCards = new ArrayList<>();
        for (MockTest mockTest : mockTests) {
            Map<String, Object> card = new HashMap<>();
            card.put("id", mockTest.getId());
            card.put("testNumber", mockTest.getTestNumber());
            String displayName = "Mock Test " + mockTest.getTestNumber();
            card.put("name", displayName);
            card.put("description", mockTest.getDescription());
            boolean unlocked = hasPaid || mockTest.getTestNumber() <= 2;
            card.put("unlocked", unlocked);
            UserMockTestAttempt attempt = attemptMap.get(mockTest.getId());
            boolean attempted = attempt != null && attempt.isAttempted();
            card.put("attempted", attempted);
            mockTestCards.add(card);
        }
        model.addAttribute("topic", topic);
        model.addAttribute("mockTests", mockTestCards);
        model.addAttribute("hasPaid", hasPaid);
        return "mocktest-list";
    }
} 