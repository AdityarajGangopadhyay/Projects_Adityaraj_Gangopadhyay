<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<html>
<head>
<title>Add Customer</title>
</head>
<html>

<%
	String username = request.getParameter("Username");
	
	ApplicationDB db = new ApplicationDB();	
	Connection con = db.getConnection();
	PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM users WHERE Username = ?");
	ps.setString(1, username);
	ResultSet rs = ps.executeQuery();
	
	if (rs.next()) {
		int count = rs.getInt(1);
	    if (count != 1) {
	        out.println("Username does not exist! Please <a href='adminHome.jsp'>try again</a>");
	    } else {
	    	try {
	    	    PreparedStatement ps2 = con.prepareStatement("DELETE FROM users WHERE Username = ?");
	    	    ps2.setString(1, username);
	    	    ps2.executeUpdate();
	    	    out.println(username + " deleted successfully. Return back to <a href='adminHome.jsp'>Admin Home</a>");
	    	} catch (Exception e){
	    		out.println("Invalid or incomplete information, Please <a href='adminHome.jsp'>try again</a>");
	    	}
		}
	} else {
		out.println("Invalid or incomplete information, Please <a href='adminHome.jsp'>try again</a>");
	}
%>