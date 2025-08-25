document.addEventListener('DOMContentLoaded', function() {
    // Card hover animations
    document.querySelectorAll('.test-card').forEach(card => {
        card.addEventListener('mouseenter', function() {
            if (!this.classList.contains('loading')) {
                this.style.transform = 'translateY(-8px) scale(1.02)';
            }
        });
        
        card.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0) scale(1)';
        });
    });

    // Redirect locked tests to pricing page
    document.querySelectorAll('.test-card').forEach(card => {
        const isLocked = card.querySelector('.test-status') && card.querySelector('.test-status').classList.contains('status-locked');
        if (isLocked) {
            card.addEventListener('click', function(e) {
                const startBtn = card.querySelector('.btn-start');
                if (startBtn && startBtn.hasAttribute('disabled')) {
                    window.location.href = `${document.body.dataset.ctx || ''}/pricing`;
                    e.preventDefault();
                    e.stopPropagation();
                }
            });
        }
    });

    // Remove any stale secondary button listeners (button removed in JSP)

    // Smooth page load
    window.addEventListener('load', () => {
        document.querySelectorAll('.test-card').forEach((card, index) => {
            card.style.opacity = '0';
            card.style.transform = 'translateY(40px)';
            
            setTimeout(() => {
                card.style.transition = 'all 0.6s cubic-bezier(0.4, 0.0, 0.2, 1)';
                card.style.opacity = '1';
                card.style.transform = 'translateY(0)';
            }, index * 100);
        });
    });

    // Navigation interactions: only intercept hash links; allow full navigation for real URLs
    document.querySelectorAll('.nav-links a').forEach(link => {
        link.addEventListener('click', function(e) {
            const href = this.getAttribute('href');
            if (href && href.startsWith('#')) {
                e.preventDefault();
                document.querySelectorAll('.nav-links a').forEach(l => l.classList.remove('active'));
                this.classList.add('active');
            }
        });
    });
}); 