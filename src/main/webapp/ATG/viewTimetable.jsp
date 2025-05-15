<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.ATG.DB.*" %>
<%@ page import="java.util.*, com.ATG.Timetable.TimetableGenerator" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Subjects</title>
    <link rel="stylesheet" href="../css/viewStyle.css">
</head>
<body>
<%
    String program = request.getParameter("program");
    String department = request.getParameter("department");
    String semester = request.getParameter("semester");
    String section = request.getParameter("section");
    List<String> timeSlots = null;
    Map<String, Map<String, String>> timetable=null;
    String[] days={"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"};
    
    try {
    	Connection conn = DBUtil.getConnection();
        timeSlots = TimetableGenerator.fetchTimeSlots(conn, program, department, semester);
        timetable = new LinkedHashMap<>();

        for (String day : days) {
            timetable.put(day, new HashMap<>());
        }

        String query = "SELECT day, timeSlot, allocation FROM timetable WHERE programName = ? AND departmentName = ? AND semester = ? AND section = ? ORDER BY FIELD(day, 'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'), timeSlot";
        PreparedStatement stmt = conn.prepareStatement(query);
        stmt.setString(1, program);
        stmt.setString(2, department);
        stmt.setString(3, semester);
        stmt.setString(4, section);
        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            String day = rs.getString("day");
            String slot = rs.getString("timeSlot");
            String subjectTeacher = rs.getString("allocation");
            timetable.get(day).put(slot, subjectTeacher);
        }
    
    if(rs != null) rs.close();
    if(stmt != null) stmt.close();
    if(conn != null) conn.close();
    }
    catch(Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    }
        


%>

<div class="container">
<h2>Timetable for <%= program %> - <%= department %> - <%= semester %> - Section <%= section %></h2>

<table border="1" cellpadding="10" cellspacing="0">
    <tr>
        <th>Days/Slots</th>
        <% for(String slot : timeSlots) { %>
            <th><%= slot %></th>
        <% } %>
    </tr>

    <% for(String day : days) { %>
        <tr>
            <td><%= day %></td>
            <% for(String slot : timeSlots) {
                if(slot.contains("break")) 
                {%>
                <td></td>
                <%}else{ %>
                <% String val = timetable.get(day).get(slot); %>
                <td><%= val != null ? val : "" %></td>
            <% }} %>
        </tr>
    <% } %>
</table>
<br/>
        <form action="TimetableActions.jsp">
        <button type="submit" id="backButton" name="action" value="view" style="padding: 8px 16px;
    border: none;
    background: #007bff;
    color: white;
    border-radius: 5px;
    cursor: pointer;">Go Back</button>
         </form>
</div>
</body>
</html>
