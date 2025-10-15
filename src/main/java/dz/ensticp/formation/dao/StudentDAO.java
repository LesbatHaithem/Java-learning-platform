package dz.ensticp.formation.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import dz.ensticp.formation.model.Student;

public class StudentDAO {
    // In-memory storage (replace with database in production)
    private static List<Student> students = new ArrayList<>();
    private static int nextId = 1;
    
    // Find student by email
    public Optional<Student> findByEmail(String email) {
        return students.stream()
                .filter(s -> s.getEmail().equalsIgnoreCase(email))
                .findFirst();
    }
    
    // Find student by Google ID
    public Optional<Student> findByGoogleId(String googleId) {
        return students.stream()
                .filter(s -> googleId.equals(s.getGoogleId()))
                .findFirst();
    }
    
    // Create new student
    public Student create(Student student) {
        student.setId(nextId++);
        students.add(student);
        return student;
    }
    
    // Update student
    public void update(Student student) {
        students.removeIf(s -> s.getId() == student.getId());
        students.add(student);
    }
    
    // Check if email exists
    public boolean emailExists(String email) {
        return findByEmail(email).isPresent();
    }
}