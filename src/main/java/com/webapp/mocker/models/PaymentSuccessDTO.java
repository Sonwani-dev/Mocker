package com.webapp.mocker.models;

public class PaymentSuccessDTO {
    private String razorpayPaymentId;
    private String razorpayOrderId;
    private String signature;
    private Long planId;

    public String getRazorpayPaymentId() { return razorpayPaymentId; }
    public void setRazorpayPaymentId(String razorpayPaymentId) { this.razorpayPaymentId = razorpayPaymentId; }
    public String getRazorpayOrderId() { return razorpayOrderId; }
    public void setRazorpayOrderId(String razorpayOrderId) { this.razorpayOrderId = razorpayOrderId; }
    public String getSignature() { return signature; }
    public void setSignature(String signature) { this.signature = signature; }
    public Long getPlanId() { return planId; }
    public void setPlanId(Long planId) { this.planId = planId; }
} 