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

// Event listeners
document.addEventListener('DOMContentLoaded', function() {
    const themeIndicator = document.getElementById('themeIndicator');
    if (themeIndicator) {
        themeIndicator.addEventListener('click', toggleThemeDropdown);
    }

    // Close dropdown when clicking outside
    document.addEventListener('click', (e) => {
        const themeSelector = document.querySelector('.theme-selector');
        if (themeSelector && !themeSelector.contains(e.target)) {
            closeThemeDropdown();
        }
    });

    // Prevent dropdown from closing when clicking inside
    const themeDropdown = document.getElementById('themeDropdown');
    if (themeDropdown) {
        themeDropdown.addEventListener('click', (e) => {
            e.stopPropagation();
        });
    }

    // Load default theme on page load
    updateThemeIndicator('gradient');

    // Input focus effects
    document.querySelectorAll('.form-group input').forEach(input => {
        input.addEventListener('focus', function() {
            this.parentElement.style.transform = 'translateY(-2px)';
        });
        
        input.addEventListener('blur', function() {
            this.parentElement.style.transform = 'translateY(0)';
        });
    });

    // Button ripple effect
    document.querySelectorAll('.login-btn').forEach(button => {
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

    // Enhanced keyboard navigation
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && isDropdownOpen) {
            closeThemeDropdown();
        }
        
        // Enter key on form elements
        if (e.key === 'Enter' && e.target.tagName === 'INPUT') {
            const form = e.target.closest('form');
            if (form) {
                const inputs = Array.from(form.querySelectorAll('input[required]'));
                const currentIndex = inputs.indexOf(e.target);
                const nextInput = inputs[currentIndex + 1];
                
                if (nextInput) {
                    nextInput.focus();
                    e.preventDefault();
                }
            }
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

    // Form validation feedback
    document.querySelectorAll('input[required]').forEach(input => {
        input.addEventListener('invalid', function(e) {
            e.preventDefault();
            this.style.borderColor = '#ff3b30';
            this.style.boxShadow = '0 0 0 3px rgba(255, 59, 48, 0.1)';
            
            setTimeout(() => {
                this.style.borderColor = '';
                this.style.boxShadow = '';
            }, 3000);
        });
        
        input.addEventListener('input', function() {
            if (this.checkValidity()) {
                this.style.borderColor = '#34c759';
                this.style.boxShadow = '0 0 0 3px rgba(52, 199, 89, 0.1)';
            } else {
                this.style.borderColor = '';
                this.style.boxShadow = '';
            }
        });
    });

    // Auto-focus on first input when page loads
    setTimeout(() => {
        const firstInput = document.querySelector('input[type="text"]');
        if (firstInput) {
            firstInput.focus();
        }
    }, 500);
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

// Add loading animation
window.addEventListener('load', () => {
    document.body.style.opacity = '0';
    document.body.style.transition = 'opacity 0.8s ease';
    setTimeout(() => {
        document.body.style.opacity = '1';
    }, 100);
});
