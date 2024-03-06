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
    	out.println("Flight Edit Confirmation<br/>");
        
%>

<html>
<head>
<title>Flight Edit Confirmation</title>
</head>
<body>
	<%
	String flightNumber = request.getParameter("flightNumber");
	String airlineID = request.getParameter("airlineID").toUpperCase();
	String departureTime = request.getParameter("departureTime");
	//String newFlightNumber = request.getParameter("newFlightNumber");
	//String departingFrom = request.getParameter("departingFrom").toUpperCase();
	//String arrivingTo = request.getParameter("arrivingTo").toUpperCase();
	String type = request.getParameter("type");
	String arrivalTime = request.getParameter("arrivalTime");
	//String aircraftID = request.getParameter("aircraftID");
	String numberOfStops = request.getParameter("numberOfStops");
	String economyPrice = request.getParameter("economyPrice");
	String businessPrice = request.getParameter("businessPrice");
	String firstClassPrice = request.getParameter("firstClassPrice");
	//String newAirlineID = request.getParameter("newAirlineID");
	String newDepartureTime = request.getParameter("newDepartureTime");
	
	String isDomesticValue;
	if (type != null && type.trim().equalsIgnoreCase("yes")) {
	    isDomesticValue = "1";
	} else {
	    isDomesticValue = "0";
	}
	
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	

	
    if (flightNumber != null && !flightNumber.trim().isEmpty() 
    		&&  (airlineID != null && !airlineID.trim().isEmpty()) 
    		&& (departureTime != null && !departureTime.trim().isEmpty()) &&
    	    (   
    	        (type != null && !type.trim().isEmpty()) ||
    	        (newDepartureTime != null && !newDepartureTime.trim().isEmpty()) ||
    	        (arrivalTime != null && !arrivalTime.trim().isEmpty()) ||
    	        (numberOfStops != null && !numberOfStops.trim().isEmpty()) ||
    	        (economyPrice != null && !economyPrice.trim().isEmpty()) ||
    	        (businessPrice != null && !businessPrice.trim().isEmpty()) ||
    	        (firstClassPrice != null && !firstClassPrice.trim().isEmpty())
    	    )
    	) {
        try {
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();
            
            String checkFlightQuery = "SELECT COUNT(*) FROM operates_flight WHERE flight_number = ? AND airlineID = ? AND departure_time = ?";
            PreparedStatement checkFlightStmt = con.prepareStatement(checkFlightQuery);
            checkFlightStmt.setString(1, flightNumber);
            checkFlightStmt.setString(2, airlineID);
            checkFlightStmt.setString(3, departureTime);
            ResultSet checkFlightResult = checkFlightStmt.executeQuery();
            checkFlightResult.next();
            int flightCount = checkFlightResult.getInt(1);

            if (flightCount == 0) {
                out.print("Error: Flight with flight number " + flightNumber + ", airlineID " + airlineID + ", and departure time " + departureTime + " does not exist.");
                out.println("<br/><a href='repModifyFlights.jsp'>Back</a>");
                return;
            }
                
                
                if (airlineID != null && !airlineID.trim().isEmpty()) {
	                String checkAirlineQuery = "SELECT COUNT(*) FROM airline WHERE airlineID = ?";
	                PreparedStatement checkAirlineStmt = con.prepareStatement(checkAirlineQuery);
	                checkAirlineStmt.setString(1, airlineID);
	                ResultSet checkAirlineResult = checkAirlineStmt.executeQuery();
	                checkAirlineResult.next();
	                int airlineCount = checkAirlineResult.getInt(1);
	                if (airlineCount == 0) {
	                    out.print("Error: Airline with ID " + airlineID + " does not exist.");
	                    out.println("<br/><a href='repModifyFlights.jsp'>Back</a>");
	                    return;
	                }
                }
                
                
                if (newDepartureTime != null && !newDepartureTime.trim().isEmpty()
                    	&& arrivalTime != null && !arrivalTime.trim().isEmpty()) {

    	                Date departureDate = sdf.parse(departureTime);
    	                Date arrivalDate = sdf.parse(arrivalTime);
    	                
    	                if (!arrivalDate.after(departureDate)) {
    	                    out.println("Error: Arrival time must be after departure time.");
    	                    out.println("<br/><a href='repModifyFlights.jsp'>Back</a>");
    	                    return;
    	                }
    	                
    	                
                } else if (newDepartureTime != null && !newDepartureTime.trim().isEmpty()) {
                    Date departureDate = sdf.parse(newDepartureTime);

                    String getOldArrivalTimeQuery = "SELECT arrival_time FROM operates_flight WHERE flight_number = ? AND airlineID = ? AND departure_time = ?";
                    PreparedStatement getOldArrivalTimeStmt = con.prepareStatement(getOldArrivalTimeQuery);
                    getOldArrivalTimeStmt.setString(1, flightNumber);
                    getOldArrivalTimeStmt.setString(2, airlineID);
                    getOldArrivalTimeStmt.setString(3, departureTime);
                    ResultSet oldArrivalTimeResult = getOldArrivalTimeStmt.executeQuery();

                    if (oldArrivalTimeResult.next()) {
                        String oldArrivalTime = oldArrivalTimeResult.getString("arrival_time");
                        Date oldArrivalDate = sdf.parse(oldArrivalTime);

                        if (!oldArrivalDate.after(departureDate)) {
                            out.println("Error: Arrival time must be after new departure time.");
                            out.println("<br/><a href='repModifyFlights.jsp'>Back</a>");
                            return;
                        }
                    }
               
	                
	               
                } else if (arrivalTime != null && !arrivalTime.trim().isEmpty()) {
	                Date arrivalDate = sdf.parse(arrivalTime);
                    Date departureDate = sdf.parse(departureTime);

	                
	                if (!arrivalDate.after(departureDate)) {
	                    out.println("Error: New arrival time must be after departure time.");
	                    out.println("<br/><a href='repModifyFlights.jsp'>Back</a>");
	                    return;
	                }
	               
                }
                
               
                
               
	

                
                
                
                String updateFlightsQuery = "UPDATE operates_flight SET ";
                boolean hasFlightsUpdateFields = false;


                if (type != null && !type.trim().isEmpty()) {
                	if (hasFlightsUpdateFields) {
                    	updateFlightsQuery += ", ";
                    }
                    updateFlightsQuery += "isDomestic = ?";
                    hasFlightsUpdateFields = true;
                }
                
                if (newDepartureTime != null && !newDepartureTime.trim().isEmpty()) {
                	if (hasFlightsUpdateFields) {
                    	updateFlightsQuery += ", ";
                    }
                    updateFlightsQuery += "departure_time = ?";
                    hasFlightsUpdateFields = true;
                }
                
                
                if (arrivalTime != null && !arrivalTime.trim().isEmpty()) {
                	if (hasFlightsUpdateFields) {
                    	updateFlightsQuery += ", ";
                    }
                    updateFlightsQuery += "arrival_time = ?";
                    hasFlightsUpdateFields = true;
                }

                
                if (numberOfStops != null && !numberOfStops.trim().isEmpty()) {
                	if (hasFlightsUpdateFields) {
                    	updateFlightsQuery += ", ";
                    }
                    updateFlightsQuery += "numberOfStops = ?";
                    hasFlightsUpdateFields = true;
                }
                
                if (economyPrice != null && !economyPrice.trim().isEmpty()) {
                	if (hasFlightsUpdateFields) {
                    	updateFlightsQuery += ", ";
                    }
                    updateFlightsQuery += "economyPrice = ?";
                    hasFlightsUpdateFields = true;
                }
                
                if (businessPrice != null && !businessPrice.trim().isEmpty()) {
                	if (hasFlightsUpdateFields) {
                    	updateFlightsQuery += ", ";
                    }
                    updateFlightsQuery += "businessPrice = ?";
                    hasFlightsUpdateFields = true;
                }
                
                
                if (firstClassPrice != null && !firstClassPrice.trim().isEmpty()) {
                	if (hasFlightsUpdateFields) {
                    	updateFlightsQuery += ", ";
                    }
                    updateFlightsQuery += "firstClassPrice = ?";
                    hasFlightsUpdateFields = true;
                }
                
                
                
                updateFlightsQuery += " WHERE flight_number = ? AND airlineID = ? AND departure_time = ?";


                PreparedStatement updateFlightStmt = con.prepareStatement(updateFlightsQuery);
                int parameterIndex = 1;

                if (type != null && !type.trim().isEmpty()) {
                	updateFlightStmt.setString(parameterIndex++, isDomesticValue);
                }
                
                if (newDepartureTime != null && !newDepartureTime.trim().isEmpty()) {
                	updateFlightStmt.setString(parameterIndex++, newDepartureTime);
                }
                
                
                if (arrivalTime != null && !arrivalTime.trim().isEmpty()) {
                	updateFlightStmt.setString(parameterIndex++, arrivalTime);
                }
                
                if (numberOfStops != null && !numberOfStops.trim().isEmpty()) {
                	updateFlightStmt.setString(parameterIndex++, numberOfStops);
                }
                
                if (economyPrice != null && !economyPrice.trim().isEmpty()) {
                	updateFlightStmt.setString(parameterIndex++, economyPrice);
                }
                
                if (businessPrice != null && !businessPrice.trim().isEmpty()) {
                	updateFlightStmt.setString(parameterIndex++, businessPrice);
                }
                
                if (firstClassPrice != null && !firstClassPrice.trim().isEmpty()) {
                	updateFlightStmt.setString(parameterIndex++, firstClassPrice);
                }
                
                updateFlightStmt.setString(parameterIndex++, flightNumber);
                updateFlightStmt.setString(parameterIndex++, airlineID);
                updateFlightStmt.setString(parameterIndex, departureTime);




                int rowsAffected = updateFlightStmt.executeUpdate();

                if (rowsAffected > 0) {
                    out.print("Flight " + flightNumber + " updated successfully.");
                } else {
                    out.print("Error: Unable to update flight " + flightNumber);
                }

            
            db.closeConnection(con);

        } catch (SQLException e) {
            out.println("Error: " + e.getMessage());
        }
    } else {
        out.println("Error: Missing or empty values");
    }
%>

</body>
</html>

<%
out.println("<br/><a href='repModifyFlights.jsp'>Back</a>");
    }
%>
