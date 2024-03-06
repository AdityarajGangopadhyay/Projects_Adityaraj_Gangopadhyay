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
	String pwd = request.getParameter("Password");
	String fname = request.getParameter("Fname");
	String lname = request.getParameter("Lname");
	String type = request.getParameter("Type");
	
	ApplicationDB db = new ApplicationDB();	
	Connection con = db.getConnection();
	PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM users WHERE Username = ?");
	ps.setString(1, username);
	ResultSet rs = ps.executeQuery();
	
	if (rs.next()) {
		int count = rs.getInt(1);
	    if (count == 1) {
	        out.println("Username already exists! Please <a href='adminHome.jsp'>try again</a>");
	    } else {
	    	try {
	    		PreparedStatement ps1 = con.prepareStatement("INSERT INTO users (Username, Fname, Lname, Type, Password) VALUES (?, ?, ?, ?, ?)");
	    		ps1.setString(1, username);
	    		ps1.setString(2, fname);
	    		ps1.setString(3, lname);
	    		ps1.setString(4, type);
	    		ps1.setString(5, pwd);
	    		ps1.executeUpdate();
	    		
	    		PreparedStatement ps2 = con.prepareStatement("SELECT LAST_INSERT_ID()");
	    		ResultSet rs2 = ps2.executeQuery();
	    		
	    		if (rs2.next()) {
	    			int lastInsertedId = rs2.getInt(1);
	    			out.println("Customer/Customer Rep Account Added! Assigned UserID: " + lastInsertedId + ". Return back to <a href='adminHome.jsp'>Admin Home</a>");
	    		} else {
	    			out.println("Invalid or incomplete information, Please <a href='adminHome.jsp'>try again</a>");
	    		}
	    	} catch (Exception e){
	    		out.println("Invalid or incomplete information, Please <a href='adminHome.jsp'>try again</a>");
	    	}
		}
	} else {
		out.println("Invalid or incomplete information, Please <a href='adminHome.jsp'>try again</a>");
	}
%>