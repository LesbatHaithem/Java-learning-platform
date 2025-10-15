package dz.ensticp.formation.servlet;

import dz.ensticp.formation.model.Student;
import dz.ensticp.formation.util.PasswordUtil;
import dz.ensticp.formation.config.GoogleOAuthConfig;
import dz.ensticp.formation.dao.StudentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Optional;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@WebServlet("/auth/google/*")
public class GoogleOAuthServlet extends HttpServlet {
    
    private StudentDAO studentDAO = new StudentDAO();
    private ObjectMapper objectMapper = new ObjectMapper();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        
        if ("/login".equals(pathInfo)) {
            // Initiate Google OAuth flow
            initiateGoogleLogin(request, response);
        } else if ("/callback".equals(pathInfo)) {
            // Handle Google OAuth callback
            handleGoogleCallback(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    /**
     * Step 1: Redirect user to Google's OAuth consent screen
     */
    private void initiateGoogleLogin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        // Build Google OAuth URL
        String googleAuthUrl = GoogleOAuthConfig.AUTH_URI + "?"
                + "client_id=" + URLEncoder.encode(GoogleOAuthConfig.CLIENT_ID, "UTF-8")
                + "&redirect_uri=" + URLEncoder.encode(GoogleOAuthConfig.REDIRECT_URI, "UTF-8")
                + "&response_type=code"
                + "&scope=" + URLEncoder.encode(GoogleOAuthConfig.SCOPE, "UTF-8")
                + "&state=" + GoogleOAuthConfig.STATE
                + "&access_type=offline"
                + "&prompt=consent";
        
        // Redirect to Google
        response.sendRedirect(googleAuthUrl);
    }
    
    /**
     * Step 2: Handle callback from Google after user grants permission
     */
    private void handleGoogleCallback(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String code = request.getParameter("code");
        String state = request.getParameter("state");
        String error = request.getParameter("error");
        
        // Check for errors
        if (error != null) {
            request.setAttribute("error", "Google authentication failed: " + error);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        // Validate state (CSRF protection)
        if (!GoogleOAuthConfig.STATE.equals(state)) {
            request.setAttribute("error", "Invalid state parameter. Possible CSRF attack.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        try {
            // Exchange authorization code for access token
            String accessToken = exchangeCodeForToken(code);
            
            // Get user info from Google
            JsonNode userInfo = getUserInfo(accessToken);
            
            String email = userInfo.get("email").asText();
            String name = userInfo.get("name").asText();
            String googleId = userInfo.get("id").asText();
            
            // Find or create student
            Student student = findOrCreateGoogleStudent(email, name, googleId);
            
            // Create session
            HttpSession session = request.getSession();
            session.setAttribute("student", student);
            session.setAttribute("studentId", student.getId());
            session.setAttribute("studentName", student.getName());
            session.setAttribute("message", "Welcome back, " + student.getName() + "!");
            
            // Redirect to home page
            response.sendRedirect(request.getContextPath() + "/");
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Authentication failed: " + e.getMessage());
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
    
    /**
     * Exchange authorization code for access token
     */
    private String exchangeCodeForToken(String code) throws IOException {
        // Prepare POST request to Google's token endpoint
        String urlParameters = "code=" + URLEncoder.encode(code, "UTF-8")
                + "&client_id=" + URLEncoder.encode(GoogleOAuthConfig.CLIENT_ID, "UTF-8")
                + "&client_secret=" + URLEncoder.encode(GoogleOAuthConfig.CLIENT_SECRET, "UTF-8")
                + "&redirect_uri=" + URLEncoder.encode(GoogleOAuthConfig.REDIRECT_URI, "UTF-8")
                + "&grant_type=authorization_code";
        
        URL url = new URL(GoogleOAuthConfig.TOKEN_URI);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        conn.setDoOutput(true);
        
        // Send request
        conn.getOutputStream().write(urlParameters.getBytes(StandardCharsets.UTF_8));
        
        // Read response
        BufferedReader reader = new BufferedReader(
                new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
        StringBuilder response = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            response.append(line);
        }
        reader.close();
        
        // Parse JSON response
        JsonNode jsonResponse = objectMapper.readTree(response.toString());
        return jsonResponse.get("access_token").asText();
    }
    
    /**
     * Get user information from Google
     */
    private JsonNode getUserInfo(String accessToken) throws IOException {
        URL url = new URL(GoogleOAuthConfig.USER_INFO_URI + "?access_token=" + 
                URLEncoder.encode(accessToken, "UTF-8"));
        
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        
        // Read response
        BufferedReader reader = new BufferedReader(
                new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
        StringBuilder response = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            response.append(line);
        }
        reader.close();
        
        // Parse and return JSON
        return objectMapper.readTree(response.toString());
    }
    
    /**
     * Find existing student or create new one for Google account
     */
    private Student findOrCreateGoogleStudent(String email, String name, String googleId) {
        // First, try to find by Google ID
        Optional<Student> existingByGoogleId = studentDAO.findByGoogleId(googleId);
        if (existingByGoogleId.isPresent()) {
            return existingByGoogleId.get();
        }
        
        // Try to find by email
        Optional<Student> existingByEmail = studentDAO.findByEmail(email);
        if (existingByEmail.isPresent()) {
            // Link Google account to existing email account
            Student student = existingByEmail.get();
            student.setGoogleId(googleId);
            student.setAuthProvider("GOOGLE");
            studentDAO.update(student);
            return student;
        }
        
        // Create new student
        Student newStudent = new Student();
        newStudent.setName(name);
        newStudent.setEmail(email);
        newStudent.setGoogleId(googleId);
        newStudent.setAuthProvider("GOOGLE");
        newStudent.setPassword(PasswordUtil.generateRandomPassword()); // Random password for OAuth users
        
        return studentDAO.create(newStudent);
    }
}