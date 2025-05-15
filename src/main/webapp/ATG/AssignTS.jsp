<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.ATG.DB.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assign Subjects</title>
    <link rel="stylesheet" href="css/InputAdd.css">
</head>
<body>
    <div class="container">
    <% 
            String success = request.getParameter("success");
            String error = request.getParameter("error");
            if ("1".equals(success)) {
        %>
        <p id="success-msg" style="color: green; background: #d4edda; padding: 10px; border-radius: 5px;">
            Teacher added to Subject successfully!
        </p>
        <% 
            } else if ("2".equals(error)) { 
        %>
        <p id="error-msg" style="color: red; background: #f8d7da; padding: 10px; border-radius: 5px;">
            Invalid Input!
        </p>
        <% } %>
        <h1>Assign Subjects to Teachers</h1>
        <form id="assignForm" action="../AssignServlet" method="post">
            <!-- Program Dropdown -->
            <div class="form-group">
                <label for="programName">Program</label>
                <select id="programName" name="programName" required>
                    <option value="" disabled selected>Select a Program</option>
                    <% 
                        Connection conn = DBUtil.getConnection();
                        String sql = "SELECT DISTINCT name FROM programs";
                        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                            ResultSet rs = stmt.executeQuery();
                            while (rs.next()) {
                    %>
                    <option value="<%= rs.getString("name") %>"><%= rs.getString("name") %></option>
                    <% 
                            }
                            rs.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    %>
                </select>
            </div>

            <!-- Department Dropdown -->
            <div class="form-group">
                <label for="departmentName">Department</label>
                <select id="departmentName" name="departmentName" required>
                    <option value="" disabled selected>Select a Department</option>
                </select>
            </div>

            <!-- Semester Dropdown -->
            <div class="form-group">
                <label for="semester">Semester</label>
                <select id="semester" name="semester" required>
                    <option value="" disabled selected>Select a Semester</option>
                </select>
            </div>

            <!-- Section -->
            <div class="form-group">
                <label for="section">Section</label>
                <select id="section" name="section" required>
                    <option value="" disabled selected>Select a Section</option>
                </select>
            </div>

            <!-- Subject -->
            <div class="form-group">
                <label for="subjectCode">Subject</label>
                <select id="subjectCode" name="subjectCode" required>
                    <option value="" disabled selected>Select a Subject</option>
                </select>
            </div>

            <!-- Teacher -->
            <div class="form-group">
                <label for="teacherId">Teacher</label>
                <select id="teacherId" name="teacherId" required>
                    <option value="" disabled selected>Select a Teacher</option>
                </select>
            </div>

            <!-- Submit Button -->
            <div class="button-container">
                <button type="submit" class="styled-button" name="action" value="assign">Assign</button>
            </div>
        </form>
        <br>
        <div class="button-container">
        <form action="ViewPages/ViewAssigned.jsp">
        <button type="submit" id="viewButton" class="styled-button" name="action" value="view">View</button>
         </form>
    </div>
    </div>

    <!-- JavaScript for AJAX -->
      <script>
      //for program
      document.getElementById("programName").addEventListener("change", function () {
          const program = this.value;
          const departmentDropdown = document.getElementById("departmentName");

          
          departmentDropdown.innerHTML = `<option value="" disabled selected>Loading...</option>`;

          
          fetch('../SubjectsServlet?action=getDepartments&program=' + encodeURIComponent(program))
              .then(response => response.json())
              .then(data => {
                  if (data.success) {
                      departmentDropdown.innerHTML = `<option value="" disabled selected>Select a Department</option>`;
                      data.departments.forEach(dept => {
                          const option = document.createElement("option");
                          option.value = dept;
                          option.textContent = dept;
                          departmentDropdown.appendChild(option);
                      });
                  } else {
                      departmentDropdown.innerHTML = `<option value="" disabled selected>No departments available</option>`;
                  }
              })
              .catch(error => {
                  departmentDropdown.innerHTML = `<option value="" disabled selected>Error loading departments</option>`;
                  console.error("Error fetching departments:", error);
              });
      });
      //for semesters
      document.getElementById("departmentName").addEventListener("change", function () {
          const department = this.value;
          const program = document.getElementById("programName").value; 
          const semesterDropdown = document.getElementById("semester");

          semesterDropdown.innerHTML = `<option value="" disabled selected>Loading...</option>`;

         
          fetch('../SubjectsServlet?action=getSemesters&program=' + encodeURIComponent(program) + '&department=' + encodeURIComponent(department))
              .then(response => response.json())
              .then(data => {
                  if (data.success) {
                      semesterDropdown.innerHTML = `<option value="" disabled selected>Select a semester</option>`;
                      data.semesters.forEach(sem => {
                          const option = document.createElement("option");
                          option.value = sem;
                          option.textContent = sem;
                          semesterDropdown.appendChild(option);
                      });
                  } else {
                      semesterDropdown.innerHTML = `<option value="" disabled selected>No semesters available</option>`;
                  }
              })
              .catch(error => {
                  semesterDropdown.innerHTML = `<option value="" disabled selected>Error loading semesters</option>`;
                  console.error("Error fetching semesters:", error);
              });
      });
      
      
      document.getElementById("semester").addEventListener("change", function () {
    const semester = this.value;
    const program = document.getElementById("programName").value;
    const department = document.getElementById("departmentName").value;
    const sectionDropdown = document.getElementById("section"); 
    const subjectDropdown = document.getElementById("subjectCode");
    const teacherDropdown = document.getElementById("teacherId");
  //for sections
    sectionDropdown.innerHTML = `<option value="" disabled selected>Loading...</option>`;
    fetch('../AssignServlet?action=getSection&program=' + encodeURIComponent(program) + 
          '&department=' + encodeURIComponent(department) + 
          '&semester=' + encodeURIComponent(semester))
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                sectionDropdown.innerHTML = `<option value="" disabled selected>Select a section</option>`;
                let c = 'A';
                while (data.sections-- > 0) {
                    const option = document.createElement("option");
                    option.value = c;
                    option.textContent = c;
                    sectionDropdown.appendChild(option);
                    c = String.fromCharCode(c.charCodeAt(0) + 1); 
                }
            } else {
                sectionDropdown.innerHTML = `<option value="" disabled selected>No sections available</option>`;
            }
        })
        .catch(error => {
            sectionDropdown.innerHTML = `<option value="" disabled selected>Error loading sections</option>`;
            console.error("Error fetching sections:", error);
        });
    
    //for subjects
    subjectDropdown.innerHTML = `<option value="" disabled selected>Loading...</option>`;
    fetch('../AssignServlet?action=getSubject&program=' + encodeURIComponent(program) + 
          '&department=' + encodeURIComponent(department) + 
          '&semester=' + encodeURIComponent(semester))
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                subjectDropdown.innerHTML = `<option value="" disabled selected>Select a subject</option>`;
                data.subjects.forEach(sub => {
                    const option = document.createElement("option");
                    option.value = sub;
                    option.textContent = sub;
                    subjectDropdown.appendChild(option);
                });
            } else {
                subjectDropdown.innerHTML = `<option value="" disabled selected>No subjects available</option>`;
            }
        })
        .catch(error => {
            subjectDropdown.innerHTML = `<option value="" disabled selected>Error loading subjects</option>`;
            console.error("Error fetching subjects:", error);
        });
    
    //for teachers
    teacherDropdown.innerHTML = `<option value="" disabled selected>Loading...</option>`;
    fetch('../AssignServlet?action=getTeacher&program=' + encodeURIComponent(program) + 
          '&department=' + encodeURIComponent(department) + 
          '&semester=' + encodeURIComponent(semester))
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                teacherDropdown.innerHTML = `<option value="" disabled selected>Select a teacher</option>`;
                data.teachers.forEach(teacher => {
                    const option = document.createElement("option");
                    option.value = teacher;
                    option.textContent = teacher;
                    teacherDropdown.appendChild(option);
                });
            } else {
                teacherDropdown.innerHTML = `<option value="" disabled selected>No teachers available</option>`;
            }
        })
        .catch(error => {
            teacherDropdown.innerHTML = `<option value="" disabled selected>Error loading teachers</option>`;
            console.error("Error fetching teachers:", error);
        });
    
});
      </script>
</body>
</html>
