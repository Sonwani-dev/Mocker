<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MockTestPro - Theme Selector</title>
    <!-- Link to CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <!-- Link to JavaScript -->
    <script src="${pageContext.request.contextPath}/resources/js/theme.js"></script>
</head>
<body class="theme-gradient index-page">
    <!-- Floating Background Elements -->
    <div class="floating-elements">
        <div class="float-element"></div>
        <div class="float-element"></div>
        <div class="float-element"></div>
        <div class="float-element"></div>
    </div>

    <!-- Include Navbar -->
    <jsp:include page="navbar.jsp" />

    <!-- Hero Section -->
    <section class="hero" id="home">
        <div class="hero-container">
            <h1>Elevate Your Exam Prep</h1>
            <p class="hero-subtitle">Master Physical Education with AI-powered analytics, personalized recommendations, and comprehensive mock tests</p>
            
            <div class="cta-container">
                <a href="${pageContext.request.contextPath}/login" class="btn-primary">
                    Start Free Test
                    <span>&rarr;</span>
                </a>
                <a href="#pricing" class="btn-secondary">View Pricing</a>
            </div>

            <div class="hero-stats">
                <div class="stat-card">
                    <div class="stat-number">50K+</div>
                    <div class="stat-label">Active Students</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">10K+</div>
                    <div class="stat-label">Mock Tests</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">95%</div>
                    <div class="stat-label">Success Rate</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">4.9</div>
                    <div class="stat-label">Rating</div>
                </div>
            </div>
        </div>
    </section>

    <!-- Main Content -->
    <div class="main-content">
        <!-- Features Section -->
        <section class="features">
            <div class="features-container">
                <h2 class="section-title">Why Choose MockTestPro?</h2>
                <p class="section-subtitle">Everything you need for a winning preparation strategy</p>
                
                <div class="features-grid">
                    <div class="feature-card">
                        <div class="feature-icon">&#128202;</div>
                        <h3>Deep Analytics</h3>
                        <p>Visualize performance patterns, identify knowledge gaps, and track your accuracy trends with comprehensive AI-powered insights.</p>
                    </div>
                    <div class="feature-card">
                        <div class="feature-icon">&#127919;</div>
                        <h3>AI Recommendations</h3>
                        <p>Get dynamic, topic-based suggestions powered by machine learning to strengthen your weak areas and optimize study time.</p>
                    </div>
                    <div class="feature-card">
                        <div class="feature-icon">&#128218;</div>
                        <h3>Previous Year Papers</h3>
                        <p>Practice with authentic past papers to understand exam patterns, question types, and boost your confidence.</p>
                    </div>
                    <div class="feature-card">
                        <div class="feature-icon">&#9889;</div>
                        <h3>Instant Results</h3>
                        <p>Receive immediate feedback with detailed explanations, solution steps, and performance metrics for every question.</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- Subjects Section -->
        <section class="subjects" id="subjects">
            <!-- Background Image Container -->
            <div class="subjects-background">
                <div class="subjects-bg-image" id="subjectsBgImage"></div>
                <div class="subjects-overlay"></div>
            </div>
            
            <div class="subjects-container">
                <h2 class="section-title">Physical Education Topics</h2>
                <p class="section-subtitle">Comprehensive coverage of all essential PE concepts</p>
                
                <div class="subjects-grid">
                    <div class="subject-card">
                        <h4>First Aid Basics</h4>
                        <p>Cover essential knowledge of first aid techniques and emergency response procedures</p>
                        <span class="topic-count">12 Topics</span>
                    </div>
                    <div class="subject-card">
                        <h4>Human Anatomy in Sports</h4>
                        <p>Understanding major body systems, joints, and movement mechanics in sports</p>
                        <span class="topic-count">15 Topics</span>
                    </div>
                    <div class="subject-card">
                        <h4>Fitness & Training Methods</h4>
                        <p>Cover training types, fitness testing methodologies, and program planning</p>
                        <span class="topic-count">18 Topics</span>
                    </div>
                    <div class="subject-card">
                        <h4>Sports Rules & Regulations</h4>
                        <p>Rules and scoring systems for common sports like football, basketball, and more</p>
                        <span class="topic-count">20 Topics</span>
                    </div>
                    <div class="subject-card">
                        <h4>Psychology in Sports</h4>
                        <p>Mental preparation, motivation techniques, and concentration in athletics</p>
                        <span class="topic-count">10 Topics</span>
                    </div>
                    <div class="subject-card">
                        <h4>Nutrition for Athletes</h4>
                        <p>Balanced diet principles, supplements, and hydration strategies in sports</p>
                        <span class="topic-count">8 Topics</span>
                    </div>
                </div>
            </div>
        </section>

        <!-- Pricing Section -->
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
                    
                    <div class="pricing-card">
                        <h3>Silver</h3>
                        <div class="price">&#8377;99</div>
                        <div class="period">per month</div>
                        <ul class="pricing-features">
                            <li>Unlimited mock papers</li>
                            <li>Detailed explanations</li>
                            <li>Basic analytics</li>
                            <li>Practice questions</li>
                            <li>Email support</li>
                        </ul>
                        <a href="${pageContext.request.contextPath}/login" class="pricing-btn primary">Choose Silver</a>
                    </div>
                    
                    <div class="pricing-card featured">
                        <h3>Gold</h3>
                        <div class="price">&#8377;199</div>
                        <div class="period">per month</div>
                        <ul class="pricing-features">
                            <li>Everything in Silver</li>
                            <li>Advanced analytics</li>
                            <li>Custom test creator</li>
                            <li>AI recommendations</li>
                            <li>Priority support</li>
                            <li>Performance insights</li>
                        </ul>
                        <a href="${pageContext.request.contextPath}/login" class="pricing-btn featured">Choose Gold</a>
                    </div>
                    
                    <div class="pricing-card">
                        <h3>Platinum</h3>
                        <div class="price">&#8377;299</div>
                        <div class="period">per month</div>
                        <ul class="pricing-features">
                            <li>Everything in Gold</li>
                            <li>Previous year papers</li>
                            <li>Live doubt chat</li>
                            <li>1-on-1 mentorship</li>
                            <li>Offline access</li>
                            <li>Premium support</li>
                        </ul>
                        <a href="${pageContext.request.contextPath}/login" class="pricing-btn primary">Choose Platinum</a>
                    </div>
                </div>
            </div>
        </section>
    </div>

    <!-- Include Footer -->
    <jsp:include page="footer.jsp" />
</body>
</html>