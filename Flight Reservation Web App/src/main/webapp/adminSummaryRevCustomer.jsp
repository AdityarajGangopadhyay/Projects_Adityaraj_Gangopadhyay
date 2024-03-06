<%@ page language="java" import="java.util.Date" import="java.text.SimpleDateFormat" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<html>
<head>
<title>Summary of Revenue For Customer</title>
</head>
<html>

<%
	String customerID = request.getParameter("customerIDRev");
    
	ApplicationDB db = new ApplicationDB();	
	Connection con = db.getConnection();
	
	String sql2 = "SELECT COUNT(*) AS customer_count FROM users WHERE UserID = ? AND Type = 'customer'";
	PreparedStatement ps2 = con.prepareStatement(sql2);
	ps2.setString(1, customerID);
	ResultSet rs2 = ps2.executeQuery();

	String sql = "SELECT SUM(totalFare) AS total_revenue FROM ticket t "
		 + "INNER JOIN buys b on t.ticketNum = b.ticketNum "
		 + "INNER JOIN users u on b.Username = u.Username "
	     + "WHERE u.UserID = ?";
	
	PreparedStatement ps = con.prepareStatement(sql);
	ps.setString(1, customerID);
	
	ResultSet rs = ps.executeQuery();
	
	if (rs2.next()) {
		int flightCount = rs2.getInt("customer_count");
		if (flightCount > 0) {
			if (rs.next()) {
			   double totalRevenue = rs.getDouble("total_revenue");
			   out.println("Total Revenue for Customer: " + customerID + "<br>");
			   out.println("Total Revenue: $" + totalRevenue + "<br>");
			   out.println("Return back to <a href='adminHome.jsp'>Admin Home</a>");
			} else {
			  out.println("No revenue found for Customer: " + customerID + ", Please <a href='adminHome.jsp'>try again</a>");
			}
		} else {
		      out.println("Customer with ID: " + customerID + " does not exist. Please <a href='adminHome.jsp'>try again</a>");
	    }
	}
%>