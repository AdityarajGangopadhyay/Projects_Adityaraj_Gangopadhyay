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
	String userID = request.getParameter("UserID");
	String username = request.getParameter("Username");
	String pwd = request.getParameter("Password");
	String fname = request.getParameter("Fname");
	String lname = request.getParameter("Lname");
	
	ApplicationDB db = new ApplicationDB();	
	Connection con = db.getConnection();
	PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM users WHERE UserID = ?");
	ps.setString(1, userID);
	ResultSet rs = ps.executeQuery();
	
	if (rs.next()) {
		int count = rs.getInt(1);
	    if (count < 1) {
	        out.println("UseID does not already exist! Please <a href='adminHome.jsp'>try again</a>");
	    } else {
	    	try {
	    		int check = 0;
	    		String sql = "";
	    		
	    		if (username != null && !username.isEmpty()) {
	    			if (check == 0){
	    				sql+= "UPDATE users SET Username = ? ";
	    				check = 1;
	    			}
	    			else {
	    				sql += ", Username = ? ";
	    			}
	    		}
	
	    		if (pwd != null && !pwd.isEmpty()) {
	    			if (check == 0){
	    				sql+= "UPDATE users SET Password = ? ";
	    				check = 1;
	    			}
	    			else {
	    				sql += ", Password = ? ";
	    			}
	    		}
	    		
	    		if (fname != null && !fname.isEmpty()) {
	    			if (check == 0){
	    				sql+= "UPDATE users SET Fname = ? ";
	    				check = 1;
	    			}
	    			else {
	    				sql += ", Fname = ? ";
	    			}
	    		}
	    		
	    		if (lname != null && !lname.isEmpty()) {
	    			if (check == 0){
	    				sql+= "UPDATE users SET Lname = ? ";
	    				check = 1;
	    			}
	    			else {
	    				sql += ", Lname = ? ";
	    			}
	    		}	    	
		    	
    			sql += " WHERE UserID = ?";
   
	    		PreparedStatement ps1 = con.prepareStatement(sql);
	    		int paramIndex = 1;
	    		if (username != null && !username.isEmpty()) {
		    		   ps1.setString(paramIndex++, username);
		    		}
	    		if (pwd != null && !pwd.isEmpty()) {
	    		   ps1.setString(paramIndex++, pwd);
	    		}
	    		if (fname != null && !fname.isEmpty()) {
	    		   ps1.setString(paramIndex++, fname);
	    		}
	    		if (lname != null && !lname.isEmpty()) {
	    		   ps1.setString(paramIndex++, lname);
	    		}
	    		ps1.setString(paramIndex, userID);
	    		ps1.executeUpdate();
	    		out.println("Customer Account Edited! Return back to <a href='adminHome.jsp'>Admin Home</a>");
	    	} catch (Exception e){
	    		out.println("Invalid/Incomplete Information, Please <a href='adminHome.jsp'>try again</a>");
	    	}
		}
	} else {
		out.println("Invalid information, Please <a href='adminHome.jsp'>try again</a>");
	}
%>