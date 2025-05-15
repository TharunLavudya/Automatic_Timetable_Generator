<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.ATG.DB.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Program Management</title>
    <link rel="stylesheet" href="css/ProgramStyle.css">
</head>
<body>
    <div class="container">
        <h1>Program Management</h1>
        <!-- Add Program Form -->
        <form id="programForm" action="../ProgramServlet" method="post">
            <div class="form-group">
                <label for="program">Program</label>
                <input type="text" id="program" name="programName" placeholder="Enter Program" required>
            </div>
            <div class="button-group">
                <button type="submit" id="addButton" name="action" value="add">Add</button>
            </div>
        </form>
        <br/>

        <!-- Display Error/Success Message -->
        <% String error = request.getParameter("error");
           if (error != null && error.equals("1")) { %>
               <p id="error-msg" style="color: green; background: lightyellow;">Added Successfully!</p>
        <% } else if (error != null && error.equals("2")) { %>
               <p id="error-msg" style="color: red; background: lightyellow;">Error: Invalid Input</p>
        <% }else if (error != null && error.equals("3")) { %>
               <p id="error-msg" style="color: green; background: lightyellow;">Deleted Successfully!</p>
        <% } %>

        <!-- View Programs -->
        <h2>Existing Programs</h2>
        <table id="programTable" style="width: 100%;
    border-collapse: collapse;
    margin-top: 20px;">
            <thead>
                <tr>
                    <th>S.No</th>
                    <th>Program</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    try {
                        Connection conn = DBUtil.getConnection();
                        String sql = "SELECT name FROM programs";
                        PreparedStatement stmt = conn.prepareStatement(sql);
                        ResultSet rs = stmt.executeQuery();
                        int x=1;
                        while (rs.next()) {
                            String program = rs.getString("name");
                %>
                            <tr>
                                <td style=" text-align: center;"><%= x++ %></td>
                                <td style=" text-align: center;"><%= program %></td>
                                <td style=" text-align: center;">
                                    <form action="../ProgramServlet" method="post" style="display:inline;">
                                        <input type="hidden" name="programName" value="<%= program %>">
                                        <button type="submit" class="delete-btn"name="action" value="delete" style="background-color:#ff4d4d;color:white;"  onclick="return confirm('Are you sure?')">Delete</button>
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
    </div>
</body>
</html>
