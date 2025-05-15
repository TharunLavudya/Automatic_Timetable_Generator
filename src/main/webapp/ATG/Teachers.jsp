<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.ATG.DB.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Teacher</title>
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
            Teacher added successfully!
        </p>
        <% 
            } else if ("2".equals(error)) { 
        %>
        <p id="error-msg" style="color: red; background: #f8d7da; padding: 10px; border-radius: 5px;">
            Invalid Input!
        </p>
        <% } %>
        
        
        <h1>Add Teacher</h1>
        <form id="teacherForm" action="../TeachersServlet" method="post">
            <!-- Program Dropdown -->
            <div class="form-group">
                <label for="programName">Program</label>
                <select id="programName" name="programName" required>
                    <option value="" disabled selected>Select a Program</option>
                    <% 
                        // Populate Program Dropdown
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

            <!-- Teacher ID -->
            <div class="form-group">
                <label for="teacherId">Teacher ID</label>
                <input type="text" id="teacherId" name="teacherId" placeholder="Enter Teacher ID" required>
            </div>

            <!-- Teacher Name -->
            <div class="form-group">
                <label for="teacherName">Teacher Name</label>
                <input type="text" id="teacherName" name="teacherName" placeholder="Enter Teacher Name" required>
            </div>

            <!-- Submit Button -->
            <div class="button-container">
                <button type="submit" class="styled-button" id="addButton" name="action" value="add">Add Teacher</button>
            </div>
        </form>
        <br>
        <div class="button-container">
        <form action="ViewPages/ViewTeachers.jsp">
        <button type="submit" id="viewButton" class="styled-button" name="action" value="view">View</button>
         </form>
    </div>
    </div>

    <!-- JavaScript for AJAX -->
    <script>
    document.getElementById("programName").addEventListener("change", function () {
        const program = this.value;
        const departmentDropdown = document.getElementById("departmentName");

        // Clear previous options
        departmentDropdown.innerHTML = `<option value="" disabled selected>Loading...</option>`;

        // Fetch departments for the selected program
        fetch('../TeachersServlet?action=getDepartments&program=' + encodeURIComponent(program))
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
    
    
    document.getElementById("departmentName").addEventListener("change", function () {
        const department = this.value;
        const program = document.getElementById("programName").value; // Get selected program value
        const semesterDropdown = document.getElementById("semester");

        // Clear previous options
        semesterDropdown.innerHTML = `<option value="" disabled selected>Loading...</option>`;

        // Fetch semesters for the selected program and department
        fetch('../TeachersServlet?action=getSemesters&program=' + encodeURIComponent(program) + '&department=' + encodeURIComponent(department))
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

    </script>
</body>
</html>
