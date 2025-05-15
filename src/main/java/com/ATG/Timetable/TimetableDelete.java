package com.ATG.Timetable;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.ATG.DB.DBUtil;

/**
 * Servlet implementation class TimetableDelete
 */
@WebServlet("/TimetableDelete")
public class TimetableDelete extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public TimetableDelete() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String program = request.getParameter("program");
		String dept = request.getParameter("department");
		String sem = request.getParameter("semester");
		String section = request.getParameter("section");

		try (Connection conn = DBUtil.getConnection()) {
		    PreparedStatement stmt = conn.prepareStatement(
		        "DELETE FROM timetable WHERE programName = ? AND departmentName = ? AND semester = ? AND section = ?"
		    );
		    stmt.setString(1, program);
		    stmt.setString(2, dept);
		    stmt.setString(3, sem);
		    stmt.setString(4, section);
		    int rowsAffected = stmt.executeUpdate();
		    
		    if (rowsAffected > 0) {
		    	 PreparedStatement ps = conn.prepareStatement(
				            "DELETE FROM global_schedule WHERE program = ? AND department = ? AND semester = ? AND section = ?"
				        );
				        ps.setString(1, program);
				        ps.setString(2, dept);
				        ps.setString(3, sem);
				        ps.setString(4, section);
				        ps.executeUpdate();
				        
		        response.sendRedirect("ATG/TimetableActions.jsp?error=1");
		    } else {
		        response.sendRedirect("ATG/TimetableActions.jsp?error=2");
		    }

		} catch (SQLException e) {
		    e.printStackTrace();
		}

	}


}
