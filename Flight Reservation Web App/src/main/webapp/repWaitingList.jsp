<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>


<%
    if(session.getAttribute("user") == null || !"rep".equals(session.getAttribute("type"))) {
        out.println("Unauthorized Access.<br/>");
        out.println("<a href='login.jsp'>Please Login</a>");
    }else{
   		out.println("View Waiting List" + "<br/>");        
%>

<html>
<head>
<title>View Waiting List</title>
</head>
<body>
<%
		try {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

		String airlineID = request.getParameter("airlineID");
		String flightNumber = request.getParameter("flightNumber");
		String departureTime = request.getParameter("departureTime");

		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		
		String query = "SELECT u.username, u.Fname, u.Lname " +
	               "FROM ticketstatus t " +
	               "JOIN users u ON t.username = u.Username " +
	               "WHERE t.status = 'onWaitingList' " +
	               "  AND t.flightNumber = ? " +
	               "  AND t.airlineID = ? " +
	               "  AND t.departure_time = ?";

		PreparedStatement preparedStatement = con.prepareStatement(query);

		 preparedStatement.setString(1, flightNumber);
		 preparedStatement.setString(2, airlineID);
		 preparedStatement.setString(3, departureTime);

		 ResultSet resultSet = preparedStatement.executeQuery();
		 
		 out.println("List of customers on waiting list for flight: " + airlineID + " " + flightNumber + " departing on " + departureTime + "<br>");
		 out.println("<table border='1'>");
		 
		 out.println("<tr><th>Username</th><th>Full Name</th></tr>");

		 while (resultSet.next()) {
		     String username = resultSet.getString("username");
		     String firstName = resultSet.getString("Fname");
		     String lastName = resultSet.getString("Lname");
		     String fullName = firstName + " " + lastName;

		     out.println("<tr>");
		     out.println("<td>" + username + "</td>");
		     out.println("<td>" + fullName + "</td>");
		     out.println("</tr>");
		 }

		 out.println("</table>");
		 

			db.closeConnection(con);
		 
		   } catch (Exception e) {
	            out.print("Error: " + e);
	       }


	        
	        
	        %>
</body>
</html>

<%
out.println("<a href='repHome.jsp'>Back</a>");
    }
%>
