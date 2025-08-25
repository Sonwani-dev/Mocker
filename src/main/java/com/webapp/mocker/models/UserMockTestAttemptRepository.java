package com.webapp.mocker.models;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface UserMockTestAttemptRepository extends JpaRepository<UserMockTestAttempt, Long> {
    List<UserMockTestAttempt> findByUserIdAndMockTest_TopicId(Long userId, Long topicId);
    UserMockTestAttempt findByUserIdAndMockTestId(Long userId, Long mockTestId);
    List<UserMockTestAttempt> findByMockTestIdAndAttemptedTrue(Long mockTestId);
} 