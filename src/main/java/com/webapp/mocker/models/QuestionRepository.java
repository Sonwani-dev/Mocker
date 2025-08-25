package com.webapp.mocker.models;

import java.util.List;

import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

public interface QuestionRepository extends JpaRepository<Question, Long> {
	List<Question> findByMockTestIdOrderByOrderIndexAsc(Long mockTestId);

	@EntityGraph(attributePaths = {})
	List<Question> findByMockTestIdAndActiveTrueOrderByOrderIndexAsc(Long mockTestId);
}


