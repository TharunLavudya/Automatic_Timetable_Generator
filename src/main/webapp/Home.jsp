<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Automatic Timetable Generator</title>
    <style>
    /* Reset */
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: 'Roboto', sans-serif;
  line-height: 1.6;
  color: #333;
  background-color: #f9f9f9;
}

/* Navbar */
.navbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem 2rem;
  background: linear-gradient(90deg, #0e1417, #06090a);
  color: white;
  box-shadow: 0px 2px 4px rgba(0, 0, 0, 0.1);
}

.navbar .logo {
  font-size: 1.8rem;
  font-weight: bold;
}

.navbar ul {
  list-style: none;
  display: flex;
  gap: 1.5rem;
}

.navbar ul li a {
  color: white;
  text-decoration: none;
  font-size: 1rem;
  font-weight: 500;
  transition: color 0.3s ease;
}

.navbar ul li a:hover {
  color: #ffcc00;
}

/* Hero Section */
.hero {
  background: linear-gradient(135deg, #007acc, #005f99);
  color: white;
  text-align: center;
  padding: 3rem 1rem;
  border-bottom: 5px solid #ffcc00;
}

.hero h2 {
  font-size: 2.5rem;
  margin-bottom: 1rem;
  text-transform: uppercase;
  letter-spacing: 1.2px;
}

.hero p {
  font-size: 1.2rem;
  line-height: 1.8;
  max-width: 800px;
  margin: 0 auto;
}

/* Features Section */
.features {
  padding: 2rem 1rem;
  background-color: #ffffff;
  text-align: center;
}

.features h3 {
  font-size: 2rem;
  margin-bottom: 1rem;
  color: #005f99;
  text-transform: uppercase;
  letter-spacing: 1.2px;
}

.features ul {
  list-style: none;
  padding: 0;
  margin: 1rem auto;
  max-width: 600px;
}

.features ul li {
  margin: 0.8rem 0;
  font-size: 1.1rem;
  color: #555;
  text-align: left;
  padding-left: 1.5rem;
  position: relative;
}

.features ul li::before {
  content: "✔";
  color: #005f99;
  font-weight: bold;
  position: absolute;
  left: 0;
}

/* CTA Section */
.cta {
text-align: center;
padding: 2rem;
background-color: #174a7c;
color: #fff;
}

.cta h3 {
font-size: 2rem;
margin-bottom: 1rem;
}

.cta-container {
display: flex;
justify-content: center;
gap: 90px;
background: #174a7c;
margin: 2rem auto;
max-width: 1300px;
flex-wrap: wrap;
}

.cta-box {
background-color: #f5f5f5;
padding: 30px;
text-align: center;
border-radius: 10px;
box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
transition: transform 0.3s ease, box-shadow 0.3s ease;
background: #fff;
color: #333;
padding: 2rem;
flex: 1;
min-width: 280px;
box-sizing: border-box;
}
.cta-box:hover{
  transform: scale(1.05);
box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
}
.cta-box h4 {
color: #174a7c;
margin-bottom: 0.5rem;
}

.cta-box p {
margin-bottom: 1rem;
}

.button {
display: inline-block;
padding: 0.6rem 1.2rem;
background-color: #ffc107;
color: #000;
border-radius: 25px;
text-decoration: none;
font-weight: bold;
transition: background 0.3s;
}

.button:hover {
background-color: #e0a800;
}

@media (max-width: 768px) {
.cta-container {
  flex-direction: column;
}
}


/* Footer */
footer {
  text-align: center;
  padding: 1.5rem;
  background-color: #003d66;
  color: white;
  font-size: 0.9rem;
  margin-top: 2rem;
  letter-spacing: 0.5px;
}
    
    </style>
</head>
<body>
    <header>
        <div class="navbar">
            <h1 class="logo">Timetable Generator</h1>
            <nav>
                <ul>
                    <li><a href="Login/Login.jsp">Admin Login</a></li>
                </ul>
            </nav>
        </div>
    </header>

    <main>
        <section class="hero">
            <h2>Welcome to the Automatic Timetable Generator</h2>
            <p>
                Our software helps educational institutions simplify and automate the process of timetable generation. 
                Say goodbye to manual errors, scheduling conflicts, and time-consuming tasks. With the Automatic Timetable Generator, 
                you can manage timetables efficiently and adjust labs/theory classes seamlessly.
            </p>
        </section>

        <section class="features">
            <h3>Key Features</h3>
            <ul>
                <li>Automatic generation of class timetables for all departments and sections.</li>
                <li>Ensures no clashes between faculty schedules.</li>
                <li>Customizable class durations, break times, and work days.</li>
                <li>Manages faculty workloads efficiently.</li>
                <li>Adjusts Labs and Theory classes dynamically.</li>
            </ul>
        </section>

       <section class="cta">
          <h3>Access Your Timetables</h3>
          <p>Select your role below to continue:</p>
          <div class="cta-container">
             <div class="cta-box">
                <h4>Teacher Workload</h4>
                <p>View assigned workloads and schedules.</p>
                <a href="Teacher/teacherWorkLoad.jsp" class="button">Go to Teacher Page</a>
            </div>

           <div class="cta-box">
               <h4>Student Timetable</h4>
               <p>Check your class timetable.</p>
               <a href="Student/studentTimetable.jsp" class="button">Go to Student Page</a>
           </div>

           <div class="cta-box">
                 <h4>Admin Panel</h4>
                 <p>Login to manage and generate timetables.</p>
                 <a href="Login/Login.jsp" class="button">Admin Login</a>
            </div>
         </div>
      </section>



    </main>

    <footer>
        <p>Automatic Timetable Generator - By Team A10! </p>
    </footer>
</body>
</html>
