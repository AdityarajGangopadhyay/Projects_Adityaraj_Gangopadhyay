<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<%
    if (session.getAttribute("user") == null || !"rep".equals(session.getAttribute("type"))) {
         out.println("Unauthorized Access.<br/>");
         out.println("<a href='login.jsp'>Please Login</a>");
    } else {
    	out.println("Flight Delete Confirmation<br/>");
        
%>



<html>
<head>
<title>Flight Delete Confirmation</title>
</head>
<body>
	<%
	String flightNumber = request.getParameter("flightNumber");

	if (flightNumber != null && !flightNumber.trim().isEmpty()) {
        try {
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();
            
            String sql = "DELETE FROM operates_flight WHERE flight_number = ?";	
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setString(1, flightNumber);
            int rowsAffected = pstmt.executeUpdate();
            db.closeConnection(con);
            if (rowsAffected > 0) {
                out.print("Flight " + flightNumber + " has been deleted.");
            } else {
                out.print("No flight found with flight number " + flightNumber);
            }
        } catch (SQLException e) {
            out.println("Error: " + e.getMessage());
        }
    } else {
        out.println("Error: The Flight Number cannot be null or empty.");
    }
	%>
</body>
</html>

<%
out.println("<br/><a href='repModifyFlights.jsp'>Back</a>");
    }
%>
