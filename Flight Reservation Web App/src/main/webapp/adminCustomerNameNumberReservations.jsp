<%@ page language="java" import="java.util.Date" import="java.text.SimpleDateFormat" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<html>
<head>
<title>List of Reservations By Customer Name</title>
</head>
<html>

<%
	String fname = request.getParameter("customerFnameReserve");
	String lname = request.getParameter("customerLnameReserve");
    
	ApplicationDB db = new ApplicationDB();	
	Connection con = db.getConnection();

	  String sql = "SELECT t.ticketNum, u.Fname, u.Lname, u.UserID, t.totalFare, b.purchaseDateTime, "
		      + "f.flight_number, f.airlineID, d.departing_airportID, a.arriving_airportID, "
		      + "f.departure_time, f.arrival_time, i.seatNum, i.class "
		      + "FROM ticket t "
		      + "INNER JOIN buys b ON t.ticketNum = b.ticketNum "
		      + "INNER JOIN includes i ON t.ticketNum = i.ticketNum "
		      + "INNER JOIN operates_flight f ON i.flight_number = f.flight_number AND i.airlineID = f.airlineID AND i.departure_time = f.departure_time "
		      + "INNER JOIN departing_from d ON d.flight_number = i.flight_number AND d.airlineID = i.airlineID "
		      + "INNER JOIN arriving_to a ON a.flight_number = i.flight_number AND a.airlineID = i.airlineID "
		      + "INNER JOIN users u ON b.Username = u.Username "
		      + "WHERE u.Fname = ? AND u.Lname = ?";

	  PreparedStatement ps = con.prepareStatement(sql);
	  ps.setString(1, fname);
	  ps.setString(2, lname);

	  ResultSet rs = ps.executeQuery();

	  if (rs.next()) {
	    out.println("<table border='1'>");
	    out.println("<tr><th>Ticket Number</th><th>Passenger Name</th><th>ID Number</th><th>Total Fare</th><th>Purchase Date/Time</th><th>From Airport</th><th>To Airport</th><th>Flight Number (Airline)</th><th>Departure Date/Time</th><th>Arrival Date/Time</th><th>Seat Number</th><th>Class</th></tr>");

	    do {
	      String ticketNum = rs.getString("ticketNum");
	      String passengerName = rs.getString("Fname") + " " + rs.getString("Lname");
	      String userID = rs.getString("UserID");
	      int totalFare = rs.getInt("totalFare");
	      String purchaseDateTime = rs.getString("purchaseDateTime");
	      String fromAirportID = rs.getString("departing_airportID");
	      String toAirportID = rs.getString("arriving_airportID");
	      String airlineID = rs.getString("airlineID");
	      String flightNumberDB = rs.getString("flight_number");
	      String departureTime = rs.getString("departure_time");
	      String arrivalTime = rs.getString("arrival_time");
	      int seatNum = rs.getInt("seatNum");
	      String classStr = rs.getString("class");

	      out.println("<tr>");
	      out.println("<td>" + ticketNum + "</td>");
	      out.println("<td>" + passengerName + "</td>");
	      out.println("<td>" + userID + "</td>");
	      out.println("<td>" + totalFare + "</td>");
	      out.println("<td>" + purchaseDateTime + "</td>");
	      out.println("<td>" + fromAirportID + "</td>");
	      out.println("<td>" + toAirportID + "</td>");
	      out.println("<td>" + flightNumberDB + " (" + airlineID + ")</td>");
	      out.println("<td>" + departureTime + "</td>");
	      out.println("<td>" + arrivalTime + "</td>");
	      out.println("<td>" + (seatNum > 0 ? Integer.toString(seatNum) : "N/A") + "</td>");
	      out.println("<td>" + classStr + "</td>");
	      out.println("</tr>");
	    } while (rs.next());

	    out.println("</table>");
	    out.println("Return back to <a href='adminHome.jsp'>Admin Home</a>");
	  } else {
	    out.println("No reservations found for flight number " + fname + " " + lname + ", Please <a href='adminHome.jsp'>try again</a>");
	  }
%>