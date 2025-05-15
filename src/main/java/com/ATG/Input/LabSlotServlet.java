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

/**
 * Servlet implementation class LabSlotServlet
 */
@WebServlet("/LabSlotServlet")
public class LabSlotServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public LabSlotServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = request.getParameter("action");
		String program = request.getParameter("program");
		String department = request.getParameter("department");
		String semester = request.getParameter("semester");
		String subject = request.getParameter("subject");
		if ("getSubject".equals(action) && program != null && department != null && semester != null) {
		    response.setContentType("application/json");
		    PrintWriter out = response.getWriter();

		    try (Connection conn = DBUtil.getConnection()) {
		        String sql = "SELECT subjectName FROM subjects WHERE programName = ? AND departmentName = ? AND semester = ? AND subjectType = 'Lab' ";
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
		
		if ("getTeacher".equals(action) && program != null && department != null && semester != null && subject !=null) {
		    response.setContentType("application/json");
		    PrintWriter out = response.getWriter();

		    try (Connection conn = DBUtil.getConnection()) {
		        String sql = "SELECT teacherName FROM assign WHERE programName = ? AND departmentName = ? AND semester = ? AND subjectName = ?";
		        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
		            stmt.setString(1, program);
		            stmt.setString(2, department);
		            stmt.setString(3, semester);
		            stmt.setString(4, subject);
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

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
