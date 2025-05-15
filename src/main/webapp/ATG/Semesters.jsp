<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.ATG.DB.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Semester</title>
    <link rel="stylesheet" href="css/SemesterStyle.css">
</head>
<body>
    <div class="container">
    <% 
            String success = request.getParameter("success");
            String error = request.getParameter("error");
            if ("1".equals(success)) {
        %>
        <p id="success-msg" style="color: green; background: #d4edda; padding: 10px; border-radius: 5px;">
            Semester added successfully!
        </p>
        <% 
            } else if ("2".equals(error)) { 
        %>
        <p id="error-msg" style="color: red; background: #f8d7da; padding: 10px; border-radius: 5px;">
            Error adding semester. Please try again.
        </p>
        <% } %>
        <h1>Add Semester</h1>
        <form id="semesterForm" action="../SemesterServlet" method="post">
            <div class="form-group">
                <label for="programName">Program</label>
                <select id="programName" name="programName" required>
                    <option value="" disabled selected>Select a Program</option>
                    <% 
                        Connection conn = null;
                        PreparedStatement stmt = null;
                        ResultSet rs = null;
                        try {
                            conn = com.ATG.DB.DBUtil.getConnection();
                            String sql = "SELECT name FROM programs";
                            stmt = conn.prepareStatement(sql);
                            rs = stmt.executeQuery();
                            while (rs.next()) {
                    %>
                    <option value="<%= rs.getString("name") %>"><%= rs.getString("name") %></option>
                    <% 
                            }
                        } catch (SQLException e) {
                            e.printStackTrace();
                        } finally {
                            if (rs != null) rs.close();
                            if (stmt != null) stmt.close();
                            if (conn != null) conn.close();
                        }
                    %>
                </select>
            </div>

            <div class="form-group">
                <label for="departmentName">Department</label>
                <select id="departmentName" name="departmentName" required>
                    <option value="" disabled selected>Select a Department</option>
                </select>
            </div>

            <div class="form-group">
                <label for="semester">Semester</label>
                <input type="text" id="semester" name="semester" placeholder="e.g., 3-2" required>
            </div>

            <div class="form-group">
                <label for="numSections">Number of Sections</label>
                <input type="number" id="numSections" name="numSections" placeholder="Enter number of sections" required>
            </div>

            <div class="form-group">
                <label for="startTime">Class Start Time</label>
                <input type="time" id="startTime" name="startTime" required>
            </div>

            <div class="form-group">
                <label for="endTime">Class End Time</label>
                <input type="time" id="endTime" name="endTime" required>
            </div>

            <div class="form-group">
                <label for="classDuration">Class Duration (minutes)</label>
                <input type="number" id="classDuration" name="classDuration" placeholder="Enter class duration in minutes" required>
            </div>

            <div class="form-group">
                <label for="breakDuration">Break Duration (minutes)</label>
                <input type="number" id="breakDuration" name="breakDuration" placeholder="Enter break duration in minutes" required>
            </div>

            <div class="button-container">
                <button type="submit" class="styled-button" id="addButton" name="action" value="add">Add Semester</button>
            </div>
        </form>
        <br>
        <div class="button-container">
        <form action="ViewPages/ViewSemester.jsp">
        <button type="submit" id="viewButton" class="styled-button" name="action" value="view">View</button>
         </form>
         </div>
    </div>

    <script>
    document.getElementById("programName").addEventListener("change", function () {
        const program = this.value;
        const departmentDropdown = document.getElementById("departmentName");

        // Clear previous options
        departmentDropdown.innerHTML = `<option value="" disabled selected>Loading...</option>`;

        // Fetch departments for the selected program
        fetch('../SemesterServlet?action=getDepartments&program=' + encodeURIComponent(program))
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

    </script>
</body>
</html>
