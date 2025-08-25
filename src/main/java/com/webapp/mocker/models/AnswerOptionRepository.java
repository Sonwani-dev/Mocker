package com.webapp.mocker.models;

import java.util.Collection;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

public interface AnswerOptionRepository extends JpaRepository<AnswerOption, Long> {
	List<AnswerOption> findByQuestionIdOrderByOrderIndexAsc(Long questionId);
	List<AnswerOption> findByQuestionIdInOrderByQuestionIdAscOrderIndexAsc(Collection<Long> questionIds);
}


