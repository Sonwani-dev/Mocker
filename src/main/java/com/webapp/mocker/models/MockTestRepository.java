package com.webapp.mocker.models;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface MockTestRepository extends JpaRepository<MockTest, Long> {
    List<MockTest> findByTopicIdOrderByTestNumberAsc(Long topicId);
} 