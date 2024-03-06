<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%
ApplicationDB db = new ApplicationDB();	
Connection con = db.getConnection();
PreparedStatement psSearchQuery = null;
ResultSet rsSearchQuery = null;
ResultSetMetaData rsmd2 = null;
switch(request.getParameter("searchFlightsType")){
	case "custOneWayDate":
		psSearchQuery = con.prepareStatement("select o.airlineID, o.flight_number, o.departure_time, o.arrival_time, "
			+ "d.departing_airportID, a.arriving_airportID, o.numberOfStops from operates_flight o, arriving_to a, "
				+ "departing_from d where o.flight_number = a.flight_number and o.airlineID = a.airlineID and o.departure_time = a.departure_time and " +
				"o.flight_number = d.flight_number and o.airlineID = d.airlineID and o.departure_time = d.departure_time and Date(o.departure_time) = ? "
				+ " and d.departing_airportID = ? and a.arriving_airportID = ?");
   	 	psSearchQuery.setString(1, request.getParameter("custOneWayDate"));
   	 	psSearchQuery.setString(2, request.getParameter("custOneWayDAirportID"));
   	 	psSearchQuery.setString(3, request.getParameter("custOneWayAAirportID"));
   	 	//out.println(request.getParameter("custOneWayDate"));
		rsSearchQuery = psSearchQuery.executeQuery();
		rsmd2 = rsSearchQuery.getMetaData();
		break;
	case "custRoundTripDate":
		psSearchQuery = con.prepareStatement("select o.airlineID, o.flight_number, o.departure_time, o.arrival_time, "
				+ "d.departing_airportID, a.arriving_airportID, o.numberOfStops from operates_flight o, arriving_to a, "
					+ "departing_from d where o.flight_number = a.flight_number and o.airlineID = a.airlineID and o.departure_time = a.departure_time and " +
					"o.flight_number = d.flight_number and o.airlineID = d.airlineID and o.departure_time = d.departure_time and Date(o.departure_time) = ? "
					+ "and Date(o.arrival_time) = ? and o.numberOfStops > 1 and d.departing_airportID = ? and a.arriving_airportID = ?");
	   	 	psSearchQuery.setString(1, request.getParameter("custRoundTripDateStart"));
	   	 	psSearchQuery.setString(2, request.getParameter("custRoundTripDateEnd"));
	   	 	psSearchQuery.setString(3, request.getParameter("custRoundTripAirport"));
	   	 	psSearchQuery.setString(4, request.getParameter("custRoundTripAirport"));
	   	 	//out.println(request.getParameter("custOneWayDate"));
			rsSearchQuery = psSearchQuery.executeQuery();
			rsmd2 = rsSearchQuery.getMetaData();
		break;
	case "custOneWayDateFlex":
		psSearchQuery = con.prepareStatement("select o.airlineID, o.flight_number, o.departure_time, o.arrival_time, "
				+ "d.departing_airportID, a.arriving_airportID, o.numberOfStops from operates_flight o, arriving_to a, "
					+ "departing_from d where o.flight_number = a.flight_number and o.airlineID = a.airlineID and o.departure_time = a.departure_time and " +
					"o.flight_number = d.flight_number and o.airlineID = d.airlineID and o.departure_time = d.departure_time and "
					+ "(datediff(Date(o.departure_time),?) between -3 and 3) and d.departing_airportID = ? and a.arriving_airportID = ?");
	   	 	psSearchQuery.setString(1, request.getParameter("custOneWayDateFlex"));
	   	 	psSearchQuery.setString(2, request.getParameter("custOneWayDAirportIDFlex"));
	   	 	psSearchQuery.setString(3, request.getParameter("custOneWayAAirportIDFlex"));
	   	 	//psSearchQuery.setString(2, request.getParameter("custOneWayDateFlex"));
			rsSearchQuery = psSearchQuery.executeQuery();
			rsmd2 = rsSearchQuery.getMetaData();
		break;
	case "custRoundTripDateFlex":
		psSearchQuery = con.prepareStatement("select o.airlineID, o.flight_number, o.departure_time, o.arrival_time, "
				+ "d.departing_airportID, a.arriving_airportID, o.numberOfStops from operates_flight o, arriving_to a, "
					+ "departing_from d where o.flight_number = a.flight_number and o.airlineID = a.airlineID and o.departure_time = a.departure_time and " +
					"o.flight_number = d.flight_number and o.airlineID = d.airlineID and o.departure_time = d.departure_time and (datediff(Date(o.departure_time),?) between -3 and 3)"
					+ "and (datediff(Date(o.arrival_time),?) between -3 and 3) and o.numberOfStops > 1 and d.departing_airportID = ? and a.arriving_airportID = ?");
	   	 	psSearchQuery.setString(1, request.getParameter("custRoundTripDateStartFlex"));
	   	 	psSearchQuery.setString(2, request.getParameter("custRoundTripDateEndFlex"));
	   	 	psSearchQuery.setString(3, request.getParameter("custRoundTripAirportFlex"));
	   	 	psSearchQuery.setString(4, request.getParameter("custRoundTripAirportFlex"));
	   	 	//out.println(request.getParameter("custOneWayDate"));
			rsSearchQuery = psSearchQuery.executeQuery();
			rsmd2 = rsSearchQuery.getMetaData();
		break;
	default:
		break;
}
int rowCount = 0;
out.println("<P><TABLE BORDER=1>");
int columnCount = rsmd2.getColumnCount();
// table header
out.println("<TR>");
for (int i = 0; i < columnCount; i++) {
  out.println("<TH>" + rsmd2.getColumnLabel(i + 1) + "</TH>");
}
out.println("</TR>");
// the data
while (rsSearchQuery.next()) {
	rowCount++;
  	out.println("<TR>");
  	for (int i = 0; i < columnCount; i++) {
    	out.println("<TD>" + rsSearchQuery.getString(i + 1) + "</TD>");
    }
  	out.println("</TR>");
 }
 out.println("</TABLE></P>");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Search</title>
</head>
<body>

</body>

</html>
<%
out.println("<a href='customerHome.jsp'>Go back</a>");
%>