<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    boolean loggedIn = session.getAttribute("username") != null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Pricing - MockTestPro</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pricing.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pricing.css">
    <style>
        body { padding-top: 48px; padding-bottom: 48px; }
    </style>
</head>
<body>
    <jsp:include page="navbar.jsp" />
    <div class="container">
        <h1 style="text-align:center; margin-top:2rem;">Choose Your Plan</h1>
        <table class="pricing-table">
            <thead>
                <tr>
                    <th>Feature</th>
                    <th>Free</th>
                    <th>Starter<br><span style='font-size:0.9em;color:#888;'>₹199/month</span></th>
                    <th>Pro<br><span style='font-size:0.9em;color:#888;'>₹499/month</span></th>
                    <th>Ultimate<br><span style='font-size:0.9em;color:#888;'>₹999/month</span></th>
                </tr>
            </thead>
            <tbody>
                <tr class="feature-row">
                    <td>Topic-wise Mock Papers</td>
                    <td>Limited (1 per topic)</td>
                    <td>20 mock papers</td>
                    <td>Unlimited</td>
                    <td>Unlimited</td>
                </tr>
                <tr class="feature-row">
                    <td>Previous Year Papers</td>
                    <td>&#10060;</td>
                    <td>&#10060;</td>
                    <td>&#10060;</td>
                    <td>&#10004;</td>
                </tr>
                <tr class="feature-row">
                    <td>Answer Explanations</td>
                    <td>&#10060;</td>
                    <td>&#10060;</td>
                    <td>&#10004;</td>
                    <td>&#10004;</td>
                </tr>
                <tr class="feature-row">
                    <td>Performance Analysis</td>
                    <td>Basic (only score)</td>
                    <td>Basic</td>
                    <td>Advanced (topic strength/weakness)</td>
                    <td>Advanced (topic strength/weakness)</td>
                </tr>
                <tr class="feature-row">
                    <td>Custom Mock Test Creator</td>
                    <td>&#10060;</td>
                    <td>&#10060;</td>
                    <td>&#10004;</td>
                    <td>&#10004;</td>
                </tr>
                <tr class="feature-row">
                    <td>Adaptive Learning Suggestions</td>
                    <td>&#10060;</td>
                    <td>&#10060;</td>
                    <td>&#10004;</td>
                    <td>&#10004; (AI recommends weak topics)</td>
                </tr>
                <tr class="feature-row">
                    <td>Live Doubt Chat</td>
                    <td>&#10060;</td>
                    <td>&#10060;</td>
                    <td>&#10060;</td>
                    <td>&#10004;</td>
                </tr>
                <tr>
                    <td></td>
                    <td><button class="btn-upgrade" style="width:100%;">Get Started</button></td>
                    <td><button id="buy-starter-btn" class="btn-upgrade" style="width:100%;">Buy Starter</button></td>
                    <td><button class="btn-upgrade" style="width:100%;">Buy Pro</button></td>
                    <td><button class="btn-upgrade" style="width:100%;">Buy Ultimate</button></td>
                </tr>
            </tbody>
        </table>
    </div>
    <jsp:include page="footer.jsp" />
    <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
    <script>
    document.getElementById('buy-starter-btn').onclick = function(e) {
        e.preventDefault();
        var loggedIn = "<%= loggedIn %>" === "true";
        console.log('Logged in:', loggedIn);
        if (!loggedIn) {
            window.location.href = "${pageContext.request.contextPath}/login";
            return;
        }
        fetch('/create-order?planId=1', { method: 'POST' })
        .then(res => {
            console.log('create-order response:', res);
            if (!res.ok) { throw new Error('Order creation failed'); }
            return res.json();
        })
        .then(data => {
            var options = {
                "key": "rzp_test_juGDlBGq2m7P9a", // Replace with your Razorpay key
                "amount": "19900", // Or get from plan
                "currency": "INR",
                "name": "MockTestPro",
                "order_id": data.orderId,
                "handler": function (response){
                    fetch('/payment-success', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/json'},
                        body: JSON.stringify({
                            razorpay_payment_id: response.razorpay_payment_id,
                            razorpay_order_id: response.razorpay_order_id,
                            signature: response.razorpay_signature,
                            planId: 1 // Use actual planId
                        })
                    }).then(() => window.location.href = "/pe-subjects");
                }
            };
            var rzp1 = new Razorpay(options);
            rzp1.open();
        })
        .catch(err => {
            console.error(err);
        });
    };
    </script>
</body>
</html> 