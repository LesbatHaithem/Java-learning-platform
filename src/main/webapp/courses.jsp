<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="dz.ensticp.formation.model.Course" %>
<%
    List<Course> courses = (List<Course>) request.getAttribute("courses");
    List<Course> enrolledCourses = (List<Course>) request.getAttribute("enrolledCourses");
    int enrollmentCount = (enrolledCourses != null) ? enrolledCourses.size() : 0;
    
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
    <title>Available Courses - ENSTICP Formation</title>
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
            background: #f8f9fa;
            overflow-x: hidden;
        }

        /* Navbar - Same as index.jsp */
        nav {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 1rem 5%;
            position: fixed;
            width: 100%;
            top: 0;
            z-index: 1000;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        nav .nav-container {
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

        /* Hero Section for Courses Page */
        .hero {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 120px 5% 80px;
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
            font-size: 2.5rem;
            margin-bottom: 0.5rem;
            animation: fadeInUp 0.8s ease-out;
        }

        .hero p {
            font-size: 1.2rem;
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

        /* Main Container */
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 3rem 5%;
        }

        /* Courses Grid */
        .courses-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 2rem;
        }

        .course-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            transition: transform 0.3s, box-shadow 0.3s;
            position: relative;
            animation: fadeInUp 0.6s ease-out;
        }

        .course-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.15);
        }

        .course-card.enrolled {
            border: 3px solid #10b981;
        }

        .enrolled-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            background: #10b981;
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 25px;
            font-size: 0.85rem;
            font-weight: bold;
            box-shadow: 0 2px 8px rgba(16, 185, 129, 0.3);
            z-index: 10;
        }

        .course-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem;
            position: relative;
        }

        .course-header h3 {
            font-size: 1.4rem;
            margin-bottom: 0.8rem;
        }

        .course-meta {
            display: flex;
            gap: 1.5rem;
            font-size: 0.9rem;
            opacity: 0.95;
        }

        .course-meta span {
            display: flex;
            align-items: center;
            gap: 0.3rem;
        }

        .course-body {
            padding: 2rem;
        }

        .course-description {
            color: #666;
            margin-bottom: 1.5rem;
            line-height: 1.6;
            min-height: 60px;
        }

        .course-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 1rem;
            border-top: 1px solid #eee;
        }

        .level-badge {
            padding: 0.5rem 1rem;
            border-radius: 25px;
            font-size: 0.85rem;
            font-weight: bold;
            color: white;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .btn {
            padding: 0.7rem 1.8rem;
            border: none;
            border-radius: 50px;
            cursor: pointer;
            font-weight: bold;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
            font-size: 0.95rem;
        }

        .btn-primary {
            background: #667eea;
            color: white;
        }

        .btn-primary:hover {
            background: #5568d3;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }

        .btn-danger {
            background: #ef4444;
            color: white;
        }

        .btn-danger:hover {
            background: #dc2626;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(239, 68, 68, 0.4);
        }

        .btn:disabled {
            background: #ccc;
            cursor: not-allowed;
            transform: none;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
        }

        .empty-state-icon {
            font-size: 5rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }

        .empty-state h3 {
            font-size: 1.8rem;
            color: #666;
            margin-bottom: 0.5rem;
        }

        .empty-state p {
            color: #999;
            font-size: 1.1rem;
        }

        /* Footer */
        footer {
            background: #2d3748;
            color: white;
            text-align: center;
            padding: 2rem 5%;
            margin-top: 4rem;
        }

        footer p {
            margin-bottom: 0.5rem;
        }

        .instructor {
            color: #667eea;
            font-weight: bold;
        }

        /* Responsive */
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

            .courses-grid {
                grid-template-columns: 1fr;
            }

            .stats-container {
                grid-template-columns: repeat(2, 1fr);
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
        <div class="nav-container">
            <div class="logo">ENSTICP Formation</div>
            <ul>
                <li><a href="<%= request.getContextPath() %>/">Home</a></li>
                <li><a href="#features">Features</a></li>
                <li><a href="<%= request.getContextPath() %>/courses">Courses</a></li>
                <li><a href="#contact">Contact</a></li>
                <% if (enrollmentCount > 0) { %>
                <li>
                    <div class="enrollment-badge">
                        📚 My Courses: <span class="count"><%= enrollmentCount %></span>
                    </div>
                </li>
                <% } %>
            </ul>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero">
        <div class="hero-content">
            <h1>Available Courses</h1>
            <p>Choose from our comprehensive Java programming courses and start your learning journey</p>
        </div>
    </section>

    <!-- Stats Bar -->
    <section class="stats-bar">
        <div class="stats-container">
            <div class="stat-item">
                <h3><%= courses != null ? courses.size() : 0 %></h3>
                <p>Total Courses</p>
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

    <!-- Courses Grid -->
    <div class="container">
        <% if (courses != null && !courses.isEmpty()) { %>
        <div class="courses-grid">
            <% 
                for (Course course : courses) {
                    boolean isEnrolled = enrolledCourses != null && 
                                       enrolledCourses.stream()
                                       .anyMatch(c -> c.getId() == course.getId());
            %>
            <div class="course-card <%= isEnrolled ? "enrolled" : "" %>">
                <% if (isEnrolled) { %>
                <div class="enrolled-badge">✓ Enrolled</div>
                <% } %>
                
                <div class="course-header">
                    <h3><%= course.getTitle() %></h3>
                    <div class="course-meta">
                        <span>⏱ <%= course.getDuration() %> hours</span>
                        <span>📊 <%= course.getLevel() %></span>
                    </div>
                </div>
                
                <div class="course-body">
                    <p class="course-description"><%= course.getDescription() %></p>
                    
                    <div class="course-footer">
                        <span class="level-badge" style="background-color: <%= course.getLevelBadgeColor() %>;">
                            <%= course.getLevel() %>
                        </span>
                        
                        <% if (isEnrolled) { %>
                        <form method="post" action="<%= request.getContextPath() %>/courses" style="display: inline;">
                            <input type="hidden" name="action" value="unenroll">
                            <input type="hidden" name="courseId" value="<%= course.getId() %>">
                            <button type="submit" class="btn btn-danger">Unenroll</button>
                        </form>
                        <% } else { %>
                        <form method="post" action="<%= request.getContextPath() %>/courses" style="display: inline;">
                            <input type="hidden" name="action" value="enroll">
                            <input type="hidden" name="courseId" value="<%= course.getId() %>">
                            <button type="submit" class="btn btn-primary">Enroll Now</button>
                        </form>
                        <% } %>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
        <% } else { %>
        <div class="empty-state">
            <div class="empty-state-icon">📚</div>
            <h3>No Courses Available</h3>
            <p>Check back soon for new courses!</p>
        </div>
        <% } %>
    </div>

    <!-- Footer -->
    <footer id="contact">
        <div class="container">
            <p>Instructor: <span class="instructor">Lesbat Haithem</span></p>
            <p>&copy; 2025 ENSTICP Formation. All rights reserved.</p>
            <p>Empowering developers with cutting-edge Java skills</p>
            <% if (enrollmentCount > 0) { %>
            <p style="margin-top: 1rem; opacity: 0.8;">You are currently enrolled in <%= enrollmentCount %> course<%= enrollmentCount != 1 ? "s" : "" %></p>
            <% } %>
        </div>
    </footer>
</body>
</html>