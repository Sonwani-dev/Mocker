<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register - ExamMocker</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/user-avatar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/auth.css">
</head>
<body>
    <jsp:include page="navbar.jsp" />
    <div class="form-container">
        <div class="form-box">
            <h2>Create Account</h2>
            <form action="${pageContext.request.contextPath}/register" method="post">
                <div class="input-group">
                    <label for="name">Full Name</label>
                    <input type="text" name="name" id="name" required>
                </div>
                <div class="input-group">
                    <label for="email">Email</label>
                    <input type="email" name="email" id="email" required>
                </div>
                <div class="input-group">
                    <label for="username">Username</label>
                    <input type="text" name="username" id="username" required>
                </div>
                <div class="input-group">
                    <label for="password">Password</label>
                    <input type="password" name="password" id="password" required>
                </div>
                <button type="submit" class="btn-primary">Register</button>
            </form>
            <p class="switch-link">Already have an account? <a href="${pageContext.request.contextPath}/login">Login</a></p>
            <p class="switch-link"><a href="${pageContext.request.contextPath}/pe-subjects">Go to PE Subjects Dashboard</a></p>
        </div>
    </div>
    <jsp:include page="footer.jsp" />
    <c:if test="${not empty error}">
        <p style="color:red;">${error}</p>
    </c:if>
    <c:if test="${not empty message}">
        <p style="color:green;">${message}</p>
    </c:if>
</body>
</html> 