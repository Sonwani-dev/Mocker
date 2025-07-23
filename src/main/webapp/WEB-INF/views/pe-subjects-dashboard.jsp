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
                <p>Select a topic to view its mock tests.</p>
            </div>
            <div class="topics-grid">
                <c:forEach var="topic" items="${topics}">
                    <div class="topic-card">
                        <h3>${topic.name}</h3>
                        <p>${topic.description}</p>
                        <a href="${pageContext.request.contextPath}/topic/${topic.id}/mocktests" class="btn btn-primary">View Mock Tests</a>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>

    <jsp:include page="footer.jsp" />
</body>
</html> 