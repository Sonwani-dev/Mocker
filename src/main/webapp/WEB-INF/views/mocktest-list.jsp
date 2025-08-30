<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MockTestPro - ${topic.name} Tests</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/mocktest-list.css">
    <script src="${pageContext.request.contextPath}/resources/js/mocktest-list.js"></script>
</head>
<body data-ctx="${pageContext.request.contextPath}">
    <!-- Header -->
    <header class="header nav-on-white">
        <div class="header-container">
            <div class="logo">MockTestPro</div>
            <nav>
                <ul class="nav-links">
                    <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/pe-subjects" class="active">Subjects</a></li>
                    <li><a href="${pageContext.request.contextPath}/pricing">Pricing</a></li>
                    <li><a href="${pageContext.request.contextPath}/pe-subjects">Dashboard</a></li>
                </ul>
            </nav>
            <c:choose>
                <c:when test="${isLoggedIn}">
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
                    <div class="user-profile">
                        <div class="user-avatar">${user.name.charAt(0)}</div>
                        <span>${user.name}</span>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </header>

    <!-- Main Container -->
    <div class="main-container">
        <!-- Page Header -->
        <div class="page-header">
            <h1 class="page-title">Mock Tests for ${topic.name}</h1>
            <p class="page-subtitle">Master ${topic.name} with comprehensive practice tests</p>
            <a href="${pageContext.request.contextPath}/pe-subjects" class="back-to-topics">
                ← Back to Topics
            </a>
        </div>

        <!-- Tests Container -->
        <div class="tests-container">
            <div class="tests-grid">
                <c:forEach var="mockTest" items="${mockTests}" varStatus="status">
                    <div class="test-card ${mockTest.completed ? 'completed' : ''}">
                        <c:if test="${mockTest.completed}">
                            <div class="score-badge">${mockTest.score}%</div>
                        </c:if>
                        <div class="test-header">
                            <div class="test-number">${mockTest.testNumber}</div>
                            <div class="test-status ${mockTest.unlocked ? 'status-unlocked' : 'status-locked'}">
                                ${mockTest.unlocked ? 'Unlocked' : 'Locked'}
                            </div>
                        </div>
                        <h3 class="test-title">${mockTest.name}</h3>
                        <p class="test-description">${mockTest.description}</p>
                        
                        <!-- Test Theory Preview -->
                        <c:if test="${not empty mockTest.theoryText}">
                            <div class="test-theory-preview">
                                <div class="theory-icon">📚</div>
                                <div class="theory-text">
                                    ${mockTest.theoryText.length() > 150 ? mockTest.theoryText.substring(0, 150).concat('...') : mockTest.theoryText}
                                </div>
                            </div>
                        </c:if>
                        
                        <div class="test-stats">
                            <div class="stat-item">
                                <span>⏱</span>
                                <span>${mockTest.durationMinutes} mins</span>
                            </div>
                            <div class="stat-item">
                                <span>📝</span>
                                <span>${mockTest.numberOfQuestions} questions</span>
                            </div>
                            <div class="stat-item">
                                <span>🎯</span>
                                <span>
                                    <c:choose>
                                        <c:when test="${mockTest.attempted}">
                                            Attempted · ${mockTest.score != null ? mockTest.score : 0}%
                                        </c:when>
                                        <c:when test="${mockTest.unlocked}">
                                            Not attempted
                                        </c:when>
                                        <c:otherwise>
                                            Complete Test ${mockTest.testNumber - 1}
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                        <div class="test-actions">
                            <c:choose>
                                <c:when test="${mockTest.unlocked}">
                                    <c:choose>
                                        <c:when test="${mockTest.attempted}">
                                            <button class="btn-start" onclick="window.location.href='${pageContext.request.contextPath}/mocktest/start/${mockTest.id}'">Retake Test</button>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="btn-start" onclick="window.location.href='${pageContext.request.contextPath}/mocktest/start/${mockTest.id}'">Start Test</button>
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <form method="post" action="${pageContext.request.contextPath}/mocktest/unlock" style="display:inline;">
                                        <input type="hidden" name="mockTestId" value="${mockTest.id}" />
                                        <button class="btn-secondary" type="submit">Unlock</button>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</body>
</html>
