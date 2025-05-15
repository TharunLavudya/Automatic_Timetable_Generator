# 🗓️ Automatic Timetable Generator

This is a Java-based Automatic Timetable Generator for colleges and universities. It uses JSP, Servlets, JDBC, and MySQL to dynamically allocate and manage subject, teacher, and lab schedules, ensuring no clashes and considering constraints like workloads and lab sessions.

---

## 🚀 Features

- Automatic timetable generation
- Manual lab slot booking
- Teacher workload viewer
- Clash-free scheduling across branches, years, and sections
- MySQL database integration

---

## 🧰 Tech Stack

- **Frontend**: HTML, CSS, JavaScript (Vanilla)
- **Backend**: JSP, Servlets, JDBC
- **Database**: MySQL
- **IDE Recommended**: Eclipse IDE for Enterprise Java Developers
- **Web Server**: Apache Tomcat (v9 or v10)

---

## 🏗️ Instructions on how to use it

### 1. Clone the Repository in your local folder

### 2. Import Project

Open Eclipse
Launch Eclipse IDE (choose workspace if prompted).

Go to File → Import...
Select General → Existing Projects into Workspace → Click Next
Browse to the cloned Automatic_Timetable_Generator folder
Click Finish

### 3. Convert to Dynamic Web Project (if not already)

Right-click the project → Properties
Go to Project Facets → Enable Dynamic Web Module and Java
Set the appropriate Java version

### 5. Configure Apache Tomcat

Go to Servers tab (or Window → Show View → Servers)
Add a new server → Select Apache Tomcat (install if not present)
Right-click project → Run As → Run on Server

### 6. Create the Database

Open MySQL Workbench or your MySQL CLI
Run the SQL schema file located in the db/ folder:

 - SOURCE path/to/Automatic_Timetable_Generator/db/schema.sql;

### Also add the password, username  in DBUtil.java file in java/com/ATG/DB

