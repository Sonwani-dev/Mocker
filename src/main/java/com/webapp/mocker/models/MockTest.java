package com.webapp.mocker.models;

import jakarta.persistence.*;

@Entity
@Table(name = "mock_tests")
public class MockTest {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "topic_id", nullable = false)
    private Topic topic;

    @Column(nullable = false)
    private int testNumber; // e.g. 1, 2, 3, ...

    private String name; // Optional: e.g. "Mock Test 1"
    private String description; // Optional

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Topic getTopic() { return topic; }
    public void setTopic(Topic topic) { this.topic = topic; }

    public int getTestNumber() { return testNumber; }
    public void setTestNumber(int testNumber) { this.testNumber = testNumber; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
} 