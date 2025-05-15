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
import javax.servlet.http.HttpSession;



/**
 * Servlet implementation class LoginServlet
 */
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
   
    public LoginServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//System.out.println("Error");
		String UserName = request.getParameter("userName");
		String Password = request.getParameter("pwd");
		
		 String URL = "jdbc:mysql://localhost:3306/ATG";
		 String username = "root";
		 String password = "2601";
		
		String query = "Select * from users where username = ? and password = ?";
		try { 
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection con = DriverManager.getConnection(URL, username, password);
			PreparedStatement ps = con.prepareStatement(query);
			ps.setString(1, UserName);
			ps.setString(2, Password);
			ResultSet rs = ps.executeQuery();
			 if (rs.next()) {
				 HttpSession session = request.getSession();
				 session.setAttribute("username", UserName);
	                response.sendRedirect("ATG/Dashboard.jsp");
	            } else {
	                response.sendRedirect("Login/Login.jsp?error=1");
	            }
			 con.close();			
		}
		catch(Exception e) {
			e.printStackTrace();
			response.sendRedirect("login/index.jsp");
			
		}
		
	}

}
