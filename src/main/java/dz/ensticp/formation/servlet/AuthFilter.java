package dz.ensticp.formation.servlet;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Authentication Filter
 * Protects all pages except public ones (login, signup, home, static files)
 * Redirects unauthenticated users to login page
 */
@WebFilter("/*")
public class AuthFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        
        // Remove context path from URI for easier comparison
        String path = requestURI.substring(contextPath.length());
        
        // Define public pages that don't require authentication
        boolean isPublicPage = isPublicPage(path);
        
        // Allow public pages without authentication
        if (isPublicPage) {
            chain.doFilter(request, response);
            return;
        }
        
        // Check if user is authenticated
        HttpSession session = httpRequest.getSession(false);
        boolean isLoggedIn = (session != null && session.getAttribute("student") != null);
        
        // Redirect to login if not authenticated
        if (!isLoggedIn) {
            httpResponse.sendRedirect(contextPath + "/login.jsp");
        } else {
            // User is logged in, proceed
            chain.doFilter(request, response);
        }
    }
    
    @Override
    public void destroy() {
        // Cleanup code if needed
    }
    
    /**
     * Check if the requested page is public (no authentication required)
     */
    private boolean isPublicPage(String path) {
        // Public pages
        if (path.equals("/") 
            || path.equals("/index.jsp")
            || path.equals("/login.jsp")
            || path.equals("/signup.jsp")) {
            return true;
        }
        
        // Google OAuth paths (no session yet during OAuth flow)
        if (path.contains("/auth/google/login") 
            || path.contains("/auth/google/callback")) {
            return true;
        }
        
        // Email auth endpoints
        if (path.contains("/auth/")) {
            return true;
        }
        
        // Static resources (CSS, JS, images, fonts)
        if (path.endsWith(".css") 
            || path.endsWith(".js") 
            || path.endsWith(".jpg") 
            || path.endsWith(".jpeg") 
            || path.endsWith(".png") 
            || path.endsWith(".gif") 
            || path.endsWith(".svg") 
            || path.endsWith(".woff") 
            || path.endsWith(".woff2") 
            || path.endsWith(".ttf")) {
            return true;
        }
        
        // All other pages require authentication
        return false;
    }
}