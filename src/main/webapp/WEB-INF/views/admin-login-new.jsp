<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MockTestPro - Admin Login</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin-login.css">
</head>
<body class="theme-gradient">
    <!-- Floating Background Elements -->
    <div class="floating-elements">
        <div class="float-element"></div>
        <div class="float-element"></div>
        <div class="float-element"></div>
        <div class="float-element"></div>
    </div>

    <!-- Navigation -->
    <nav class="nav">
        <div class="nav-container">
            <a href="${pageContext.request.contextPath}/" class="logo">MockTestPro</a>
            <ul class="nav-links">
                <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                <li><a href="${pageContext.request.contextPath}/pricing">Pricing</a></li>
                <li><a href="${pageContext.request.contextPath}/login">User Login</a></li>
            </ul>
            <div class="nav-actions">
                <div class="theme-selector">
                    <div class="theme-indicator active" id="themeIndicator"></div>
                    <div class="theme-dropdown" id="themeDropdown">
                        <div class="theme-grid">
                            <button class="theme-option active" onclick="setTheme('gradient', this)" title="Gradient" data-theme="gradient"></button>
                            <button class="theme-option" onclick="setTheme('dark', this)" title="Dark Mode" data-theme="dark"></button>
                            <button class="theme-option" onclick="setTheme('minimal', this)" title="Minimalist" data-theme="minimal"></button>
                            <button class="theme-option" onclick="setTheme('neon', this)" title="Neon Cyber" data-theme="neon"></button>
                            <button class="theme-option" onclick="setTheme('nature', this)" title="Nature" data-theme="nature"></button>
                            <button class="theme-option" onclick="setTheme('warm', this)" title="Warm Sunset" data-theme="warm"></button>
                        </div>
                        <div class="theme-label">Choose Theme</div>
                    </div>
                </div>
            </div>
        </div>
    </nav>

    <!-- Login Container -->
    <div class="login-container">
        <div class="login-card">
            <div class="admin-badge">
                <div class="admin-icon">⚡</div>
                Admin Portal
            </div>
            
            <h1 class="login-title">Welcome Back</h1>
            <p class="login-subtitle">Sign in to access the MockTestPro admin dashboard</p>
            
            <form class="login-form" method="post" action="${pageContext.request.contextPath}/admin/login">
                <c:if test="${not empty error}">
                    <div class="error-message">${error}</div>
                </c:if>
                
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" placeholder="Enter your username" required>
                </div>
                
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" placeholder="Enter your password" required>
                </div>
                
                <button type="submit" class="login-btn">
                    Sign In
                </button>
                
                <div class="forgot-password">
                    <a href="#forgot">Forgot your password?</a>
                </div>
            </form>
            
            <div class="back-home">
                <a href="${pageContext.request.contextPath}/">
                    ← Back to Home
                </a>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/resources/js/admin-login.js"></script>
</body>
</html>
