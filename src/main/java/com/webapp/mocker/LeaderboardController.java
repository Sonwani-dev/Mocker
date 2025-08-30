package com.webapp.mocker;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.webapp.mocker.models.*;

import java.util.*;

@RestController
@RequestMapping("/api")
public class LeaderboardController {

    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private UserMockTestAttemptRepository userMockTestAttemptRepository;
    
    @Autowired
    private MockTestRepository mockTestRepository;
    
    @Autowired
    private TopicRepository topicRepository;

    @GetMapping("/leaderboard")
    public ResponseEntity<Map<String, Object>> getLeaderboard(
            @RequestParam(required = false) Long topicId,
            @RequestParam(required = false) Long testId) {
        
        try {
            List<Map<String, Object>> leaderboard = new ArrayList<>();
            
            if (testId != null) {
                // Get leaderboard for specific test
                leaderboard = getTestLeaderboard(testId);
            } else if (topicId != null) {
                // Get leaderboard for specific topic
                leaderboard = getTopicLeaderboard(topicId);
            } else {
                // Get overall leaderboard
                leaderboard = getOverallLeaderboard();
            }
            
            // Calculate statistics
            Map<String, Object> stats = calculateStats(leaderboard);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("leaderboard", leaderboard);
            response.put("stats", stats);
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Failed to load leaderboard: " + e.getMessage());
            return ResponseEntity.status(500).body(errorResponse);
        }
    }

    private List<Map<String, Object>> getOverallLeaderboard() {
        List<Map<String, Object>> leaderboard = new ArrayList<>();
        
        // Get all users who have taken tests
        List<User> users = userRepository.findAll();
        
        for (User user : users) {
            // Get all test attempts for this user - we need to find them differently
            List<UserMockTestAttempt> attempts = new ArrayList<>();
            // Since findByUserId doesn't exist, we'll get all attempts and filter by user
            List<UserMockTestAttempt> allAttempts = userMockTestAttemptRepository.findAll();
            for (UserMockTestAttempt attempt : allAttempts) {
                if (attempt.getUser().getId().equals(user.getId())) {
                    attempts.add(attempt);
                }
            }
            
            if (attempts.isEmpty()) continue;
            
            // Calculate average score using percent field
            double totalScore = 0;
            int totalTests = attempts.size();
            
            for (UserMockTestAttempt attempt : attempts) {
                if (attempt.getPercent() != null) {
                    totalScore += attempt.getPercent();
                }
            }
            
            if (totalScore == 0) continue;
            
            double avgScore = totalScore / totalTests;
            
            Map<String, Object> userData = new HashMap<>();
            userData.put("userId", user.getId());
            userData.put("userName", user.getName() != null ? user.getName() : user.getUsername());
            userData.put("avgScore", round(avgScore, 2));
            userData.put("totalTests", totalTests);
            userData.put("totalTimeTaken", 0); // Not available in current model
            
            leaderboard.add(userData);
        }
        
        // Sort by average score (descending), then by total tests (descending)
        leaderboard.sort((a, b) -> {
            double scoreA = (Double) a.get("avgScore");
            double scoreB = (Double) b.get("avgScore");
            
            if (scoreA != scoreB) {
                return Double.compare(scoreB, scoreA); // Descending
            }
            
            int testsA = (Integer) a.get("totalTests");
            int testsB = (Integer) b.get("totalTests");
            
            return Integer.compare(testsB, testsA); // Descending
        });
        
        return leaderboard;
    }

    private List<Map<String, Object>> getTopicLeaderboard(Long topicId) {
        List<Map<String, Object>> leaderboard = new ArrayList<>();
        
        // Get all tests for this topic
        List<MockTest> tests = mockTestRepository.findByTopicIdOrderByTestNumberAsc(topicId);
        if (tests.isEmpty()) return leaderboard;
        
        // Get all users who have taken tests in this topic
        List<User> users = userRepository.findAll();
        
        for (User user : users) {
            // Get test attempts for this topic only
            List<UserMockTestAttempt> topicAttempts = new ArrayList<>();
            for (MockTest test : tests) {
                UserMockTestAttempt testAttempt = userMockTestAttemptRepository.findByUserIdAndMockTestId(user.getId(), test.getId());
                if (testAttempt != null) {
                    topicAttempts.add(testAttempt);
                }
            }
            
            if (topicAttempts.isEmpty()) continue;
            
            // Calculate average score for this topic
            double totalScore = 0;
            int totalTests = topicAttempts.size();
            
            for (UserMockTestAttempt attempt : topicAttempts) {
                if (attempt.getPercent() != null) {
                    totalScore += attempt.getPercent();
                }
            }
            
            if (totalScore == 0) continue;
            
            double avgScore = totalScore / totalTests;
            
            Map<String, Object> userData = new HashMap<>();
            userData.put("userId", user.getId());
            userData.put("userName", user.getName() != null ? user.getName() : user.getUsername());
            userData.put("avgScore", round(avgScore, 2));
            userData.put("totalTests", totalTests);
            userData.put("totalTimeTaken", 0); // Not available in current model
            
            leaderboard.add(userData);
        }
        
        // Sort by average score (descending)
        leaderboard.sort((a, b) -> {
            double scoreA = (Double) a.get("avgScore");
            double scoreB = (Double) b.get("avgScore");
            return Double.compare(scoreB, scoreA);
        });
        
        return leaderboard;
    }

