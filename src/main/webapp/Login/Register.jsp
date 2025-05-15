<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register</title>
    <link href="Login_Style.css" rel="stylesheet">
</head>
<body>
    <div class="login-wrapper">
        <form action="../RegisterServlet" method="post">
            <h2>Register</h2>
            <div class="input-field">
                <input type="text" name="uname" required>
                <label>Enter UserName</label>   
            </div>
            <div class="input-field">
                <input type="password" name="pwd1" required>
                <label>Enter Password</label>   
            </div>
            <div class="input-field">
                <input type="password" name="pwd2" required>
                <label>Confirm Password</label>   
            </div>
           
            <button type="submit">Register</button>
            <div class="account-options">
                <a href="Login.jsp">Login</a><br/><br/>
                <a href="../Home.jsp">Back to Home</a>
            </div>
        </form>
         <% String error = request.getParameter("error");
               if(error != null && error.equals("1")){ %>
               <p id="error-msg" style = "color:red; background:yellow;">Password didn't match</p>
               <%} else if(error != null && error.equals("2")){%>
               <p id="error-msg" style = "color:red; background:yellow;">UserName already exists</p>
               <%} %>
               
    </div>
    
    <script type="text/javascript">
    setTimeout(function() {
        document.getElementById("error-msg").style.display = "none";
    }, 3000);
    </script>
</body>
</html>