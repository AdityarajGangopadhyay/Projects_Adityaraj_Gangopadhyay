<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<%
    if (session.getAttribute("user") == null || !"rep".equals(session.getAttribute("type"))) {
         out.println("Unauthorized Access.<br/>");
         out.println("<a href='login.jsp'>Please Login</a>");
    } else {
    	out.println("Modify Aircrafts<br/>");
        out.println("<a href='repHome.jsp'>Back</a>");
%>


<html>
<head>
    <title>Modify Aircrafts</title>
</head>
<body>
<%
    try {
        ApplicationDB db = new ApplicationDB();    
        Connection con = db.getConnection();       
        String sql = "SELECT * FROM owns_aircraft";
        PreparedStatement pstmt = con.prepareStatement(sql);
        ResultSet result = pstmt.executeQuery();
%>
    
    <table style="width: 100%; border-collapse: collapse; margin-top: 20px;">
        <tr>
        	<th style="background-color: #f2f2f2; border: 1px solid #dddddd; text-align: left; padding: 8px;">Airline Owned By</th>
            <th style="background-color: #f2f2f2; border: 1px solid #dddddd; text-align: left; padding: 8px;">Aircraft ID</th>
            <th style="background-color: #f2f2f2; border: 1px solid #dddddd; text-align: left; padding: 8px;">Number of seats</th>
        </tr>
        <% while (result.next()) { %>
            <tr>
            	<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= result.getString("airlineID") %></td>
                <td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= result.getString("aircraftID") %></td>
                <td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= result.getString("seats") %></td>
            </tr>
            
            
            
            
        <% }
        db.closeConnection(con);
        %>
        
        
    </table>
    
    <%  } catch (Exception e) {
            out.print("Error: " + e);
        }%>
    <br>

    Add an aircraft:
    	<br>
        <form method="post" action="repModifyAircraftsAdd.jsp">
			Airline ID: <input type="text" name="airlineID" required/> <br/>
			Aircraft ID: <input type="text" name="aircraftID" required/> <br/>
			Number of Seats: <input type="text" name="seats" required/> 
			<input type="submit" value="Submit"/>
		</form>
    Edit an aircraft:
        <form method="post" action="repModifyAircraftsEdit.jsp">
        	Aircraft ID to edit: <input type="text" name="aircraftID" required/> <br/>
			New Airline ID: <input type="text" name="airlineID"/> <br/>
			New Aircraft ID: <input type="text" name="newAircraftID"/> <br/>
			New Number of Seats: <input type="text" name="seats"/> 
			<input type="submit" value="Submit"/>
		</form>
    Delete an aircraft:
        <form method="post" action="repModifyAircraftsDelete.jsp">
			Aircraft ID: <input type="text" name="aircraftID" required/> <br/>
			<input type="submit" value="Submit"/>
		</form>
    	<br>
   
</body>
</html>

<%
    }
%>

