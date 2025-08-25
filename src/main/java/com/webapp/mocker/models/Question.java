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
@Table(name = "questions")
public class Question {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "mock_test_id", nullable = false)
	private MockTest mockTest;

	@Column(nullable = false, length = 1000)
	private String text;

	@Column(length = 2000)
	private String explanation;

	@Column(name = "order_index")
	private Integer orderIndex;

	@Column(name = "active")
	private Boolean active = Boolean.TRUE;

	public Long getId() { return id; }
	public void setId(Long id) { this.id = id; }

	public MockTest getMockTest() { return mockTest; }
	public void setMockTest(MockTest mockTest) { this.mockTest = mockTest; }

	public String getText() { return text; }
	public void setText(String text) { this.text = text; }

	public String getExplanation() { return explanation; }
	public void setExplanation(String explanation) { this.explanation = explanation; }

	public Integer getOrderIndex() { return orderIndex; }
	public void setOrderIndex(Integer orderIndex) { this.orderIndex = orderIndex; }

	public Boolean getActive() { return active; }
	public void setActive(Boolean active) { this.active = active; }
}


