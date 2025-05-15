<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.ATG.DB.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Department</title>
    <link rel="stylesheet" href="css/DepartmentStyle.css">
    
</head>
<body>
    <div class="container">
        <h1>Department Management</h1>
        <form id="departmentForm" action="../DepartmentServlet" method="post">
            <div class="form-group">
                <label for="programSelect">Program</label>
                <select id="programSelect" name="programName" required>
                    <option value="">Select Program</option>
                    <%-- Dynamically load programs here --%>
                    <% 
                        
                        Connection conn = DBUtil.getConnection();
                        String sql = "SELECT  name FROM programs";
                        try (PreparedStatement stmt = conn.prepareStatement(sql);
                             ResultSet rs = stmt.executeQuery()) {
                            while (rs.next()) {
                                String programName = rs.getString("name");
                    %>
                    <option value="<%= programName %>"><%= programName %></option>
                    <% 
                            }
                        }
                        catch (Exception e) {
                            e.printStackTrace();
                        }
                        
                    %>
                </select>
            </div>

            <!-- Department ID -->
            <div class="form-group">
                <label for="departmentId">Department ID</label>
                <input type="text" id="departmentId" name="departmentId" placeholder="Enter Department ID" required>
            </div>

            <!-- Department Name -->
            <div class="form-group">
                <label for="departmentName">Department Name</label>
                <input type="text" id="departmentName" name="departmentName" placeholder="Enter Department Name" required>
            </div>

            <!-- Buttons -->
            <div class="button-group">
                <button type="submit" id="addButton" name="action" value="add">Add</button>
                <!--  <button type="button" id="viewButton" name="action" value="view">View/Edit</button>-->
            </div>
        </form>

        <!-- Error Messages -->
        <% String error = request.getParameter("error");
           if (error != null && error.equals("1")) { %>
               <p id="error-msg" style="color: green; background: lightyellow;">Added Successfully</p>
        <% } else if (error != null && error.equals("2")) { %>
               <p id="error-msg" style="color: red; background: lightyellow;">Operation Failed</p>
       <% }else if (error != null && error.equals("3")) { %>
               <p id="error-msg" style="color: green; background: lightyellow;">Deleted Successfully!</p>
        <% } %>

        <h2>Existing Programs</h2>
        <table id="programTable" style="width: 100%;
    border-collapse: collapse;
    margin-top: 20px;">
            <thead>
                <tr>
                    <th>S.No</th>
                    <th>Program Name</th>
                    <th>Dept Id</th>
                    <th>Dept Name</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    try {
                        
                        String query = "SELECT * FROM departments";
                        PreparedStatement stmt = conn.prepareStatement(query);
                        ResultSet rs = stmt.executeQuery();
                        int x=1;
                        while (rs.next()) {
                            String program = rs.getString("program");
                            String id = rs.getString("id");
                            String deptname = rs.getString("deptname");
                %>
                            <tr>
                                <td style=" text-align: center;"><%= x++ %></td>
                                <td style=" text-align: center;"><%= program %></td>
                                <td style=" text-align: center;"><%= id %></td>
                                <td style=" text-align: center;"><%= deptname %></td>
                                <td style=" text-align: center;">
                                    <form action="../DepartmentServlet" method="post" style="display:inline;">
                                             <input type="hidden" name="departmentId" value="<%= id %>">
                                            <input type="hidden" name="departmentName" value="<%= deptname %>">
                                    <button type="submit" class="delete-btn" name="action" value="delete" style="background-color:#ff4d4d;color:white;" onclick="return confirm('Are you sure?')">Delete</button>
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
