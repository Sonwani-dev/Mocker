package com.webapp.mocker.models;

import jakarta.persistence.*;
import java.sql.Timestamp;

@Entity
@Table(name = "user_unlocked_tests")
public class UserUnlockedTest {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private com.webapp.mocker.User user;

    @ManyToOne
    @JoinColumn(name = "topic_id", nullable = false)
    private Topic topic;

    @ManyToOne
    @JoinColumn(name = "mock_test_id", nullable = false)
    private MockTest mockTest;

    @Column(name = "unlocked_at", nullable = false)
    private Timestamp unlockedAt = new Timestamp(System.currentTimeMillis());

    @Column(name = "expires_at", nullable = false)
    private Timestamp expiresAt;

    @PrePersist
    protected void onCreate() {
        if (unlockedAt == null) {
            unlockedAt = new Timestamp(System.currentTimeMillis());
        }
        if (expiresAt == null) {
            long ninetyDaysMs = 90L * 24 * 60 * 60 * 1000;
            expiresAt = new Timestamp(unlockedAt.getTime() + ninetyDaysMs);
        }
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public com.webapp.mocker.User getUser() { return user; }
    public void setUser(com.webapp.mocker.User user) { this.user = user; }
    public Topic getTopic() { return topic; }
    public void setTopic(Topic topic) { this.topic = topic; }
    public MockTest getMockTest() { return mockTest; }
    public void setMockTest(MockTest mockTest) { this.mockTest = mockTest; }
    public Timestamp getUnlockedAt() { return unlockedAt; }
    public void setUnlockedAt(Timestamp unlockedAt) { this.unlockedAt = unlockedAt; }
    public Timestamp getExpiresAt() { return expiresAt; }
    public void setExpiresAt(Timestamp expiresAt) { this.expiresAt = expiresAt; }
}


