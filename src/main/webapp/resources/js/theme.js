let isDropdownOpen = false;

function setTheme(theme, element) {
    // Remove all theme classes
    document.body.classList.remove('theme-gradient', 'theme-dark', 'theme-minimal', 'theme-neon', 'theme-nature', 'theme-warm');
    
    // Add selected theme class
    document.body.classList.add('theme-' + theme);
    
    // Update active button
    document.querySelectorAll('.theme-option').forEach(btn => btn.classList.remove('active'));
    element.classList.add('active');
    
    // Update theme indicator
    updateThemeIndicator(theme);
    
    // Store theme preference (Note: localStorage not available in Claude artifacts)
    
    // Add transition effect
    document.body.style.transition = 'all 0.5s cubic-bezier(0.4, 0.0, 0.2, 1)';
    setTimeout(() => {
        document.body.style.transition = '';
    }, 500);

    // Close dropdown
    closeThemeDropdown();
}

        function updateThemeIndicator(theme) {
            const indicator = document.getElementById('themeIndicator');
            const footerIndicator = document.getElementById('footerThemeIndicator');
            const themeColors = {
                'gradient': 'linear-gradient(135deg, #667eea, #764ba2)',
                'dark': 'linear-gradient(135deg, #1a1a1a, #2d2d2d)',
                'minimal': 'linear-gradient(135deg, #ffffff, #f8f9fa)',
                'neon': 'linear-gradient(135deg, #0f0f23, #ff006e)',
                'nature': 'linear-gradient(135deg, #2d5016, #a8e6cf)',
                'warm': 'linear-gradient(135deg, #ff9a56, #ffad56)'
            };
            
            if (indicator) {
                indicator.style.background = themeColors[theme];
                
                if (theme === 'minimal') {
                    indicator.style.border = '2px solid rgba(0, 0, 0, 0.2)';
                } else {
                    indicator.style.border = '2px solid rgba(255, 255, 255, 0.3)';
                }
            }
            
            if (footerIndicator) {
                footerIndicator.style.background = themeColors[theme];
                
                if (theme === 'minimal') {
                    footerIndicator.style.border = '2px solid rgba(0, 0, 0, 0.2)';
                } else {
                    footerIndicator.style.border = '2px solid rgba(255, 255, 255, 0.3)';
                }
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

// Event listeners
document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('themeIndicator').addEventListener('click', toggleThemeDropdown);

    // Close dropdown when clicking outside
    document.addEventListener('click', (e) => {
        const themeSelector = document.querySelector('.theme-selector');
        if (!themeSelector.contains(e.target)) {
            closeThemeDropdown();
        }
    });

    // Prevent dropdown from closing when clicking inside
    document.getElementById('themeDropdown').addEventListener('click', (e) => {
        e.stopPropagation();
    });

    // Load default theme on page load
    updateThemeIndicator('gradient');

    // Manual smooth scrolling for navigation links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const href = this.getAttribute('href');
            
            if (href === '#subjects') {
                // Scroll to Physical Education Topics heading
                window.scrollTo({
                    top: 1775, // Manual pixel value for subjects section
                    behavior: 'smooth'
                });
            } else if (href === '#pricing') {
                // Scroll to Choose Your Plan heading
                window.scrollTo({
                    top: 2560, // Manual pixel value for pricing section
                    behavior: 'smooth'
                });
            } else if (href === '#home') {
                // Scroll to top
                window.scrollTo({
                    top: 0,
                    behavior: 'smooth'
                });
            }
        });
    });

    // Card hover effects
    document.querySelectorAll('.feature-card, .subject-card').forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-12px) scale(1.02)';
            this.style.boxShadow = '0 20px 60px rgba(0, 0, 0, 0.15)';
        });
        
        card.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0) scale(1)';
            this.style.boxShadow = '';
        });
    });

    // Pricing card interactions
    document.querySelectorAll('.pricing-card:not(.featured)').forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-12px) scale(1.02)';
            this.style.boxShadow = '0 20px 60px rgba(0, 0, 0, 0.15)';
        });
        
        card.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0) scale(1)';
            this.style.boxShadow = '';
        });
    });

    // Dynamic navigation blur based on scroll
    window.addEventListener('scroll', () => {
        const nav = document.querySelector('.nav');
        const scrollY = window.scrollY;
        
        if (scrollY > 100) {
            nav.style.backdropFilter = 'blur(60px)';
            nav.style.background = 'var(--glass-bg)';
        } else {
            nav.style.backdropFilter = 'blur(40px)';
        }
    });

    // Parallax effect for floating elements
    window.addEventListener('scroll', () => {
        const scrolled = window.pageYOffset;
        const parallax = document.querySelector('.floating-elements');
        if (parallax) {
            const rate = scrolled * -0.3;
            parallax.style.transform = `translateY(${rate}px)`;
        }
    });

    // Add loading animation
    document.body.style.opacity = '0';
    document.body.style.transition = 'opacity 0.8s ease';
    setTimeout(() => {
        document.body.style.opacity = '1';
    }, 100);

    // Button ripple effect
    document.querySelectorAll('.btn-primary, .btn-secondary, .login-btn, .pricing-btn').forEach(button => {
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

    // Add ripple animation keyframes
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

    // Theme-specific hover effects
    function updateThemeSpecificEffects() {
        const currentTheme = document.body.className.match(/theme-(\w+)/)?.[1];
        
        if (currentTheme === 'neon') {
            document.querySelectorAll('.feature-card, .subject-card').forEach(card => {
                card.addEventListener('mouseenter', function() {
                    this.style.boxShadow = '0 0 40px rgba(255, 0, 110, 0.3), 0 20px 60px rgba(0, 0, 0, 0.15)';
                });
            });
        }
    }

    // Initialize theme-specific effects
    setTimeout(updateThemeSpecificEffects, 100);

    // Enhanced keyboard navigation
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && isDropdownOpen) {
            closeThemeDropdown();
        }
    });

    // Touch support for mobile
    let touchStartY = 0;
    document.addEventListener('touchstart', (e) => {
        touchStartY = e.touches[0].clientY;
    });

    document.addEventListener('touchend', (e) => {
        const touchEndY = e.changedTouches[0].clientY;
        const deltaY = touchStartY - touchEndY;
        
        // Close dropdown on swipe up (mobile gesture)
        if (deltaY > 50 && isDropdownOpen) {
            closeThemeDropdown();
        }
    });

    // Background image functionality for subjects section
    function setSubjectsBackground(imageUrl) {
        const subjectsBgImage = document.getElementById('subjectsBgImage');
        if (subjectsBgImage) {
            // Set both inline style and CSS custom property for better compatibility
            subjectsBgImage.style.backgroundImage = `url('${imageUrl}')`;
            subjectsBgImage.style.setProperty('--custom-bg-image', `url('${imageUrl}')`);
            console.log('Setting background image:', imageUrl);
        } else {
            console.error('subjectsBgImage element not found');
        }
    }

    // Make the function globally available
    window.setSubjectsBackground = setSubjectsBackground;

    // Set the background image for subjects section (now handled by CSS)
    console.log('Background image should be set via CSS');
}); 