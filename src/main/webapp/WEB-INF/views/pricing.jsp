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
                    
                    <div class="pricing-card featured">
                        <h3>Pro</h3>
                        <div class="price">&#8377;499</div>
                        <div class="period">per month</div>
                        <ul class="pricing-features">
                            <li>Unlimited mock papers</li>
                            <li>Detailed explanations</li>
                            <li>Advanced analytics</li>
                            <li>Custom test creator</li>
                            <li>AI recommendations</li>
                            <li>Priority support</li>
                        </ul>
                        <button id="buy-pro-btn" class="pricing-btn featured">Choose Pro</button>
                    </div>
                    
                    <div class="pricing-card">
                        <h3>Ultimate</h3>
                        <div class="price">&#8377;999</div>
                        <div class="period">per month</div>
                        <ul class="pricing-features">
                            <li>Everything in Pro</li>
                            <li>Previous year papers</li>
                            <li>Live doubt chat</li>
                            <li>1-on-1 mentorship</li>
                            <li>Offline access</li>
                            <li>Performance insights</li>
                        </ul>
                        <button id="buy-ultimate-btn" class="pricing-btn primary">Choose Ultimate</button>
                    </div>
                </div>
            </div>
        </section>
    </div>

    <jsp:include page="footer.jsp" />

    <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
    <script>
    (function(){
        function buy(planId) {
        var loggedIn = "<%= loggedIn %>" === "true";
        if (!loggedIn) {
            window.location.href = "${pageContext.request.contextPath}/login";
            return;
        }
            fetch(`${pageContext.request.contextPath}/create-order?planId=${planId}`, { method: 'POST', credentials: 'include' })
            .then(res => { if (!res.ok) throw new Error('Order creation failed'); return res.json(); })
        .then(data => {
            var options = {
                    key: 'rzp_test_juGDlBGq2m7P9a',
                    order_id: data.orderId,
                    handler: function (response){
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
            .catch(console.error);
        }
        var proBtn = document.getElementById('buy-pro-btn');
        if (proBtn) proBtn.addEventListener('click', function(e){ e.preventDefault(); buy(1); });
        var ultimateBtn = document.getElementById('buy-ultimate-btn');
        if (ultimateBtn) ultimateBtn.addEventListener('click', function(e){ e.preventDefault(); buy(2); });
    })();
    </script>
</body>
</html> 