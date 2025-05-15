<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.ATG.DB.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Teacher Workload Viewer</title>
<link rel="stylesheet" href="../ATG/css/InputAdd.css">
<Style>
.container {
    width: 100%;
    max-width: 1300px;
    margin: 50px auto;
    background: #f9f9f9;
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}
.group-row {
    display: flex;
    gap: 110px; 
    align-items: center;
}
.group-select {
    display: flex;
    flex-direction: column;
}
.group-select label {
    font-weight: bold;
    margin-bottom: 5px;
}
.sec-sel {
    width: 300px;
    padding: 10px;
    font-size: 16px;
    border: 1px solid #ccc;
    border-radius: 5px; 
}
table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 30px;
}
th, td {
    padding: 10px;
    border: 1px solid #ccc;
    text-align: center;
}
th {
    background-color: #f0f0f0;
}
</Style>
</head>
<body>

<div class="container">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 20px;">
        <h1 style="margin: 0 auto; text-align: center; flex: 1;">Teacher Workload Viewer</h1>
        <form action="../Home.jsp" style="margin-left: auto;">
            <button type="submit" class="styled-button">Go Back</button>
        </form>
    </div>

    <br><br>

        <div class="group-row">
            <div class="group-select">
                <label for="programName">Program</label>
                <select id="programName" class="sec-sel" name="programName" required>
                    <option value="" disabled selected>Select a Program</option>
                    <% 
                        Connection conn = DBUtil.getConnection();
                        String sql = "SELECT DISTINCT name FROM programs";
                        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                            ResultSet rs = stmt.executeQuery();
                            while (rs.next()) {
                    %>
                    <option value="<%= rs.getString("name") %>" <%= request.getParameter("programName") != null && request.getParameter("programName").equals(rs.getString("name")) ? "selected" : "" %>><%= rs.getString("name") %></option>
                    <% 
                            }
                            rs.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    %>
                </select>
            </div>

            <div class="group-select">
                <label for="departmentName">Department</label>
                <select id="departmentName" class="sec-sel" name="departmentName" required>
                    <option value="" disabled selected>Select a Department</option>
                </select>
            </div>

            <div class="group-select">
                <label for="semester">Semester</label>
                <select id="semester" class="sec-sel" name="semester" required>
                    <option value="" disabled selected>Select a Semester</option>
                </select>
            </div> 
        </div>
        <br>
        <div class="group-select">
            <label for="teacherId">Teacher</label>
            <select id="teacherId" class="sec-sel" name="teacherId" required>
                <option value="" disabled selected>Select a Teacher</option>
            </select>
        </div>
        <br>
        <div style="margin-top: 20px;">
    <button type="button" id="viewWorkloadBtn" class="styled-button" onclick="loadWorkloadTable()">View Workload</button>
</div>

<div id="workload-table-container" style="margin-top: 30px;"></div>


   
</div>

<script src="../ATG/script/timetable.js"></script>
<script>
document.getElementById("semester").addEventListener("change", function () {
    const semester = this.value;
    const program = document.getElementById("programName").value;
    const department = document.getElementById("departmentName").value;
    const teacherDropdown = document.getElementById("teacherId");
    teacherDropdown.innerHTML = `<option value="" disabled selected>Loading...</option>`;
    fetch('../AssignServlet?action=getTeacher&program=' + encodeURIComponent(program) + 
          '&department=' + encodeURIComponent(department) + 
          '&semester=' + encodeURIComponent(semester))
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                teacherDropdown.innerHTML = `<option value="" disabled selected>Select a teacher</option>`;
                data.teachers.forEach(teacher => {
                    const option = document.createElement("option");
                    option.value = teacher;
                    option.textContent = teacher;
                    teacherDropdown.appendChild(option);
                });
            } else {
                teacherDropdown.innerHTML = `<option value="" disabled selected>No teachers available</option>`;
            }
        })
        .catch(error => {
            teacherDropdown.innerHTML = `<option value="" disabled selected>Error loading teachers</option>`;
            console.error("Error fetching teachers:", error);
        });
});

document.getElementById("viewWorkloadBtn").addEventListener("click", function () {
    const teacherId = document.getElementById("teacherId").value;
    const program = document.getElementById("programName").value;
    const department = document.getElementById("departmentName").value;
    const semester = document.getElementById("semester").value;

    if (!teacherId) {
        alert("Please select a teacher first.");
        return;
    }

    fetch("TeacherWorkloadTable.jsp?teacherId=" + encodeURIComponent(teacherId) +
    	      "&program=" + encodeURIComponent(program) +
    	      "&department=" + encodeURIComponent(department) +
    	      "&semester=" + encodeURIComponent(semester))
        .then(response => response.text())
        .then(html => {
            document.getElementById("workload-table-container").innerHTML = html;
        })
        .catch(error => {
            console.error("Error fetching workload table:", error);
        });
});

</script>

</body>
</html>
