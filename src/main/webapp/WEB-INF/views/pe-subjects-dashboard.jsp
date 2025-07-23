<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Physical Education Subjects - MockTestPro</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pe-dashboard.css">
</head>
<body>
    <jsp:include page="navbar.jsp" />

    <section class="section">
        <div class="container">
            <div class="section-header">
                <h2>Physical Education Topics</h2>
                <p>Select a topic to start your mock test. Free users have limited attempts.</p>
            </div>
            <div class="topics-grid">
                <c:forEach var="topic" items="${topics}">
                    <div class="topic-card">
                        <h3>${topic.name}</h3>
                        <p>${topic.description}</p>
                        <p><strong>Access:</strong> 
                            <c:choose>
                                <c:when test="${topic.unlimitedAccess}">Unlimited</c:when>
                                <c:otherwise>${topic.remainingAccess} free left</c:otherwise>
                            </c:choose>
                        </p>
                        <c:choose>
                            <c:when test="${topic.locked}">
                                <button class="btn btn-secondary" disabled style="opacity:0.6;cursor:not-allowed;">Locked &#128274;</button>
                            </c:when>
                            <c:when test="${topic.unlimitedAccess}">
                                <a href="${pageContext.request.contextPath}/mocktest/start/${topic.id}" class="btn btn-primary">Start Test</a>
                            </c:when>
                            <c:when test="${topic.remainingAccess > 0}">
                                <a href="${pageContext.request.contextPath}/mocktest/start/${topic.id}" class="btn btn-primary">Start Test</a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/pricing" class="btn btn-secondary">Upgrade for More</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>

    <jsp:include page="footer.jsp" />
</body>
</html> 