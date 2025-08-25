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
    @Column(name = "starter_unlocked_tests")
    private Integer starterUnlockedTests;

    @Column(name = "pro_unlocked_tests")
    private Integer proUnlockedTests;

    @Column(name = "ultimate_unlocked_tests")
    private Integer ultimateUnlockedTests;

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getSubject() { return subject; }
    public void setSubject(String subject) { this.subject = subject; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Integer getStarterUnlockedTests() { return starterUnlockedTests; }
    public void setStarterUnlockedTests(Integer starterUnlockedTests) { this.starterUnlockedTests = starterUnlockedTests; }

    public Integer getProUnlockedTests() { return proUnlockedTests; }
    public void setProUnlockedTests(Integer proUnlockedTests) { this.proUnlockedTests = proUnlockedTests; }

    public Integer getUltimateUnlockedTests() { return ultimateUnlockedTests; }
    public void setUltimateUnlockedTests(Integer ultimateUnlockedTests) { this.ultimateUnlockedTests = ultimateUnlockedTests; }
} 