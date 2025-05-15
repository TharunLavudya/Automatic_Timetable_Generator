<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="css/DBHomeStyle.css">
 </head>
<body>

    <div class="instructions-container">
    <h2 class="instructions-title">How to Use the Automatic Timetable Generator</h2>
    <p class="instructions-desc">Follow the steps below to create and manage your timetables effectively:</p>
    
    <div class="steps-grid">
        <div class="step-box">
            <h3>Add a Program</h3>
            <p>Navigate to "Add Program" in the sidebar to create programs like B.Tech, M.Tech, etc.</p>
        </div>
        <div class="step-box">
            <h3>Add Departments</h3>
            <p>Specify departments like Computer Science, Mechanical, etc., under each program.</p>
        </div>
        <div class="step-box">
            <h3>Add Semesters</h3>
            <p>Define semesters for each department, with multiple sections for each semester.</p>
        </div>
        <div class="step-box">
            <h3>Add Teachers</h3>
            <p>Add faculty members and assign subjects to them. Specify their availability.</p>
        </div>
        <div class="step-box">
            <h3>Add Subjects</h3>
            <p>Define subjects, including theory and labs, and assign them to teachers.</p>
        </div>
        <div class="step-box">
            <h3>Generate Timetables</h3>
            <p>Generate timetables for sections and faculty, ensuring no conflicts.</p>
        </div>
    </div>

    <p class="return-link">
        <a href="Timetable.jsp" class="back-to-dashboard">Generate Timetable</a>
    </p>
</div>
        
</body>
</html>