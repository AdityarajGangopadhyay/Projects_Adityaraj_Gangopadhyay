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

	String sql = "SELECT u.Username, SUM(totalFare) AS total_revenue " +
            "FROM ticket t " +
            "JOIN buys b ON t.ticketNum = b.ticketNum " +
            "JOIN users u ON b.Username = u.Username " +
            "WHERE u.Type = 'customer' " +
            "GROUP BY u.Username " +
            "ORDER BY total_revenue DESC " +
            "LIMIT 1;";

    PreparedStatement ps = con.prepareStatement(sql);
	ResultSet rs = ps.executeQuery();
	
	if (rs.next()) {
		String username = rs.getString("Username");
		int totalRevenue = rs.getInt("total_revenue");
		out.println("Customer with the most total revenue: Username: " + username + "<br>");
		out.println("Total Revenue: $" + totalRevenue + "<br>");
		out.println("Return back to <a href='adminHome.jsp'>Admin Home</a>");
	} else {
		out.println("No customer found with total revenue, Please <a href='adminHome.jsp'>try again</a>");
	}
%>