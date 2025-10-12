package dz.ensticp.formation.servlet;

import dz.ensticp.formation.model.Course;
//import dz.ensticp.formation.model.Student;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * CourseServlet - Handles course listing and enrollment
 * URL Mapping: /courses
 */
@WebServlet("/courses")
public class CourseServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get all available courses
        List<Course> courses = getAllCourses();
        
        // Put courses in request scope so JSP can access them
        request.setAttribute("courses", courses);
        
        // Get enrolled courses from session
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<Course> enrolledCourses = (List<Course>) session.getAttribute("enrolledCourses");
        
        if (enrolledCourses == null) {
            enrolledCourses = new ArrayList<>();
            session.setAttribute("enrolledCourses", enrolledCourses);
        }
        
        request.setAttribute("enrolledCourses", enrolledCourses);
        
        // Forward to JSP page
        request.getRequestDispatcher("/courses.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("enroll".equals(action)) {
            enrollInCourse(request, response);
        } else if ("unenroll".equals(action)) {
            unenrollFromCourse(request, response);
        }
        
        // Redirect back to courses page
        response.sendRedirect(request.getContextPath() + "/courses");
    }
    
    /**
     * Enroll student in a course
     */
    private void enrollInCourse(HttpServletRequest request, HttpServletResponse response) {
        String courseIdStr = request.getParameter("courseId");
        
        if (courseIdStr != null) {
            int courseId = Integer.parseInt(courseIdStr);
            Course course = getCourseById(courseId);
            
            if (course != null) {
                HttpSession session = request.getSession();
                
                @SuppressWarnings("unchecked")
                List<Course> enrolledCourses = (List<Course>) session.getAttribute("enrolledCourses");
                
                if (enrolledCourses == null) {
                    enrolledCourses = new ArrayList<>();
                }
                
                // Check if already enrolled
                boolean alreadyEnrolled = enrolledCourses.stream()
                        .anyMatch(c -> c.getId() == courseId);
                
                if (!alreadyEnrolled) {
                    enrolledCourses.add(course);
                    session.setAttribute("enrolledCourses", enrolledCourses);
                    session.setAttribute("message", "Successfully enrolled in " + course.getTitle());
                } else {
                    session.setAttribute("message", "You are already enrolled in this course");
                }
            }
        }
    }
    
    /**
     * Unenroll student from a course
     */
    private void unenrollFromCourse(HttpServletRequest request, HttpServletResponse response) {
        String courseIdStr = request.getParameter("courseId");
        
        if (courseIdStr != null) {
            int courseId = Integer.parseInt(courseIdStr);
            
            HttpSession session = request.getSession();
            @SuppressWarnings("unchecked")
            List<Course> enrolledCourses = (List<Course>) session.getAttribute("enrolledCourses");
            
            if (enrolledCourses != null) {
                enrolledCourses.removeIf(c -> c.getId() == courseId);
                session.setAttribute("message", "Successfully unenrolled from course");
            }
        }
    }
    
    /**
     * Get all available courses (in real app, this would query database)
     */
    private List<Course> getAllCourses() {
        List<Course> courses = new ArrayList<>();
        
        courses.add(new Course(1, "Java Fundamentals", 
                "Master the basics of Java programming including OOP concepts", 
                40, "Beginner"));
        
        courses.add(new Course(2, "Advanced Java", 
                "Collections, Multithreading, Streams, and Lambda Expressions", 
                60, "Intermediate"));
        
        courses.add(new Course(3, "Web Development with Java", 
                "Servlets, JSP, and building modern web applications", 
                50, "Intermediate"));
        
        courses.add(new Course(4, "Spring Boot Framework", 
                "Build production-ready applications with Spring Boot", 
                70, "Advanced"));
        
        courses.add(new Course(5, "Database with Java", 
                "JDBC, JPA, Hibernate and database design", 
                45, "Intermediate"));
        
        return courses;
    }
    
    /**
     * Get course by ID
     */
    private Course getCourseById(int id) {
        return getAllCourses().stream()
                .filter(c -> c.getId() == id)
                .findFirst()
                .orElse(null);
    }
}