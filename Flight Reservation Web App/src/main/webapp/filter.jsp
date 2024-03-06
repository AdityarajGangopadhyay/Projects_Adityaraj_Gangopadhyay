<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%

int minPrice=0; int maxPrice=100000; int numStops=0; String minArrival=""; String maxArrival=""; String minDeparture=""; String maxDeparture=""; String airline="";

ApplicationDB db = new ApplicationDB();	
Connection con = db.getConnection();
String query = "select * from operates_flight where ";
try{
	int arr[] = new int[8]; //each index corresponds to each param in the order below, if 1 use param, if 0 don't use param
	int count = 0;
	String tmp = request.getParameter("minPrice");
	if (!tmp.isEmpty()){
		minPrice = Integer.parseInt(tmp);
		arr[0] = 1;
		query += "firstClassPrice >= ?";
		count++;
	}

	tmp = request.getParameter("maxPrice");
	if (!tmp.isEmpty()){
		maxPrice = Integer.parseInt(tmp);
		arr[1] = 1;
		if (count!=0){
			query += " AND firstClassPrice <= ?";
		} else {
			query += "firstClassPrice <= ?";
		}
		
		count++;
	}

	tmp = request.getParameter("numStops");
	if (!tmp.isEmpty()){
		numStops = Integer.parseInt(tmp);
		arr[2] = 1;
		if (count!=0){
			query += " AND numberOfStops = ?";
		} else {
			query += "numberOfStops = ?";
		}
		count++;
	}

	tmp = request.getParameter("minArrival");
	if (!tmp.isEmpty()){
		minArrival = tmp;
		arr[3] = 1;
		if (count!=0){
			query += " AND cast(arrival_time as time) >= ?";
		} else {
			query += "cast(arrival_time as time) >= ?";
		}
		
		count++;
	}

	tmp = request.getParameter("maxArrival");
	if (!tmp.isEmpty()){
		maxArrival = tmp;
		arr[4] = 1;
		if (count!=0){
			query += " AND cast(arrival_time as time) <= ?";
		} else {
			query += "cast(arrival_time as time) <= ?";
		}
		
		count++;
	}

	tmp = request.getParameter("minDeparture");
	if (!tmp.isEmpty()){
		minDeparture = tmp;
		arr[5] = 1;
		if (count!=0){
			query += " AND cast(departure_time as time) >= ?";
		} else {
			query += "cast(departure_time as time) >= ?";
		}
		
		count++;
	}

	tmp = request.getParameter("maxDeparture");
	if (!tmp.isEmpty()){
		maxDeparture = tmp;
		arr[6] = 1;
		if (count!=0){
			query += " AND cast(departure_time as time) <= ?";
		} else {
			query += "cast(departure_time as time) <= ?";
		}
		
		count++;
	}

	tmp = request.getParameter("airline");
	if (!tmp.isEmpty()){
		airline = tmp;
		arr[7] = 1;
		if (count!=0){
			query += " AND airlineID = ?";
		} else {
			query += "airlineID = ?";
		}
		
		count++;
	}

	PreparedStatement ps = con.prepareStatement(query);
	int index = 1;
	if(arr[0] == 1){
		ps.setInt(index, minPrice);
		index++;
	}
	if(arr[1] == 1){
		ps.setInt(index, maxPrice);
		index++;
	}
	if(arr[2] == 1){
		ps.setInt(index, numStops);
		index++;
	}
	if(arr[3] == 1){
		ps.setString(index, minArrival+=":00");
		index++;
	}

	if(arr[4] == 1){
		ps.setString(index, maxArrival+=":00");
		index++;
	}

	if(arr[5] == 1){
		ps.setString(index, minDeparture+=":00");
		index++;
	}

	if(arr[6] == 1){
		ps.setString(index, maxDeparture+=":00");
		index++;
	}

	if(arr[7] == 1){
		ps.setString(index, airline);
		index++;
	}

	ResultSet rs = ps.executeQuery();
	ResultSetMetaData rsmd = rs.getMetaData();
	int rowCount = 0;

	out.println("<P><TABLE BORDER=1>");
	int columnCount = rsmd.getColumnCount();
	// table header
	out.println("<TR>");
	for (int i = 0; i < columnCount; i++) {
	  out.println("<TH>" + rsmd.getColumnLabel(i + 1) + "</TH>");
	}
	out.println("</TR>");
	// the data
	while (rs.next()) {
		rowCount++;
	  	out.println("<TR>");
	  	for (int i = 0; i < columnCount; i++) {
	    	out.println("<TD>" + rs.getString(i + 1) + "</TD>");
	    }
	  	out.println("</TR>");
	 }
	 out.println("</TABLE></P>");
}catch(Exception e){
	out.println("You did not put any filters, try again");
}

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Filter Flights</title>
</head>
<body>

</body>
</html>
<%
out.println("<br/><a href='customerHome.jsp'>Go Back Home</a>");
%>