<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MockTestPro - Sign In</title>
    <!-- Link to Auth CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/auth.css">
    <!-- Link to PE Dashboard CSS for navbar/footer -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pe-dashboard.css">
    <!-- Link to Auth JavaScript -->
    <script src="${pageContext.request.contextPath}/resources/js/auth.js"></script>
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
                <li><a href="#pricing">Pricing</a></li>
                <li><a href="#dashboard">Dashboard</a></li>
                <li><a href="#subjects">Subjects</a></li>
            </ul>
            <a href="${pageContext.request.contextPath}/login" class="login-btn">Sign In</a>
        </div>
    </nav>

    <!-- Page Selector -->
    <div class="page-selector">
        <button class="page-btn active" data-page="login">Login</button>
        <button class="page-btn" data-page="register">Register</button>
        <button class="page-btn" data-page="forgot">Reset Password</button>
        <button class="page-btn" data-page="otp">OTP Verify</button>
    </div>

    <div class="container">
        <!-- Login Page -->
        <div class="page active" id="login">
            <div class="auth-container">
                <div class="auth-card">
                    <div class="auth-header">
                        <div class="logo">MockTestPro</div>
                        <h1 class="auth-title">Welcome Back</h1>
                        <p class="auth-subtitle">Sign in to continue your exam preparation</p>
                    </div>

                    <form id="login-form" method="post" action="${pageContext.request.contextPath}/login">
                        <div class="form-group">
                            <label class="form-label">Email</label>
                            <input type="email" class="form-input" id="login-email" name="username" placeholder="Enter your email address" required>
                            <div class="error-message">Please enter a valid email address</div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Password</label>
                            <input type="password" class="form-input" id="login-password" name="password" placeholder="Enter your password" required>
                            <div class="error-message">Password must be at least 6 characters</div>
                        </div>

                        <div class="form-extras">
                            <div class="checkbox-group">
                                <input type="checkbox" id="remember-me">
                                <label for="remember-me">Remember me</label>
                            </div>
                            <a href="#" onclick="showPage('forgot')">Forgot Password?</a>
                        </div>

                        <button type="submit" class="btn-primary" id="login-btn">
                            Sign In
                        </button>
                    </form>

                    <div class="message" id="login-message">
                        <% String error = request.getParameter("error"); if (error != null) { %>
                            <div class="message error show"><%= error %></div>
                        <% } %>
                    </div>

                    <div class="social-login">
                        <div class="divider">
                            <span>or continue with</span>
                        </div>
                        <div class="social-buttons">
                            <button class="social-btn" onclick="socialLogin('google')">
                                <span>&#128269;</span> Google
                            </button>
                            <button class="social-btn" onclick="socialLogin('apple')">
                                <span>&#127822;</span> Apple
                            </button>
                        </div>
                    </div>

                    <div class="auth-links">
                        Don't have an account? <a href="#" onclick="showPage('register')">Sign up</a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Register Page -->
        <div class="page" id="register">
            <div class="auth-container">
                <div class="auth-card">
                    <div class="auth-header">
                        <div class="logo">MockTestPro</div>
                        <h1 class="auth-title">Create Account</h1>
                        <p class="auth-subtitle">Join thousands of successful students</p>
                    </div>

                    <form id="register-form">
                        <div class="form-group">
                            <label class="form-label">Full Name</label>
                            <input type="text" class="form-input" id="register-name" placeholder="Enter your full name" required>
                            <div class="error-message">Please enter your full name</div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Email</label>
                            <input type="email" class="form-input" id="register-email" placeholder="Enter your email address" required>
                            <div class="error-message">Please enter a valid email address</div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Password</label>
                            <input type="password" class="form-input" id="register-password" placeholder="Create a strong password" required>
                            <div class="error-message">Password must be at least 8 characters with uppercase, lowercase and number</div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Confirm Password</label>
                            <input type="password" class="form-input" id="register-confirm-password" placeholder="Confirm your password" required>
                            <div class="error-message">Passwords do not match</div>
                        </div>

                        <div class="checkbox-group" style="margin-bottom: 24px;">
                            <input type="checkbox" id="terms-check" required>
                            <label for="terms-check">I agree to the <a href="#" style="color: var(--primary-blue);">Terms of Service</a> and <a href="#" style="color: var(--primary-blue);">Privacy Policy</a></label>
                        </div>

                        <button type="submit" class="btn-primary" id="register-btn">
                            Create Account
                        </button>
                    </form>

                    <div class="message" id="register-message"></div>

                    <div class="social-login">
                        <div class="divider">
                            <span>or sign up with</span>
                        </div>
                        <div class="social-buttons">
                            <button class="social-btn" onclick="socialLogin('google')">
                                <span>&#128269;</span> Google
                            </button>
                            <button class="social-btn" onclick="socialLogin('apple')">
                                <span>&#127822;</span> Apple
                            </button>
                        </div>
                    </div>

                    <div class="auth-links">
                        Already have an account? <a href="#" onclick="showPage('login')">Sign in</a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Forgot Password Page -->
        <div class="page" id="forgot">
            <div class="auth-container">
                <div class="auth-card">
                    <div class="auth-header">
                        <div class="logo">MockTestPro</div>
                        <h1 class="auth-title">Reset Password</h1>
                        <p class="auth-subtitle">Enter your email to receive reset instructions</p>
                    </div>

                    <form id="forgot-form">
                        <div class="form-group">
                            <label class="form-label">Email Address</label>
                            <input type="email" class="form-input" id="forgot-email" placeholder="Enter your email address" required>
                            <div class="error-message">Please enter a valid email address</div>
                        </div>

                        <button type="submit" class="btn-primary" id="forgot-btn">
                            Send Reset Link
                        </button>
                    </form>

                    <div class="message" id="forgot-message"></div>

                    <div class="auth-links">
                        Remember your password? <a href="#" onclick="showPage('login')">Sign in</a>
                    </div>
                </div>
            </div>
        </div>

        <!-- OTP Verification Page -->
        <div class="page" id="otp">
            <div class="auth-container">
                <div class="auth-card">
                    <div class="auth-header">
                        <div class="logo">MockTestPro</div>
                        <h1 class="auth-title">Verify OTP</h1>
                        <p class="auth-subtitle">Enter the 6-digit code sent to your phone</p>
                    </div>

                    <form id="otp-form">
                        <div class="form-group">
                            <label class="form-label">Verification Code</label>
                            <div style="display: flex; gap: 12px; justify-content: center; margin-bottom: 24px;">
                                <input type="text" class="otp-input" maxlength="1" style="width: 50px; height: 50px; text-align: center; font-size: 20px; font-weight: bold;">
                                <input type="text" class="otp-input" maxlength="1" style="width: 50px; height: 50px; text-align: center; font-size: 20px; font-weight: bold;">
                                <input type="text" class="otp-input" maxlength="1" style="width: 50px; height: 50px; text-align: center; font-size: 20px; font-weight: bold;">
                                <input type="text" class="otp-input" maxlength="1" style="width: 50px; height: 50px; text-align: center; font-size: 20px; font-weight: bold;">
                                <input type="text" class="otp-input" maxlength="1" style="width: 50px; height: 50px; text-align: center; font-size: 20px; font-weight: bold;">
                                <input type="text" class="otp-input" maxlength="1" style="width: 50px; height: 50px; text-align: center; font-size: 20px; font-weight: bold;">
                            </div>
                        </div>

                        <button type="submit" class="btn-primary" id="otp-btn">
                            Verify Code
                        </button>

                        <button type="button" class="btn-secondary" id="resend-btn">
                            Resend Code (<span id="timer">60</span>s)
                        </button>
                    </form>

                    <div class="message" id="otp-message"></div>

                    <div class="auth-links">
                        <a href="#" onclick="showPage('login')">Back to Sign In</a>
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