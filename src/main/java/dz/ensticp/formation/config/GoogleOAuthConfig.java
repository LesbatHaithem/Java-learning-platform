package dz.ensticp.formation.config;

public class GoogleOAuthConfig {
    
    public static final String CLIENT_ID = "836250009345-uthc2d1fraboh7rfvgqat0ibmt0qs7fm.apps.googleusercontent.com";
    public static final String CLIENT_SECRET = "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";
    
    // Redirect URI must match exactly what you configured in Google Cloud Console
    public static final String REDIRECT_URI = "http://localhost:8080/java-learning-platform/auth/google/callback";
    
    // Google OAuth endpoints
    public static final String AUTH_URI = "https://accounts.google.com/o/oauth2/v2/auth";
    public static final String TOKEN_URI = "https://oauth2.googleapis.com/token";
    public static final String USER_INFO_URI = "https://www.googleapis.com/oauth2/v2/userinfo";
    
    // Scopes - what information we're requesting
    public static final String SCOPE = "email profile";
    
    // State parameter for CSRF protection (generate random for production)
    public static final String STATE = "security_token_" + System.currentTimeMillis();
}