package com.webapp.mocker.models;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "topics")
public class Topic {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;  // e.g. "Sports Psychology", "Anatomy"

    private String subject;  // e.g. "PE"

    private String description; // For dashboard display

    // Per-package unlocked tests configuration
    @Column(name = "free_unlocked_tests")
    private Integer freeUnlockedTests;

    @Column(name = "silver_unlocked_tests")
    private Integer silverUnlockedTests;

    @Column(name = "gold_unlocked_tests")
    private Integer goldUnlockedTests;

    @Column(name = "platinum_unlocked_tests")
    private Integer platinumUnlockedTests;

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getSubject() { return subject; }
    public void setSubject(String subject) { this.subject = subject; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Integer getFreeUnlockedTests() { return freeUnlockedTests; }
    public void setFreeUnlockedTests(Integer freeUnlockedTests) { this.freeUnlockedTests = freeUnlockedTests; }

    public Integer getSilverUnlockedTests() { return silverUnlockedTests; }
    public void setSilverUnlockedTests(Integer silverUnlockedTests) { this.silverUnlockedTests = silverUnlockedTests; }

    public Integer getGoldUnlockedTests() { return goldUnlockedTests; }
    public void setGoldUnlockedTests(Integer goldUnlockedTests) { this.goldUnlockedTests = goldUnlockedTests; }

    public Integer getPlatinumUnlockedTests() { return platinumUnlockedTests; }
    public void setPlatinumUnlockedTests(Integer platinumUnlockedTests) { this.platinumUnlockedTests = platinumUnlockedTests; }
} 