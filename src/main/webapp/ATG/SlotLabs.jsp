<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*, com.ATG.Timetable.TimetableGenerator" %>
<%@ page import="com.ATG.DB.*" %>

<%
    String isAjax = request.getHeader("X-Requested-With");
    if ("XMLHttpRequest".equals(isAjax)) {
        String program = request.getParameter("program");
        String department = request.getParameter("department");
        String semester = request.getParameter("semester");

        if (program != null && department != null && semester != null) {
            Connection conn = null;

            try {
                
                conn = com.ATG.DB.DBUtil.getConnection();
                List<String> timeSlots = TimetableGenerator.fetchTimeSlots(conn, program, department, semester);

                // Output HTML for the table
                out.println("<table border='2' class='timetable'>");
                out.println("<thead><tr><th>Day / Time</th>");
                for (String slot : timeSlots) {
                    out.println("<th>" + slot + "</th>");
                }
                out.println("</tr></thead><tbody>");

                String[] days = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"};
                for (String day : days) {
                    out.println("<tr><th>" + day + "</th>");
                    for (int i = 0; i < timeSlots.size(); i++) {
                        out.println("<td onclick=\"toggleCell(this, '" + day + "', " + (i + 1) + ")\"></td>");
                    }
                    out.println("</tr>");
                }

                out.println("</tbody></table>");

            } catch (Exception e) {
                out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
            } finally {
                if (conn != null) conn.close();
            }
        }
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="css/InputAdd.css">
    <title>Manual Lab Slotting</title>
    <link rel="stylesheet" href="css/InputAdd.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f0f4f8;
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
  display: block;
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
        
        h2 {
            text-align: center;
        }
        .controls, .timetable {
            width: 90%;
            margin: auto;
            margin-bottom: 30px;
        }
        select, input[type="text"], button {
            margin: 5px;
            padding: 6px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        th, td {
            border: 1px solid #aaa;
            text-align: center;
            height: 50px;
            cursor: pointer;
        }
        .selected {
            background-color: #ffdd57;
        }
    </style>
    <script>
    function fetchTimeSlots() {
    	var program = document.getElementById("programName").value;
    	var department = document.getElementById("departmentName").value;
    	var semester = document.getElementById("semester").value;

        if (program && department && semester) {
            var xhr = new XMLHttpRequest();
            xhr.open("POST", "<%= request.getRequestURI() %>", true);
            xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
            xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");

            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    document.getElementById("result").innerHTML = xhr.responseText;
                }
            };

            xhr.send("program=" + encodeURIComponent(program) +
                     "&department=" + encodeURIComponent(department) +
                     "&semester=" + encodeURIComponent(semester));
        }
    }

        let selectedCells = [];

        function toggleCell(cell, day, period) {
            const key = day + "-" + period;
            const index = selectedCells.findIndex(e => e === key);

            if (index >= 0) {
                selectedCells.splice(index, 1);
                cell.classList.remove("selected");
            } else {
                selectedCells.push(key);
                cell.classList.add("selected");
            }

            document.getElementById("selectedSlots").value = selectedCells.join(",");
        }
    </script>
</head>
<body>
<div class="container">

<% 
            String error = request.getParameter("error");
            if ("1".equals(error)) {
        %>
        <p id="success-msg" style="color: green; background: #d4edda; padding: 10px; border-radius: 5px;">
           Slot Booked successfully!
        </p>
        <% 
            } else if ("2".equals(error)) { 
        %>
        <p id="error-msg" style="color: red; background: #f8d7da; padding: 10px; border-radius: 5px;">
            Slot already exists
        </p>
        <% } %>

<h2>Manual Lab Slotting</h2>
<br>

