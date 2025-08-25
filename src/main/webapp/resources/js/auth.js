// Page Navigation
function showPage(pageId) {
    // Hide all pages
    document.querySelectorAll('.page').forEach(page => {
        page.classList.remove('active');
    });
    
    // Remove active class from all buttons
    document.querySelectorAll('.page-btn').forEach(btn => {
        btn.classList.remove('active');
    });
    
    // Show selected page
    document.getElementById(pageId).classList.add('active');
    
    // Add active class to corresponding button
    document.querySelector(`[data-page="${pageId}"]`).classList.add('active');
}

// Page selector event listeners
document.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll('.page-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            showPage(btn.dataset.page);
        });
    });

    // Form Validation
    function validateEmail(email) {
        const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return re.test(email);
    }

    function validatePassword(password) {
        return password.length >= 8 && /[A-Z]/.test(password) && /[a-z]/.test(password) && /\d/.test(password);
    }

    function showMessage(formId, message, type) {
        const messageEl = document.getElementById(`${formId}-message`);
        messageEl.textContent = message;
        messageEl.className = `message ${type} show`;
        setTimeout(() => {
            messageEl.classList.remove('show');
        }, 5000);
    }

    function setLoading(btnId, loading) {
        const btn = document.getElementById(btnId);
        if (loading) {
            btn.innerHTML = '<div class="loading"><span class="spinner"></span>Processing...</div>';
            btn.disabled = true;
        } else {
            // Reset button text based on form
            const originalTexts = {
                'login-btn': 'Sign In',
                'register-btn': 'Create Account',
                'forgot-btn': 'Send Reset Link',
                'otp-btn': 'Verify Code'
            };
            btn.innerHTML = originalTexts[btnId] || 'Submit';
            btn.disabled = false;
        }
    }

    // Let the browser submit the login form normally to support redirect with error param

    // Register Form
    document.getElementById('register-form').addEventListener('submit', async (e) => {
        e.preventDefault();
        
        const name = document.getElementById('register-name').value;
        const email = document.getElementById('register-email').value;
        const password = document.getElementById('register-password').value;
        const confirmPassword = document.getElementById('register-confirm-password').value;
        const termsAccepted = document.getElementById('terms-check').checked;
        
        if (!name || !email || !password || !confirmPassword) {
            showMessage('register', 'Please fill in all fields', 'error');
            return;
        }
        
        if (!validateEmail(email)) {
            showMessage('register', 'Please enter a valid email address', 'error');
            return;
        }
        
        if (!validatePassword(password)) {
            showMessage('register', 'Password must be at least 8 characters with uppercase, lowercase and number', 'error');
            return;
        }
        
        if (password !== confirmPassword) {
            showMessage('register', 'Passwords do not match', 'error');
            return;
        }
        
        if (!termsAccepted) {
            showMessage('register', 'Please accept the terms and conditions', 'error');
            return;
        }
        
        setLoading('register-btn', true);
        
        // Create form data for backend submission
        const formData = new FormData();
        formData.append('username', email); // Use email as username
        formData.append('email', email);
        formData.append('password', password);
        formData.append('name', name);
        
        try {
            const response = await fetch('/register', {
                method: 'POST',
                body: formData,
                credentials: 'include'
            });
            
            if (response.ok) {
                showMessage('register', 'Account created successfully! Redirecting...', 'success');
                setTimeout(() => {
                    window.location.href = '/pe-subjects';
                }, 1500);
            } else {
                const errorText = await response.text();
                showMessage('register', 'Registration failed: ' + errorText, 'error');
            }
        } catch (error) {
            showMessage('register', 'Registration failed. Please try again.', 'error');
        } finally {
            setLoading('register-btn', false);
        }
    });

    // Forgot Password Form
    document.getElementById('forgot-form').addEventListener('submit', async (e) => {
        e.preventDefault();
        
        const email = document.getElementById('forgot-email').value;
        
        if (!email) {
            showMessage('forgot', 'Please enter your email address', 'error');
            return;
        }
        
        if (!validateEmail(email)) {
            showMessage('forgot', 'Please enter a valid email address', 'error');
            return;
        }
        
        setLoading('forgot-btn', true);
        
        // Simulate API call
        setTimeout(() => {
            setLoading('forgot-btn', false);
            showMessage('forgot', 'Reset link sent to your email!', 'success');
            setTimeout(() => {
                showPage('login');
            }, 2000);
        }, 2000);
    });

    // OTP Form
    document.getElementById('otp-form').addEventListener('submit', async (e) => {
        e.preventDefault();
        
        const otpInputs = document.querySelectorAll('.otp-input');
        let otp = '';
        
        otpInputs.forEach(input => {
            otp += input.value;
        });
        
        if (otp.length !== 6) {
            showMessage('otp', 'Please enter the complete 6-digit code', 'error');
            return;
        }
        
        setLoading('otp-btn', true);
        
        // Simulate API call
        setTimeout(() => {
            setLoading('otp-btn', false);
            if (otp === '123456') {
                showMessage('otp', 'OTP verified successfully! Redirecting...', 'success');
                setTimeout(() => {
                    window.location.href = '#dashboard';
                }, 1500);
            } else {
                showMessage('otp', 'Invalid OTP. Please try again.', 'error');
            }
        }, 2000);
    });

    // OTP Input Auto-focus
    const otpInputs = document.querySelectorAll('.otp-input');
    otpInputs.forEach((input, index) => {
        input.addEventListener('input', function() {
            if (this.value.length === 1 && index < otpInputs.length - 1) {
                otpInputs[index + 1].focus();
            }
        });
        
        input.addEventListener('keydown', function(e) {
            if (e.key === 'Backspace' && this.value.length === 0 && index > 0) {
                otpInputs[index - 1].focus();
            }
        });
    });

    // Resend Timer
    let timer = 60;
    const timerElement = document.getElementById('timer');
    const resendBtn = document.getElementById('resend-btn');
    
    function updateTimer() {
        if (timer > 0) {
            timerElement.textContent = timer;
            timer--;
            setTimeout(updateTimer, 1000);
        } else {
            resendBtn.disabled = false;
            resendBtn.innerHTML = 'Resend Code';
        }
    }
    
    resendBtn.addEventListener('click', function() {
        if (timer === 0) {
            timer = 60;
            this.disabled = true;
            this.innerHTML = 'Resend Code (<span id="timer">60</span>s)';
            updateTimer();
            showMessage('otp', 'Code resent successfully!', 'success');
        }
    });

    // Social Login
    window.socialLogin = function(provider) {
        showMessage('login', `Redirecting to ${provider}...`, 'success');
        setTimeout(() => {
            showMessage('login', `${provider} login not implemented in demo`, 'error');
        }, 1500);
    };
}); 