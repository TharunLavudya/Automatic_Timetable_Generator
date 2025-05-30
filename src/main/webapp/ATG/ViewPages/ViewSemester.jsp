<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.ATG.DB.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Semesters</title>
    <link rel="stylesheet" href="../css/DepartmentStyle.css">
</head>
<body>
    <div class="container">
    <% String error = request.getParameter("error");
           if (error != null && error.equals("1")) { %>
               <p id="error-msg" style="color: green; background: lightyellow;">Deleted Successfully!</p>
        <% } else if (error != null && error.equals("2")) { %>
               <p id="error-msg" style="color: red; background: lightyellow;">Operation Failed</p>
        <% } %>
        <h1>View Semesters</h1>
        <table>
            <thead>
                <tr>
                    <th>S.No</th>
                    <th>Program</th>
                    <th>Department</th>
                    <th>Semester</th>
                    <th>Sections</th>
                    <th>Class Timings</th>
                    <th>Class Duration</th>
                    <th>Break Duration</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <!-- Populate rows dynamically -->
                <% 
                    try {
                    	Connection conn = DBUtil.getConnection();
                        String query = "SELECT * FROM semesters";
                        PreparedStatement stmt = conn.prepareStatement(query);
                        ResultSet rs = stmt.executeQuery();
                        int x=1;
                        while (rs.next()) {
                        	String programName = rs.getString("programName");
                            String departmentName = rs.getString("departmentName");
                            String semester = rs.getString("semester");
                            int numSections = rs.getInt("numSections");
                            String startTime = rs.getString("startTime");
                            String endTime = rs.getString("endTime");
                            int classDuration = rs.getInt("classDuration");
                            int breakDuration = rs.getInt("breakDuration");
                %>
                        
                <tr>
                    <td><%=x++ %></td>
                    <td><%= programName %></td>
                    <td><%= departmentName %></td>
                    <td><%= semester %></td>
                    <td><%= numSections%></td>
                    <td><%= startTime %> to <%= endTime %></td>
                    <td><%= classDuration %></td>
                    <td><%= breakDuration  %></td>
                    <td>
                        <form action="../../SemesterServlet" method="post">
                            <input type="hidden" name="semesterId" value="<%= semester%>">
                            <input type="hidden" name="departmentName" value="<%= departmentName%>">
                            <button type="submit" name="action" value="delete" class="delete-btn" onclick="return confirm('Are you sure?')">Delete</button>
                        </form>
                    </td>
                </tr>
                <%      }
                        conn.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                %>
            </tbody>
        </table>
        <br/>
        <form action="../Semesters.jsp">
        <button type="submit" id="backButton" name="action" value="view" style="padding: 8px 16px;
    border: none;
    background: #007bff;
    color: white;
    border-radius: 5px;
    cursor: pointer;">Back to Adding</button>
         </form>
    </div>
</body>
</html>
