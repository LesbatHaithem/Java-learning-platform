// 4. AuthServlet.java - Authentication Servlet
package dz.ensticp.formation.servlet;

import dz.ensticp.formation.model.StudentDAO;
import dz.ensticp.formation.model.Student;
import dz.ensticp.formation.model.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/auth")
public class AuthServlet extends HttpServlet {
    private StudentDAO studentDAO = new StudentDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("login".equals(action)) {
            handleLogin(request, response);
        } else if ("signup".equals(action)) {
            handleSignup(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }
    
    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        // Validate input
        if (email == null || email.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Email and password are required");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        // Find student
        java.util.Optional<Student> studentOpt = studentDAO.findByEmail(email);
        
        if (!studentOpt.isPresent()) {
            request.setAttribute("error", "Invalid email or password");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        Student student = studentOpt.get();
        
        // Verify password
        if (!PasswordUtil.verifyPassword(password, student.getPassword())) {
            request.setAttribute("error", "Invalid email or password");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        // Login successful
        HttpSession session = request.getSession();
        session.setAttribute("student", student);
        session.setAttribute("studentId", student.getId());
        session.setAttribute("studentName", student.getName());
        
        response.sendRedirect(request.getContextPath() + "/");
    }
    
    private void handleSignup(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validate input
        if (name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "All fields are required");
            request.getRequestDispatcher("/signup.jsp").forward(request, response);
            return;
        }
        
        // Check password match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            request.getRequestDispatcher("/signup.jsp").forward(request, response);
            return;
        }
        
        // Check password strength
        if (password.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters");
            request.getRequestDispatcher("/signup.jsp").forward(request, response);
            return;
        }
        
        // Check if email already exists
        if (studentDAO.emailExists(email)) {
            request.setAttribute("error", "Email already registered");
            request.getRequestDispatcher("/signup.jsp").forward(request, response);
            return;
        }
        
        // Create new student
        Student student = new Student();
        student.setName(name);
        student.setEmail(email);
        student.setPassword(PasswordUtil.hashPassword(password));
        student.setAuthProvider("LOCAL");
        
        studentDAO.create(student);
        
        // Auto-login after signup
        HttpSession session = request.getSession();
        session.setAttribute("student", student);
        session.setAttribute("studentId", student.getId());
        session.setAttribute("studentName", student.getName());
        
        response.sendRedirect(request.getContextPath() + "/");
    }
}