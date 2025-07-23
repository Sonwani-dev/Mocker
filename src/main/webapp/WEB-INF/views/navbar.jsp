<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<header class="header">
    <div class="container header-container" style="padding-bottom: 16px;">
        <a href="${pageContext.request.contextPath}/<c:choose><c:when test='${not empty sessionScope.username}'>dashboard</c:when><c:otherwise></c:otherwise></c:choose>" class="logo">MockTest<span class="accent">Pro</span></a>
        <nav>
            <ul class="nav-menu">
                <li><a href="${pageContext.request.contextPath}/<c:choose><c:when test='${not empty sessionScope.username}'>dashboard</c:when><c:otherwise></c:otherwise></c:choose>">Home</a></li>
                <li><a href="${pageContext.request.contextPath}/pricing">Pricing</a></li>
                <li><a href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
                <c:if test="${empty sessionScope.username}">
                    <li><a href="${pageContext.request.contextPath}/login" class="btn btn-outline">Login</a></li>
                </c:if>
                <c:if test="${not empty sessionScope.username}">
                    <li class="user-avatar-dropdown" style="list-style: none;">
                        <div class="user-avatar" id="userAvatar">
                            <c:out value="${sessionScope.name != null ? sessionScope.name.substring(0,1) : sessionScope.username.substring(0,1)}"/>
                        </div>
                        <div class="user-dropdown" id="userDropdown">
                            <div class="user-details">
                                <strong>${sessionScope.name}</strong><br/>
                                <span>${sessionScope.username}</span>
                            </div>
                            <a href="${pageContext.request.contextPath}/profile" class="profile-link">View Profile</a>
                            <form action="${pageContext.request.contextPath}/logout" method="post" style="margin:0;">
                                <button type="submit" class="btn-logout" style="background:none;">Logout</button>
                            </form>
                        </div>
                    </li>
                </c:if>
            </ul>
            <button class="mobile-toggle">☰</button>
        </nav>
    </div>
</header>
<script>
// Improved dropdown show/hide logic
const avatar = document.getElementById('userAvatar');
const dropdown = document.getElementById('userDropdown');
if (avatar && dropdown) {
    let dropdownTimeout;
    avatar.addEventListener('mouseenter', () => {
        clearTimeout(dropdownTimeout);
        dropdown.style.display = 'block';
    });
    avatar.addEventListener('mouseleave', () => {
        dropdownTimeout = setTimeout(() => dropdown.style.display = 'none', 200);
    });
    dropdown.addEventListener('mouseenter', () => {
        clearTimeout(dropdownTimeout);
        dropdown.style.display = 'block';
    });
    dropdown.addEventListener('mouseleave', () => {
        dropdownTimeout = setTimeout(() => dropdown.style.display = 'none', 200);
    });
}
</script> 