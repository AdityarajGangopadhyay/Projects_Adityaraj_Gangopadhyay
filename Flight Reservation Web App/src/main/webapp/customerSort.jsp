<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%
ApplicationDB db = new ApplicationDB();	
Connection con = db.getConnection();
String query = "select * from operates_flight ";
switch(request.getParameter("sort")){
	case "price":
		query += "order by firstClassPrice ";
		break;
	case "take_off_time":
		query += "order by departure_time ";
		break;
	case "landing_time":
		query += "order by arrival_time ";
		break;
	case "duration":
		query += "order by TIMESTAMPDIFF(SECOND, departure_time, arrival_time) ";
		break;
	default:
		break;
}
query += request.getParameter("sortOrder");
PreparedStatement psSort = con.prepareStatement(query);
ResultSet rsSort = psSort.executeQuery();
ResultSetMetaData rsmdSort = rsSort.getMetaData();
int rowCount = 0;
out.println("<P><TABLE BORDER=1>");
int columnCount = rsmdSort.getColumnCount();
// table header
out.println("<TR>");
for (int i = 0; i < columnCount; i++) {
  out.println("<TH>" + rsmdSort.getColumnLabel(i + 1) + "</TH>");
}
out.println("</TR>");
// the data
while (rsSort.next()) {
	rowCount++;
  	out.println("<TR>");
  	for (int i = 0; i < columnCount; i++) {
    	out.println("<TD>" + rsSort.getString(i + 1) + "</TD>");
    }
  	out.println("</TR>");
 }
 out.println("</TABLE></P>");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Sort Flights</title>
</head>
<body>

</body>
</html>
<%
out.println("<br/><a href='customerHome.jsp'>Go Back Home</a>");
%>