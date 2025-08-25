package com.webapp.mocker.models;

import jakarta.persistence.*;
import com.webapp.mocker.User;

@Entity
@Table(name = "user_mock_test_attempts")
public class UserMockTestAttempt {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne
    @JoinColumn(name = "mock_test_id", nullable = false)
    private MockTest mockTest;

    @Column(nullable = false)
    private boolean attempted = false;

    @Column(name = "correct_count")
    private Integer correctCount;

    @Column(name = "total_questions")
    private Integer totalQuestions;

    @Column(name = "percent")
    private Integer percent;

    // Optionally, add timestamp for attempt
    // private LocalDateTime attemptedAt;

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public MockTest getMockTest() { return mockTest; }
    public void setMockTest(MockTest mockTest) { this.mockTest = mockTest; }

    public boolean isAttempted() { return attempted; }
    public void setAttempted(boolean attempted) { this.attempted = attempted; }

    public Integer getCorrectCount() { return correctCount; }
    public void setCorrectCount(Integer correctCount) { this.correctCount = correctCount; }

    public Integer getTotalQuestions() { return totalQuestions; }
    public void setTotalQuestions(Integer totalQuestions) { this.totalQuestions = totalQuestions; }

    public Integer getPercent() { return percent; }
    public void setPercent(Integer percent) { this.percent = percent; }
} 