<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<%
    if(session.getAttribute("user") == null || !"rep".equals(session.getAttribute("type"))) {
        out.println("Unauthorized Access.<br/>");
        out.println("<a href='login.jsp'>Please Login</a>");
    }else{
   		out.println("Customer Representative Home" + "<br/>");
    	out.println("Welcome to RU Flight, " + session.getAttribute("user") + "<br/>");
        
%>

<html>
<head>
<title>Customer Representative Home</title>
</head>
<body>
<%
	ApplicationDB db = new ApplicationDB();	
	Connection con = db.getConnection();
	PreparedStatement ps2 = con.prepareStatement("select t.ticketNum, b.purchaseDateTime, b.Username, t.totalFare from buys b, ticket t where b.ticketNum = t.ticketNum"); 
	ResultSet rs2 = ps2.executeQuery();
	ResultSetMetaData rsmd2 = rs2.getMetaData();
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
    <form method="post" action="repCreateReserve.jsp">
        CustomerID: <input type="number" required name="repCreateCustomerID"/>
        # of Flights: <input type="number" required name="repCreateNumFlights" value="1"/>
        <input type="submit" value="Reserve Customer Flight" />
    </form>
    <form method="post" action="repEditReserve.jsp">
    	Username: <input type="text" required name="repEditCustomerUsername"/>
    	Ticket#: <input type="number" required name="repEditTicketNumber"/>
        <input type="submit" value="Edit Customer Flight" />
    </form>
    <form method="post" action="repQuestionHome.jsp">
        <input type="submit" value="View Questions" />
    </form>
    <form method="post" action="repModifyAircrafts.jsp">
        <input type="submit" value="Modify Aircrafts" />
    </form>
    <form method="post" action="repModifyAirports.jsp">
        <input type="submit" value="Modify Airports" />
    </form>
    <form method="post" action="repModifyFlights.jsp">
        <input type="submit" value="Modify Flights" />
    </form>
    <form method="post" action="repWaitingList.jsp">
        View Waiting List for a Flight: <br/>
        Airline ID: <input type="text" name="airlineID" required/> <br/>
        Flight Number: <input type="text" name="flightNumber" required/> <br/>
        Departure Time: <input type="text" name="departureTime" required/>(Format: 'YYYY-MM-DD hh:mm:ss') <br/>
        <input type="submit" value="Submit" />
    </form>
    <form method="post" action="repAirportFlights.jsp">
        View Departing and Arriving Flights for an Airport: <br/> 
        Airport ID: <input type="text" name="airportID"/> <br/> 
        <input type="submit" value="Submit" />
    </form>
</body>
</html>

<%
		out.println("<a href='logout.jsp'>Log out</a>" + "<br/>");
    }
%>
