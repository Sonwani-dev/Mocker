// View Mock Tests Function
function viewMockTests(topic) {
    // Add loading state to button
    const button = event.target;
    const originalText = button.textContent;
    button.textContent = 'Loading...';
    button.style.background = 'linear-gradient(135deg, #86868b, #86868b)';
    button.disabled = true;
    
    // Simulate navigation to mock tests
    setTimeout(() => {
        alert(`Redirecting to ${topic} mock tests...`);
        button.textContent = originalText;
        button.style.background = 'linear-gradient(135deg, var(--primary-blue), var(--primary-purple))';
        button.disabled = false;
    }, 1500);
}

// Smooth scrolling for navigation links
document.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });

    // Advanced scroll animations
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -100px 0px'
    };

    const observer = new IntersectionObserver((entries) => {
        entries.forEach((entry, index) => {
            if (entry.isIntersecting) {
                setTimeout(() => {
                    entry.target.classList.add('fade-in-up');
                    entry.target.style.animationDelay = `${index * 0.1}s`;
                }, index * 100);
            }
        });
    }, observerOptions);

    // Apply animations to cards
    document.querySelectorAll('.topic-card, .stat-card').forEach(card => {
        observer.observe(card);
    });

    // Parallax effect for hero background
    window.addEventListener('scroll', () => {
        const scrolled = window.pageYOffset;
        const parallax = document.querySelector('.floating-elements');
        if (parallax) {
            const rate = scrolled * -0.5;
            parallax.style.transform = `translateY(${rate}px)`;
        }
    });

    // Dynamic navigation blur
    window.addEventListener('scroll', () => {
        const nav = document.querySelector('.nav');
        if (nav) {
            const scrollY = window.scrollY;
            
            if (scrollY > 100) {
                nav.style.background = 'rgba(255, 255, 255, 0.2)';
                nav.style.backdropFilter = 'blur(60px)';
            } else {
                nav.style.background = 'rgba(255, 255, 255, 0.1)';
                nav.style.backdropFilter = 'blur(40px)';
            }
        }
    });

    // Interactive hover effects for cards
    document.querySelectorAll('.topic-card').forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-12px) scale(1.02)';
        });
        
        card.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0) scale(1)';
        });
    });

    // Button ripple effect
    document.querySelectorAll('.view-tests-btn').forEach(button => {
        button.addEventListener('click', function(e) {
            const ripple = document.createElement('span');
            const rect = this.getBoundingClientRect();
            const size = Math.max(rect.width, rect.height);
            const x = e.clientX - rect.left - size / 2;
            const y = e.clientY - rect.top - size / 2;
            
            ripple.style.width = ripple.style.height = size + 'px';
            ripple.style.left = x + 'px';
            ripple.style.top = y + 'px';
            ripple.style.position = 'absolute';
            ripple.style.borderRadius = '50%';
            ripple.style.background = 'rgba(255, 255, 255, 0.6)';
            ripple.style.transform = 'scale(0)';
            ripple.style.animation = 'ripple 0.6s linear';
            ripple.style.pointerEvents = 'none';
            
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

    // Add loading animation
    window.addEventListener('load', () => {
        document.body.style.opacity = '0';
        document.body.style.transition = 'opacity 0.5s ease';
        setTimeout(() => {
            document.body.style.opacity = '1';
        }, 100);
    });

    // Stat cards hover effects
    document.querySelectorAll('.stat-card').forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-8px) scale(1.05)';
        });
        
        card.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0) scale(1)';
        });
    });
}); 