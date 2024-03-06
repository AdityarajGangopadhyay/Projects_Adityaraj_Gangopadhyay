<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<%
    if (session.getAttribute("user") == null || !"rep".equals(session.getAttribute("type"))) {
         out.println("Unauthorized Access.<br/>");
         out.println("<a href='login.jsp'>Please Login</a>");
    } else {
    	out.println("Airport Add Confirmation<br/>");
        
%>



<html>
<head>
<title>Airport Add Confirmation</title>
</head>
<body>
	<%
	String airportID = request.getParameter("airportID").toUpperCase();

	if (airportID != null && !airportID.trim().isEmpty()) 
		{
        try {
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();
            
            
            
            String checkAircraftQuery = "SELECT COUNT(*) FROM airport WHERE airportID = ?";
			PreparedStatement checkAircraftStmt = con.prepareStatement(checkAircraftQuery);
                checkAircraftStmt.setString(1, airportID);
                ResultSet checkAircraftResult = checkAircraftStmt.executeQuery();
                checkAircraftResult.next();
                int aircraftCount = checkAircraftResult.getInt(1);
                if (aircraftCount > 0) {
                    out.print("Error: Aircraft with ID " + airportID + " already exists.");
                    return; 
                }
 
            String insertAircraftQuery = "INSERT INTO airport (airportID) VALUES (?)";
			PreparedStatement pstmt = con.prepareStatement(insertAircraftQuery);
                pstmt.setString(1, airportID);

                int rowsAffected = pstmt.executeUpdate();
                db.closeConnection(con);

                if (rowsAffected > 0) {
                    out.print("Airport with ID " + airportID + " inserted successfully.");
                } else {
                    out.print("Error: Unable to insert airport with ID " + airportID);
                }
            
    		
        } catch (SQLException e) {
            out.println("Error: " + e.getMessage());
        }
    } else {
        out.println("Error: Missing or empty values for airportID.");
    }
	%>
</body>
</html>

<%
out.println("<br/><a href='repModifyAirports.jsp'>Back</a>");
    }
%>
