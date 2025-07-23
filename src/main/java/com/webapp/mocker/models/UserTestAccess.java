package com.webapp.mocker.models;

import jakarta.persistence.*;

@Entity
@Table(name = "user_test_access")
public class UserTestAccess {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private com.webapp.mocker.User user;

    @ManyToOne
    @JoinColumn(name = "topic_id", nullable = false)
    private Topic topic;

    @Column(name = "test_attempted_count")
    private int testAttemptedCount = 0;

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public com.webapp.mocker.User getUser() { return user; }
    public void setUser(com.webapp.mocker.User user) { this.user = user; }

    public Topic getTopic() { return topic; }
    public void setTopic(Topic topic) { this.topic = topic; }

    public int getTestAttemptedCount() { return testAttemptedCount; }
    public void setTestAttemptedCount(int testAttemptedCount) { this.testAttemptedCount = testAttemptedCount; }
} 