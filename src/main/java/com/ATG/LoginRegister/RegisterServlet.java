package com.ATG.LoginRegister;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class RegisterServlet
 */
@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public RegisterServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		  
		String UserName = request.getParameter("uname");
		String pwd1 = request.getParameter("pwd1");
		String pwd2 = request.getParameter("pwd2");
		
		 String URL = "jdbc:mysql://localhost:3306/ATG";
		 String username = "root";
		 String password = "2601";
		 
		 try {
			 Class.forName("com.mysql.cj.jdbc.Driver");
				Connection con = DriverManager.getConnection(URL, username, password);
				String query1 = "Select username from users where username = ?";
				PreparedStatement ps = con.prepareStatement(query1);
				ps.setString(1, UserName);
				ResultSet rs = ps.executeQuery();
				if(rs.next())
				{
					response.sendRedirect("Login/Register.jsp?error=2");
				}
				else if(pwd1.equals(pwd2)) {
				String query = "INSERT INTO users (username, password) VALUES (?, ?)";
	            PreparedStatement pstmt = con.prepareStatement(query);
	            pstmt.setString(1, UserName);
	            pstmt.setString(2, pwd1);
	            pstmt.executeUpdate();
	            response.sendRedirect("Login/Login.jsp?error=2");
				}
				else 
				{
					response.sendRedirect("Login/Register.jsp?error=1");
				}
				
				con.close();
		 }
		 catch(Exception e) {
			 e.printStackTrace();
				response.sendRedirect("Login/Register.jsp");
		 }
	}

}
