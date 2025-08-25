package com.webapp.mocker.models;

import jakarta.persistence.*;

@Entity
@Table(name = "answer_options")
public class AnswerOption {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "question_id", nullable = false)
	private Question question;

	@Column(nullable = false, length = 1000)
	private String text;

	@Column(name = "is_correct")
	private Boolean isCorrect = Boolean.FALSE;

	@Column(name = "order_index")
	private Integer orderIndex;

	@Column(name = "active")
	private Boolean active = Boolean.TRUE;

	public Long getId() { return id; }
	public void setId(Long id) { this.id = id; }

	public Question getQuestion() { return question; }
	public void setQuestion(Question question) { this.question = question; }

	public String getText() { return text; }
	public void setText(String text) { this.text = text; }

	public Boolean getIsCorrect() { return isCorrect; }
	public void setIsCorrect(Boolean isCorrect) { this.isCorrect = isCorrect; }

	public Integer getOrderIndex() { return orderIndex; }
	public void setOrderIndex(Integer orderIndex) { this.orderIndex = orderIndex; }

	public Boolean getActive() { return active; }
	public void setActive(Boolean active) { this.active = active; }
}


