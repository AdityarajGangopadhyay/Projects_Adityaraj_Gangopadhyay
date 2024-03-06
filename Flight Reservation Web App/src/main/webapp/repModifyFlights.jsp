<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>

<%
    if (session.getAttribute("user") == null || !"rep".equals(session.getAttribute("type"))) {
         out.println("Unauthorized Access.<br/>");
         out.println("<a href='login.jsp'>Please Login</a>");
    } else {
    	out.println("Modify Flights<br/>");
        out.println("<a href='repHome.jsp'>Back</a>");
%>


<html>
<head>
    <title>Modify Flights</title>
</head>
<body>
<%
    try {
        ApplicationDB db = new ApplicationDB();    
        Connection con = db.getConnection();      
        
        String combinedSql = "SELECT f.*, df.departing_airportID AS departing_airport, at.arriving_airportID AS arriving_airport, fo.airlineID AS flown_airline, fo.aircraftID " +
                "FROM operates_flight f " +
                "LEFT JOIN departing_from df ON f.flight_number = df.flight_number " +
                "AND f.airlineID = df.airlineID " +
                "AND f.departure_time = df.departure_time " +
                "LEFT JOIN arriving_to at ON f.flight_number = at.flight_number " +
                "AND f.airlineID = at.airlineID " +
                "AND f.departure_time = at.departure_time " +
                "LEFT JOIN flown_on fo ON f.flight_number = fo.flight_number " +
                "AND f.airlineID = fo.airlineID " +
                "AND f.departure_time = fo.departure_time " +
                "LEFT JOIN flight_days fd ON f.flight_number = fd.flight_number " +
                "AND f.airlineID = fd.airlineID " +
                "AND f.departure_time = fd.departure_time";
        
        PreparedStatement combinedStmt = con.prepareStatement(combinedSql);
        ResultSet combinedResult = combinedStmt.executeQuery();
        
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");


%>
    
    <table style="width: 100%; border-collapse: collapse; margin-top: 20px;">
        <tr>
        	<th style="background-color: #f2f2f2; border: 1px solid #dddddd; text-align: left; padding: 4px;">Airline</th>
            <th style="background-color: #f2f2f2; border: 1px solid #dddddd; text-align: left; padding: 4px;">Flight Number</th>
            <th style="background-color: #f2f2f2; border: 1px solid #dddddd; text-align: left; padding: 4px;">Departing From</th>
            <th style="background-color: #f2f2f2; border: 1px solid #dddddd; text-align: left; padding: 4px;">Arriving To</th>
            <th style="background-color: #f2f2f2; border: 1px solid #dddddd; text-align: left; padding: 4px;">Aircraft ID</th>
            <th style="background-color: #f2f2f2; border: 1px solid #dddddd; text-align: left; padding: 4px;">Domestic?</th>
            <th style="background-color: #f2f2f2; border: 1px solid #dddddd; text-align: left; padding: 4px;">Departure Time</th>
            <th style="background-color: #f2f2f2; border: 1px solid #dddddd; text-align: left; padding: 4px;">Arrival Time</th>
            <th style="background-color: #f2f2f2; border: 1px solid #dddddd; text-align: left; padding: 4px;">Number of Stops</th>
            <th style="background-color: #f2f2f2; border: 1px solid #dddddd; text-align: left; padding: 4px;">Economy Price</th>
            <th style="background-color: #f2f2f2; border: 1px solid #dddddd; text-align: left; padding: 4px;">Business Price</th>
            <th style="background-color: #f2f2f2; border: 1px solid #dddddd; text-align: left; padding: 4px;">First Class Price</th>
            
            
            
            
        </tr>
        <% while (combinedResult.next()) { 
        
          Date departureDate = sdf.parse(combinedResult.getString("departure_time"));
  		  Date arrivalDate = sdf.parse(combinedResult.getString("arrival_time"));%>
            <tr>
            	  <td style="border: 1px solid #dddddd; text-align: left; padding: 4px;"><%= combinedResult.getString("airlineID") %></td>
                <td style="border: 1px solid #dddddd; text-align: left; padding: 4px;"><%= combinedResult.getString("flight_number") %></td>
                <td style="border: 1px solid #dddddd; text-align: left; padding: 4px;"><%= combinedResult.getString("departing_airport") %></td>
                <td style="border: 1px solid #dddddd; text-align: left; padding: 4px;"><%= combinedResult.getString("arriving_airport") %></td>
                <td style="border: 1px solid #dddddd; text-align: left; padding: 4px;"><%= combinedResult.getString("aircraftID") %></td>

                 <td style="border: 1px solid #dddddd; text-align: left; padding: 4px;"> <% 
                    String isDomesticValue = combinedResult.getString("isDomestic");
                    if (isDomesticValue != null && isDomesticValue.equals("1")) {
                        out.print("Yes");
                    } else {
                        out.print("No");
                    }
                %></td>
				<td style="border: 1px solid #dddddd; text-align: left; padding: 4px;"><%= sdf.format(departureDate) %></td>
				<td style="border: 1px solid #dddddd; text-align: left; padding: 4px;"><%= sdf.format(arrivalDate) %></td>
                <td style="border: 1px solid #dddddd; text-align: left; padding: 4px;"><%= combinedResult.getString("numberOfStops") %></td>
                <td style="border: 1px solid #dddddd; text-align: left; padding: 4px;"><%= combinedResult.getString("economyPrice") %></td>
                <td style="border: 1px solid #dddddd; text-align: left; padding: 4px;"><%= combinedResult.getString("businessPrice") %></td>
                <td style="border: 1px solid #dddddd; text-align: left; padding: 4px;"><%= combinedResult.getString("firstClassPrice") %></td>
            </tr>
            
            
            
        <% }
        db.closeConnection(con);
        %>
        
        
    </table>
    
    <%  } catch (Exception e) {
            out.print("Error: " + e);
        }%>
    <br>

    Add a flight:
    	<br>
		<form method="post" action="repModifyFlightsAdd.jsp">
		    Airline ID: <input type="text" name="airlineID" required/><br/>
		    Flight Number: <input type="text" name="flightNumber" required/><br/>
		    Departing From: <input type="text" name="departingFrom" required/><br/>
		    Aircraft ID: <input type="text" name="aircraftID" required/><br/>
		    Arriving To: <input type="text" name="arrivingTo" required/><br/>
		    Domestic?:
		    <select name="type" required>
		        <option value="">Select Type*</option>
		        <option value="yes">Yes</option>
		        <option value="no">No</option>
		    </select><br/>
		    Departure Time: <input type="text" name="departureTime" required/> (Format: 'YYYY-MM-DD hh:mm:ss')<br/>
		    Arrival Time: <input type="text" name="arrivalTime" required/>(Format: 'YYYY-MM-DD hh:mm:ss')<br/>
		    Number of Stops: <input type="text" name="numberOfStops" required/><br/>
		    Economy Price: <input type="text" name="economyPrice" required/><br/>
		    Business Price: <input type="text" name="businessPrice" required/><br/>
		    First Class Price: <input type="text" name="firstClassPrice" required/><br/>
		    <input type="submit" value="Submit"/>
		</form>

    Edit a flight:
        <form method="post" action="repModifyFlightsEdit.jsp">
            Airline ID to edit: <input type="text" name="airlineID" required/> 
        	Flight Number to edit: <input type="text" name="flightNumber" required/> 
        	Departure Time to edit: <input type="text" name="departureTime" required/> <br/>
		    New Domestic?:
		    <select name="type" >
		        <option value="">Select Type*</option>
		        <option value="yes">Yes</option>
		        <option value="no">No</option>
		    </select><br/>
		    New Departure Time: <input type="text" name="newDepartureTime" />(Format: 'YYYY-MM-DD hh:mm:ss')<br/>
		    New Arrival Time: <input type="text" name="arrivalTime" />(Format: 'YYYY-MM-DD hh:mm:ss')<br/>
		    New Number of Stops: <input type="text" name="numberOfStops" /><br/>
		    New Economy Price: <input type="text" name="economyPrice" /><br/>
		    New Business Price: <input type="text" name="businessPrice" /><br/>
		    New First Class Price: <input type="text" name="firstClassPrice" /><br/>
			<input type="submit" value="Submit"/>
		</form>
    Delete a flight:
        <form method="post" action="repModifyFlightsDelete.jsp">
			Flight Number: <input type="text" name="flightNumber" required/> <br/>
			<input type="submit" value="Submit"/>
		</form>
    	<br>
   
</body>
</html>

<%
    }
%>

