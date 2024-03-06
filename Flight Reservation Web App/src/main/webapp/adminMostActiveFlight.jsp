<%@ page language="java" import="java.util.Date" import="java.text.SimpleDateFormat" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<html>
<head>
<title>Customer With Most Total Revenue</title>
</head>
<html>

<%
	ApplicationDB db = new ApplicationDB();	
	Connection con = db.getConnection();

	String sql = "SELECT i.airlineID, i.flight_number, COUNT(i.ticketNum) AS tickets_sold " +
            "FROM ticket t " +
            "JOIN includes i ON t.ticketNum = i.ticketNum " +
            "GROUP BY i.airlineID, i.flight_number " +
            "ORDER BY tickets_sold DESC;";

	Statement stmt = con.createStatement();
	ResultSet rs = stmt.executeQuery(sql);
	
	out.println("Most active flights (most tickets sold):<br>");
	
	while (rs.next()) {
		String airlineID = rs.getString("airlineID");
		int flightNumber = rs.getInt("flight_number");
		int ticketsSold = rs.getInt("tickets_sold");
		out.println("<br>AirlineID: "  + airlineID + "<br> Flight Number: " + flightNumber + "<br> " + ticketsSold + " ticket(s) sold<br>");
	}
	out.println("<br>End of List or No valid flights, Return back to <a href='adminHome.jsp'>Admin Home</a>");
%>