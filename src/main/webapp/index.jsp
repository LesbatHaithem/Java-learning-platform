<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="dz.ensticp.formation.model.Course" %>
<%@ page import="dz.ensticp.formation.model.Student" %>
<%
// Get student from session
Student student = (Student) session.getAttribute("student");
boolean isLoggedIn = (student != null);
// Get enrollment count from session
List<Course> enrolledCourses = (List<Course>) session.getAttribute("enrolledCourses");
int enrollmentCount = (enrolledCourses != null) ? enrolledCourses.size() : 0;

// Get message if any
String message = (String) session.getAttribute("message");
if (message != null) {
    session.removeAttribute("message");
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ENSTICP Formation - Master Java Programming</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        line-height: 1.6;
        color: #333;
        overflow-x: hidden;
    }

    /* Navbar */
    nav {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        padding: 1rem 5%;
        position: fixed;
        width: 100%;
        top: 0;
        z-index: 1000;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    }

    nav .container {
        display: flex;
        justify-content: space-between;
        align-items: center;
        max-width: 1200px;
        margin: 0 auto;
    }

    nav .logo {
        font-size: 1.5rem;
        font-weight: bold;
        color: white;
    }

    nav ul {
        display: flex;
        list-style: none;
        gap: 2rem;
        align-items: center;
    }

    nav a {
        color: white;
        text-decoration: none;
        transition: opacity 0.3s;
    }

    nav a:hover {
        opacity: 0.8;
    }

    /* Login Button */
    .login-btn {
        background: rgba(255, 255, 255, 0.2);
        padding: 0.6rem 1.5rem;
        border-radius: 25px;
        backdrop-filter: blur(10px);
        transition: all 0.3s;
    }

    .login-btn:hover {
        background: rgba(255, 255, 255, 0.3);
    }

    /* User Account Dropdown */
    .user-account {
        position: relative;
    }

    .user-avatar {
        display: flex;
        align-items: center;
        gap: 0.8rem;
        background: rgba(255, 255, 255, 0.15);
        padding: 0.5rem 1rem;
        border-radius: 50px;
        cursor: pointer;
        transition: all 0.3s;
    }

    .user-avatar:hover {
        background: rgba(255, 255, 255, 0.25);
    }

    .avatar-circle {
        width: 35px;
        height: 35px;
        border-radius: 50%;
        background: white;
        color: #667eea;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: bold;
        font-size: 1rem;
    }

    .user-info {
        display: flex;
        flex-direction: column;
        align-items: flex-start;
    }

    .user-name {
        font-weight: 600;
        font-size: 0.9rem;
    }

    .user-email {
        font-size: 0.75rem;
        opacity: 0.8;
    }

    .dropdown-arrow {
        margin-left: 0.5rem;
        transition: transform 0.3s;
    }

    .dropdown-arrow.open {
        transform: rotate(180deg);
    }

    /* Dropdown Menu */
    .dropdown-menu {
        position: absolute;
        top: calc(100% + 0.5rem);
        right: 0;
        background: white;
        border-radius: 12px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        min-width: 220px;
        opacity: 0;
        visibility: hidden;
        transform: translateY(-10px);
        transition: all 0.3s;
    }

    .dropdown-menu.show {
        opacity: 1;
        visibility: visible;
        transform: translateY(0);
    }

    .dropdown-header {
        padding: 1rem;
        border-bottom: 1px solid #e5e7eb;
    }

    .dropdown-header-name {
        font-weight: 600;
        color: #333;
        margin-bottom: 0.2rem;
    }

    .dropdown-header-email {
        font-size: 0.85rem;
        color: #6b7280;
    }

    .dropdown-item {
        padding: 0.8rem 1rem;
        color: #333;
        text-decoration: none;
        display: flex;
        align-items: center;
        gap: 0.8rem;
        transition: background 0.2s;
        cursor: pointer;
    }

    .dropdown-item:hover {
        background: #f3f4f6;
    }

    .dropdown-item:last-child {
        border-top: 1px solid #e5e7eb;
        color: #dc2626;
    }

    .dropdown-divider {
        height: 1px;
        background: #e5e7eb;
        margin: 0.5rem 0;
    }

    /* Enrollment Badge */
    .enrollment-badge {
        background: rgba(255, 255, 255, 0.2);
        padding: 0.5rem 1rem;
        border-radius: 20px;
        font-size: 0.9rem;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .enrollment-badge .count { 
        background: white;
        color: #667eea;
        padding: 0.2rem 0.6rem;
        border-radius: 50%;
        font-weight: bold;
        min-width: 25px;
        text-align: center;
    }

    /* Alert Message */
    .alert {
        position: fixed;
        top: 80px;
        right: 20px;
        background: #10b981;
        color: white;
        padding: 1rem 1.5rem;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        z-index: 1001;
        animation: slideIn 0.3s ease-out;
    }

    @keyframes slideIn {
        from {
            opacity: 0;
            transform: translateX(100px);
        }
        to {
            opacity: 1;
            transform: translateX(0);
        }
    }

    /* Hero Section */
    .hero {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        padding: 150px 5% 100px;
        text-align: center;
        position: relative;
        overflow: hidden;
    }

    .hero::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: url('data:image/svg+xml,<svg width="100" height="100" xmlns="http://www.w3.org/2000/svg"><text x="10" y="50" font-size="40" opacity="0.1" fill="white">{ }</text></svg>');
        animation: float 20s linear infinite;
    }

    @keyframes float {
        from { transform: translateY(0); }
        to { transform: translateY(-100px); }
    }

    .hero-content {
        max-width: 800px;
        margin: 0 auto;
        position: relative;
        z-index: 1;
    }

    .hero h1 {
        font-size: 3rem;
        margin-bottom: 1rem;
        animation: fadeInUp 0.8s ease-out;
    }

    .hero p {
        font-size: 1.3rem;
        margin-bottom: 2rem;
        opacity: 0.9;
        animation: fadeInUp 0.8s ease-out 0.2s both;
    }

    @keyframes fadeInUp {
        from {
            opacity: 0;
            transform: translateY(30px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    .cta-button {
        display: inline-block;
        padding: 15px 40px;
        background: white;
        color: #667eea;
        text-decoration: none;
        border-radius: 50px;
        font-weight: bold;
        transition: transform 0.3s, box-shadow 0.3s;
        animation: fadeInUp 0.8s ease-out 0.4s both;
    }

    .cta-button:hover {
        transform: translateY(-3px);
        box-shadow: 0 10px 25px rgba(0,0,0,0.2);
    }

    /* Stats Bar */
    .stats-bar {
        background: white;
        padding: 2rem 5%;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    }

    .stats-container {
        max-width: 1200px;
        margin: 0 auto;
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 2rem;
        text-align: center;
    }

    .stat-item h3 {
        font-size: 2.5rem;
        color: #667eea;
        margin-bottom: 0.5rem;
    }

    .stat-item p {
        color: #666;
        font-size: 1rem;
    }

    /* Features Section */
    .features {
        padding: 80px 5%;
        background: #f8f9fa;
    }

    .container {
        max-width: 1200px;
        margin: 0 auto;
    }

    .section-title {
        text-align: center;
        font-size: 2.5rem;
        margin-bottom: 3rem;
        color: #333;
    }

    .features-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
        gap: 2rem;
    }

    .feature-card {
        background: white;
        padding: 2rem;
        border-radius: 15px;
        box-shadow: 0 5px 15px rgba(0,0,0,0.08);
        transition: transform 0.3s, box-shadow 0.3s;
    }

    .feature-card:hover {
        transform: translateY(-10px);
        box-shadow: 0 15px 30px rgba(0,0,0,0.15);
    }

    .feature-icon {
        font-size: 3rem;
        margin-bottom: 1rem;
    }

    .feature-card h3 {
        font-size: 1.5rem;
        margin-bottom: 1rem;
        color: #667eea;
    }

    /* Courses Section */
    .courses {
        padding: 80px 5%;
    }

    .course-card {
        background: white;
        border-radius: 15px;
        overflow: hidden;
        box-shadow: 0 5px 15px rgba(0,0,0,0.08);
        transition: transform 0.3s;
        margin-bottom: 2rem;
    }

    .course-card:hover {
        transform: translateY(-5px);
    }

    .course-header {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        padding: 2rem;
    }

    .course-body {
        padding: 2rem;
    }

    .course-modules {
        list-style: none;
        padding-left: 0;
    }

    .course-modules li {
        padding: 0.8rem 0;
        border-bottom: 1px solid #eee;
    }

    .course-modules li:before {
        content: "✓ ";
        color: #667eea;
        font-weight: bold;
        margin-right: 0.5rem;
    }

    /* CTA Section */
    .cta-section {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        padding: 60px 5%;
        text-align: center;
    }

    .cta-section h2 {
        font-size: 2.5rem;
        margin-bottom: 1rem;
    }

    .cta-section p {
        font-size: 1.2rem;
        margin-bottom: 2rem;
        opacity: 0.9;
    }

    .cta-section .cta-button {
        background: white;
        color: #667eea;
    }

    /* Footer */
    footer {
        background: #2d3748;
        color: white;
        text-align: center;
        padding: 2rem 5%;
    }

    footer p {
        margin-bottom: 0.5rem;
    }

    .instructor {
        color: #667eea;
        font-weight: bold;
    }

    @media (max-width: 768px) {
        .hero h1 {
            font-size: 2rem;
        }
        
        nav ul {
            gap: 1rem;
            font-size: 0.9rem;
        }

        .enrollment-badge {
            display: none;
        }

        .user-info {
            display: none;
        }
    }
</style>
</head>
<body>
    <!-- Alert Message -->
    <% if (message != null) { %>
    <div class="alert" id="alertMessage">
        <%= message %>
    </div>
    <script>
        setTimeout(function() {
            var alert = document.getElementById('alertMessage');
            if (alert) {
                alert.style.opacity = '0';
                setTimeout(function() {
                    alert.style.display = 'none';
                }, 300);
            }
        }, 5000);
    </script>
    <% } %>
<!-- Navigation -->
<nav>
    <div class="container">
        <div class="logo">ENSTICP Formation</div>
        <ul>
            <li><a href="<%= request.getContextPath() %>/">Home</a></li>
            <li><a href="#features">Features</a></li>
            <li><a href="<%= request.getContextPath() %>/courses">Courses</a></li>
            <li><a href="#contact">Contact</a></li>
            
            <% if (isLoggedIn) { %>
                <!-- Logged In: Show User Account -->
                <% if (enrollmentCount > 0) { %>
                <li>
                    <div class="enrollment-badge">
                        📚 My Courses: <span class="count"><%= enrollmentCount %></span>
                    </div>
                </li>
                <% } %>
                
                <li class="user-account">
                    <div class="user-avatar" onclick="toggleDropdown()">
                        <div class="avatar-circle">
                            <%= student.getName().substring(0, 1).toUpperCase() %>
                        </div>
                        <div class="user-info">
                            <div class="user-name"><%= student.getName() %></div>
                            <div class="user-email"><%= student.getEmail() %></div>
                        </div>
                        <span class="dropdown-arrow" id="dropdownArrow">▼</span>
                    </div>
                    
                    <div class="dropdown-menu" id="dropdownMenu">
                        <div class="dropdown-header">
                            <div class="dropdown-header-name"><%= student.getName() %></div>
                            <div class="dropdown-header-email"><%= student.getEmail() %></div>
                        </div>
                        
                        <a href="<%= request.getContextPath() %>/courses" class="dropdown-item">
                            <span>📚</span>
                            <span>My Courses (<%= enrollmentCount %>)</span>
                        </a>
                        
                        <a href="#" class="dropdown-item">
                            <span>👤</span>
                            <span>Profile Settings</span>
                        </a>
                        
                        <div class="dropdown-divider"></div>
                        
                        <a href="<%= request.getContextPath() %>/auth?action=logout" class="dropdown-item">
                            <span>🚪</span>
                            <span>Logout</span>
                        </a>
                    </div>
                </li>
            <% } else { %>
                <!-- Not Logged In: Show Login Button -->
                <li>
                    <a href="<%= request.getContextPath() %>/login.jsp" class="login-btn">Login</a>
                </li>
            <% } %>
        </ul>
    </div>
</nav>

<!-- Hero Section -->
<section class="hero" id="home">
    <div class="hero-content">
        <h1>Master Java Programming</h1>
        <p>Learn Java from fundamentals to advanced concepts with hands-on projects and real-world applications</p>
        <a href="<%= request.getContextPath() %>/courses" class="cta-button">Start Learning</a>
    </div>
</section>

<!-- Stats Bar -->
<section class="stats-bar">
    <div class="stats-container">
        <div class="stat-item">
            <h3>5+</h3>
            <p>Java Courses</p>
        </div>
        <div class="stat-item">
            <h3><%= enrollmentCount %></h3>
            <p>Your Enrollments</p>
        </div>
        <div class="stat-item">
            <h3>100+</h3>
            <p>Hours of Content</p>
        </div>
        <div class="stat-item">
            <h3>24/7</h3>
            <p>Learning Access</p>
        </div>
    </div>
</section>

<!-- Features Section -->
<section class="features" id="features">
    <div class="container">
        <h2 class="section-title">Why Learn With Us?</h2>
        <div class="features-grid">
            <div class="feature-card">
                <div class="feature-icon">📚</div>
                <h3>Comprehensive Curriculum</h3>
                <p>From basics to advanced topics including Spring Boot, Hibernate, and microservices architecture</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">💻</div>
                <h3>Hands-On Projects</h3>
                <p>Build real-world applications including REST APIs, web apps, and enterprise solutions</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">🎯</div>
                <h3>Industry-Ready Skills</h3>
                <p>Learn tools and frameworks used by top companies: Maven, Git, Docker, and more</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">⚡</div>
                <h3>Modern Practices</h3>
                <p>Master design patterns, best practices, testing, and continuous integration</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">🤝</div>
                <h3>Expert Guidance</h3>
                <p>Learn from experienced developers with industry expertise</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">🚀</div>
                <h3>Career Support</h3>
                <p>Portfolio building, interview preparation, and job placement assistance</p>
            </div>
        </div>
    </div>
</section>

<!-- Courses Section -->
<section class="courses" id="courses-preview">
    <div class="container">
        <h2 class="section-title">Course Modules</h2>
        
        <div class="course-card">
            <div class="course-header">
                <h3>Module 1: Java Fundamentals</h3>
            </div>
            <div class="course-body">
                <ul class="course-modules">
                    <li>Variables, Data Types & Operators</li>
                    <li>Control Flow & Loops</li>
                    <li>Object-Oriented Programming</li>
                    <li>Classes, Objects & Inheritance</li>
                    <li>Polymorphism & Encapsulation</li>
                </ul>
            </div>
        </div>

        <div class="course-card">
            <div class="course-header">
                <h3>Module 2: Advanced Java</h3>
            </div>
            <div class="course-body">
                <ul class="course-modules">
                    <li>Collections Framework</li>
                    <li>Exception Handling</li>
                    <li>File I/O & Serialization</li>
                    <li>Multithreading & Concurrency</li>
                    <li>Lambda Expressions & Stream API</li>
                </ul>
            </div>
        </div>

        <div class="course-card">
            <div class="course-header">
                <h3>Module 3: Web Development</h3>
            </div>
            <div class="course-body">
                <ul class="course-modules">
                    <li>Servlets & JSP</li>
                    <li>Spring Framework & Spring Boot</li>
                    <li>RESTful API Development</li>
                    <li>Database Integration (JDBC, JPA, Hibernate)</li>
                    <li>Security & Authentication</li>
                </ul>
            </div>
        </div>
    </div>
</section>

<!-- CTA Section -->
<section class="cta-section">
    <div class="container">
        <h2>Ready to Start Your Java Journey?</h2>
        <p>Browse our complete course catalog and enroll today!</p>
        <a href="<%= request.getContextPath() %>/courses" class="cta-button">View All Courses</a>
    </div>
</section>

<!-- Footer -->
<footer id="contact">
    <div class="container">
        <p>Instructor: <span class="instructor">Lesbat Haithem</span></p>
        <p>&copy; 2025 ENSTICP Formation. All rights reserved.</p>
        <p>Empowering developers with cutting-edge Java skills</p>
        <% if (isLoggedIn && enrollmentCount > 0) { %>
        <p style="margin-top: 1rem; opacity: 0.8;">You are currently enrolled in <%= enrollmentCount %> course<%= enrollmentCount != 1 ? "s" : "" %></p>
        <% } %>
    </div>
</footer>

<script>
    function toggleDropdown() {
        const menu = document.getElementById('dropdownMenu');
        const arrow = document.getElementById('dropdownArrow');
        menu.classList.toggle('show');
        arrow.classList.toggle('open');
    }

    // Close dropdown when clicking outside
    document.addEventListener('click', function(event) {
        const userAccount = document.querySelector('.user-account');
        if (userAccount && !userAccount.contains(event.target)) {
            const menu = document.getElementById('dropdownMenu');
            const arrow = document.getElementById('dropdownArrow');
            if (menu) menu.classList.remove('show');
            if (arrow) arrow.classList.remove('open');
        }
    });
</script>
</body>
</html>