<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up - ENSTICP Formation</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 2rem;
            position: relative;
        }

        /* Back Button - Modern Style */
        .back-button {
            position: absolute;
            top: 2rem;
            left: 2rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: white;
            text-decoration: none;
            font-size: 0.95rem;
            padding: 0.7rem 1.2rem;
            background: rgba(255, 255, 255, 0.15);
            border-radius: 50px;
            backdrop-filter: blur(10px);
            transition: all 0.3s;
        }

        .back-button:hover {
            background: rgba(255, 255, 255, 0.25);
            transform: translateX(-5px);
        }

        .back-button svg {
            width: 20px;
            height: 20px;
        }

        .auth-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            overflow: hidden;
            max-width: 450px;
            width: 100%;
            animation: slideUp 0.5s ease-out;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .auth-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2.5rem 2rem;
            text-align: center;
        }

        .auth-header h1 {
            font-size: 2rem;
            margin-bottom: 0.5rem;
        }

        .auth-header p {
            opacity: 0.9;
        }

        .auth-body {
            padding: 2.5rem 2rem;
        }

        .error-message {
            background: #fee2e2;
            color: #dc2626;
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            color: #374151;
            font-weight: 500;
        }

        .form-group input {
            width: 100%;
            padding: 0.9rem 1rem;
            border: 2px solid #e5e7eb;
            border-radius: 10px;
            font-size: 1rem;
            transition: all 0.3s;
        }

        .form-group input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .password-strength {
            height: 4px;
            background: #e5e7eb;
            border-radius: 2px;
            margin-top: 0.5rem;
            overflow: hidden;
        }

        .password-strength-bar {
            height: 100%;
            width: 0%;
            transition: all 0.3s;
        }

        .strength-weak { 
            background: #ef4444; 
            width: 33%; 
        }

        .strength-medium { 
            background: #f59e0b; 
            width: 66%; 
        }

        .strength-strong { 
            background: #10b981; 
            width: 100%; 
        }

        .password-hint {
            font-size: 0.8rem;
            color: #6b7280;
            margin-top: 0.3rem;
        }

        .btn {
            width: 100%;
            padding: 1rem;
            border: none;
            border-radius: 10px;
            font-size: 1rem;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s;
            margin-bottom: 1rem;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }

        .btn-google {
            background: white;
            color: #333;
            border: 2px solid #e5e7eb;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.8rem;
        }

        .btn-google:hover {
            background: #f9fafb;
            border-color: #667eea;
        }

        .divider {
            display: flex;
            align-items: center;
            margin: 1.5rem 0;
            color: #9ca3af;
            font-size: 0.9rem;
        }

        .divider::before,
        .divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: #e5e7eb;
        }

        .divider span {
            padding: 0 1rem;
        }

        .auth-footer {
            text-align: center;
            color: #6b7280;
            font-size: 0.9rem;
        }

        .auth-footer a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }

        .auth-footer a:hover {
            text-decoration: underline;
        }

        .terms {
            font-size: 0.85rem;
            color: #6b7280;
            text-align: center;
            margin-top: 1rem;
        }

        .terms a {
            color: #667eea;
            text-decoration: none;
        }

        @media (max-width: 640px) {
            .back-button {
                top: 1rem;
                left: 1rem;
                font-size: 0.85rem;
                padding: 0.6rem 1rem;
            }
        }
    </style>
</head>
<body>
    <!-- Modern Back Button -->
    <a href="<%= request.getContextPath() %>/" class="back-button">
        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
        </svg>
        Back to Home
    </a>

    <div class="auth-container">
        <div class="auth-header">
            <h1>Create Account</h1>
            <p>Start your learning journey today</p>
        </div>

        <div class="auth-body">
            <% String error = (String) request.getAttribute("error"); %>
            <% if (error != null) { %>
            <div class="error-message">
                <span>⚠️</span>
                <span><%= error %></span>
            </div>
            <% } %>

            <!-- Google Sign Up Button -->
            <form method="post" action="<%= request.getContextPath() %>/auth">
                <input type="hidden" name="action" value="google-signup">
                <button type="submit" class="btn btn-google">
                    <svg width="20" height="20" viewBox="0 0 48 48">
                        <path fill="#EA4335" d="M24 9.5c3.54 0 6.71 1.22 9.21 3.6l6.85-6.85C35.9 2.38 30.47 0 24 0 14.62 0 6.51 5.38 2.56 13.22l7.98 6.19C12.43 13.72 17.74 9.5 24 9.5z"></path>
                        <path fill="#4285F4" d="M46.98 24.55c0-1.57-.15-3.09-.38-4.55H24v9.02h12.94c-.58 2.96-2.26 5.48-4.78 7.18l7.73 6c4.51-4.18 7.09-10.36 7.09-17.65z"></path>
                        <path fill="#FBBC05" d="M10.53 28.59c-.48-1.45-.76-2.99-.76-4.59s.27-3.14.76-4.59l-7.98-6.19C.92 16.46 0 20.12 0 24c0 3.88.92 7.54 2.56 10.78l7.97-6.19z"></path>
                        <path fill="#34A853" d="M24 48c6.48 0 11.93-2.13 15.89-5.81l-7.73-6c-2.15 1.45-4.92 2.3-8.16 2.3-6.26 0-11.57-4.22-13.47-9.91l-7.98 6.19C6.51 42.62 14.62 48 24 48z"></path>
                    </svg>
                    Sign up with Google
                </button>
            </form>

            <div class="divider">
                <span>OR</span>
            </div>

            <!-- Email Signup Form -->
            <form method="post" action="<%= request.getContextPath() %>/auth" onsubmit="return validateForm()">
                <input type="hidden" name="action" value="signup">
                
                <div class="form-group">
                    <label for="name">Full Name</label>
                    <input type="text" id="name" name="name" required 
                           placeholder="John Doe">
                </div>

                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" required 
                           placeholder="your.email@example.com">
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" required 
                           placeholder="Create a strong password"
                           oninput="checkPasswordStrength()">
                    <div class="password-strength">
                        <div class="password-strength-bar" id="strengthBar"></div>
                    </div>
                    <div class="password-hint">Use at least 6 characters</div>
                </div>

                <div class="form-group">
                    <label for="confirmPassword">Confirm Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" required 
                           placeholder="Re-enter your password">
                </div>

                <button type="submit" class="btn btn-primary">Create Account</button>
            </form>

            <div class="terms">
                By signing up, you agree to our <a href="#">Terms of Service</a> and <a href="#">Privacy Policy</a>
            </div>

            <div class="auth-footer" style="margin-top: 1.5rem;">
                Already have an account? <a href="<%= request.getContextPath() %>/login.jsp">Sign In</a>
            </div>
        </div>
    </div>

    <script>
        function checkPasswordStrength() {
            const password = document.getElementById('password').value;
            const strengthBar = document.getElementById('strengthBar');
            
            // Remove all strength classes
            strengthBar.className = 'password-strength-bar';
            
            if (password.length === 0) {
                return;
            }
            
            if (password.length < 6) {
                strengthBar.classList.add('strength-weak');
            } else if (password.length < 10) {
                strengthBar.classList.add('strength-medium');
            } else {
                strengthBar.classList.add('strength-strong');
            }
        }

        function validateForm() {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (password !== confirmPassword) {
                alert('Passwords do not match!');
                return false;
            }
            
            if (password.length < 6) {
                alert('Password must be at least 6 characters long!');
                return false;
            }
            
            return true;
        }
    </script>
</body>
</html>