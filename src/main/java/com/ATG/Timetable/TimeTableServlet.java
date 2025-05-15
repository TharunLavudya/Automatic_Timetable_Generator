package com.ATG.Timetable;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.ATG.DB.DBUtil;
import com.google.gson.Gson;
//import com.google.gson.JsonObject;
//import com.google.gson.JsonElement;
//import com.google.gson.JsonObject;


/**
 * Servlet implementation class TimeTableServlet
 */
@WebServlet("/TimeTableServlet")
public class TimeTableServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = request.getParameter("action");
		String program = request.getParameter("program");
		String department = request.getParameter("department");
		String semester = request.getParameter("semester");
		String section = request.getParameter("section");
		 PrintWriter out = response.getWriter();
		if ("getTable".equals(action)) {
			response.setContentType("application/json");

	        try (Connection conn = DBUtil.getConnection()) {
	            Map<String, Map<String, String>> timetable = new HashMap<>(); // { day: { timeslot: "subject-teacher" } }
	           
	            String sql = "SELECT day, timeSlot, allocation FROM timetable WHERE programName = ? AND departmentName = ? AND semester = ? AND section = ?";
	            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
	                stmt.setString(1, program);
	                stmt.setString(2, department);
	                stmt.setString(3, semester);
	                stmt.setString(4, section);
	                try (ResultSet rs = stmt.executeQuery()) {
	                    while (rs.next()) {
	                        String day = rs.getString("day");
	                        String timeSlot = rs.getString("timeSlot");
	                        String allocation = rs.getString("allocation"); // "subject-teacher"

	                        timetable.putIfAbsent(day, new HashMap<>());
	                        timetable.get(day).put(timeSlot, allocation);
	                    }
	                }
	            }

	            // Respond with JSON
	            //System.out.println(timetable);
	           Gson gson = new Gson();
	            String jsonResponse = gson.toJson(Map.of("success", true, "timetable", timetable));
	            response.getWriter().write(jsonResponse);
	        } catch (Exception e) {
	            e.printStackTrace();
	            out.print("{\"success\": false}");
	        }
		}
		
		
		if ("getTimeSlots".equals(action)) {
		    response.setContentType("application/json");
		   
		    
		    try (Connection conn = DBUtil.getConnection()) {
		        String query = "SELECT startTime, endTime, classDuration, breakDuration FROM semesters WHERE programName = ? AND departmentName = ? AND semester = ?";
		        try (PreparedStatement stmt = conn.prepareStatement(query)) {
		            stmt.setString(1, program);
		            stmt.setString(2, department);
		            stmt.setString(3, semester);
		            try (ResultSet rs = stmt.executeQuery()) {
		                if (rs.next()) {
		                    String startTime = rs.getString("startTime");
		                    String endTime = rs.getString("endTime");
		                    int slotDuration = rs.getInt("classDuration");
		                    int breakDuration = rs.getInt("breakDuration");

		                    // Generate time slots
		                    List<String> timeSlots = generateTimeSlots(startTime, endTime, slotDuration, breakDuration);
		                    String jsonResponse = "{\"success\": true, \"timeSlots\": " + new Gson().toJson(timeSlots) + "}";
		                    out.print(jsonResponse);
		                } else {
		                    out.print("{\"success\": false, \"message\": \"No data found for the semester.\"}");
		                }
		            }
		        }
		    } catch (SQLException e) {
		        e.printStackTrace();
		        out.print("{\"success\": false, \"message\": \"Database error.\"}");
		    }
		}
	}

	private List<String> generateTimeSlots(String startTime, String endTime, int slotDuration, int breakDuration) {
		 List<String> slots = new ArrayList<>();
		    LocalTime start = LocalTime.parse(startTime);
		    LocalTime end = LocalTime.parse(endTime);
		    int count=0;
		    while (start.isBefore(end)) {
		    	if(count==3)
		    	{
		    		LocalTime next=start.plusMinutes(breakDuration);
		    		slots.add("break: "+start+"-"+next);
		    		start=next;
		    	}
		        LocalTime nextSlot = start.plusMinutes(slotDuration);
		        slots.add(start + " - " + (nextSlot.isAfter(end) ? end : nextSlot));
		        start = nextSlot;
		        count++;
		    }
		    return slots;
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("application/json");
//        String body = request.getReader().lines().reduce("", (accumulator, actual) -> accumulator + actual);
//        JsonObject json = JsonParser.parseString(body).getAsJsonObject();

		 String semester = request.getParameter("semester");
	 	   String section = request.getParameter("section");
	 	  String program = request.getParameter("programName");
	 	 String department = request.getParameter("departmentName");

        try (Connection conn = DBUtil.getConnection()) {
        	String checkQuery = "SELECT COUNT(*) FROM timetable WHERE programName = ? AND departmentName = ? AND semester = ? AND section = ?";
            try (PreparedStatement ps = conn.prepareStatement(checkQuery)) {
                ps.setString(1, program);
                ps.setString(2, department);
                ps.setString(3, semester);
                ps.setString(4, section);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        // Timetable already exists
                        response.sendRedirect("ATG/Timetable.jsp?error=3");
                        return; // stop further execution
                    }
                }
            }
            TimetableGenerator generator = new TimetableGenerator(conn, program, department, semester, section);
            Map<String, Map<String, String>> timetable = generator.generate();
            boolean isTimetableEmpty = true;
            for (Map<String, String> day : timetable.values()) {
                for (String session : day.values()) {
                    if (session != null && !session.trim().isEmpty()) {
                        isTimetableEmpty = false;
                        break;
                    }
                }
                if (!isTimetableEmpty) {
                    break;
                }
            }

            if (isTimetableEmpty) {
                response.sendRedirect("ATG/Timetable.jsp?error=2");
            } else {
                saveTimetableToDatabase(conn, timetable, program, department, semester, section);
                response.sendRedirect("ATG/Timetable.jsp?error=1");
            }

//            if (timetable == null || timetable.isEmpty()) {
//            	 response.sendRedirect("ATG/Timetable.jsp?error=2");
//            }                
//            else {
//            saveTimetableToDatabase(conn, timetable, program, department, semester, section);
//
//            // Send timetable back to frontend
////            JsonObject responseJson = new JsonObject();
////            responseJson.addProperty("success", true);
////            responseJson.add("timetable", new Gson().toJsonTree(timetable));
////            response.getWriter().write(responseJson.toString());
//            response.sendRedirect("ATG/Timetable.jsp?error=1");
//            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\": false}");
        }
	}
	public static void saveTimetableToDatabase(Connection conn, Map<String, Map<String, String>> timetable,
            String program, String department, String semester, String section) throws SQLException {
                    String sql = "INSERT INTO timetable (programName, departmentName, semester, section, day, timeSlot, allocation) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";

                    try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    for (Map.Entry<String, Map<String, String>> dayEntry : timetable.entrySet()) {
                    String day = dayEntry.getKey();
                    Map<String, String> slots = dayEntry.getValue();

                    for (Map.Entry<String, String> slotEntry : slots.entrySet()) {
                    String timeSlot = slotEntry.getKey();
                    String subjectTeacher = slotEntry.getValue();

                    if (subjectTeacher != null) { // Only save non-empty slots
                    stmt.setString(1, program);
                    stmt.setString(2, department);
                    stmt.setString(3, semester);
                    stmt.setString(4, section);
                    stmt.setString(5, day);
                    stmt.setString(6, timeSlot);
                    stmt.setString(7, subjectTeacher);
                    stmt.addBatch();
                    }
                }
         }

// Execute the batch insert
            stmt.executeBatch();
         }
}                    

}
