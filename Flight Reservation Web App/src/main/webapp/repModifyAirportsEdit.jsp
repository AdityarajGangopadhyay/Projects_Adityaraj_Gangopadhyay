<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<%
    if (session.getAttribute("user") == null || !"rep".equals(session.getAttribute("type"))) {
         out.println("Unauthorized Access.<br/>");
         out.println("<a href='login.jsp'>Please Login</a>");
    } else {
        out.println("Airport Edit Confirmation<br/>");
        
%>

<html>
<head>
    <title>Airport Edit Confirmation</title>
</head>
<body>
    <%
        String airportID = request.getParameter("airportID").toUpperCase();
        String newAirportID = request.getParameter("newAirportID").toUpperCase();

        if (airportID != null && !airportID.trim().isEmpty() && newAirportID != null && !newAirportID.trim().isEmpty()) 
        {
            try {
                ApplicationDB db = new ApplicationDB();
                Connection con = db.getConnection();

                String checkAirportQuery = "SELECT COUNT(*) FROM airport WHERE airportID = ?";
                PreparedStatement checkAirportStmt = con.prepareStatement(checkAirportQuery);
                checkAirportStmt.setString(1, airportID);
                ResultSet checkAirportResult = checkAirportStmt.executeQuery();
                checkAirportResult.next();
                int airportCount = checkAirportResult.getInt(1);
                
                if (airportCount == 0) {
                    out.print("Error: Airport with ID " + airportID + " does not exist.");
                    return;
                }

                String checkNewAirportQuery = "SELECT COUNT(*) FROM airport WHERE airportID = ?";
                PreparedStatement checkNewAirportStmt = con.prepareStatement(checkNewAirportQuery);
                checkNewAirportStmt.setString(1, newAirportID);
                ResultSet checkNewAirportResult = checkNewAirportStmt.executeQuery();
                checkNewAirportResult.next();
                int newAirportCount = checkNewAirportResult.getInt(1);
                
                if (newAirportCount > 0) {
                    out.print("Error: Airport with ID " + newAirportID + " already exists.");
                    return;
                }

                String updateAirportQuery = "UPDATE airport SET airportID = ? WHERE airportID = ?";
                PreparedStatement updateStmt = con.prepareStatement(updateAirportQuery);
                updateStmt.setString(1, newAirportID);
                updateStmt.setString(2, airportID);

                int rowsAffected = updateStmt.executeUpdate();

                if (rowsAffected > 0) {
                    out.print("Airport with ID " + airportID + " updated successfully to " + newAirportID);
                } else {
                    out.print("Error: Unable to update airport with ID " + airportID);
                }

                db.closeConnection(con);

            } catch (SQLException e) {
                out.println("Error: " + e.getMessage());
            }
        } else {
            out.println("Error: Missing or empty values for airportID or newAirportID.");
        }
    %>
</body>
</html>

<%
    out.println("<br/><a href='repModifyAirports.jsp'>Back</a>");
}
%>
