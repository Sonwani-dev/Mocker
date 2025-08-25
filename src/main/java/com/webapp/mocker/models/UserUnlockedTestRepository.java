package com.webapp.mocker.models;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;

public interface UserUnlockedTestRepository extends JpaRepository<UserUnlockedTest, Long> {
    @Query("SELECT u FROM UserUnlockedTest u WHERE u.user.id = :userId AND u.topic.id = :topicId AND u.expiresAt > CURRENT_TIMESTAMP")
    List<UserUnlockedTest> findByUserIdAndTopicId(@Param("userId") Long userId, @Param("topicId") Long topicId);

    @Query("SELECT u FROM UserUnlockedTest u WHERE u.user.id = :userId AND u.mockTest.id = :mockTestId AND u.expiresAt > CURRENT_TIMESTAMP")
    UserUnlockedTest findByUserIdAndMockTestId(@Param("userId") Long userId, @Param("mockTestId") Long mockTestId);
}


