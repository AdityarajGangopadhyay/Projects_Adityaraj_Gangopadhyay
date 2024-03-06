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
   		out.println("View Flights for an Airport" + "<br/>");        
%>

<html>
<head>
<title>View Flights for an Airport</title>
</head>
<body>
<%
		try {

		String airportID = request.getParameter("airportID");

		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		
		
		String query = "(SELECT d.airlineID, d.flight_number, d.departure_time, 'Departing' as flight_type, o.arrival_time " +
	               " FROM departing_from d " +
	               " JOIN operates_flight o ON d.flight_number = o.flight_number AND d.airlineID = o.airlineID AND d.departure_time = o.departure_time " +
	               " WHERE d.departing_airportID = ?) " +
	               " UNION " +
	               " (SELECT a.airlineID, a.flight_number, a.departure_time, 'Arriving' as flight_type, o.arrival_time " +
	               " FROM arriving_to a " +
	               " JOIN operates_flight o ON a.flight_number = o.flight_number AND a.airlineID = o.airlineID AND a.departure_time = o.departure_time " +
	               " WHERE a.arriving_airportID = ?)";

		
		  PreparedStatement preparedStatement = con.prepareStatement(query);
		
		  preparedStatement.setString(1, airportID);
		  preparedStatement.setString(2, airportID);
		
		  ResultSet resultSet = preparedStatement.executeQuery();
		  
		 out.println("List of flights departing or arriving at airport: " + airportID + "<br>");

		  out.println("<table border='1'>");
		  out.println("<tr><th>Airline ID</th><th>Flight Number</th><th>Departing or Arriving</th><th>Departure Time</th><th>Arrival Time</th></tr>");

		  while (resultSet.next()) {
		      String airlineID = resultSet.getString("airlineID");
		      String flightNumber = resultSet.getString("flight_number");
		      String flightType = resultSet.getString("flight_type");
		      String departureTime = resultSet.getString("departure_time");
		      String arrivalTime = resultSet.getString("arrival_time");

		      out.println("<tr>");
		      out.println("<td>" + airlineID + "</td>");
		      out.println("<td>" + flightNumber + "</td>");
		      out.println("<td>" + flightType + "</td>");
		      out.println("<td>" + departureTime + "</td>");
		      out.println("<td>" + arrivalTime + "</td>");
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
