<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<%
    if (session.getAttribute("user") == null || !"rep".equals(session.getAttribute("type"))) {
         out.println("Unauthorized Access.<br/>");
         out.println("<a href='login.jsp'>Please Login</a>");
    } else {
    	out.println("Aircraft Add Confirmation<br/>");
        
%>



<html>
<head>
<title>Aircraft Add Confirmation</title>
</head>
<body>
	<%
	String aircraftID = request.getParameter("aircraftID");
	String airlineID = request.getParameter("airlineID").toUpperCase();
	String seats = request.getParameter("seats");


	if (aircraftID != null && !aircraftID.trim().isEmpty() 
		&& airlineID != null && !airlineID.trim().isEmpty()
		&& seats != null && !seats.trim().isEmpty()) {
        try {
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();
            
            
            
            String checkAircraftQuery = "SELECT COUNT(*) FROM owns_aircraft WHERE aircraftID = ?";
			PreparedStatement checkAircraftStmt = con.prepareStatement(checkAircraftQuery);
                checkAircraftStmt.setString(1, aircraftID);
                ResultSet checkAircraftResult = checkAircraftStmt.executeQuery();
                checkAircraftResult.next();
                int aircraftCount = checkAircraftResult.getInt(1);
                if (aircraftCount > 0) {
                    out.print("Error: Aircraft with ID " + aircraftID + " already exists.");
                    return; 
                }
            
            String checkAirlineQuery = "SELECT COUNT(*) FROM airline WHERE airlineID = ?";
			PreparedStatement checkAirlineStmt = con.prepareStatement(checkAirlineQuery); 
                checkAirlineStmt.setString(1, airlineID);
                ResultSet checkAirlineResult = checkAirlineStmt.executeQuery();
                checkAirlineResult.next();
                int airlineCount = checkAirlineResult.getInt(1);
                if (airlineCount == 0) {
                    out.print("Error: Airline with ID " + airlineID + " does not exist.");
                    return; 
                }
                

            
            
            String insertAircraftQuery = "INSERT INTO owns_aircraft (aircraftID, airlineID, seats) VALUES (?, ?, ?)";
			PreparedStatement pstmt = con.prepareStatement(insertAircraftQuery);
                pstmt.setString(1, aircraftID);
                pstmt.setString(2, airlineID);
                pstmt.setString(3, seats);

                int rowsAffected = pstmt.executeUpdate();
                db.closeConnection(con);

                if (rowsAffected > 0) {
                    out.print("Aircraft with ID " + aircraftID + " inserted successfully.");
                } else {
                    out.print("Error: Unable to insert aircraft with ID " + aircraftID);
                }
            
    		
        } catch (SQLException e) {
            out.println("Error: " + e.getMessage());
        }
    } else {
        out.println("Error: Missing or empty values for aircraftID, airlineID, or seats.");
    }
	%>
</body>
</html>

<%
out.println("<br/><a href='repModifyAircrafts.jsp'>Back</a>");
    }
%>
