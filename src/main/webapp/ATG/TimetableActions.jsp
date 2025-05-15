<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.ATG.DB.*" %>
<%
    Connection conn = DBUtil.getConnection();
    String query = "SELECT DISTINCT programName, departmentName, semester, section FROM timetable ORDER BY departmentName, semester, section";
    PreparedStatement stmt = conn.prepareStatement(query);
    ResultSet rs = stmt.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Timetables</title>
    <link rel="stylesheet" href="css/viewStyle.css">
</head>
<style>
    .action-btns {
        display: flex;
        justify-content: left;
        gap: 30px; 
    }

    .btn-delete {
        background-color: #dc3545;
        color: white;
        border: none;
        padding: 5px 10px;
        border-radius: 5px;
    }

    .btn-delete:hover {
        background-color: #c82333;
    }

    .btn-view {
        background-color: #17a2b8;
        color: white;
        border: none;
        padding: 5px 10px;
        border-radius: 5px;
    }

    .btn-view:hover {
        background-color: #138496;
    }
</style>


<body class="bg-light">
<div class="container">
        <% String error = request.getParameter("error");
           if (error != null && error.equals("1")) { %>
               <p id="error-msg" style="color: green; background: lightyellow;">Deleted Successfully!</p>
        <% } else if (error != null && error.equals("2")) { %>
               <p id="error-msg" style="color: red; background: lightyellow;">Operation Failed</p>
        <% } %>
    <h2>Generated Timetables</h2>
    <table>
        <thead>
            <tr>
                <th>Program</th>
                <th>Department</th>
                <th>Semester</th>
                <th>Section</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
        <%
            while (rs.next()) {
                String program = rs.getString("programName");
                String dept = rs.getString("departmentName");
                String sem = rs.getString("semester");
                String section = rs.getString("section");
        %>
            <tr>
                <td><%= program %></td>
                <td><%= dept %></td>
                <td><%= sem %></td>
                <td><%= section %></td>
                <td>
                <div class="action-btns">
                <form action="viewTimetable.jsp" method="get" style="display:inline;">
                        <input type="hidden" name="program" value="<%= program %>">
                        <input type="hidden" name="department" value="<%= dept %>">
                        <input type="hidden" name="semester" value="<%= sem %>">
                        <input type="hidden" name="section" value="<%= section %>">
                        <button class="btn-view">View</button>
                    </form>
                    
                    
                    <form action="../TimetableDelete" method="post" style="display:inline;">
                        <input type="hidden" name="program" value="<%= program %>">
                        <input type="hidden" name="department" value="<%= dept %>">
                        <input type="hidden" name="semester" value="<%= sem %>">
                        <input type="hidden" name="section" value="<%= section %>">
                        <button class="btn-delete" onclick="return confirm('Are you sure?')">Delete</button>
                    </form>
                    </div>
                </td>
            </tr>
        <%
            }
            rs.close(); stmt.close();
        %>
        </tbody>
    </table>
</div>
</body>
</html>
