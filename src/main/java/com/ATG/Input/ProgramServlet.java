package com.ATG.Input;

import com.ATG.DB.DBUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;


@WebServlet("/ProgramServlet")
public class ProgramServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String programName = request.getParameter("programName");

        try (Connection conn = DBUtil.getConnection()) {
            if ("add".equals(action)) {
                handleAddProgram(request, response, conn, programName);
            } else if ("delete".equals(action)) {
                handleDeleteProgram(request, response, conn, programName);
           }
            conn.close();
            } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("ATG/Program.jsp?error=2"); // Redirect with error
        }
    }

    private void handleAddProgram(HttpServletRequest request, HttpServletResponse response, Connection conn, String programName)
            throws IOException, SQLException {
        if (programName != null && !programName.isEmpty()) {
            String sql = "INSERT INTO programs (name) VALUES (?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, programName);
                stmt.executeUpdate();
                response.sendRedirect("ATG/Program.jsp?error=1"); // Success message
            }
        } else {
            response.sendRedirect("ATG/Program.jsp?error=2"); // Invalid input
        }
    }

    private void handleDeleteProgram(HttpServletRequest request, HttpServletResponse response, Connection conn, String programName)
            throws IOException, SQLException {
        if (programName != null && !programName.isEmpty()) {
            String sql = "DELETE FROM programs WHERE name = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, programName);
                int rowsAffected = stmt.executeUpdate();
                if (rowsAffected > 0) {
                    response.sendRedirect("ATG/Program.jsp?error=3"); // Success message
                } else {
                    response.sendRedirect("ATG/Program.jsp?error=4"); // Program not found
                }
            }
        } else {
            response.sendRedirect("ATG/Program.jsp?error=2"); // Invalid input
        }
    }

}
