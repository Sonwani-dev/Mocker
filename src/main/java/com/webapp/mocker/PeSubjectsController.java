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
        List<Long> topicIds = new ArrayList<>();
        for (Topic topic : topics) {
            topicIds.add(topic.getId());
        }
        List<UserTestAccess> accessList = userTestAccessRepository.findByUserIdAndTopicIdIn(user.getId(), topicIds);
        Map<Long, UserTestAccess> accessMap = new HashMap<>();
        for (UserTestAccess access : accessList) {
            accessMap.put(access.getTopic().getId(), access);
        }
        // Premium logic: check for active purchase
        List<UserPurchase> activePurchases = userPurchaseRepository.findActivePurchasesByUserId(user.getId());
        System.out.println("[PE SUBJECTS] User: " + user.getUsername() + ", Active Purchases: " + activePurchases.size());
        boolean hasPremium = !activePurchases.isEmpty();
        PremiumPlan userPlan = hasPremium ? activePurchases.get(0).getPlan() : null;
        if (hasPremium && userPlan != null) {
            System.out.println("[PE SUBJECTS] Premium Plan: " + userPlan.getName() + ", Expiry: " + activePurchases.get(0).getExpiryDate());
        }
        List<Map<String, Object>> topicCards = new ArrayList<>();
        int unlockedLimit = 5;
        if (hasPremium && userPlan != null) {
            String planName = userPlan.getName().toLowerCase();
            if (planName.contains("basic")) {
                unlockedLimit = 20;
            } else if (planName.contains("pro") || planName.contains("ultimate")) {
                unlockedLimit = topics.size(); // unlock all
            }
        }
        for (int i = 0; i < topics.size(); i++) {
            Topic topic = topics.get(i);
            Map<String, Object> card = new HashMap<>();
            card.put("id", topic.getId());
            card.put("name", topic.getName());
            card.put("description", topic.getDescription());
            if (hasPremium && userPlan != null) {
                card.put("unlimitedAccess", true);
                card.put("remainingAccess", -1);
                card.put("planName", userPlan.getName());
                boolean locked = i >= unlockedLimit;
                card.put("locked", locked);
            } else {
                card.put("unlimitedAccess", false);
                UserTestAccess access = accessMap.get(topic.getId());
                int remaining = 1;
                if (access != null) {
                    remaining = Math.max(0, 1 - access.getTestAttemptedCount());
                }
                card.put("remainingAccess", remaining);
                boolean locked = i >= unlockedLimit;
                card.put("locked", locked);
            }
            topicCards.add(card);
        }
        model.addAttribute("topics", topicCards);
        if (hasPremium && userPlan != null) {
            model.addAttribute("planName", userPlan.getName());
        }
        return "pe-subjects-dashboard";
    }

    @GetMapping("/mocktest/start/{topicId}")
    public String startMockTest(@PathVariable Long topicId, HttpSession session, Model model) {
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
        UserTestAccess access = userTestAccessRepository.findByUserIdAndTopicId(user.getId(), topicId);
        if (access == null) {
            access = new UserTestAccess();
            access.setUser(user);
            Topic topic = topicRepository.findById(topicId).orElse(null);
            if (topic == null) {
                model.addAttribute("message", "Topic not found.");
                return "access-denied";
            }
            access.setTopic(topic);
            access.setTestAttemptedCount(0);
            userTestAccessRepository.save(access);
        }
        if (user.isPremium()) {
            // Premium users: allow unlimited attempts
            model.addAttribute("question", "What is the full form of PE?");
            model.addAttribute("options", List.of("Physical Education", "Public Exam", "Private Entity", "Physical Exercise"));
            model.addAttribute("topicId", topicId);
            return "test-demo";
        }
        if (access.getTestAttemptedCount() < 1) {
            access.setTestAttemptedCount(access.getTestAttemptedCount() + 1);
            userTestAccessRepository.save(access);
            model.addAttribute("question", "What is the full form of PE?");
            model.addAttribute("options", List.of("Physical Education", "Public Exam", "Private Entity", "Physical Exercise"));
            model.addAttribute("topicId", topicId);
            return "test-demo";
        } else {
            model.addAttribute("message", "You have used all your free attempts for this topic. Please upgrade for more access.");
            return "access-denied";
        }
    }
} 