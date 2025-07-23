package com.webapp.mocker.models;

import jakarta.persistence.*;
import java.sql.Timestamp;

@Entity
@Table(name = "user_purchases")
public class UserPurchase {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @ManyToOne
    @JoinColumn(name = "user_id")
    private com.webapp.mocker.User user;
    @ManyToOne
    @JoinColumn(name = "plan_id")
    private PremiumPlan plan;
    private Timestamp purchaseDate;
    private Timestamp expiryDate;
    private String status;
    private String razorpayPaymentId;
    // getters and setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public com.webapp.mocker.User getUser() { return user; }
    public void setUser(com.webapp.mocker.User user) { this.user = user; }
    public PremiumPlan getPlan() { return plan; }
    public void setPlan(PremiumPlan plan) { this.plan = plan; }
    public Timestamp getPurchaseDate() { return purchaseDate; }
    public void setPurchaseDate(Timestamp purchaseDate) { this.purchaseDate = purchaseDate; }
    public Timestamp getExpiryDate() { return expiryDate; }
    public void setExpiryDate(Timestamp expiryDate) { this.expiryDate = expiryDate; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getRazorpayPaymentId() { return razorpayPaymentId; }
    public void setRazorpayPaymentId(String razorpayPaymentId) { this.razorpayPaymentId = razorpayPaymentId; }
} 