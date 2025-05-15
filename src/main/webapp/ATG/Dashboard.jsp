<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard</title>
    <link rel="stylesheet" href="css/dashstyle.css">
</head>
<body>
    <%  
        HttpSession session1 = request.getSession(false);
        String uname = null;
        
        if (session1 != null && session1.getAttribute("username") != null) {
            uname = (String) session1.getAttribute("username");
        } else {
            response.sendRedirect("../Login/Login.jsp");
            return; // Stop further processing
        }
    %>

    <div class="dashboard">
        <!-- Sidebar -->
        <nav class="sidebar">
            <div class="sidebar-header">
                <h2>Welcome, <%= uname %>!</h2>
            </div>
            <ul class="sidebar-menu">
                <li><a href="#" data-page="DBHome.jsp">Home</a></li>
                <li><a href="#" data-page="Program.jsp">Programs</a></li>
                <li><a href="#" data-page="Department.jsp">Departments</a></li>
                <li><a href="#" data-page="Semesters.jsp">Semesters</a></li>
                <li><a href="#" data-page="Subjects.jsp">Subjects</a></li>
                <li><a href="#" data-page="Teachers.jsp">Teachers</a></li>
                <li><a href="#" data-page="AssignTS.jsp">Assign Subjects to Teachers</a></li>
                <li><a href="#" data-page="SlotLabs.jsp">Slot Labs</a></li>
                <li><a href="#" data-page="Timetable.jsp">Generate Timetable</a></li>
                <li><a href="#" data-page="TimetableActions.jsp">View Generated Timetables</a></li>
            </ul>
        </nav>

        <!-- Main Content -->
        <div class="main">
            <!-- Header -->
            <header class="main-header">
                <h2 class="header-title">Automatic Timetable Generator</h2>
                <form action="../LogoutServlet" method="post" class="logout-form">
                    <button type="submit" class="logout-button">Logout</button>
                </form>
            </header>

            <!-- Dynamic Content Area -->
            <iframe id="content-frame" src="DBHome.jsp" width="100%" height="100%" style="border: none;"></iframe>
        </div>
    </div>

    <script>
        // JavaScript for dynamic iframe content loading
        document.querySelectorAll(".sidebar-menu a").forEach(link => {
            link.addEventListener("click", event => {
                event.preventDefault();
                const page = link.getAttribute("data-page");
                const iframe = document.getElementById("content-frame");
                iframe.src = page; // Set the iframe's src dynamically
            });
        });
    </script>
</body>
</html>
