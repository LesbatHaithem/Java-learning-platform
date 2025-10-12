<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="dz.ensticp.formation.model.Course" %>
<%
    List<Course> courses = (List<Course>) request.getAttribute("courses");
    List<Course> enrolledCourses = (List<Course>) request.getAttribute("enrolledCourses");
    String message = (String) session.getAttribute("message");
    
    // Clear message after displaying
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
        }

        nav {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 1rem 5%;
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
        }

        nav a {
            color: white;
            text-decoration: none;
            transition: opacity 0.3s;
        }

        nav a:hover {
            opacity: 0.8;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem 5%;
        }

        .page-header {
            text-align: center;
            padding: 3rem 0;
        }

        .page-header h1 {
            font-size: 2.5rem;
            color: #333;
            margin-bottom: 0.5rem;
        }

        .page-header p {
            color: #666;
            font-size: 1.1rem;
        }

        .alert {
            background: #10b981;
            color: white;
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 2rem;
            animation: slideDown 0.3s ease-out;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .stats {
            display: flex;
            gap: 1rem;
            margin-bottom: 2rem;
            justify-content: center;
        }

        .stat-card {
            background: white;
            padding: 1.5rem 2rem;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            text-align: center;
        }

        .stat-card h3 {
            font-size: 2rem;
            color: #667eea;
            margin-bottom: 0.5rem;
        }

        .courses-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 2rem;
            margin-top: 2rem;
        }

        .course-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            transition: transform 0.3s, box-shadow 0.3s;
            position: relative;
        }

        .course-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
        }

        .course-card.enrolled {
            border: 3px solid #10b981;
        }

        .enrolled-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            background: #10b981;
            color: white;
            padding: 0.3rem 0.8rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: bold;
        }

        .course-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 1.5rem;
        }

        .course-header h3 {
            font-size: 1.3rem;
            margin-bottom: 0.5rem;
        }

        .course-meta {
            display: flex;
            gap: 1rem;
            font-size: 0.9rem;
            opacity: 0.9;
        }

        .course-body {
            padding: 1.5rem;
        }

        .course-description {
            color: #666;
            margin-bottom: 1.5rem;
            line-height: 1.5;
        }

        .course-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .level-badge {
            padding: 0.4rem 0.8rem;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: bold;
            color: white;
        }

        .btn {
            padding: 0.6rem 1.5rem;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-weight: bold;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }

        .btn-primary {
            background: #667eea;
            color: white;
        }

        .btn-primary:hover {
            background: #5568d3;
            transform: translateY(-2px);
        }

        .btn-danger {
            background: #ef4444;
            color: white;
        }

        .btn-danger:hover {
            background: #dc2626;
        }

        .btn:disabled {
            background: #ccc;
            cursor: not-allowed;
        }

        @media (max-width: 768px) {
            .courses-grid {
                grid-template-columns: 1fr;
            }
            
            .stats {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <nav>
        <div class="container">
            <div class="logo">ENSTICP Formation</div>
            <ul>
                <li><a href="<%= request.getContextPath() %>/">Home</a></li>
                <li><a href="<%= request.getContextPath() %>/courses">Courses</a></li>
                <li><a href="#contact">Contact</a></li>
            </ul>
        </div>
    </nav>

    <div class="container">
        <div class="page-header">
            <h1>Available Courses</h1>
            <p>Choose from our comprehensive Java programming courses</p>
        </div>

        <% if (message != null) { %>
        <div class="alert">
            <%= message %>
        </div>
        <% } %>

        <div class="stats">
            <div class="stat-card">
                <h3><%= courses != null ? courses.size() : 0 %></h3>
                <p>Total Courses</p>
            </div>
            <div class="stat-card">
                <h3><%= enrolledCourses != null ? enrolledCourses.size() : 0 %></h3>
                <p>Your Enrollments</p>
            </div>
        </div>

        <div class="courses-grid">
            <% 
            if (courses != null && !courses.isEmpty()) {
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
                    </div>
                </div>
                
                <div class="course-body">
                    <p class="course-description"><%= course.getDescription() %></p>
                    
                    <div class="course-footer">
                        <span class="level-badge" style="background-color: '<%= course.getLevelBadgeColor() %>'">
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
            <% 
                }
            } else { 
            %>
            <p>No courses available at the moment.</p>
            <% } %> 
        </div>
    </div>
</body>
</html>