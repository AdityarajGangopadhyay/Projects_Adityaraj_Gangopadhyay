<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>


<html>
	<head>
		<title>Register</title>
	</head>
	<body>
		<p>Please enter details below to register.</p>
		<form action="registerBackend.jsp" method="POST">
			First Name: <input type="text" name="First Name" required/> <br/>
			Last Name:<input type="text" name="Last Name" required/> <br/>
			Username: <input type="text" name="Username" required/> <br/>
			<p>Username in use. Please select a different username.</p>
			Password:<input type="password" name="Password" required/> <br/>
			<input type="submit" value="Submit"/>
		</form>
	</body>
</html>