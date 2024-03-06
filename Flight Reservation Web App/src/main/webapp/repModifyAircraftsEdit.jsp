<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<%
    if (session.getAttribute("user") == null || !"rep".equals(session.getAttribute("type"))) {
         out.println("Unauthorized Access.<br/>");
         out.println("<a href='login.jsp'>Please Login</a>");
    } else {
    	out.println("Aircraft Edit Confirmation<br/>");
        
%>


<html>
<head>
<title>Aircraft Edit Confirmation</title>
</head>
<body>

	<%
    String aircraftID = request.getParameter("aircraftID");
    String newAircraftID = request.getParameter("newAircraftID");
    String airlineID = request.getParameter("airlineID").toUpperCase();
    String seats = request.getParameter("seats");

    if (aircraftID != null && !aircraftID.trim().isEmpty() &&
    	    (   
    	        (newAircraftID != null && !newAircraftID.trim().isEmpty()) ||
    	        (airlineID != null && !airlineID.trim().isEmpty()) ||
    	        (seats != null && !seats.trim().isEmpty())
    	    )
    	) {
        try {
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();
            
            
            String checkAircraftQuery = "SELECT COUNT(*) FROM owns_aircraft WHERE aircraftID = ?";
            PreparedStatement checkAircraftStmt = con.prepareStatement(checkAircraftQuery);
                checkAircraftStmt.setString(1, aircraftID);
                ResultSet checkAircraftResult = checkAircraftStmt.executeQuery();
                checkAircraftResult.next();
                int aircraftCount = checkAircraftResult.getInt(1);
                if (aircraftCount == 0) {
                    out.print("Error: Aircraft with ID " + aircraftID + " does not exist.");
                    out.println("<br/><a href='repModifyAircrafts.jsp'>Back</a>");
                    return;
                }

            String checkNewAircraftQuery = "SELECT COUNT(*) FROM owns_aircraft WHERE aircraftID = ?";
            PreparedStatement checkNewAircraftStmt = con.prepareStatement(checkNewAircraftQuery);
                checkNewAircraftStmt.setString(1, newAircraftID);
                ResultSet checkNewAircraftResult = checkNewAircraftStmt.executeQuery();
                checkNewAircraftResult.next();
                int newAircraftCount = checkNewAircraftResult.getInt(1);
                if (newAircraftCount > 0) {
                    out.print("Error: Aircraft with ID " + newAircraftID + " already exists.");
                    out.println("<br/><a href='repModifyAircrafts.jsp'>Back</a>");
                    return;
                }
            


            

            if (airlineID != null && !airlineID.trim().isEmpty()) {
                String checkAirlineQuery = "SELECT COUNT(*) FROM airline WHERE airlineID = ?";
                PreparedStatement checkAirlineStmt = con.prepareStatement(checkAirlineQuery);
                    checkAirlineStmt.setString(1, airlineID);
                    ResultSet checkAirlineResult = checkAirlineStmt.executeQuery();
                    checkAirlineResult.next();
                    int airlineCount = checkAirlineResult.getInt(1);
                    if (airlineCount == 0) {
                        out.print("Error: Airline with ID " + airlineID + " does not exist.");
                        out.println("<br/><a href='repModifyAircrafts.jsp'>Back</a>");
                        return;
                    }
                }
            

            String updateAircraftQuery = "UPDATE owns_aircraft SET ";

            boolean hasUpdateFields = false;

            if (newAircraftID != null && !newAircraftID.trim().isEmpty()) {
                updateAircraftQuery += "aircraftID = ?";
                hasUpdateFields = true;
            }

            if (airlineID != null && !airlineID.trim().isEmpty()) {
                if (hasUpdateFields) {
                    updateAircraftQuery += ", ";
                }
                updateAircraftQuery += "airlineID = ?";
                hasUpdateFields = true;
            }

            if (seats != null && !seats.trim().isEmpty()) {
                if (hasUpdateFields) {
                    updateAircraftQuery += ", ";
                }
                updateAircraftQuery += "seats = ?";
                hasUpdateFields = true;
            }

            updateAircraftQuery += " WHERE aircraftID = ?";

            PreparedStatement updateStmt = con.prepareStatement(updateAircraftQuery);
            int parameterIndex = 1;

            if (newAircraftID != null && !newAircraftID.trim().isEmpty()) {
                updateStmt.setString(parameterIndex++, newAircraftID);
            }

            if (airlineID != null && !airlineID.trim().isEmpty()) {
                updateStmt.setString(parameterIndex++, airlineID);
            }

            if (seats != null && !seats.trim().isEmpty()) {
                updateStmt.setString(parameterIndex++, seats);
            }

            updateStmt.setString(parameterIndex, aircraftID);

            int rowsAffected = updateStmt.executeUpdate();

            if (rowsAffected > 0) {
                out.print("Aircraft with ID " + aircraftID + " updated successfully.");
            } else {
                out.print("Error: Unable to update aircraft with ID " + aircraftID);
            }

            

            db.closeConnection(con);

        } catch (SQLException e) {
            out.println("Error: " + e.getMessage());
        }
    } else {
        out.println("Error: Missing or empty values for aircraftID, newAircraftID, airlineID, or seats.");
    }
%>

</body>
</html>

<%
out.println("<br/><a href='repModifyAircrafts.jsp'>Back</a>");
    }
%>
