package dz.ensticp.formation.model;

import java.util.ArrayList;
import java.util.List;

/**
 * Student Model - Represents a student/learner
 */
public class Student {
    private int id;
    private String name;
    private String email;
    private List<Course> enrolledCourses;
    
    // Constructors
    public Student() {
        this.enrolledCourses = new ArrayList<>();
    }
    
    public Student(int id, String name, String email) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.enrolledCourses = new ArrayList<>();
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public List<Course> getEnrolledCourses() {
        return enrolledCourses;
    }
    
    public void setEnrolledCourses(List<Course> enrolledCourses) {
        this.enrolledCourses = enrolledCourses;
    }
    
    // Business methods
    public void enrollInCourse(Course course) {
        if (!enrolledCourses.contains(course)) {
            enrolledCourses.add(course);
        }
    }
    
    public void unenrollFromCourse(Course course) {
        enrolledCourses.remove(course);
    }
    
    public boolean isEnrolledIn(Course course) {
        return enrolledCourses.contains(course);
    }
    
    public int getTotalEnrolledCourses() {
        return enrolledCourses.size();
    }
    
    @Override
    public String toString() {
        return "Student{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", email='" + email + '\'' +
                ", enrolledCourses=" + enrolledCourses.size() +
                '}';
    }
}