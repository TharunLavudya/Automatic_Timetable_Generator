package com.ATG.Input;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
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
 * Servlet implementation class SemesterServlet
 */
@WebServlet("/SemesterServlet")
public class SemesterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String program = request.getParameter("program");

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

        }
    

    

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    String action = request.getParameter("action");

    try (Connection conn = DBUtil.getConnection()) {
        if ("add".equals(action)) {
            addSemester(request, response, conn);
        } else if ("delete".equals(action)) {
            deleteSemester(request, response, conn);
        } 
        conn.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
  }

   private void addSemester(HttpServletRequest request, HttpServletResponse response, Connection conn)
        throws IOException, SQLException {
    String programName = request.getParameter("programName");
    String departmentName = request.getParameter("departmentName");
    String semester = request.getParameter("semester");
    int numSections = Integer.parseInt(request.getParameter("numSections"));
    String startTime = request.getParameter("startTime");
    String endTime = request.getParameter("endTime");
    int classDuration = Integer.parseInt(request.getParameter("classDuration"));
    int breakDuration = Integer.parseInt(request.getParameter("breakDuration"));

    String sql = "INSERT INTO semesters (programName, departmentName, semester, numSections, startTime, endTime, classDuration, breakDuration) " +
                 "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

    try (PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setString(1, programName);
        stmt.setString(2, departmentName);
        stmt.setString(3, semester);
        stmt.setInt(4, numSections);
        stmt.setTime(5, Time.valueOf(startTime + ":00"));
        stmt.setTime(6, Time.valueOf(endTime + ":00"));
        stmt.setInt(7, classDuration);
        stmt.setInt(8, breakDuration);

        stmt.executeUpdate();
        response.sendRedirect("ATG/Semesters.jsp?success=1");
    } catch (SQLException e) {
        response.sendRedirect("ATG/Semesters.jsp?error=2");
    }
}

  private void deleteSemester(HttpServletRequest request, HttpServletResponse response, Connection conn)
        throws IOException, SQLException {
    String semester = request.getParameter("semesterId");
    String deptname = request.getParameter("departmentName");

    String sql = "DELETE FROM semesters WHERE semester = ? and departmentName =?";

    try (PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setString(1, semester);
        stmt.setString(2, deptname);
        int rowsAffected = stmt.executeUpdate();

        if (rowsAffected > 0) {
            response.sendRedirect("ATG/ViewPages/ViewSemester.jsp?error=1");
        } else {
            response.sendRedirect("ATG/ViewPages/ViewSemester.jsp?error=2");
        }
    }
}
}







