<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.ATG.DB.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Assign</title>
    <link rel="stylesheet" href="../css/viewStyle.css">
</head>
<body>
    <div class="container">
    <% String error = request.getParameter("error");
           if (error != null && error.equals("1")) { %>
               <p id="error-msg" style="color: green; background: lightyellow;">Deleted Successfully!</p>
        <% } else if (error != null && error.equals("2")) { %>
               <p id="error-msg" style="color: red; background: lightyellow;">Operation Failed!</p>
        <% } %>
        <h1>View Assigned Subjects to Teachers</h1>
        <table>
            <thead>
                <tr>
                    <th>S.No</th>
                    <th>Program</th>
                    <th>Department</th>
                    <th>Semester</th>
                    <th>Section</th>
                    <th>Subject</th>
                    <th>Teacher</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <!-- Populate rows dynamically -->
                <% 
                    try {
                    	Connection conn = DBUtil.getConnection();
                        String query = "SELECT * FROM assign";
                        PreparedStatement stmt = conn.prepareStatement(query);
                        ResultSet rs = stmt.executeQuery();
                        int x=1;
                        while (rs.next()) {
                        	String programName = rs.getString("programName");
                		    String departmentName = rs.getString("departmentName");
                		    String semester =rs.getString("semester");
                		    String section = rs.getString("section");
                		    String subject = rs.getString("subjectName");
                		    String teacher = rs.getString("teacherName");
                %>
                        
                <tr>
                    <td><%=x++ %></td>
                    <td><%= programName %></td>
                    <td><%= departmentName %></td>
                    <td><%= semester %></td>
                    <td><%= section %></td>
                    <td><%= subject %></td>
                    <td><%= teacher %> </td>
                    <td>
                        <form action="../../AssignServlet" method="post">
                        <input type="hidden" name="semester" value="<%= semester %>">
                            <input type="hidden" name="section" value="<%= section %>">
                            <input type="hidden" name="subjectName" value="<%= subject %>">
                            <input type="hidden" name="teacherName" value="<%= teacher %>">
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
        <form action="../AssignTS.jsp">
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
