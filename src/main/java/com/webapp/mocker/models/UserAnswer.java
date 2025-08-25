package com.webapp.mocker.models;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "user_answers")
public class UserAnswer {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "attempt_id", nullable = false)
	private UserMockTestAttempt attempt;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "question_id", nullable = false)
	private Question question;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "selected_option_id")
	private AnswerOption selectedOption; // nullable when skipped

	@Column(name = "is_correct")
	private Boolean isCorrect;

	public Long getId() { return id; }
	public void setId(Long id) { this.id = id; }

	public UserMockTestAttempt getAttempt() { return attempt; }
	public void setAttempt(UserMockTestAttempt attempt) { this.attempt = attempt; }

	public Question getQuestion() { return question; }
	public void setQuestion(Question question) { this.question = question; }

	public AnswerOption getSelectedOption() { return selectedOption; }
	public void setSelectedOption(AnswerOption selectedOption) { this.selectedOption = selectedOption; }

	public Boolean getIsCorrect() { return isCorrect; }
	public void setIsCorrect(Boolean isCorrect) { this.isCorrect = isCorrect; }
}


