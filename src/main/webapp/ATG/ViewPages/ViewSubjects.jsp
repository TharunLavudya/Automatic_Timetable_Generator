<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.ATG.DB.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Subjects</title>
    <link rel="stylesheet" href="../css/viewStyle.css">
</head>
<body>
    <div class="container">
    <% String error = request.getParameter("error");
           if (error != null && error.equals("1")) { %>
               <p id="error-msg" style="color: green; background: lightyellow;">Deleted Successfully!</p>
        <% } else if (error != null && error.equals("2")) { %>
               <p id="error-msg" style="color: red; background: lightyellow;">Operation Failed</p>
        <% } %>
        <h1>View Subjects</h1>
        <table>
            <thead>
                <tr>
                    <th>S.No</th>
                    <th>Program</th>
                    <th>Department</th>
                    <th>Semester</th>
                    <th>Subject code</th>
                    <th>Subject Name</th>
                    <th>classesPerWeek</th>
                    <th>Credits</th>
                    <th>Type</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <!-- Populate rows dynamically -->
                <% 
                    try {
                    	Connection conn = DBUtil.getConnection();
                        String query = "SELECT * FROM subjects";
                        PreparedStatement stmt = conn.prepareStatement(query);
                        ResultSet rs = stmt.executeQuery();
                        int x=1;
                        while (rs.next()) {
                        	String programName = rs.getString("programName");
                		    String departmentName = rs.getString("departmentName");
                		    String semester =rs.getString("semester");
                		    String subjectCode = rs.getString("subjectCode");
                		    String subjectName = rs.getString("subjectName");
                		    int classesPerWeek = rs.getInt("classesPerWeek");
                		    int credits = rs.getInt("credits");
                		    String subjectType = rs.getString("subjectType");
                %>
                        
                <tr>
                    <td><%=x++ %></td>
                    <td><%= programName %></td>
                    <td><%= departmentName %></td>
                    <td><%= semester %></td>
                    <td><%= subjectCode%></td>
                    <td><%= subjectName %> </td>
                     <td><%= classesPerWeek %></td>
                    <td><%= credits %></td>
                    <td><%= subjectType  %></td>
                    <td>
                        <form action="../../SubjectsServlet" method="post">
                            <input type="hidden" name="semester" value="<%= semester%>">
                            <input type="hidden" name="departmentName" value="<%= departmentName%>">
                            <input type="hidden" name="subjectName" value="<%= subjectName %>">
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
        <form action="../Subjects.jsp">
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
