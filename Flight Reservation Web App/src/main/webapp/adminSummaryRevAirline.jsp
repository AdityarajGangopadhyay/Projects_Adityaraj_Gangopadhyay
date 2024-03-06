<%@ page language="java" import="java.util.Date" import="java.text.SimpleDateFormat" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<html>
<head>
<title>Summary of Revenue For Airline</title>
</head>
<html>

<%
	String airlineID = request.getParameter("airlineIDRev");
    
	ApplicationDB db = new ApplicationDB();	
	Connection con = db.getConnection();
	
	String sql2 = "SELECT COUNT(*) AS airline_count FROM airline WHERE AirlineID = ?";
	PreparedStatement ps2 = con.prepareStatement(sql2);
	ps2.setString(1, airlineID);
	ResultSet rs2 = ps2.executeQuery();

	String sql = "SELECT SUM(totalFare) AS total_revenue FROM ticket t "
	     + "INNER JOIN includes i ON t.ticketNum = i.ticketNum "
	     + "INNER JOIN operates_flight f ON i.flight_number = f.flight_number AND i.airlineID = f.airlineID AND i.departure_time = f.departure_time "
	     + "INNER JOIN airline a on f.airlineID = a.AirlineID "
	     + "WHERE a.AirlineID = ?";
	
	PreparedStatement ps = con.prepareStatement(sql);
	ps.setString(1, airlineID);
	
	ResultSet rs = ps.executeQuery();
	
	if (rs2.next()) {
		int flightCount = rs2.getInt("airline_count");
		if (flightCount > 0) {
			if (rs.next()) {
			   double totalRevenue = rs.getDouble("total_revenue");
			   out.println("Total Revenue for Airline: " + airlineID + "<br>");
			   out.println("Total Revenue: $" + totalRevenue + "<br>");
			   out.println("Return back to <a href='adminHome.jsp'>Admin Home</a>");
			} else {
			  out.println("No revenue found for Airline: " + airlineID + ", Please <a href='adminHome.jsp'>try again</a>");
			}
		} else {
		      out.println("Airline " + airlineID + " does not exist. Please <a href='adminHome.jsp'>try again</a>");
	    }
	}
%>