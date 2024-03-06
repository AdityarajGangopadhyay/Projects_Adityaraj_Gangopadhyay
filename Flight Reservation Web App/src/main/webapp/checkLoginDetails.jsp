<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<html>
<head>
<title>Login Failed</title>
</head>
<html>

<%
	String userid = request.getParameter("username");
	String pwd = request.getParameter("password");
	
	ApplicationDB db = new ApplicationDB();	
	Connection con = db.getConnection();
	PreparedStatement ps = con.prepareStatement("select * from users where username=? and BINARY password=?");
	ps.setString(1, userid);
	ps.setString(2, pwd);
	ResultSet rs = ps.executeQuery();
	
	if (rs.next()) {
		String type = rs.getString("type");
		session.setAttribute("type", type);
	    if ("customer".equals(type)) {
	        response.sendRedirect("customerHome.jsp");
	    } else if ("admin".equals(type)) {
	        response.sendRedirect("adminHome.jsp");
	    } else if ("rep".equals(type)) {
	        response.sendRedirect("repHome.jsp");
	    }
	
		session.setAttribute("user", userid); 
		out.println("Welcome to RU Flight, " + userid);
		out.println("<a href='logout.jsp'>Log out</a>");
		} else {
			out.println("Invalid username and/or password, Please <a href='login.jsp'>try again</a>");
		}
%>