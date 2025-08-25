<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Physical Education Topics - MockTestPro</title>
    <!-- Link to PE Dashboard CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pe-dashboard.css">
    <!-- Link to PE Dashboard JavaScript -->
    <script src="${pageContext.request.contextPath}/resources/js/pe-dashboard.js"></script>
</head>
<body>
    <!-- Floating Background Elements -->
    <div class="floating-elements">
        <div class="float-element"></div>
        <div class="float-element"></div>
        <div class="float-element"></div>
        <div class="float-element"></div>
    </div>

    <!-- Glass Navigation -->
    <nav class="nav">
        <div class="nav-container">
            <div class="logo">MockTestPro</div>
            <ul class="nav-links">
                <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                <li><a href="${pageContext.request.contextPath}/pricing">Pricing</a></li>
                <li><a href="${pageContext.request.contextPath}/pe-subjects">Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/pe-subjects" class="active">Subjects</a></li>
            </ul>
            <c:choose>
                <c:when test="${isLoggedIn and user.name ne 'Demo User'}">
                    <div style="display: flex; align-items: center; gap: 16px;">
                        <div class="user-profile">
                            <div class="user-avatar">${user.name.charAt(0)}</div>
                            <span>${user.name}</span>
                        </div>
                        <form action="${pageContext.request.contextPath}/logout" method="post" style="display: inline;">
                            <button type="submit" class="logout-btn">Logout</button>
                        </form>
                    </div>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login" class="login-btn">Sign In</a>
                </c:otherwise>
            </c:choose>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="main-content">
        <!-- Page Header -->
        <div class="page-header">
            <h1 class="page-title">Physical Education Topics</h1>
            <p class="page-subtitle">Master every aspect of Physical Education with our comprehensive topic coverage</p>
        </div>

        <!-- Topics Container -->
        <div class="topics-container">
            <div class="topics-grid">
                <c:forEach var="topic" items="${topics}" varStatus="status">
                    <div class="topic-card fade-in-up">
                        <div class="topic-icon">
                            <c:choose>
                                <c:when test="${topic.name == 'First Aid Basics'}">🩹</c:when>
                                <c:when test="${topic.name == 'Human Anatomy in Sports'}">🦴</c:when>
                                <c:when test="${topic.name == 'Fitness & Training Methods'}">💪</c:when>
                                <c:when test="${topic.name == 'Sports Rules & Regulations'}">⚽</c:when>
                                <c:when test="${topic.name == 'Yoga & Wellness'}">🧘</c:when>
                                <c:when test="${topic.name == 'Psychology in Sports'}">🧠</c:when>
                                <c:when test="${topic.name == 'Physical Education Pedagogy'}">📚</c:when>
                                <c:when test="${topic.name == 'Injury Prevention & Rehabilitation'}">🏥</c:when>
                                <c:when test="${topic.name == 'Nutrition for Athletes'}">🥗</c:when>
                                <c:when test="${topic.name == 'History of Physical Education'}">📜</c:when>
                                <c:otherwise>📖</c:otherwise>
                            </c:choose>
                        </div>
                        <h3 class="topic-title">${topic.name}</h3>
                        <p class="topic-description">${topic.description}</p>
                        <a href="${pageContext.request.contextPath}/topic/${topic.id}/mocktests" class="view-tests-btn">View Mock Tests</a>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- Stats Section -->
        <div class="stats-section">
            <div class="stats-container">
                <h2 class="stats-title">Practice Makes Perfect</h2>
                <p class="stats-subtitle">Join thousands of students mastering Physical Education</p>
                
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-number">2,500+</div>
                        <div class="stat-label">Practice Questions</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">150+</div>
                        <div class="stat-label">Mock Tests</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">10</div>
                        <div class="stat-label">Major Topics</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">98%</div>
                        <div class="stat-label">Accuracy Rate</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="footer">
        <div class="footer-container">
            <div class="footer-grid">
                <div class="footer-section">
                    <h4>Quick Links</h4>
                    <ul>
                        <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                        <li><a href="#pricing">Pricing</a></li>
                        <li><a href="#dashboard">Dashboard</a></li>
                        <li><a href="#contact">Contact</a></li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h4>Resources</h4>
                    <ul>
                        <li><a href="#">Prev Year Papers</a></li>
                        <li><a href="#">Study Guides</a></li>
                        <li><a href="#">Practice Tests</a></li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h4>Legal</h4>
                    <ul>
                        <li><a href="#">Privacy Policy</a></li>
                        <li><a href="#">Terms of Service</a></li>
                    </ul>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2025 MockTestPro. All rights reserved.</p>
            </div>
        </div>
    </footer>
</body>
</html> 