<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%
	ApplicationDB db = new ApplicationDB();	
	Connection con = db.getConnection();
	PreparedStatement ps = con.prepareStatement("select * from buys where username=? and ticketNum = ?");
	String username = request.getParameter("repEditCustomerUsername");
	String ticketNumber = request.getParameter("repEditTicketNumber");
	ps.setString(1, username);
	ps.setString(2, ticketNumber);
	ResultSet rs = ps.executeQuery();
	if (rs.next() == false) {
		out.println("Invalid Username/TicketNumber, please try again");
	}else{
		PreparedStatement psTicketData = con.prepareStatement("select * from includes where ticketNum = ?");
		psTicketData.setString(1, ticketNumber);
		ResultSet rsTicketData = psTicketData.executeQuery();
		ResultSetMetaData rsmd2 = rsTicketData.getMetaData();
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
		while (rsTicketData.next()) {
			rowCount++;
		  	out.println("<TR>");
		  	for (int i = 0; i < columnCount; i++) {
		    	out.println("<TD>" + rsTicketData.getString(i + 1) + "</TD>");
		    }
		  	out.println("</TR>");
		 }
		 out.println("</TABLE></P>");

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit Flight Reservation</title>
</head>
<body>
	<form method="post" action="repSuccess.jsp">
	 		<label for="repEditReserveClass">Change Flight Class:</label>
	 		<select name="repEditReserveClass" id="repEditReserveClass">
	 			 <option>None</option>
	 		<%
			PreparedStatement psFlights = con.prepareStatement("select * from includes where ticketNum = ?");
			psFlights.setString(1, ticketNumber);
			ResultSet rsFlights = psFlights.executeQuery();
			if (rsFlights.next() == false) {
				%>
					<option>No Flights Available</option>
					<%
			}else{
				do{
						%>
						<option><%=rsFlights.getString("airlineID") + rsFlights.getString("flight_number") + "=" + rsFlights.getString("departure_time") + "=#" + rsFlights.getString("seatNum")%></option>
						<%
					}while(rsFlights.next());
			}
			%>
	 		</select>
	 		<select name="repEditClass" id="repEditClass">
			    <option value="economy">Economy</option>
			    <option value="business">Business</option>
			    <option value="first">First</option>
		  	</select>
		  	<br>
		  	<label for="repRemoveReserveClass">Remove Flight:</label>
		  	<select name="repRemoveReserveClass" id="repRemoveReserveClass">
	 			<option>None</option>
		 		<%
				PreparedStatement psRFlights = con.prepareStatement("select * from includes where ticketNum = ?");
				psRFlights.setString(1, ticketNumber);
				ResultSet rsRFlights = psRFlights.executeQuery();
				if (rsRFlights.next() == false) {
					%>
						<option>No Flights Available</option>
						<%
				}else{
					do{
							%>
							<option><%=rsRFlights.getString("airlineID") + rsRFlights.getString("flight_number") + "=" + rsRFlights.getString("departure_time") + "=#" + rsRFlights.getString("seatNum")%></option>
							<%
						}while(rsRFlights.next());
				}
				%>
	 		</select>
		  	<br>
		<input type="hidden" name="repEditTicketNum" value=<%=ticketNumber%>>
		<input type="hidden" name="repEditUsername" value=<%=username%>>
       	<input type="hidden" name="repSubmitType" value="repEditReserve">
       	<label for="repDeleteTicket">Delete Reservation/Ticket:</label>
       	<select name="repDeleteTicket" id="repDeleteTicket">
			<option value="no">No</option>
			<option value="yes">Yes</option>
		</select>
		<br>
       	NOTE: REMOVING A FLIGHT WILL OVERRIDE CHANGING ITS CLASS 
       	<br>
        <input type="submit" value="Edit Ticket" />
    </form> 
</body>
</html>
<%			
  
    }
	out.println("<br/><a href='repHome.jsp'>Go Back</a>");
	
%>
