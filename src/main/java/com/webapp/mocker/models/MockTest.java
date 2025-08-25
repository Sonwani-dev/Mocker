package com.webapp.mocker.models;

import jakarta.persistence.*;

@Entity
@Table(name = "mock_tests")
public class MockTest {
    @Id
    private Long id; // Will be manually set as topicId + testNumber (e.g., 11, 12, 13 for topic 1)

    @ManyToOne
    @JoinColumn(name = "topic_id", nullable = false)
    private Topic topic;

    @Column(nullable = false)
    private int testNumber; // e.g. 1, 2, 3, ...

    private String name; // Optional: e.g. "Mock Test 1"
    private String description; // Optional
    
    @Column(name = "duration_minutes")
    private Integer durationMinutes; // Duration in minutes
    
    @Column(name = "number_of_questions")
    private Integer numberOfQuestions; // Number of questions in the test
    
    @Column(name = "completion_percent")
    private Integer completionPercent; // Completion percentage (0-100)

    @Column(name = "theory_text", columnDefinition = "TEXT")
    private String theoryText;

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
    
    public Integer getDurationMinutes() { return durationMinutes; }
    public void setDurationMinutes(Integer durationMinutes) { this.durationMinutes = durationMinutes; }
    
    public Integer getNumberOfQuestions() { return numberOfQuestions; }
    public void setNumberOfQuestions(Integer numberOfQuestions) { this.numberOfQuestions = numberOfQuestions; }
    
    public Integer getCompletionPercent() { return completionPercent; }
    public void setCompletionPercent(Integer completionPercent) { this.completionPercent = completionPercent; }

    public String getTheoryText() { return theoryText; }
    public void setTheoryText(String theoryText) { this.theoryText = theoryText; }
} 