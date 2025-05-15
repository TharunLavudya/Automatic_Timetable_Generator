package com.ATG.Input;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
//import java.util.ArrayList;
//import java.util.List;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.ATG.DB.DBUtil;
//import com.google.gson.Gson;
import com.google.gson.Gson;


@WebServlet("/AssignServlet")
public class AssignServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = request.getParameter("action");
		String program = request.getParameter("program");
		String department = request.getParameter("department");
		String semester = request.getParameter("semester");

		if ("getSection".equals(action) && program != null && department != null && semester != null) {
		    response.setContentType("application/json");
		    PrintWriter out = response.getWriter();

		    try (Connection conn = DBUtil.getConnection()) {
		        String sql = "SELECT numSections FROM semesters WHERE programName = ? AND departmentName = ? AND semester = ?";
		        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
		            stmt.setString(1, program);
		            stmt.setString(2, department);
		            stmt.setString(3, semester);
		            try (ResultSet rs = stmt.executeQuery()) {
		                int sections = 0;
		                if (rs.next()) {
		                    sections = rs.getInt("numSections");
		                }
		                // Respond with JSON
		                String jsonResponse = "{\"success\": true, \"sections\": " + sections + "}";
		                out.print(jsonResponse);
		            }
		        }
		    } catch (SQLException e) {
		        e.printStackTrace();
		        out.print("{\"success\": false}");
		    }
		}
		
		if ("getSubject".equals(action) && program != null && department != null && semester != null) {
		    response.setContentType("application/json");
		    PrintWriter out = response.getWriter();

		    try (Connection conn = DBUtil.getConnection()) {
		        String sql = "SELECT subjectName FROM subjects WHERE programName = ? AND departmentName = ? AND semester = ?";
		        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
		            stmt.setString(1, program);
		            stmt.setString(2, department);
		            stmt.setString(3, semester);
		            try (ResultSet rs = stmt.executeQuery()) {
		            	List<String> subjects = new ArrayList<>();
                        while (rs.next()) {
                            subjects.add(rs.getString("subjectName"));
                        }
                        // Respond with JSON
                        String jsonResponse = "{\"success\": true, \"subjects\": " + new Gson().toJson(subjects) + "}";
                        out.print(jsonResponse);
		        }
		        }
		    } catch (SQLException e) {
		        e.printStackTrace();
		        out.print("{\"success\": false}");
		    }
		}
		
		if ("getTeacher".equals(action) && program != null && department != null && semester != null) {
		    response.setContentType("application/json");
		    PrintWriter out = response.getWriter();

		    try (Connection conn = DBUtil.getConnection()) {
		        String sql = "SELECT teacherName FROM teachers WHERE programName = ? AND departmentName = ? AND semester = ?";
		        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
		            stmt.setString(1, program);
		            stmt.setString(2, department);
		            stmt.setString(3, semester);
		            try (ResultSet rs = stmt.executeQuery()) {
		            	List<String> teachers = new ArrayList<>();
                        while (rs.next()) {
                            teachers.add(rs.getString("teacherName"));
                        }
                        // Respond with JSON
                        String jsonResponse = "{\"success\": true, \"teachers\": " + new Gson().toJson(teachers) + "}";
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
        if ("assign".equals(action)) {
            assignSubject(request, response);
        }else if("delete".equals(action)) {
        	deleteST(request, response);
        }
    }

    private void deleteST(HttpServletRequest request, HttpServletResponse response) throws IOException {
    	 
 	    
 	    String semester = request.getParameter("semester");
 	   String section = request.getParameter("section");
 	  String subjectName = request.getParameter("subjectName");
 	 String teacherName = request.getParameter("teacherName");

 	    String query = "DELETE FROM assign WHERE semester = ? and section = ? and subjectName = ? and teacherName = ?";

 	    try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
 	        ps.setString(1, semester);
 	        ps.setString(2, section);
 	        ps.setString(3, subjectName);
 	        ps.setString(4, teacherName);
 	        int rowsAffected = ps.executeUpdate();

 	        if (rowsAffected > 0) {
 	            response.sendRedirect("ATG/ViewPages/ViewAssigned.jsp?error=1");
 	        } else {
 	            response.sendRedirect("ATG/ViewPages/ViewAssigned.jsp?error=2");
 	        }
 	    } catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}



	private void assignSubject(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String program = request.getParameter("programName");
        String department = request.getParameter("departmentName");
        String semester = request.getParameter("semester");
        String section = request.getParameter("section");
        String subjectName = request.getParameter("subjectCode");
        String teacherName = request.getParameter("teacherId");

        String sql = "INSERT INTO assign (programName, departmentName, semester, section, subjectName, teacherName) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, program);
            stmt.setString(2, department);
            stmt.setString(3, semester);
            stmt.setString(4, section);
            stmt.setString(5, subjectName);
            stmt.setString(6, teacherName);

            stmt.executeUpdate();
            response.sendRedirect("ATG/AssignTS.jsp?success=1");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("ATG/AssignTS.jsp?error=2");
        }
	}

}
