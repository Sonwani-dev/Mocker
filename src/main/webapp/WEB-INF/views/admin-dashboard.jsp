<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MockTestPro - Admin Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin-modern.css">
</head>
<body class="theme-gradient">
    <!-- Floating Background Elements -->
    <div class="floating-elements">
        <div class="float-element"></div>
        <div class="float-element"></div>
        <div class="float-element"></div>
    </div>

    <!-- Header -->
    <header class="header">
        <div class="header-container">
            <div class="logo">MockTestPro</div>
            <ul class="nav-links">
                <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                <li><a href="${pageContext.request.contextPath}/pe-subjects">Subjects</a></li>
                <li><a href="#dashboard" class="active">Dashboard</a></li>
            </ul>
            <div class="nav-actions">
                <div class="admin-badge">Admin</div>
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
                <form method="post" action="${pageContext.request.contextPath}/admin/logout" style="display: inline;">
                    <button type="submit" class="logout-btn">Logout</button>
                </form>
            </div>
        </div>
    </header>

    <!-- Main Container -->
    <div class="main-container">
        <!-- Dashboard Header -->
        <div class="dashboard-header">
            <h1 class="dashboard-title">Admin Dashboard</h1>
            <p class="dashboard-subtitle">Upload, view and manage mock tests with ease</p>
        </div>

        <!-- Messages -->
        <c:if test="${not empty message}">
            <div class="success-message show">
                <span>✓</span>
                <span>${message}</span>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="error-message show">
                <span>✗</span>
                <span>${error}</span>
            </div>
        </c:if>

        <!-- Stats Grid -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-number">${activeTopics}</div>
                <div class="stat-label">Active Topics</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${totalTests}</div>
                <div class="stat-label">Total Tests</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${studentAttempts}</div>
                <div class="stat-label">Student Attempts</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">98.5%</div>
                <div class="stat-label">System Uptime</div>
            </div>
        </div>

        <!-- Admin Grid -->
        <div class="admin-grid">
            <!-- Create New Topic Section -->
            <div class="admin-section">
                <h2 class="section-title">
                    <div class="section-icon">📚</div>
                    Create New Topic
                </h2>

                <form method="post" action="${pageContext.request.contextPath}/admin/create-topic" onsubmit="document.getElementById('overlay').classList.add('show')">
                    <div class="form-group">
                        <label class="form-label">Topic Name</label>
                        <input type="text" name="topicName" class="form-input" required />
                    </div>
                    <div class="form-group">
                        <label class="form-label">Topic Description</label>
                        <textarea name="topicDescription" class="form-input" rows="2" placeholder="Enter topic description..." style="resize: vertical;"></textarea>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Starter Unlocked Tests</label>
                        <input type="number" name="starterUnlockedTests" class="form-input" min="0" placeholder="e.g., 2">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Pro Unlocked Tests</label>
                        <input type="number" name="proUnlockedTests" class="form-input" min="0" placeholder="e.g., 10">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Ultimate Unlocked Tests</label>
                        <input type="number" name="ultimateUnlockedTests" class="form-input" min="0" placeholder="e.g., 999 (all)">
                    </div>
                    <button class="btn btn-primary" type="submit">
                        <span>➕</span>
                        Create Topic
                    </button>
                </form>
            </div>

            <!-- Upload Test Section -->
            <div class="admin-section">
                <h2 class="section-title">
                    <div class="section-icon">📁</div>
                    Upload Test
                </h2>
                
                <form method="post" action="${pageContext.request.contextPath}/admin/upload" enctype="multipart/form-data" onsubmit="document.getElementById('overlay').classList.add('show')">
                    
                    <!-- Select Topic Dropdown -->
                    <div class="form-group">
                        <label class="form-label">Select Topic</label>
                        <select name="topicId" class="form-select" required>
                            <option value="">-- Select Topic --</option>
                            <c:forEach var="t" items="${topics}">
                                <option value="${t.id}">${t.name}</option>
                            </c:forEach>
                        </select>
                    </div>
            
                    <!-- New topics must be created in the section above -->
            
                    <!-- Test Info -->
                    <div class="form-group">
                        <label class="form-label">Test Name</label>
                        <input type="text" name="testName" class="form-input" required />
                    </div>
                    <div class="form-group">
                        <label class="form-label">Test Description</label>
                        <textarea name="testDescription" class="form-input" rows="3" placeholder="Enter test description..." style="resize: vertical;"></textarea>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Number of Questions</label>
                        <input type="number" name="numberOfQuestions" class="form-input" min="1" required />
                    </div>
                    <div class="form-group">
                        <label class="form-label">Duration (minutes)</label>
                        <input type="number" name="durationMinutes" class="form-input" min="1" required />
                    </div>
                    
                    <!-- Per-package unlock counts are configured in Create New Topic section above -->
                    
                    <!-- File Upload -->
                    <div class="form-group">
                        <label class="form-label">Upload File (.xlsx, .csv, .pdf)</label>
                        <div class="file-upload" onclick="document.getElementById('fileInput').click()">
                            <input type="file" id="fileInput" name="file" accept=".xlsx,.csv,.pdf" required onchange="handleFileSelect(event)" />
                            <div class="upload-icon">📄</div>
                            <div class="upload-text">Click to select file or drag and drop</div>
                            <div class="upload-hint">Supports .xlsx, .csv and .pdf formats</div>
                            <div id="fileName" style="margin-top: 12px; font-weight: 600; color: var(--primary); display: none;"></div>
                        </div>
                        <small style="color: var(--text-secondary); font-size: 12px; margin-top: 8px; display: block;">
                            Required format: 7 columns - Question, Option A, Option B, Option C, Option D, Correct Option (A/B/C/D), Explanation
                        </small>
                        <div style="margin-top: 8px;">
                            <a href="#" onclick="downloadTemplate()" style="color: var(--primary); font-size: 12px; text-decoration: none;">📥 Download Sample CSV</a>
                            <span style="margin: 0 6px; color: var(--text-secondary);">|</span>
                            <a href="${pageContext.request.contextPath}/admin/sample-pdf" style="color: var(--primary); font-size: 12px; text-decoration: none;">📥 Download Sample PDF</a>
                        </div>
                    </div>
            
                    <button class="btn btn-primary" type="submit">
                        <span>📤</span>
                        Upload Test
                    </button>
                </form>
            </div>

            <!-- Test Management Section -->
            <div class="admin-section test-management">
                <h2 class="section-title">
                    <div class="section-icon">🎯</div>
                    Test Management
                </h2>
                
                <p style="margin-bottom: 24px; color: var(--text-secondary);">
                    View test details or delete tests by ID. Test IDs follow the format: Topic ID + Test Number (e.g., 11, 12, 21, 22).
                </p>

                <!-- View Test -->
                <div class="form-group">
                    <label class="form-label">View Test</label>
                    <form method="get" action="${pageContext.request.contextPath}/admin/view-test" style="display: flex; gap: 16px; align-items: end;">
                        <input type="number" name="testId" class="form-input" placeholder="Enter Test ID (e.g., 11, 12, 21, 22)" required style="flex: 1;" />
                        <button class="btn btn-secondary" type="submit">
                            <span>👁️</span>
                            View Test
                        </button>
                    </form>
                </div>

                <!-- Delete Test -->
                <div class="form-group">
                    <label class="form-label">Delete Test</label>
                    <form method="post" action="${pageContext.request.contextPath}/admin/delete" onsubmit="document.getElementById('overlay').classList.add('show')" style="display: flex; gap: 16px; align-items: end;">
                        <input type="number" name="mockTestId" class="form-input" placeholder="Enter Test ID (e.g., 11, 12, 21, 22)" required style="flex: 1;" />
                        <button class="btn btn-danger" type="submit">
                            <span>🗑️</span>
                            Delete Test
                        </button>
                    </form>
                </div>
            </div>
        </div>

        <!-- Recent Activity Section -->
        <div class="admin-section" style="margin-top: 40px;">
            <h2 class="section-title">
                <div class="section-icon">📊</div>
                Recent Activity
            </h2>
            
            <div style="display: grid; gap: 16px;">
                <c:forEach var="test" items="${recentTests}" varStatus="status">
                    <div class="activity-item">
                        <div class="activity-title">Test "${test.name}" uploaded</div>
                        <div class="activity-meta">${test.topic.name} • ${test.numberOfQuestions} questions • ${test.durationMinutes} minutes</div>
                    </div>
                </c:forEach>
                <c:forEach var="topic" items="${recentTopics}" varStatus="status">
                    <div class="activity-item">
                        <div class="activity-title">New topic "${topic.name}" created</div>
                        <div class="activity-meta">Topic ID: ${topic.id} • Available for test creation</div>
                    </div>
                </c:forEach>
                <c:if test="${empty recentTests and empty recentTopics}">
                    <div class="activity-item">
                        <div class="activity-title">No recent activity</div>
                        <div class="activity-meta">Start by creating your first test or topic</div>
                    </div>
                </c:if>
            </div>
        </div>

    </div>

    <!-- Loading Overlay -->
    <div id="overlay" class="overlay">
        <div class="spinner"></div>
    </div>

    <script>
        let isDropdownOpen = false;

        // Theme Management
        function setTheme(theme, element) {
            document.body.classList.remove('theme-gradient', 'theme-dark', 'theme-minimal', 'theme-neon', 'theme-nature', 'theme-warm');
            document.body.classList.add('theme-' + theme);
            
            document.querySelectorAll('.theme-option').forEach(btn => btn.classList.remove('active'));
            element.classList.add('active');
            
            updateThemeIndicator(theme);
            
            document.body.style.transition = 'all 0.5s cubic-bezier(0.4, 0.0, 0.2, 1)';
            setTimeout(() => {
                document.body.style.transition = '';
            }, 500);

            closeThemeDropdown();
        }

        function updateThemeIndicator(theme) {
            const indicator = document.getElementById('themeIndicator');
            const themeColors = {
                'gradient': 'linear-gradient(135deg, #667eea, #764ba2)',
                'dark': 'linear-gradient(135deg, #1a1a1a, #2d2d2d)',
                'minimal': 'linear-gradient(135deg, #ffffff, #f8f9fa)',
                'neon': 'linear-gradient(135deg, #0f0f23, #ff006e)',
                'nature': 'linear-gradient(135deg, #2d5016, #a8e6cf)',
                'warm': 'linear-gradient(135deg, #ff9a56, #ffad56)'
            };
            
            indicator.style.background = themeColors[theme];
            
            if (theme === 'minimal') {
                indicator.style.border = '2px solid rgba(0, 0, 0, 0.2)';
            } else {
                indicator.style.border = '2px solid rgba(255, 255, 255, 0.3)';
            }
        }

        function toggleThemeDropdown() {
            const dropdown = document.getElementById('themeDropdown');
            isDropdownOpen = !isDropdownOpen;
            
            if (isDropdownOpen) {
                dropdown.classList.add('show');
            } else {
                dropdown.classList.remove('show');
            }
        }

        function closeThemeDropdown() {
            const dropdown = document.getElementById('themeDropdown');
            dropdown.classList.remove('show');
            isDropdownOpen = false;
        }

        // File Upload Handling
        function handleFileSelect(event) {
            const file = event.target.files[0];
            const fileName = document.getElementById('fileName');
            const uploadArea = document.querySelector('.file-upload');
            
            if (file) {
                fileName.textContent = `Selected: ${file.name}`;
                fileName.style.display = 'block';
                uploadArea.style.borderColor = 'var(--primary)';
                uploadArea.style.background = 'rgba(0, 122, 255, 0.1)';
            } else {
                fileName.style.display = 'none';
                uploadArea.style.borderColor = 'var(--border-color)';
                uploadArea.style.background = 'var(--surface)';
            }
        }

        // New Topic Toggle removed; new topics are created via dedicated section
        
        // Download Template
        function downloadTemplate() {
            const csvContent = "Question,Option A,Option B,Option C,Option D,Correct Option,Explanation\n" +
                             "What is the capital of France?,Paris,London,Berlin,Madrid,A,Paris is the capital and largest city of France.\n" +
                             "Which planet is closest to the Sun?,Mercury,Venus,Earth,Mars,A,Mercury is the first planet from the Sun and the smallest in the Solar System.\n" +
                             "What is 2 + 2?,3,4,5,6,B,Basic arithmetic: 2 + 2 = 4.";
            
            const blob = new Blob([csvContent], { type: 'text/csv' });
            const url = window.URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = 'sample_template.csv';
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            window.URL.revokeObjectURL(url);
        }

        // Event Listeners
        document.getElementById('themeIndicator').addEventListener('click', toggleThemeDropdown);

        document.addEventListener('click', (e) => {
            const themeSelector = document.querySelector('.theme-selector');
            if (!themeSelector.contains(e.target)) {
                closeThemeDropdown();
            }
        });

        document.getElementById('themeDropdown').addEventListener('click', (e) => {
            e.stopPropagation();
        });

        // Initialize
        window.addEventListener('load', () => {
            updateThemeIndicator('gradient');
            document.body.style.opacity = '0';
            document.body.style.transition = 'opacity 0.8s ease';
            setTimeout(() => {
                document.body.style.opacity = '1';
            }, 100);
        });

        // Enhanced interactions
        document.querySelectorAll('.btn').forEach(button => {
            button.addEventListener('click', function(e) {
                const ripple = document.createElement('span');
                const rect = this.getBoundingClientRect();
                const size = Math.max(rect.width, rect.height);
                const x = e.clientX - rect.left - size / 2;
                const y = e.clientY - rect.top - size / 2;
                
                ripple.style.cssText = `
                    position: absolute;
                    width: ${size}px;
                    height: ${size}px;
                    left: ${x}px;
                    top: ${y}px;
                    border-radius: 50%;
                    background: rgba(255, 255, 255, 0.6);
                    transform: scale(0);
                    animation: ripple 0.6s cubic-bezier(0.4, 0.0, 0.2, 1);
                    pointer-events: none;
                `;
                
                this.style.position = 'relative';
                this.style.overflow = 'hidden';
                this.appendChild(ripple);
                
                setTimeout(() => {
                    ripple.remove();
                }, 600);
            });
        });

        // Add ripple animation
        const style = document.createElement('style');
        style.textContent = `
            @keyframes ripple {
                to {
                    transform: scale(4);
                    opacity: 0;
                }
            }
        `;
        document.head.appendChild(style);

        // Smooth scrolling and dynamic header
        window.addEventListener('scroll', () => {
            const header = document.querySelector('.header');
            const scrollY = window.scrollY;
            
            if (scrollY > 100) {
                header.style.backdropFilter = 'blur(60px)';
            } else {
                header.style.backdropFilter = 'blur(40px)';
            }
        });

        // Keyboard shortcuts
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape' && isDropdownOpen) {
                closeThemeDropdown();
            }
        });

        // Parallax floating elements
        window.addEventListener('scroll', () => {
            const scrolled = window.pageYOffset;
            const parallax = document.querySelector('.floating-elements');
            if (parallax) {
                const rate = scrolled * -0.2;
                parallax.style.transform = `translateY(${rate}px)`;
            }
        });
    </script>
</body>
</html>


