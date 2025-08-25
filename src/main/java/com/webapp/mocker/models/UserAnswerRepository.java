package com.webapp.mocker.models;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

public interface UserAnswerRepository extends JpaRepository<UserAnswer, Long> {
	List<UserAnswer> findByAttemptId(Long attemptId);
}