    private List<Map<String, Object>> getTestLeaderboard(Long testId) {
        List<Map<String, Object>> leaderboard = new ArrayList<>();
        
        // Get all attempts for this specific test
        List<UserMockTestAttempt> allAttempts = userMockTestAttemptRepository.findByMockTestIdAndAttemptedTrue(testId);
        if (allAttempts.isEmpty()) return leaderboard;
        
        // Group by user and get all attempts
        Map<Long, List<UserMockTestAttempt>> userAttempts = new HashMap<>();
        for (UserMockTestAttempt attempt : allAttempts) {
            Long userId = attempt.getUser().getId();
            userAttempts.computeIfAbsent(userId, k -> new ArrayList<>()).add(attempt);
        }
        
        // Convert to leaderboard format
        for (Map.Entry<Long, List<UserMockTestAttempt>> entry : userAttempts.entrySet()) {
            Long userId = entry.getKey();
            List<UserMockTestAttempt> attempts = entry.getValue();
            
            // Get user details
            User user = userRepository.findById(userId).orElse(null);
            if (user == null) continue;
            
            // Calculate average score for this test
            double totalScore = 0;
            int validAttempts = 0;
            
            for (UserMockTestAttempt attempt : attempts) {
                if (attempt.getPercent() != null) {
                    totalScore += attempt.getPercent();
                    validAttempts++;
                }
            }
            
            if (validAttempts == 0) continue;
            
            double avgScore = totalScore / validAttempts;
            
            Map<String, Object> userData = new HashMap<>();
            userData.put("userId", userId);
            userData.put("userName", user.getName() != null ? user.getName() : user.getUsername());
            userData.put("avgScore", round(avgScore, 2));
            userData.put("totalTests", validAttempts);
            userData.put("totalTimeTaken", 0); // Not available in current model
            
            leaderboard.add(userData);
        }
        
        // Sort by score (descending)
        leaderboard.sort((a, b) -> {
            double scoreA = (Double) a.get("avgScore");
            double scoreB = (Double) b.get("avgScore");
            return Double.compare(scoreB, scoreA);
        });
        
        return leaderboard;
    }

    private Map<String, Object> calculateStats(List<Map<String, Object>> leaderboard) {
        Map<String, Object> stats = new HashMap<>();
        
        if (leaderboard.isEmpty()) {
            stats.put("totalUsers", 0);
            stats.put("avgScore", 0.0);
            stats.put("topScore", 0.0);
            stats.put("totalTests", 0);
            return stats;
        }
        
        stats.put("totalUsers", leaderboard.size());
        
        // Calculate average score
        double totalScore = 0;
        double topScore = 0;
        int totalTests = 0;
        
        for (Map<String, Object> user : leaderboard) {
            double score = (Double) user.get("avgScore");
            int tests = (Integer) user.get("totalTests");
            
            totalScore += score;
            totalTests += tests;
            
            if (score > topScore) {
                topScore = score;
            }
        }
        
        stats.put("avgScore", round(totalScore / leaderboard.size(), 2));
        stats.put("topScore", round(topScore, 2));
        stats.put("totalTests", totalTests);
        
        return stats;
    }

    private double round(double value, int places) {
        if (places < 0) throw new IllegalArgumentException();
        
        java.math.BigDecimal bd = java.math.BigDecimal.valueOf(value);
        bd = bd.setScale(places, java.math.RoundingMode.HALF_UP);
        return bd.doubleValue();
    }

    @GetMapping("/topics")
    public ResponseEntity<List<Map<String, Object>>> getTopics() {
        try {
            List<Topic> topics = topicRepository.findAll();
            List<Map<String, Object>> topicList = new ArrayList<>();
            
            for (Topic topic : topics) {
                Map<String, Object> topicData = new HashMap<>();
                topicData.put("id", topic.getId());
                topicData.put("name", topic.getName());
                topicData.put("subject", topic.getSubject());
                topicList.add(topicData);
            }
            
            return ResponseEntity.ok(topicList);
        } catch (Exception e) {
            return ResponseEntity.status(500).build();
        }
    }

    @GetMapping("/topics/{topicId}/tests")
    public ResponseEntity<List<Map<String, Object>>> getTestsByTopic(@PathVariable Long topicId) {
        try {
            List<MockTest> tests = mockTestRepository.findByTopicIdOrderByTestNumberAsc(topicId);
            List<Map<String, Object>> testList = new ArrayList<>();
            
            for (MockTest test : tests) {
                Map<String, Object> testData = new HashMap<>();
                testData.put("id", test.getId());
                testData.put("name", test.getName());
                testData.put("testNumber", test.getTestNumber());
                testList.add(testData);
            }
            
            return ResponseEntity.ok(testList);
        } catch (Exception e) {
            return ResponseEntity.status(500).build();
        }
    }
}
