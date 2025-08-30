<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    boolean loggedIn = session.getAttribute("username") != null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pricing - MockTestPro</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pricing.css">
</head>
<body class="theme-gradient">
    <!-- Floating Background Elements -->
    <div class="floating-elements">
        <div class="float-element"></div>
        <div class="float-element"></div>
        <div class="float-element"></div>
        <div class="float-element"></div>
    </div>

    <jsp:include page="navbar.jsp" />

    <div class="main-content">
        <section class="pricing">
            <div class="pricing-container">
                <h2 class="section-title" id="pricing">Choose Your Plan</h2>
                <p class="section-subtitle">Flexible pricing options designed for every student's needs</p>
                
                <!-- Debug Information (remove in production) -->
                <div style="background: #f8f9fa; border: 1px solid #dee2e6; border-radius: 8px; padding: 16px; margin-bottom: 24px; font-family: monospace; font-size: 12px;">
                    <strong>DEBUG INFO:</strong><br>
                    Silver Plan: ${silverPlan != null ? 'ID: ' + silverPlan.id + ', Price: ₹' + silverPlan.price : 'NOT FOUND'}<br>
                    Gold Plan: ${goldPlan != null ? 'ID: ' + goldPlan.id + ', Price: ₹' + goldPlan.price : 'NOT FOUND'}<br>
                    Platinum Plan: ${platinumPlan != null ? 'ID: ' + platinumPlan.id + ', Price: ₹' + platinumPlan.price : 'NOT FOUND'}<br>
                    User Logged In: ${loggedIn}
                </div>
                
                <div class="pricing-grid">
                    <div class="pricing-card">
                        <h3>Free</h3>
                        <div class="price">&#8377;0</div>
                        <div class="period">Forever</div>
                        <ul class="pricing-features">
                            <li>1 Mock test per topic</li>
                            <li>Basic score analysis</li>
                            <li>Limited practice questions</li>
                            <li>Community support</li>
                        </ul>
                        <a href="${pageContext.request.contextPath}/login" class="pricing-btn secondary">Get Started</a>
                    </div>
                    
                    <div class="pricing-card">
                        <h3>Silver</h3>
                        <div class="price">&#8377;99</div>
                        <div class="period">for 90 days</div>
                        <ul class="pricing-features">
                            <li>Unlimited mock papers</li>
                            <li>Detailed explanations</li>
                            <li>Basic analytics</li>
                            <li>Practice questions</li>
                            <li>Email support</li>
                        </ul>
                        <button id="buy-silver-btn" class="pricing-btn primary">Choose Silver</button>
                    </div>
                    
                    <div class="pricing-card featured">
                        <h3>Gold</h3>
                        <div class="price">&#8377;199</div>
                        <div class="period">for 90 days</div>
                        <ul class="pricing-features">
                            <li>Everything in Silver</li>
                            <li>Advanced analytics</li>
                            <li>Custom test creator</li>
                            <li>AI recommendations</li>
                            <li>Priority support</li>
                            <li>Performance insights</li>
                        </ul>
                        <button id="buy-gold-btn" class="pricing-btn featured">Choose Gold</button>
                    </div>
                    
                    <div class="pricing-card">
                        <h3>Platinum</h3>
                        <div class="price">&#8377;299</div>
                        <div class="period">for 90 days</div>
                        <ul class="pricing-features">
                            <li>Everything in Gold</li>
                            <li>Previous year papers</li>
                            <li>Live doubt chat</li>
                            <li>1-on-1 mentorship</li>
                            <li>Offline access</li>
                            <li>Premium support</li>
                        </ul>
                        <button id="buy-platinum-btn" class="pricing-btn primary">Choose Platinum</button>
                    </div>
                </div>
            </div>
        </section>
    </div>

    <jsp:include page="footer.jsp" />

    <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
    <script>
    (function(){
        // Get plan IDs from backend data
        var silverPlanId = ${silverPlan != null ? silverPlan.id : 'null'};
        var goldPlanId = ${goldPlan != null ? goldPlan.id : 'null'};
        var platinumPlanId = ${platinumPlan != null ? platinumPlan.id : 'null'};
        
        // Debug information
        console.log('=== PLAN IDS DEBUG ===');
        console.log('Silver Plan ID:', silverPlanId);
        console.log('Gold Plan ID:', goldPlanId);
        console.log('Platinum Plan ID:', platinumPlanId);
        console.log('Logged In:', "<%= loggedIn %>");
        
        // Show plan IDs on the page for debugging
        if (silverPlanId) document.getElementById('buy-silver-btn').setAttribute('data-plan-id', silverPlanId);
        if (goldPlanId) document.getElementById('buy-gold-btn').setAttribute('data-plan-id', goldPlanId);
        if (platinumPlanId) document.getElementById('buy-platinum-btn').setAttribute('data-plan-id', platinumPlanId);
        
        function buy(planId) {
            var loggedIn = "<%= loggedIn %>" === "true";
            if (!loggedIn) {
                window.location.href = "${pageContext.request.contextPath}/login";
                return;
            }
            
            if (!planId) {
                console.error('Plan ID not found');
                alert('Plan not available. Please try again later.');
                return;
            }
            
            console.log('Attempting to buy plan with ID:', planId);
            
            fetch(`${pageContext.request.contextPath}/create-order?planId=${planId}`, { method: 'POST', credentials: 'include' })
            .then(res => { 
                console.log('Response status:', res.status);
                if (!res.ok) {
                    console.error('Order creation failed:', res.status);
                    throw new Error('Order creation failed'); 
                }
                return res.json(); 
            })
            .then(data => {
                console.log('Order created successfully:', data);
                var options = {
                    key: 'rzp_test_juGDlBGq2m7P9a',
                    order_id: data.orderId,
                    handler: function (response){
                        console.log('Payment successful:', response);
                        fetch('${pageContext.request.contextPath}/payment-success', {
                            method: 'POST',
                            credentials: 'include',
                            headers: { 'Content-Type': 'application/json' },
                            body: JSON.stringify({
                                razorpay_payment_id: response.razorpay_payment_id,
                                razorpay_order_id: response.razorpay_order_id,
                                signature: response.razorpay_signature,
                                planId: planId
                            })
                        }).then(() => window.location.href = "${pageContext.request.contextPath}/pe-subjects");
                    }
                };
                new Razorpay(options).open();
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Payment initialization failed. Please try again.');
            });
        }
        
        var silverBtn = document.getElementById('buy-silver-btn');
        if (silverBtn) silverBtn.addEventListener('click', function(e){ e.preventDefault(); buy(silverPlanId); });
        
        var goldBtn = document.getElementById('buy-gold-btn');
        if (goldBtn) goldBtn.addEventListener('click', function(e){ e.preventDefault(); buy(goldPlanId); });
        
        var platinumBtn = document.getElementById('buy-platinum-btn');
        if (platinumBtn) platinumBtn.addEventListener('click', function(e){ e.preventDefault(); buy(platinumPlanId); });
    })();
    </script>
</body>
</html> 