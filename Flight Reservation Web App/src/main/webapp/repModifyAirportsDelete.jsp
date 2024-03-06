<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<%
    if (session.getAttribute("user") == null || !"rep".equals(session.getAttribute("type"))) {
         out.println("Unauthorized Access.<br/>");
         out.println("<a href='login.jsp'>Please Login</a>");
    } else {
    	out.println("Airport Delete Confirmation<br/>");
        
%>



<html>
<head>
<title>Airport Delete Confirmation</title>
</head>
<body>
	<%
	String airportID = request.getParameter("airportID").toUpperCase();

	if (airportID != null && !airportID.trim().isEmpty()) {
        try {
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();
            
            String sql = "DELETE FROM airport WHERE airportID = ?";	
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setString(1, airportID);
            int rowsAffected = pstmt.executeUpdate();
            db.closeConnection(con);
            if (rowsAffected > 0) {
                out.print("Airport " + airportID + " has been deleted.");
            } else {
                out.print("No airport found with aircraftID " + airportID);
            }
        } catch (SQLException e) {
            out.println("Error: " + e.getMessage());
        }
    } else {
        out.println("Error: The airportID cannot be null or empty.");
    }
	%>
</body>
</html>

<%
out.println("<br/><a href='repModifyAirports.jsp'>Back</a>");
    }
%>
