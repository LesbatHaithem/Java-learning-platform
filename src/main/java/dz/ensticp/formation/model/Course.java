package dz.ensticp.formation.model;

/**
 * Course Model - Represents a training course
 */
public class Course {
    private int id;
    private String title;
    private String description;
    private int duration; // in hours
    private String level; // Beginner, Intermediate, Advanced

    
    // Constructors
    public Course() {
    }
    
    public Course(int id, String title, String description, int duration, String level) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.duration = duration;
        this.level = level;
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public int getDuration() {
        return duration;
    }
    
    public void setDuration(int duration) {
        this.duration = duration;
    }
    
    public String getLevel() {
        return level;
    }
    
    public void setLevel(String level) {
        this.level = level;
    }
    
    // Helper method to get badge color based on level
    public String getLevelBadgeColor() {
        switch (level.toLowerCase()) {
            case "beginner":
                return "#10b981"; // green
            case "intermediate":
                return "#f59e0b"; // orange
            case "advanced":
                return "#ef4444"; // red
            default:
                return "#6b7280"; // gray
        }
    }
    
    @Override
    public String toString() {
        return "Course{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", duration=" + duration +
                ", level='" + level + '\'' +
                '}';
    }
}