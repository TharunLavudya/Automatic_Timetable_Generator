package com.ATG.Input;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.ATG.DB.DBUtil;
import com.google.gson.Gson;

@WebServlet("/SubjectsServlet")
public class SubjectsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		 String action = request.getParameter("action");
	        String program = request.getParameter("program");
	        String department = request.getParameter("department");

	        if ("getDepartments".equals(action) && program != null) {
	            response.setContentType("application/json");
	            PrintWriter out = response.getWriter();

	            try (Connection conn = DBUtil.getConnection()) {
	                String sql = "SELECT deptname FROM departments WHERE program = ?";
	                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
	                    stmt.setString(1, program);
	                    try (ResultSet rs = stmt.executeQuery()) {
	                        List<String> departments = new ArrayList<>();
	                        while (rs.next()) {
	                            departments.add(rs.getString("deptname"));
	                        }
	                        // Respond with JSON
	                        String jsonResponse = "{\"success\": true, \"departments\": " + new Gson().toJson(departments) + "}";
	                        out.print(jsonResponse);
	                    }
	                }
	            } catch (SQLException e) {
	                e.printStackTrace();
	                out.print("{\"success\": false}");
	            }
	        }
	        
	        
	        if ("getSemesters".equals(action) && program != null && department != null) {
	            response.setContentType("application/json");
	            PrintWriter out = response.getWriter();

	            try (Connection conn = DBUtil.getConnection()) {
	                String query = "SELECT semester FROM semesters WHERE programName = ? AND departmentName = ?";
	                try (PreparedStatement stmt = conn.prepareStatement(query)) {
	                    stmt.setString(1, program);
	                    stmt.setString(2, department);

	                    try (ResultSet rs = stmt.executeQuery()) {
	                        List<String> semesters = new ArrayList<>();
	                        while (rs.next()) {
	                            semesters.add(rs.getString("semester"));
	                        }
	                        String jsonResponse = "{\"success\": true, \"semesters\": " + new Gson().toJson(semesters) + "}";
	                        out.print(jsonResponse);
	                    }
	                }
	            } catch (SQLException e) {
	                e.printStackTrace();
	                out.print("{\"success\": false}");
	            }
	        }

	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = request.getParameter("action");

	    try (Connection conn = DBUtil.getConnection()) {
	        if ("add".equals(action)) {
	            addSubject(request, response, conn);
	        } else if ("delete".equals(action)) {
	            deleteSubject(request, response, conn);
	        } 
	        conn.close();
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

}


	private void addSubject(HttpServletRequest request, HttpServletResponse response, Connection conn) throws SQLException, IOException {
		// TODO Auto-generated method stub
		 String programName = request.getParameter("programName");
		    String departmentName = request.getParameter("departmentName");
		    String semester = request.getParameter("semester");
		    String subjectCode = request.getParameter("subjectCode");
		    String subjectName = request.getParameter("subjectName");
		    int classesPerWeek =Integer.parseInt (request.getParameter("classesPerWeek"));
		    int credits = Integer.parseInt(request.getParameter("credits"));
		    String subjectType = request.getParameter("type");
		    
		    String sql = "INSERT INTO subjects (programName, departmentName, semester, subjectCode, subjectName, classesPerWeek, credits, subjectType) " +
	                 "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

	    try (PreparedStatement stmt = conn.prepareStatement(sql)) {
	        stmt.setString(1, programName);
	        stmt.setString(2, departmentName);
	        stmt.setString(3, semester);
	        stmt.setString(4, subjectCode);
	        stmt.setString(5, subjectName);
	        stmt.setInt(6, classesPerWeek);
	        stmt.setInt(7, credits);
	        stmt.setString(8, subjectType);

	        stmt.executeUpdate();
	        response.sendRedirect("ATG/Subjects.jsp?success=1");
	    } 
	    catch (SQLException e) {
	        response.sendRedirect("ATG/Subjects.jsp?error=2");
	    } 
		
	}


	private void deleteSubject(HttpServletRequest request, HttpServletResponse response, Connection conn) throws SQLException, IOException {
		// TODO Auto-generated method stub
		String semester = request.getParameter("semester");
	    String deptname = request.getParameter("departmentName");
	    String subjectName = request.getParameter("subjectName");

	    String query = "DELETE FROM subjects WHERE semester = ? and departmentName =? and subjectName = ?";

	    try (PreparedStatement ps = conn.prepareStatement(query)) {
	      ps.setString(1, semester);
	        ps.setString(2, deptname);
	        ps.setString(3, subjectName);
	        int rowsAffected = ps.executeUpdate();

	        if (rowsAffected > 0) {
	            response.sendRedirect("ATG/ViewPages/ViewSubjects.jsp?error=1");
	        } else {
	            response.sendRedirect("ATG/ViewPages/ViewSubjects.jsp?error=2");
	        }
	    }
		
	}
}
