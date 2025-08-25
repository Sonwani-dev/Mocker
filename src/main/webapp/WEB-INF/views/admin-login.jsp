<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pe-dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/auth.css">
</head>
<body>
    <div class="floating-elements">
        <div class="float-element"></div>
        <div class="float-element"></div>
        <div class="float-element"></div>
        <div class="float-element"></div>
    </div>

    <jsp:include page="navbar.jsp" />

    <div class="main-container" style="max-width:460px; margin:0 auto; padding-top:160px;">
        <div class="tests-container" style="padding:28px;">
            <h2 style="margin-bottom:12px;">Admin Login</h2>
            <c:if test="${not empty error}"><div style="color:#FF3B30; margin:8px 0;">${error}</div></c:if>
            <form method="post" action="${pageContext.request.contextPath}/admin/login">
                <div class="form-group">
                    <label>Username</label>
                    <input name="username" type="text" required />
                </div>
                <div class="form-group">
                    <label>Password</label>
                    <input name="password" type="password" required />
                </div>
                <button class="btn-primary" type="submit">Login</button>
            </form>
        </div>
    </div>
</body>
</html>


