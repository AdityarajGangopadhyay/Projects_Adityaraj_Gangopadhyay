<%@ page language="java" import="java.util.Date" import="java.text.SimpleDateFormat" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<html>
<head>
<title>Summary of Revenue For Flight Number</title>
</head>
<html>

<%
	String flightNumber = request.getParameter("flightNumberRev");
	String airlineID = request.getParameter("airlineIDRev");
    
	ApplicationDB db = new ApplicationDB();	
	Connection con = db.getConnection();
	
	String sql2 = "SELECT COUNT(*) AS flight_count FROM operates_flight WHERE flight_number = ? AND airlineID = ?";
	PreparedStatement ps2 = con.prepareStatement(sql2);
	ps2.setString(1, flightNumber);
	ps2.setString(2, airlineID);
	ResultSet rs2 = ps2.executeQuery();
	
	
	String sql = "SELECT SUM(totalFare) AS total_revenue FROM ticket t "
	     + "INNER JOIN includes i ON t.ticketNum = i.ticketNum "
	     + "INNER JOIN operates_flight f ON i.flight_number = f.flight_number AND i.airlineID = f.airlineID AND i.departure_time = f.departure_time "
	     + "WHERE f.flight_number = ? AND f.airlineID = ?";
	
	PreparedStatement ps = con.prepareStatement(sql);
	ps.setString(1, flightNumber);
	ps.setString(2, airlineID);
	
	ResultSet rs = ps.executeQuery();
	
	if (rs2.next()) {
		int flightCount = rs2.getInt("flight_count");
		if (flightCount > 0) {
			if (rs.next()) {
			   double totalRevenue = rs.getDouble("total_revenue");
			   out.println("Total Revenue for Airline ID: " + airlineID + " Flight number: " + flightNumber + "<br>");
			   out.println("Total Revenue: $" + totalRevenue + "<br>");
			   out.println("Return back to <a href='adminHome.jsp'>Admin Home</a>");
			} else {
			  out.println("No revenue found for Airline ID: " + airlineID + " Flight number: " + flightNumber + ", Please <a href='adminHome.jsp'>try again</a>");
			}
		} else {
		      out.println("Airline ID: " + airlineID + " Flight number: " + flightNumber + " does not exist. Please <a href='adminHome.jsp'>try again</a>");
	    }
	}
%>