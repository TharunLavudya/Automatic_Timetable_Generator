package com.ATG.Timetable;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLIntegrityConstraintViolationException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.ATG.DB.DBUtil;

/**
 * Servlet implementation class SaveLabSlotsServlet
 */
@WebServlet("/SaveLabSlotsServlet")
public class SaveLabSlotsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public SaveLabSlotsServlet() {
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
		String program = request.getParameter("programName");
        String department = request.getParameter("departmentName");
        String semester = request.getParameter("semester");
        String section = request.getParameter("section");
        String subject = request.getParameter("subjectCode");
        String teacher = request.getParameter("teacherId");
        String selectedSlots = request.getParameter("selectedSlots"); 

        String entityType = "lab";

        try (Connection conn = DBUtil.getConnection()) {
        	List<String> tSl = TimetableGenerator.fetchTimeSlots(conn, program, department, semester);
            String sql = "INSERT INTO global_schedule (day, time_slot, entity_type, program, department, semester, section,  subject, teacher) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            int rows=0;

            PreparedStatement stmt = conn.prepareStatement(sql);

            for (String slot : selectedSlots.split(",")) {
                String[] parts = slot.split("-");
                if (parts.length != 2) continue; 
                String day = parts[0];
                int periodIndex = Integer.parseInt(parts[1]) - 1;
                //System.out.println(periodIndex);
             
             if (periodIndex < 0 || periodIndex >= tSl.size()) continue;
             
             String timeSlot = tSl.get(periodIndex);

                stmt.setString(1, day);
                stmt.setString(2, timeSlot);
                stmt.setString(3, entityType);
                stmt.setString(4, program);
                stmt.setString(5, department);
                stmt.setString(6, semester);
                stmt.setString(7, section);
                stmt.setString(8, subject);
                stmt.setString(9, teacher);

                try {
           
                    rows=stmt.executeUpdate();
                   
                } catch (SQLIntegrityConstraintViolationException e) {
                    System.out.println("Duplicate entry skipped: " + day + ", " + timeSlot);
                }
            }
            if(rows>0)
            {
            	response.sendRedirect("ATG/SlotLabs.jsp?error=1");
            }
            else
            {
            	response.sendRedirect("ATG/SlotLabs.jsp?error=2");
            }

          
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error saving lab slots: " + e.getMessage());
        }
    }
}
