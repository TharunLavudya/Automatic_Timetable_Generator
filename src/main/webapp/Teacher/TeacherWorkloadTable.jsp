<%@ page import="java.sql.*, com.ATG.DB.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String teacherId = request.getParameter("teacherId");
    if (teacherId != null && !teacherId.isEmpty()) {
        try (Connection conn = DBUtil.getConnection()) {
            String sql = "SELECT day, time_slot, program, department, semester, section, subject " +
                         "FROM global_schedule WHERE teacher = ? " +
                         "ORDER BY FIELD(day, 'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'), time_slot";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, teacherId);
                ResultSet rs = pstmt.executeQuery();
%>
<style>
    .workload-table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
        font-size: 16px;
        background-color: #fff;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
    }
    .workload-table th, .workload-table td {
        border: 1px solid #ccc;
        padding: 10px 12px;
        text-align: center;
    }
    .workload-table th {
        background-color: #f0f0f0;
        font-weight: bold;
    }
</style>

<table class="workload-table">
    <thead>
        <tr>
            <th>Day</th>
            <th>Time Slot</th>
            <th>Program</th>
            <th>Department</th>
            <th>Semester</th>
            <th>Section</th>
            <th>Subject</th>
        </tr>
    </thead>
    <tbody>
        <% boolean hasRows = false;
           while (rs.next()) {
               hasRows = true;
        %>
        <tr>
            <td><%= rs.getString("day") %></td>
            <td><%= rs.getString("time_slot") %></td>
            <td><%= rs.getString("program") %></td>
            <td><%= rs.getString("department") %></td>
            <td><%= rs.getString("semester") %></td>
            <td><%= rs.getString("section") %></td>
            <td><%= rs.getString("subject") %></td>
        </tr>
        <% } 
           if (!hasRows) { %>
           <tr>
               <td colspan="7">No workload entries found for this teacher.</td>
           </tr>
        <% } %>
    </tbody>
</table>
<%
            }
        } catch (SQLException e) {
            out.println("<p style='color: red;'>Error loading workload data.</p>");
            e.printStackTrace();
        }
    } else {
%>
    <p style="color: red;">Invalid or missing teacher ID.</p>
<%
    }
%>
