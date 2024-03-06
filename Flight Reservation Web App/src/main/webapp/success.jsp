<%@ page language="java" contentType="text/html; charset=ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<%
	if ((session.getAttribute("user") == null)) {
%>
You are not logged in<br/>
<a href="login.jsp">Please Login</a>
<%} else {
%>
Welcome to RU Flight, <%=session.getAttribute("user")%>
<a href='logout.jsp'>Log out</a>
<%
	}
%>