<div class="controls">
    <form action="../SaveLabSlotsServlet" method="post">
    <div class="form-group">
        <label for="programName">Program</label>
                <select id="programName" name="programName" required>
                    <option value="" disabled selected>Select Program</option>
                    <% 
                        Connection conn = DBUtil.getConnection();
                        String sql = "SELECT DISTINCT name FROM programs";
                        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                            ResultSet rs = stmt.executeQuery();
                            while (rs.next()) {
                    %>
                    <option value="<%= rs.getString("name") %>"><%= rs.getString("name") %></option>
                    <% 
                            }
                            rs.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    %>
                </select>
                </div>
         <!-- Department Dropdown -->
            <div class="form-group">
                <label for="departmentName">Department</label>
                <select id="departmentName" name="departmentName" required>
                    <option value="" disabled selected>Select Department</option>
                </select>
            </div>

            <!-- Semester Dropdown -->
            <div class="form-group">
                <label for="semester">Semester</label>
                <select id="semester" name="semester" onchange="fetchTimeSlots()" required>
                    <option value="" disabled selected>Select Semester</option>
                </select>
            </div>

            <!-- Section -->
            <div class="form-group">
                <label for="section">Section</label>
                <select id="section"  name="section" required>
                    <option value="" disabled selected>Select Section</option>
                </select>
            </div>

        <br>
              <div class="group-row">
              <div class="group-select">
                <label for="subjectCode">Subject</label>
                <select id="subjectCode" class="sec-sel" name="subjectCode" required>
                    <option value="" disabled selected>Select Subject</option>
                </select>
                </div>
              <div class="group-select">
                <label for="teacherId">Teacher</label>
                <select id="teacherId" class="sec-sel" name="teacherId" required>
                    <option value="" disabled selected>Select Teacher</option>
                </select>
                </div>
                </div>

        <input type="hidden" name="selectedSlots" id="selectedSlots" />

        <br><br>

         <div id="result" style="margin-top: 20px;"></div>

        <div style="text-align:center; margin-top:20px;">
            <button type="submit">Save Lab Slots</button>
        </div>
    </form>
</div>
</div>
     <script src="script/timetable.js">
    </script>
    <script>
    document.getElementById("semester").addEventListener("change", function () {
        const semester = this.value;
        const program = document.getElementById("programName").value;
        const department = document.getElementById("departmentName").value;
        const subjectDropdown = document.getElementById("subjectCode");
        const teacherDropdown = document.getElementById("teacherId");

        //for subjects
        subjectDropdown.innerHTML = `<option value="" disabled selected>Loading...</option>`;
        fetch('../LabSlotServlet?action=getSubject&program=' + encodeURIComponent(program) + 
              '&department=' + encodeURIComponent(department) + 
              '&semester=' + encodeURIComponent(semester))
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    subjectDropdown.innerHTML = `<option value="" disabled selected>Select a subject</option>`;
                    data.subjects.forEach(sub => {
                        const option = document.createElement("option");
                        option.value = sub;
                        option.textContent = sub;
                        subjectDropdown.appendChild(option);
                    });
                } else {
                    subjectDropdown.innerHTML = `<option value="" disabled selected>No subjects available</option>`;
                }
            })
            .catch(error => {
                subjectDropdown.innerHTML = `<option value="" disabled selected>Error loading subjects</option>`;
                console.error("Error fetching subjects:", error);
            });
    }); 
        
        //for teachers
        document.getElementById("subjectCode").addEventListener("change", function () {
        const subject = this.value;
        const program = document.getElementById("programName").value;
        const department = document.getElementById("departmentName").value;
        const semester = document.getElementById("semester").value;
        const teacherDropdown = document.getElementById("teacherId");
        teacherDropdown.innerHTML = `<option value="" disabled selected>Loading...</option>`;
        fetch('../LabSlotServlet?action=getTeacher&program=' + encodeURIComponent(program) + 
              '&department=' + encodeURIComponent(department) + 
              '&semester=' + encodeURIComponent(semester) + '&subject=' + encodeURIComponent(subject))
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

    </script>
</body>
</html>
