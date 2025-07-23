<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login - ExamMocker</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/user-avatar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/auth.css">
</head>
<body>
    <jsp:include page="navbar.jsp" />
    <div class="form-container">
        <div class="form-box">
            <h2>Welcome Back</h2>
            <form action="${pageContext.request.contextPath}/login" method="post">
                <div class="input-group">
                    <label for="username">Username</label>
                    <input type="text" name="username" id="username" required>
                </div>
                <div class="input-group">
                    <label for="password">Password</label>
                    <input type="password" name="password" id="password" required>
                </div>
                <button type="submit" class="btn-primary">Login</button>
            </form>
            <p class="switch-link">Don't have an account?<a href="${pageContext.request.contextPath}/register">Register</a></p>
            <p class="switch-link"><a href="${pageContext.request.contextPath}/pe-subjects">Go to PE Subjects Dashboard</a></p>
        </div>
    </div>
    <jsp:include page="footer.jsp" />
    <c:if test="${not empty error}">
        <p style="color:red;">${error}</p>
    </c:if>
</body>
</html> 