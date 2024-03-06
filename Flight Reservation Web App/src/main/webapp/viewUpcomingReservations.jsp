<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>


<html>
	<body>
		<p>Upcoming Reservations</p>
	</body>
</html>


<%
	
	ApplicationDB db = new ApplicationDB();	
	Connection con = db.getConnection();
	
	String username = (String)session.getAttribute("user");
	
	PreparedStatement ps2 = con.prepareStatement("select flightNumber, airlineID, seatNum, departure_time from ticketstatus where username = ? AND departure_time >= NOW() and seatNum != -1"); 
	ps2.setString(1, username);
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
		out.println("<br/><a href='customerHome.jsp'>Go Back Home</a>");

%>