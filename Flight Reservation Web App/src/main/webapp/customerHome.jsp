<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>


<%
    if (session.getAttribute("user") == null || !"customer".equals(session.getAttribute("type"))) {
         out.println("Unauthorized Access.<br/>");
         out.println("<a href='login.jsp'>Please Login</a>");
    } else {
    	 out.println("Welcome to RU Flight, " + session.getAttribute("user") + "<br/>");
    	 String username = (String)session.getAttribute("user");
    	 ApplicationDB db = new ApplicationDB();	
    	Connection con = db.getConnection();
    	 PreparedStatement psTicketStatus = con.prepareStatement("select t1.airlineID, t1.flightNumber, t1.departure_time from (select Username, airlineID, flightNumber, departure_time, status from ticketStatus "
    				+ "where Username = ? and status = 'onWaitingList') t1, (select t.airlineID, t.flightNumber, t.departure_time, count(*) from ticketStatus t where "
    	    				+ "t.status = 'onFlight' group by t.airlineID, t.flightNumber, t.departure_time having count(*) = 0 or count(*) <  (select owns_aircraft.seats from operates_flight "+
    								"join flown_on on operates_flight.flight_number = flown_on.flight_number and "
    								+ "operates_flight.airlineID = flown_on.airlineID and operates_flight.departure_time = flown_on.departure_time join owns_aircraft on flown_on.aircraftID = "
    								+ "owns_aircraft.aircraftID where operates_flight.airlineID = t.airlineID and operates_flight.flight_number = t.flightNumber and operates_flight.departure_time = t.departure_time)) t2 "
    								+ "where t1.airlineId = t2.airlineId and t1.flightNumber = t2.flightNumber and t1.departure_time = t2.departure_time"); 
    	 /* PreparedStatement psTicketStatus = con.prepareStatement("select airlineID, flightNumber, departure_time, count(*) from ticketStatus t where "
    				+ "status = 'onFlight' and airlineID = ? and flightNumber = ? and departure_time = ? having count(*) <  (select owns_aircraft.seats from operates_flight "+
							"join flown_on on operates_flight.flight_number = flown_on.flight_number and "
							+ "operates_flight.airlineID = flown_on.airlineID and operates_flight.departure_time = flown_on.departure_time join owns_aircraft on flown_on.aircraftID = "
							+ "owns_aircraft.aircraftID where operates_flight.airlineID = t.airlineID and operates_flight.flight_number = t.flight_number and operates_flight.departure_time = t.departure_time)");  */
    	 psTicketStatus.setString(1, username);
		out.println("<br/>Flights that you are on a waiting list for that you can now book:");
    		ResultSet rsTicketStatus = psTicketStatus.executeQuery();
    		ResultSetMetaData rsmdTicket = rsTicketStatus.getMetaData();
    		int rowCountT = 0;
    		out.println("<P><TABLE BORDER=1>");
    		int columnCountT = rsmdTicket.getColumnCount();
    		// table header
    		out.println("<TR>");
    		for (int i = 0; i < columnCountT; i++) {
    		  out.println("<TH>" + rsmdTicket.getColumnLabel(i + 1) + "</TH>");
    		}
    		out.println("</TR>");
    		// the data
    		while (rsTicketStatus.next()) {
    			rowCountT++;
    		  	out.println("<TR>");
    		  	for (int i = 0; i < columnCountT; i++) {
    		    	out.println("<TD>" + rsTicketStatus.getString(i + 1) + "</TD>");
    		    }
    		  	out.println("</TR>");
    		 }
    		 out.println("</TABLE></P>");
    		 
    	out.println("</br>All Flights:");
    	PreparedStatement psAllFlights = con.prepareStatement("select o.airlineID, o.flight_number, o.departure_time, o.arrival_time, "
    			+ "d.departing_airportID, a.arriving_airportID, o.firstClassPrice, o.businessPrice, o.economyPrice, o.numberOfStops from operates_flight o, arriving_to a, "
    				+ "departing_from d where o.flight_number = a.flight_number and o.airlineID = a.airlineID and o.departure_time = a.departure_time and " +
    				"o.flight_number = d.flight_number and o.airlineID = d.airlineID and o.departure_time = d.departure_time"); 
    			ResultSet rsAllFlights = psAllFlights.executeQuery();
    			ResultSetMetaData rsmdAllFlights = rsAllFlights.getMetaData();
    			int rowCountA = 0;
    			out.println("<P><TABLE BORDER=1>");
    			int columnCountA = rsmdAllFlights.getColumnCount();
    			// table header
    			out.println("<TR>");
    			for (int i = 0; i < columnCountA; i++) {
    			  out.println("<TH>" + rsmdAllFlights.getColumnLabel(i + 1) + "</TH>");
    			}
    			out.println("</TR>");
    			// the data
    			while (rsAllFlights.next()) {
    				rowCountA++;
    			  	out.println("<TR>");
    			  	for (int i = 0; i < columnCountA; i++) {
    			    	out.println("<TD>" + rsAllFlights.getString(i + 1) + "</TD>");
    			    }
    			  	out.println("</TR>");
    			 }
    			 out.println("</TABLE></P>");
%>

<html>
<head>
<title>Customer Home</title>
</head>
<body>
<%
	PreparedStatement ps2 = con.prepareStatement("select t.ticketNum, b.purchaseDateTime, b.Username, t.totalFare from buys b, ticket t "
			+ "where b.ticketNum = t.ticketNum and b.Username = ?"); 
	ps2.setString(1, username);
	ResultSet rs2 = ps2.executeQuery();
	ResultSetMetaData rsmd2 = rs2.getMetaData();
	int rowCount = 0;
	out.println("<br/>Your tickets:");
	out.println("<P><TABLE BORDER=1>");
	int columnCount = rsmd2.getColumnCount();
	// table header
	out.println("<TR>");
	for (int i = 0; i < columnCount; i++) {
	  out.println("<TH>" + rsmd2.getColumnLabel(i + 1) + "</TH>");
	}
	out.println("</TR>");
	// the data
	while (rs2.next()) {
		rowCount++;
	  	out.println("<TR>");
	  	for (int i = 0; i < columnCount; i++) {
	    	out.println("<TD>" + rs2.getString(i + 1) + "</TD>");
	    }
	  	out.println("</TR>");
	 }
	 out.println("</TABLE></P>");
%>
<br>		
<form method="post" action="customerSearch.jsp">
 	One-Way Date: <input type="date" name="custOneWayDate"/>
 	Departing Airport: <input type="text" name="custOneWayDAirportID"/>
 	Arriving Airport: <input type="text" name="custOneWayAAirportID"/>
 	<input type="hidden" name="searchFlightsType" value=custOneWayDate>
 	<input type="submit" value="Search" />
</form>
<form method="post" action="customerSearch.jsp">
 	Round Trip Date: <input type="date" name="custRoundTripDateStart"/>
 	<input type="date" name="custRoundTripDateEnd"/>
 	 	Departing and Arriving Airport: <input type="text" name="custRoundTripAirport"/>
 
 	 <input type="hidden" name="searchFlightsType" value=custRoundTripDate>
 	<input type="submit" value="Search" />
</form>
<form method="post" action="customerSearch.jsp">
 	One-Way Date (Flex Date): <input type="date" name="custOneWayDateFlex"/>
 	Departing Airport: <input type="text" name="custOneWayDAirportIDFlex"/>
 	Arriving Airport: <input type="text" name="custOneWayAAirportIDFlex"/>
 	 	 <input type="hidden" name="searchFlightsType" value=custOneWayDateFlex>
 	<input type="submit" value="Search" />
</form>
<form method="post" action="customerSearch.jsp">
 	Round Trip (Flex Date): <input type="date" name="custRoundTripDateStartFlex"/>
 	<input type="date" name="custRoundTripDateEndFlex"/>
 	 	Departing and Arriving Airport: <input type="text" name="custRoundTripAirportFlex"/>
 	 	 <input type="hidden" name="searchFlightsType" value=custRoundTripDateFlex>
 	<input type="submit" value="Search" />
</form>
<form method="post" action="customerSort.jsp">
	<label for="sort">Sort Flights By:</label>
	<select name="sort" id="sort">
		<option value="price">Price</option>
		<option value="take_off_time">Take-off Time</option>
		<option value="landing_time">Landing Time</option>
		<option value="duration">Duration of Flight</option>
	 </select>
	 <select name="sortOrder" id="sortOrder">
		<option value="asc">Ascending</option>
		<option value="desc">Descending</option>
	 </select>
	<input type="submit" value="Sort"/>
	(Sorting Flights by Price will sort by its First Class Ticket Price)
</form>
<form method="post" action="filter.jsp">
	<label for="filter" ><b>Filter Flights By: (Price based on First Class)</b></label> <br/><br/>

		Min. Price: <input type="number" name="minPrice"  /> 
		Max. Price:<input type="number" name="maxPrice" /> <br/><br/>
		Number Of Stops: <input type="number" name="numStops" value=/> <br/><br/>
		Earliest Departure Time:<input type="time" name="minDeparture" /> 
		Latest Departure Time:<input type="time" name="maxDeparture" /> <br/><br/>
		Earliest Arrival Time:<input type="time" name="minArrival" /> 
		Latest Arrival Time:<input type="time" name="maxArrival" /> <br/><br/>
		Airline (two Letter Airline ID): <input type="text" size= "2" minLength="2" maxLength="2" name="airline" /> <br/><br/>
			
	<input type="submit" value="Filter" style="height:30px; width:70px"/>
</form>
<form method="post" action="customerCreateReserve.jsp">
	# of Flights: <input type="number" required name="custCreateNumFlights" value="1"/>		
  <input type="hidden" name="customerMakeUser" value=<%=username%>>
    <input type="submit" value="Make Flight Reservations" />
</form>
<form method="post" action="customerEditReserve.jsp">
	Ticket #: <input type="number" required name="custEditTicketNum"/>		
  <input type="hidden" name="customerEditUser" value=<%=username%>>
  <input type="submit" value="Edit Flight Reservation" />
</form>
<form method="post" action="viewPastReservations.jsp">
  <input type="submit" value="View Past Flight Reservations" />
</form>
<form method="post" action="viewUpcomingReservations.jsp">
  <input type="submit" value="View Upcoming Flight Reservations" />
</form>		
<form method="post" action="customerQuestionHome.jsp">
  <input type="submit" value="View Questions" />
</form>	


</body>
</html>

<%
		out.println("<a href='logout.jsp'>Log out</a>");
    }
%>
