package com.webapp.mocker.models;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;

public interface UserPurchaseRepository extends JpaRepository<UserPurchase, Long> {
    @Query("SELECT up FROM UserPurchase up WHERE up.user.id = :userId AND up.status = 'ACTIVE' AND up.expiryDate > CURRENT_TIMESTAMP")
    List<UserPurchase> findActivePurchasesByUserId(@Param("userId") Long userId);
} 