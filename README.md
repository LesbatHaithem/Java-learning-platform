<!-- PROJECT LOGO -->
<p align="center">
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/java/java-original.svg" alt="Java Logo" width="100"/>
</p>

<h1 align="center">🎓 Java Learning Platform</h1>

<p align="center">
  A modern educational web application built with <b>Java EE, Servlets, and JSP</b>.<br/>
  Learn, explore, and practice the core principles of Java Web Development.
  <br/><br/>
  <a href="https://github.com/LesbatHaithem/Java-learning-platform"><strong>🔗 Explore the project »</strong></a>
  <br/><br/>
  <img src="https://img.shields.io/badge/Java-25-blue?style=for-the-badge&logo=openjdk"/>
  <img src="https://img.shields.io/badge/Maven-4.0.0-orange?style=for-the-badge&logo=apache-maven"/>
  <img src="https://img.shields.io/badge/Tomcat-10+-yellow?style=for-the-badge&logo=apache-tomcat"/>
  <img src="https://img.shields.io/badge/JSP%20%26%20Servlets-Jakarta-blueviolet?style=for-the-badge"/>
</p>

---

## 📘 Overview

**Java Learning Platform** is a web-based application that demonstrates how to build a structured **Java EE project** using **Servlets**, **JSP**, and the **MVC architecture**.  
It's perfect for beginners learning Java Web Development and understanding the flow between client requests, server-side logic, and dynamic web pages.

---

## 🧩 Features

✅ Display a list of available courses  
✅ Enroll and unenroll in courses (session-based)  
✅ Uses Servlets + JSP for clean MVC separation  
✅ Lightweight and easily deployable on **Tomcat**  
✅ Fully written in **pure Java (no frameworks)**  

---

## 🏗️ Tech Stack

| Technology | Description |
|-------------|-------------|
| ☕ **Java 25 (JDK)** | Core programming language |
| 🧱 **Maven** | Build automation and dependency management |
| 🌐 **Jakarta Servlet API 5.0** | Backend web layer |
| 🖥️ **JSP** | View layer (frontend rendering) |
| 🚀 **Apache Tomcat 10+** | Java web server for deployment |

---

## 📂 Project Structure

```
Java-learning-platform/
│
├── src/
│   ├── main/
│   │   ├── java/dz/ensticp/formation/
│   │   │   ├── model/
│   │   │   │   ├── Course.java
│   │   │   │   └── Student.java
│   │   │   └── servlet/
│   │   │       └── CourseServlet.java
│   │   └── webapp/
│   │       ├── WEB-INF/web.xml
│   │       ├── index.jsp
│   │       └── courses.jsp
│   └── test/
│
├── pom.xml
└── README.md
```

---

## ⚙️ Installation & Setup

### 1️⃣ Clone the Repository
```bash
git clone https://github.com/LesbatHaithem/Java-learning-platform.git
cd Java-learning-platform
```

### 2️⃣ Build the Project
```bash
mvn clean package
```

### 3️⃣ Deploy the .war file

The build will generate:
```
target/Java-learning-platform.war
```

Copy this file to your Tomcat `webapps/` directory.

### 4️⃣ Run the Server

Start Tomcat and open your browser at:
```
http://localhost:8080/Java-learning-platform
```

---

## 🧭 Future Improvements

🚀 Add user authentication (login/register)  
💾 Integrate a real database (MySQL / PostgreSQL)  
🧮 Add course progress tracking  
🎨 Improve UI using Bootstrap or Tailwind CSS  
📊 Add an admin dashboard for managing courses

---

## 📝 License

This project is open source and available under the [MIT License](LICENSE).

---

## 👨‍💻 Author

**Haithem Lesbat**  
[GitHub](https://github.com/LesbatHaithem)