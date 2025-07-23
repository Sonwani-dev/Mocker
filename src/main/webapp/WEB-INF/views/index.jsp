<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MockTest Platform</title>
    <!-- Link to CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
</head>
<body>
    <jsp:include page="navbar.jsp" />

    <!-- Hero Section -->
    <section class="hero">
        <div class="container hero-content">
            <div class="hero-text">
                <h1>Elevate Your Exam Prep<br><span class="accent">With Confidence</span></h1>
                <p>Interactive mock tests, smart analytics, and personalized recommendations to boost your scores.</p>
                <div class="hero-buttons">
                    <a href="${pageContext.request.contextPath}/mock-tests" class="btn btn-primary">Start Free Test</a>
                    <a href="${pageContext.request.contextPath}/pricing" class="btn btn-secondary">View Pricing</a>
                </div>
            </div>
            <div class="hero-image">
                <img src="${pageContext.request.contextPath}/resources/images/hero-illustration.svg" alt="Exam Prep Illustration">
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section class="features section">
        <div class="container">
            <div class="section-header">
                <h2>Our Key Features</h2>
                <p>Everything you need for a winning preparation strategy.</p>
                <!-- Pricing button removed as requested -->
            </div>
            <div class="features-grid">
                <div class="feature-card">
                    <img src="${pageContext.request.contextPath}/resources/images/free-tests.png" alt="Free Mock Tests">
                    <h3>Free Mock Tests</h3>
                    <p>Instant access to topic-wise free tests to gauge your strengths.</p>
                </div>
                <div class="feature-card">
                    <img src="${pageContext.request.contextPath}/resources/images/analytics.png" alt="Deep Analytics">
                    <h3>Deep Analytics</h3>
                    <p>Visualize performance, time metrics, and accuracy trends.</p>
                </div>
                <div class="feature-card">
                    <img src="${pageContext.request.contextPath}/resources/images/previous-papers.png" alt="Previous Year Papers">
                    <h3>Prev. Year Papers</h3>
                    <p>Practice with real past papers to familiarize with exam patterns.</p>
                </div>
                <div class="feature-card">
                    <img src="${pageContext.request.contextPath}/resources/images/ai-suggest.png" alt="AI Recommendations">
                    <h3>AI Recommendations</h3>
                    <p>Get dynamic topic suggestions to strengthen weak areas.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Testimonials Section -->
    <section class="testimonials section">
        <div class="container">
            <div class="section-header">
                <h2>What Our Users Say</h2>
            </div>
            <div class="testimonials-slider">
                <div class="testimonial-card">
                    <img src="${pageContext.request.contextPath}/resources/images/user-priya.png" alt="Priya Sharma">
                    <p>"MockTestPro transformed my prep! The analytics helped me focus on weak topics and improved my score by 20%!"</p>
                    <h4> Priya Sharma</h4>
                </div>
                <div class="testimonial-card">
                    <img src="${pageContext.request.contextPath}/resources/images/user-rahul.png" alt="Rahul Kumar">
                    <p>"Loved the previous year papers section. Real exam feel and great explanations."</p>
                    <h4> Rahul Kumar</h4>
                </div>
                <div class="testimonial-card">
                    <img src="${pageContext.request.contextPath}/resources/images/user-sneha.png" alt="Sneha Patel">
                    <p>"The AI suggestions are spot on. It guided me through personalized practice."</p>
                    <h4> Sneha Patel</h4>
                </div>
            </div>
        </div>
    </section>

    <jsp:include page="footer.jsp" />
</body>
</html>