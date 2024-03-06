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
    	out.println("Flight Add Confirmation<br/>");
        
%>


<html>
<head>
<title>Flight Add Confirmation</title>
</head>
<body>
	<%
	String airlineID = request.getParameter("airlineID").toUpperCase();
	String flightNumber = request.getParameter("flightNumber");
	String departingFrom = request.getParameter("departingFrom").toUpperCase();
	String arrivingTo = request.getParameter("arrivingTo").toUpperCase();
	String type = request.getParameter("type");
	String departureTime = request.getParameter("departureTime");
	String arrivalTime = request.getParameter("arrivalTime");
	String aircraftID = request.getParameter("aircraftID");
	String numberOfStops = request.getParameter("numberOfStops");
	String economyPrice = request.getParameter("economyPrice");
	String businessPrice = request.getParameter("businessPrice");
	String firstClassPrice = request.getParameter("firstClassPrice");



	
	String isDomesticValue;
	if (type != null && type.trim().equalsIgnoreCase("yes")) {
	    isDomesticValue = "1";
	} else {
	    isDomesticValue = "0";
	}



	if (airlineID != null && !airlineID.trim().isEmpty() 
		&& flightNumber != null && !flightNumber.trim().isEmpty()
		&& type != null && !type.trim().isEmpty()
		&& departureTime != null && !departureTime.trim().isEmpty()
		&& arrivalTime != null && !arrivalTime.trim().isEmpty()
		&& departingFrom != null && !departingFrom.trim().isEmpty()
		&& arrivingTo != null && !arrivingTo.trim().isEmpty()
		&& aircraftID != null && !aircraftID.trim().isEmpty()
		&& numberOfStops != null && !numberOfStops.trim().isEmpty()
		&& economyPrice != null && !economyPrice.trim().isEmpty()
		&& businessPrice != null && !businessPrice.trim().isEmpty()
		&& firstClassPrice != null && !firstClassPrice.trim().isEmpty()
	) {
		
        try {
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();
            
            PreparedStatement pstmtCheckFlight = con.prepareStatement("SELECT COUNT(*) FROM operates_flight WHERE flight_number = ?");
            pstmtCheckFlight.setString(1, flightNumber);
            ResultSet rsCheckFlight = pstmtCheckFlight.executeQuery();
            rsCheckFlight.next();
            int existingFlightCount = rsCheckFlight.getInt(1);
            pstmtCheckFlight.close();
            
            String checkAirlineQuery = "SELECT COUNT(*) FROM airline WHERE airlineID = ?";
            PreparedStatement checkAirlineStmt = con.prepareStatement(checkAirlineQuery);
            checkAirlineStmt.setString(1, airlineID);
            ResultSet checkAirlineResult = checkAirlineStmt.executeQuery();
            checkAirlineResult.next();
            int airlineCount = checkAirlineResult.getInt(1);
           
            String checkDepartingAirportQuery = "SELECT COUNT(*) FROM airport WHERE airportID = ?";
            PreparedStatement checkDepartingAirportStmt = con.prepareStatement(checkDepartingAirportQuery);
            checkDepartingAirportStmt.setString(1, departingFrom);
            ResultSet checkDepartingAirportResult = checkDepartingAirportStmt.executeQuery();
            checkDepartingAirportResult.next();
            int departingAirportCount = checkDepartingAirportResult.getInt(1);
           
            String checkArrivingAirportQuery = "SELECT COUNT(*) FROM airport WHERE airportID = ?";
            PreparedStatement checkArrivingAirportStmt = con.prepareStatement(checkArrivingAirportQuery);
            checkArrivingAirportStmt.setString(1, arrivingTo);
            ResultSet checkArrivingAirportResult = checkArrivingAirportStmt.executeQuery();
            checkArrivingAirportResult.next();
            int arrivingAirportCount = checkArrivingAirportResult.getInt(1);
            
            String checkAircraftQuery = "SELECT COUNT(*) FROM owns_aircraft WHERE aircraftID = ?";
            PreparedStatement checkAircraftStmt = con.prepareStatement(checkAircraftQuery);
            checkAircraftStmt.setString(1, aircraftID);
            ResultSet checkAircraftResult = checkAircraftStmt.executeQuery();
            checkAircraftResult.next();
            int aircraftCount = checkAircraftResult.getInt(1);
           
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            Date departureDate = sdf.parse(departureTime);
            Date arrivalDate = sdf.parse(arrivalTime);
           

            PreparedStatement pstmtCheckAirlineDeparting = con.prepareStatement("SELECT COUNT(*) FROM associated_with WHERE airlineID = ? AND airportID = ?");
            pstmtCheckAirlineDeparting.setString(1, airlineID);
            pstmtCheckAirlineDeparting.setString(2, departingFrom);
            ResultSet rsCheckAirlineDeparting = pstmtCheckAirlineDeparting.executeQuery();
            rsCheckAirlineDeparting.next();
            int associatedAirlineDepartingCount = rsCheckAirlineDeparting.getInt(1);
            pstmtCheckAirlineDeparting.close();

            PreparedStatement pstmtCheckAirlineArriving = con.prepareStatement("SELECT COUNT(*) FROM associated_with WHERE airlineID = ? AND airportID = ?");
            pstmtCheckAirlineArriving.setString(1, airlineID);
            pstmtCheckAirlineArriving.setString(2, arrivingTo);
            ResultSet rsCheckAirlineArriving = pstmtCheckAirlineArriving.executeQuery();
            rsCheckAirlineArriving.next();
            int associatedAirlineArrivingCount = rsCheckAirlineArriving.getInt(1);
            pstmtCheckAirlineArriving.close();
            

            
            
            if (existingFlightCount > 0) {
                out.println("Error: Flight with the same flight number already exists.");
                return;
            } else if (airlineCount == 0) {
                out.print("Error: Airline with ID " + airlineID + " does not exist.");
                return;
            } else if (departingAirportCount == 0) {
                out.print("Error: Departing airport with ID " + departingFrom + " does not exist.");
                return;
            } else if (arrivingAirportCount == 0) {
                out.print("Error: Arriving airport with ID " + arrivingTo + " does not exist.");
                return;
            } else if (aircraftCount == 0) {
                out.print("Error: Aircraft with ID " + aircraftID + " does not exist");
                return;
            } else if (!arrivalDate.after(departureDate)) {
                out.println("Error: Arrival time must be after departure time.");
                return;
            //} else if (departingFrom.equals(arrivingTo)) {
            //    out.println("Error: Departing airport and arriving airport cannot be the same.");
            //    return;
            } else if (!(associatedAirlineDepartingCount > 0)){
                out.println("Error: Departure Airport " + departingFrom + " is not associated with the Airline " + airlineID);
                return;
            } else if (!(associatedAirlineArrivingCount > 0)){
                out.println("Error: Arrival Airport " + arrivingTo + " is not associated with the Airline " + airlineID);
                return;
            } else {
            

            
            String insertOperatesFlightSql = "INSERT INTO operates_flight (airlineID, flight_number, isDomestic, departure_time, arrival_time, numberOfStops, economyPrice, businessPrice, firstClassPrice) " +
            		    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

            String insertDepartingFromSql = "INSERT INTO departing_from (flight_number, departing_airportID, airlineID, departure_time) VALUES (?, ?, ?, ?)";
            String insertArrivingToSql = "INSERT INTO arriving_to (flight_number, arriving_airportID, airlineID, departure_time) VALUES (?, ?, ?, ?)";
            String insertFlownOnSql = "INSERT INTO flown_on (airlineID, aircraftID, flight_number, departure_time) VALUES (?, ?, ?, ?)";

		     PreparedStatement pstmtOperatesFlight = con.prepareStatement(insertOperatesFlightSql);
		     PreparedStatement pstmtDepartingFrom = con.prepareStatement(insertDepartingFromSql);
		     PreparedStatement pstmtArrivingTo = con.prepareStatement(insertArrivingToSql); 
	         PreparedStatement pstmtFlownOn = con.prepareStatement(insertFlownOnSql);

		    pstmtOperatesFlight.setString(1, airlineID);
		    pstmtOperatesFlight.setString(2, flightNumber);
		    pstmtOperatesFlight.setString(3, isDomesticValue);
		    pstmtOperatesFlight.setString(4, departureTime);
		    pstmtOperatesFlight.setString(5, arrivalTime);
		    pstmtOperatesFlight.setString(6, numberOfStops); 
		    pstmtOperatesFlight.setString(7, economyPrice);  
		    pstmtOperatesFlight.setString(8, businessPrice);  
		    pstmtOperatesFlight.setString(9, firstClassPrice); 
		
		    int operatesFlightRowsAffected = pstmtOperatesFlight.executeUpdate();
		
		    pstmtDepartingFrom.setString(1, flightNumber);
		    pstmtDepartingFrom.setString(2, departingFrom);
		    pstmtDepartingFrom.setString(3, airlineID);  
		    pstmtDepartingFrom.setString(4, departureTime);

		    int departingFromRowsAffected = pstmtDepartingFrom.executeUpdate();
		
		    pstmtArrivingTo.setString(1, flightNumber);
		    pstmtArrivingTo.setString(2, arrivingTo);
		    pstmtArrivingTo.setString(3, airlineID);  
		    pstmtArrivingTo.setString(4, departureTime);

		
		    int arrivingToRowsAffected = pstmtArrivingTo.executeUpdate();
		    
		    pstmtFlownOn.setString(1, airlineID);
	        pstmtFlownOn.setString(2, aircraftID);
	        pstmtFlownOn.setString(3, flightNumber);
	        pstmtFlownOn.setString(4, departureTime);


	        int flownOnRowsAffected = pstmtFlownOn.executeUpdate();
            
		
		   if (operatesFlightRowsAffected > 0 && departingFromRowsAffected > 0 &&
            arrivingToRowsAffected > 0 && flownOnRowsAffected > 0) {
            out.print("Flight with flight number " + flightNumber + " inserted successfully.");
	        } else {
	            out.print("Error: Unable to insert flight with flight number " + flightNumber);
	        }
           }
		        
		        } catch (SQLException e) {
		            out.println("Error: " + e.getMessage());
		        }
			} else {
		       out.println("Error: Missing or empty values.");
		    }
	%>
</body>
</html>

<%
out.println("<br/><a href='repModifyFlights.jsp'>Back</a>");
    }
%>
