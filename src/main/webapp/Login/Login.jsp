<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Page</title>
    <link href="Login_Style.css" rel="stylesheet">
</head>
<body>
    <div class="login-wrapper">
        <form action="../LoginServlet" method="post">
            <h2>Login</h2>
            <div class="input-field">
                <input type="text" name="userName" required>
                <label>Enter UserName</label>   
            </div>
            <div class="input-field">
                <input type="password" name="pwd" required>
                <label>Enter Password</label>   
            </div>
            <!--  <div class="password-options">
                <label for="remember">
                    <input type="checkbox" id="remember">
                </label>
                <p>Remember me</p>
                <a href="#">Forgot Password</a>
            </div> -->
            <br/>
            <button type="submit">Login</button>
            <div class="account-options">
                <p>Don't have an account? <a href="Register.jsp">Register</a></p>
                <br/>
                <a href="../Home.jsp">Back to Home</a>
            </div>
            
        </form>
        <br/>
        <% String error = request.getParameter("error");
               if(error != null && error.equals("1")){ %>
               <p id="error-msg" style = "color:red; background:yellow;">Invalid UserName or Password</p>
               <%} else if(error != null && error.equals("2")){%>
               <p id="error-msg" style = "color:red; background:yellow;">Registered Successfully</p>
               <%} %>
    </div>
    
    <script type="text/javascript">
    setTimeout(function() {
        document.getElementById("error-msg").style.display = "none";
    }, 3000);
    </script>
    
</body>
</html>