<!-- Navigation with Integrated Theme Selector -->
<nav class="nav">
    <div class="nav-container">
        <div class="logo">MockTestPro</div>
        <ul class="nav-links">
            <li><a href="${pageContext.request.contextPath}/">Home</a></li>
            <li><a href="${pageContext.request.contextPath}/pe-subjects">Subjects</a></li>
            <li><a href="${pageContext.request.contextPath}/pricing">Pricing</a></li>
            <li><a href="${pageContext.request.contextPath}/leaderboard">🏆 Leaderboard</a></li>
            <li><a href="${pageContext.request.contextPath}/pe-subjects">Dashboard</a></li>
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
            <a href="${pageContext.request.contextPath}/login" class="login-btn">Sign In</a>
        </div>
    </div>
</nav> 