<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%
ApplicationDB db = new ApplicationDB();	
Connection con = db.getConnection();
PreparedStatement ps = con.prepareStatement("select * from buys where username=? and ticketNum = ?");
String username = request.getParameter("customerEditUser");
String ticketNumber = request.getParameter("custEditTicketNum");
ps.setString(1, username);
ps.setString(2, ticketNumber);
ResultSet rs = ps.executeQuery();
if (rs.next() == false) {
	out.println("Invalid TicketNumber, please try again");
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
	<form method="post" action="customerSuccess.jsp">
	 		<label for="custEditReserveClass">Change Flight Class:</label>
	 		<select name="custEditReserveClass" id="custEditReserveClass">
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
	 		<select name="custEditClass" id="custEditClass">
			    <option value="economy">Economy</option>
			    <option value="business">Business</option>
			    <option value="first">First</option>
		  	</select>
		  	<br>
		  	<label for="custRemoveReserveClass">Remove Flight:</label>
		  	<select name="custRemoveReserveClass" id="repRemoveReserveClass">
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
		 <label for="custDeleteTicket">Delete Reservation/Ticket:</label>
       	<select name="custDeleteTicket" id="custDeleteTicket">
			<option value="no">No</option>
			<option value="yes">Yes</option>
		</select>
		<input type="hidden" name="custEditTicketNum" value=<%=ticketNumber%>>
		<input type="hidden" name="custEditUsername" value=<%=username%>>
       	<input type="hidden" name="custSubmitType" value="custEditReserve">
		<br>
       	NOTE: REMOVING A FLIGHT WILL OVERRIDE CHANGING ITS CLASS 
       	<br>
        <input type="submit" value="Edit Ticket" />
    </form> 
</body>
</html>
<%			
  
    }
	out.println("<br/><a href='customerHome.jsp'>Go Back</a>");
	
%>