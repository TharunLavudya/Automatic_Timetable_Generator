<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.ATG.DB.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Student Timetable</title>
<link rel="stylesheet" href="../ATG/css/InputAdd.css">
<Style>
.container {
    width: 100%;
    max-width: 1000px;
    margin: 50px auto;
    background: #f9f9f9;
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}
</Style>
</head>
<body>
    
    <div class="container">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 20px;">
        <h1 style="margin: 0 auto; text-align: center; flex: 1;">Timetable Viewer</h1>
        <form action="../Home.jsp" style="margin-left: auto;">
            <button type="submit" class="styled-button">Go Back</button>
        </form>
    </div>

<br><br>
               
        <form id="timetableForm" action="../TimeTableServlet" method="post">
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

            <!-- Generate Button -->
            <div class="button-container">
            
                <button type="button" class="styled-button" id="viewButton">view Timetable</button>
            </div>
        </form>
        

        <!-- Table for displaying the generated timetable -->
        <div id="timetableContainer" style="margin-top: 20px;">
            <h2>Generated Timetable</h2>
            <table id="timetable" border="1">
                <!-- Timetable will be dynamically populated -->
            </table>
        </div>
    </div>
    
    <script src="../ATG/script/timetable.js">
       
    </script>
</body>
</html>
