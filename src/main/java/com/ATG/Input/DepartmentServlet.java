package com.ATG.Input;

import com.ATG.DB.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;

@WebServlet("/DepartmentServlet")
public class DepartmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String programName = request.getParameter("programName");
        String departmentId = request.getParameter("departmentId");
        String departmentName = request.getParameter("departmentName");

        try (Connection conn = DBUtil.getConnection()) {
            if ("add".equals(action)) {
                handleAddProgram(request, response, conn, programName, departmentId, departmentName);
            } else if ("delete".equals(action)) {
                handleDeleteProgram(request, response, conn, programName, departmentId, departmentName);
           }
            conn.close();
            } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("ATG/Department.jsp?error=2"); // Redirect with error
        }
    }
    
    private void handleAddProgram(HttpServletRequest request, HttpServletResponse response, Connection conn, String programName,String departmentId, String departmentName)
            throws IOException, SQLException {
        if (programName != null && departmentId != null && departmentName !=null && !programName.isEmpty() && !departmentId.isEmpty() && !departmentName.isEmpty()) {
            String sql = "INSERT INTO departments (program, id, deptname) VALUES (?,?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, programName);
                stmt.setString(2, departmentId);
                stmt.setString(3, departmentName);
                stmt.executeUpdate();
                
                response.sendRedirect("ATG/Department.jsp?error=1"); // Success message
            }
        } else {
            response.sendRedirect("ATG/Department.jsp?error=2"); // Invalid input
        }
    }

    private void handleDeleteProgram(HttpServletRequest request, HttpServletResponse response, Connection conn, String programName, String departmentId, String departmentName)
            throws IOException, SQLException {
//        if (programName != null && !programName.isEmpty()) {
            String sql = "DELETE FROM departments WHERE id = ? and deptname = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, departmentId);
                stmt.setString(2, departmentName);
                int rowsAffected = stmt.executeUpdate();
                if (rowsAffected > 0) {
                    response.sendRedirect("ATG/Department.jsp?error=3"); // Success message
                } else {
                    response.sendRedirect("ATG/Department.jsp?error=2"); // Program not found
                }
            }
//        } else {
//            response.sendRedirect("ATG/Program.jsp?error=2"); // Invalid input
//        }
    }

}

