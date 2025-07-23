package com.webapp.mocker.models;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UserTestAccessRepository extends JpaRepository<UserTestAccess, Long> {
    UserTestAccess findByUserIdAndTopicId(Long userId, Long topicId);
    List<UserTestAccess> findByUserIdAndTopicIdIn(Long userId, List<Long> topicIds);
} 