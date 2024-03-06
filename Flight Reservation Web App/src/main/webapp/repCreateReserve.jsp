<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<%
	if(request.getParameter("repCreateCustomerID") == "" || request.getParameter("repCreateCustomerID") == null) {
	    out.println("No CustomerID inputted, try again.<br/>");
	}else{
		int customerID = Integer.parseInt(request.getParameter("repCreateCustomerID"));
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		PreparedStatement ps = con.prepareStatement("select * from users where userID=?");
		ps.setInt(1, customerID);
		ResultSet rs = ps.executeQuery();
		if (rs.next()) {
			String userID = rs.getString("userID");
			session.setAttribute("repCreateCustomerID", userID);
			//Getting all flights
 			PreparedStatement ps2 = con.prepareStatement("select o.airlineID, o.flight_number, o.departure_time, o.arrival_time, "
			+ "d.departing_airportID, a.arriving_airportID, o.firstClassPrice, o.businessPrice, o.economyPrice, o.numberOfStops from operates_flight o, arriving_to a, "
				+ "departing_from d where o.flight_number = a.flight_number and o.airlineID = a.airlineID and o.departure_time = a.departure_time and " +
				"o.flight_number = d.flight_number and o.airlineID = d.airlineID and o.departure_time = d.departure_time"); 
/* 			PreparedStatement ps2 = con.prepareStatement("select o.airlineID, o.flight_number, o.isDomestic, " + 
					"o.departure_time, o.arrival_time from operates_flight o"); */
			ResultSet rs2 = ps2.executeQuery();
			ResultSetMetaData rsmd2 = rs2.getMetaData();
			int numFlights = Integer.parseInt(request.getParameter("repCreateNumFlights"));

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Create Reservation</title>
</head>
<body>
<br>
All Flights (Selected a fully booked flight will automatically put you on the waiting list):
<br>
<%
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
<table>
  <tr>
    <th>Description</th>
    <th>Cost</th>
  </tr>
   <tr>
    <td>Booking Fee</td>
    <td>$10</td>
  </tr> 
     <tr>
    <td>Cancellation Fee if Economy</td>
    <td>$10</td>
  </tr>
</table>
<br>
	<form method="post" action="repSuccess.jsp">
		<%PreparedStatement psFlights = con.prepareStatement("select o.airlineID, o.flight_number, o.departure_time from operates_flight o, arriving_to a, "
					+ "departing_from d where o.flight_number = a.flight_number and o.airlineID = a.airlineID and o.departure_time = a.departure_time and" +
					" o.flight_number = d.flight_number and o.airlineID = d.airlineID and o.departure_time = d.departure_time");
		for(int i = 1; i <= numFlights; i++){ %>
	 		<label for="repBuyReserveFlight<%=i%>">Reserve Flight <%=i%>:</label>
	 		<select name="repBuyReserveFlight<%=i%>" id="repBuyReserveFlight">
	 		<%	
				ResultSet rsFlights = psFlights.executeQuery();
				if (rsFlights.next() == false) {
					%>
	 				<option>No Flights Available</option>
	 				<%
				}else{
					do{
		 				%>
		 				<option><%=rsFlights.getString("airlineID") + rsFlights.getString("flight_number") + "=" + rsFlights.getString("departure_time")%></option>
		 				<%
		 			}while(rsFlights.next());
				}
				
	 		%>
	 		</select>
	 		<br>
		  	<label for="repBuyClass<%=i%>">Flight#<%=i%> Class:</label>
			<select name="repBuyClass<%=i%>" id="repBuyClass<%=i%>">
			    <option value="economy">Economy</option>
			    <option value="business">Business</option>
			    <option value="first">First</option>
		  	</select>
		  	<br>
		  	<br>
	  	<%}%>
	  	
	  	<br>     
	  	Seats are given based on availability. If no seats available, then you will be placed in to waiting list
	  	<br>
	  	<input type="hidden" name="numFlightsBuy" value=<%=numFlights%>>
	  	<input type="hidden" name="flightsBuyUserID" value=<%=customerID%>>
       	<input type="hidden" name="repSubmitType" value="repBuyReserve">
        <input type="submit" value="Buy Ticket" />
    </form>
</body>
</html>

<%			
		} else {
			out.println("Invalid CustomerID, try again.<br/>");
		}     
    }
	out.println("<br/><a href='repHome.jsp'>Go Back</a>");

%>