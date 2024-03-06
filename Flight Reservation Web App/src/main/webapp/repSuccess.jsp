<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
    <%
    ApplicationDB db = new ApplicationDB();	
	Connection con = db.getConnection();
		switch(request.getParameter("repSubmitType")){
	    	case "repBuyReserve":
	    		if(request.getParameter("repBuyReserveFlight1").equals("No Flights Available")){
	    			out.println("Sorry, no flights available, please return home");
	    		}else{
	    			PreparedStatement psAddTicket = 
							con.prepareStatement("INSERT INTO ticket (totalFare) VALUES (?)");
						psAddTicket.setString(1, String.valueOf(0));
						psAddTicket.executeUpdate();
						DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");  
						LocalDateTime now = LocalDateTime.now();
						PreparedStatement psTicketID = con.prepareStatement("SELECT LAST_INSERT_ID()");
		                ResultSet rsTicketID = psTicketID.executeQuery();
		                int lastInsertedId = -1;
		                if (rsTicketID.next()) {
		                   lastInsertedId = rsTicketID.getInt(1);
		                }
		                PreparedStatement psUsername = con.prepareStatement("Select Username from users where UserID = ?");
						psUsername.setString(1, request.getParameter("flightsBuyUserID"));
		                ResultSet rsUsername = psUsername.executeQuery();
						rsUsername.next();
						String username = rsUsername.getString("Username");
						PreparedStatement psAddBuys = 
								con.prepareStatement("INSERT INTO buys (ticketNum, purchaseDateTime, Username) VALUES (?, ?, ?)");
						psAddBuys.setString(1, String.valueOf(lastInsertedId));
						psAddBuys.setString(2, dtf.format(now));
						psAddBuys.setString(3, username);
						psAddBuys.executeUpdate();
		    		int numFlights = Integer.parseInt(request.getParameter("numFlightsBuy"));
		    		int totalCost = 10;
		    		ArrayList<ArrayList<Integer>> availableSeats = new ArrayList<ArrayList<Integer>>();
					for(int i = 0; i < numFlights; i++){
						availableSeats.add(new ArrayList<Integer>());
						String flightData = request.getParameter("repBuyReserveFlight"+(i+1));
			    		String flightClass = request.getParameter("repBuyClass"+(i+1));
			    		String airlineID = flightData.substring(0, 2);
						String flightNumber = flightData.substring(2).split("=")[0];
						String departureTime = flightData.substring(2).split("=")[1];
						//out.println(flightData + " " + flightClass);
						int prevCost = totalCost;
						PreparedStatement psClassCosts = con.prepareStatement("select operates_flight.economyPrice, operates_flight.businessPrice, operates_flight.firstClassPrice "
								+ "from operates_flight where operates_flight.airlineID = ? and operates_flight.flight_number = ? and operates_flight.departure_time = ?");
								psClassCosts.setString(1, airlineID);
								psClassCosts.setString(2, flightNumber);
								psClassCosts.setString(3, departureTime);
								ResultSet rsClassCosts = psClassCosts.executeQuery();
								rsClassCosts.next();
/* 								out.println(Integer.parseInt(rsClassCosts.getString("firstClassPrice")));
								out.println(Integer.parseInt(rsClassCosts.getString("businessPrice")));
								out.println(Integer.parseInt(rsClassCosts.getString("economyPrice"))); */
								switch(flightClass){
									case "first":
										totalCost += Integer.parseInt(rsClassCosts.getString("firstClassPrice"));
										break;
									case "business":
										totalCost += Integer.parseInt(rsClassCosts.getString("businessPrice"));
										break;
									case "economy":
										totalCost += Integer.parseInt(rsClassCosts.getString("economyPrice"));
										break;
									default:
										break;
								}
					
						PreparedStatement psSeats = con.prepareStatement("select owns_aircraft.seats from operates_flight "+
								"join flown_on on operates_flight.flight_number = flown_on.flight_number and "
								+ "operates_flight.airlineID = flown_on.airlineID and operates_flight.departure_time = flown_on.departure_time join owns_aircraft on flown_on.aircraftID = "
								+ "owns_aircraft.aircraftID where operates_flight.airlineID = ? and operates_flight.flight_number = ? and operates_flight.departure_time = ?");
						psSeats.setString(1, airlineID);
						psSeats.setString(2, flightNumber);
						psSeats.setString(3, departureTime);
						ResultSet rsSeats = psSeats.executeQuery();
						rsSeats.next();
						int numSeats = Integer.parseInt(rsSeats.getString("seats"));
						for(int j = 1; j <= numSeats; j++){
							availableSeats.get(i).add(j);
						}
						PreparedStatement psTakenSeats = con.prepareStatement("select includes.seatNum from operates_flight join includes on " + 
							"operates_flight.flight_number = includes.flight_number and operates_flight.airlineID = "
							+ " includes.airlineID where operates_flight.airlineID = ? and operates_flight.flight_number = ? and operates_flight.departure_time = ?");
						psTakenSeats.setString(1, airlineID);
						psTakenSeats.setString(2, flightNumber);
						psTakenSeats.setString(3, departureTime);
						ResultSet rsTakenSeats = psTakenSeats.executeQuery();
						while (rsTakenSeats.next()){	
							availableSeats.get(i).remove(Integer.valueOf(rsTakenSeats.getString("seatNum")));
							//out.println(rsTakenSeats.getString("seatNum"));
						}
						/* for(int j = 0; j < availableSeats.get(i).size(); j++){
							out.print(availableSeats.get(i).get(j) + " "); 
						} */
						if(availableSeats.get(i).isEmpty()){
							try{
								totalCost = prevCost;
								PreparedStatement ps = con.prepareStatement("INSERT INTO ticketStatus (status, username, flightNumber, airlineID, departure_time) VALUES ('onWaitingList', ?, ?, ?, ?)");
								ps.setString(1, username);
								ps.setString(2, flightNumber);
								ps.setString(3, airlineID);
								ps.setString(4, departureTime);
								ps.executeUpdate();
								out.println(flightData + " is fully packed, you have been placed on the waitlist! As a result, this ticket will not be bought");
							}catch(Exception e){
								//You are already on this flight
								out.println("Sorry, you are already on the waiting list for this flight, as a result, you will not enter the waiting list again!");
							}finally{
								
							} 
							%><br><%
						}else{
							PreparedStatement ps = con.prepareStatement("INSERT INTO includes (ticketNum, airlineID, flight_number, class, seatNum, departure_time) VALUES (?, ?, ?, ?, ?, ?)");
							ps.setString(1, String.valueOf(lastInsertedId));
							ps.setString(2, airlineID);
							ps.setString(3, flightNumber);
							ps.setString(4, flightClass);
							ps.setString(5, String.valueOf(availableSeats.get(i).get(0)));
							ps.setString(6, departureTime);
							ps.executeUpdate(); 
							PreparedStatement psTS = con.prepareStatement("INSERT INTO ticketStatus (status, username, flightNumber, airlineID, seatNum, departure_time) VALUES ('onFlight', ?, ?, ?, ?, ?)");
							psTS.setString(1, username);
							psTS.setString(2, flightNumber);
							psTS.setString(3, airlineID);
							psTS.setString(4, String.valueOf(availableSeats.get(i).get(0)));
							psTS.setString(5, departureTime);
							psTS.executeUpdate();
							out.println("You have sucessfully bought a " + flightClass + " ticket for " + flightData + " and your seat number is " + availableSeats.get(i).get(0));
							%><br><%
						}
	    			}
					PreparedStatement ps = con.prepareStatement("UPDATE ticket SET totalFare = ? WHERE ticketNum = ?");
					ps.setString(1, String.valueOf(totalCost));
					ps.setString(2, String.valueOf(lastInsertedId));
					ps.executeUpdate();
					%><br><%
		    		out.println("Your total cost is $" + totalCost);
	    		}
	    		break;
	    	case "repEditReserve":
    			String ticketNum = request.getParameter("repEditTicketNum");
	    		if(request.getParameter("repDeleteTicket").equals("yes")){
	    			try{
	    				PreparedStatement psGetData = con.prepareStatement("Select includes.flight_number, includes.airlineID, includes.seatNum, "
	    	    				+ "buys.Username, includes.departure_time from ticket join includes on ticket.ticketNum = includes.ticketNum join buys on buys.ticketNum = "
	    	    				+ "ticket.ticketNum where ticket.ticketNum = ?");
	    	    			psGetData.setString(1, ticketNum);
	    					ResultSet rsData = psGetData.executeQuery();
	    					while(rsData.next()){
		    					String flightNumber = rsData.getString("flight_number");
		    					String airlineID = rsData.getString("airlineID");
		    					String seatNum = rsData.getString("seatNum");
		    					String username = rsData.getString("Username");
		    					String departureTime = rsData.getString("departure_time");
		    					PreparedStatement psDeleteTicketStatus = con.prepareStatement("DELETE FROM ticketStatus WHERE flightNumber = ? and "
		    							+ "airlineID = ? and seatNum = ? and username = ? and departure_time = ?");
		    					psDeleteTicketStatus.setString(1, flightNumber);
		    					psDeleteTicketStatus.setString(2, airlineID);
		    					psDeleteTicketStatus.setString(3, seatNum);
		    					psDeleteTicketStatus.setString(4, username);
		    					psDeleteTicketStatus.setString(5, departureTime);
		    					psDeleteTicketStatus.executeUpdate();
	    					}
	    			}catch(Exception e){
	    				//Flights are embpty
	    			}finally{
	    				PreparedStatement psDeleteTicket = con.prepareStatement("DELETE FROM ticket WHERE ticketNum = ?");
    					psDeleteTicket.setString(1, ticketNum);
    					psDeleteTicket.executeUpdate();
    					out.println("Ticket #" + ticketNum + " has been deleted!");
	    			}
	    		}else{
	    			if(request.getParameter("repEditReserveClass").equals("No Flights Available")){
		    			out.println("Sorry, no flights available, please return home");
		    		}else{
		    			String flightClass = request.getParameter("repEditClass");
		    			String classFlightData = request.getParameter("repEditReserveClass");
		    			if(!classFlightData.equals("None")){
		    				String classAirlineID = classFlightData.substring(0, 2);
		    				String flightNumber = classFlightData.substring(2).split("=")[0];
							String departureTime = classFlightData.substring(2).split("=")[1];
							String seatNum = classFlightData.substring(2).split("=")[2].substring(1); 
/* 							out.println(classAirlineID);
							out.println(flightNumber);
							out.println(departureTime);
							out.println(classAirlineID); */
							PreparedStatement psCost = con.prepareStatement("Select totalFare from ticket where ticketNum = ?");
							psCost.setString(1, ticketNum);
							ResultSet rsCost = psCost.executeQuery();
							rsCost.next();
							int changeCost = Integer.parseInt(rsCost.getString("totalFare"));
							PreparedStatement psClass = con.prepareStatement("Select class from includes where ticketNum = ? and flight_number = ? and "
									+ "airlineID = ? and seatNum = ? and departure_time = ?");
							psClass.setString(1, ticketNum);
							psClass.setString(2, flightNumber);
							psClass.setString(3, classAirlineID);
							psClass.setString(4, seatNum);
							psClass.setString(5, departureTime);
							ResultSet rsClass = psClass.executeQuery();
							rsClass.next();
							String changeClass = rsClass.getString("class");
							//out.println(changeClass);
							PreparedStatement psClassCosts = con.prepareStatement("select operates_flight.economyPrice, operates_flight.businessPrice, operates_flight.firstClassPrice "
							+ "from operates_flight where operates_flight.airlineID = ? and operates_flight.flight_number = ? and operates_flight.departure_time = ?");
							psClassCosts.setString(1, classAirlineID);
							psClassCosts.setString(2, flightNumber);
							psClassCosts.setString(3, departureTime);
							ResultSet rsClassCosts = psClassCosts.executeQuery();
							rsClassCosts.next();
							switch(changeClass){
								case "First":
									changeCost -= Integer.parseInt(rsClassCosts.getString("firstClassPrice"));
									break;
								case "Business":
									changeCost -= Integer.parseInt(rsClassCosts.getString("businessPrice"));
									break;
								case "Economy":
									changeCost += 10; //fee for being economy
									changeCost -= Integer.parseInt(rsClassCosts.getString("economyPrice"));
									break;
								default:
									break;
							}
							//out.println(changeCost);
							switch(flightClass){
								case "first":
									changeCost += Integer.parseInt(rsClassCosts.getString("firstClassPrice"));
									break;
								case "business":
									changeCost += Integer.parseInt(rsClassCosts.getString("businessPrice"));
									break;
								case "economy":
									changeCost += Integer.parseInt(rsClassCosts.getString("economyPrice"));
									break;
								default:
									break;
							}
							//out.println(changeCost);
							PreparedStatement psUpdateCost = con.prepareStatement("UPDATE ticket SET totalFare = ? WHERE ticketNum = ?");
							psUpdateCost.setString(1, String.valueOf(changeCost));
							psUpdateCost.setString(2, ticketNum);
							psUpdateCost.executeUpdate();	
							PreparedStatement psUpdateClass = con.prepareStatement("UPDATE includes SET class = ? WHERE ticketNum = ? and flight_number = ? and "
									+ "airlineID = ? and seatNum = ? and departure_time = ?");
							psUpdateClass.setString(1, flightClass);
							psUpdateClass.setString(2, ticketNum);
							psUpdateClass.setString(3, flightNumber);
							psUpdateClass.setString(4, classAirlineID);
							psUpdateClass.setString(5, seatNum);
							psUpdateClass.setString(6, departureTime);
							psUpdateClass.executeUpdate();
							/* out.println(flightClass);
							out.println(ticketNum);
							out.println(flightNumber);
							out.println(classAirlineID);
							out.println(seatNum); */
							out.println("Flight Class has been changed");
		    			}
		    			//Remove Flight
		    			String removeFlightData = request.getParameter("repRemoveReserveClass");
		    			if(!removeFlightData.equals("None")){
		    				String removeAirlineID = removeFlightData.substring(0, 2);
		    				String flightNumber = removeFlightData.substring(2).split("=")[0];
							String departureTime = removeFlightData.substring(2).split("=")[1];
							String seatNum = removeFlightData.substring(2).split("=")[2].substring(1); 
							String username = request.getParameter("repEditUsername");
							PreparedStatement psTicket = con.prepareStatement("Select totalFare from ticket where ticketNum = ?");
							psTicket.setString(1, ticketNum);
							ResultSet rsTicket = psTicket.executeQuery();
							rsTicket.next();
							int changeCost = Integer.parseInt(rsTicket.getString("totalFare"));
							PreparedStatement psClass = con.prepareStatement("Select class from includes where ticketNum = ? and flight_number = ? and "
									+ "airlineID = ? and seatNum = ? and departure_time = ?");
							psClass.setString(1, ticketNum);
							psClass.setString(2, flightNumber);
							psClass.setString(3, removeAirlineID);
							psClass.setString(4, seatNum);
							psClass.setString(5, departureTime);
							ResultSet rsClass = psClass.executeQuery();
							rsClass.next();
							String changeClass = rsClass.getString("class");
							
							PreparedStatement psClassCosts = con.prepareStatement("select operates_flight.economyPrice, operates_flight.businessPrice, operates_flight.firstClassPrice "
									+ "from operates_flight where operates_flight.airlineID = ? and operates_flight.flight_number = ? and operates_flight.departure_time = ?");
									psClassCosts.setString(1, removeAirlineID);
									psClassCosts.setString(2, flightNumber);
									psClassCosts.setString(3, departureTime);
									ResultSet rsClassCosts = psClassCosts.executeQuery();
									rsClassCosts.next();
									switch(changeClass){
										case "First":
											changeCost -= Integer.parseInt(rsClassCosts.getString("firstClassPrice"));
											break;
										case "Business":
											changeCost -= Integer.parseInt(rsClassCosts.getString("businessPrice"));
											break;
										case "Economy":
											changeCost += 10; //fee for being economy
											changeCost -= Integer.parseInt(rsClassCosts.getString("economyPrice"));
											break;
										default:
											break;
									}							
							PreparedStatement psUpdateCost = con.prepareStatement("UPDATE ticket SET totalFare = ? WHERE ticketNum = ?");
							psUpdateCost.setString(1, String.valueOf(changeCost));
							psUpdateCost.setString(2, ticketNum);
							psUpdateCost.executeUpdate();
							PreparedStatement psDeleteTicketStatus = con.prepareStatement("DELETE FROM ticketStatus WHERE flightNumber = ? and "
									+ "airlineID = ? and seatNum = ? and username = ? and departure_time = ?");
							psDeleteTicketStatus.setString(1, flightNumber);
							psDeleteTicketStatus.setString(2, removeAirlineID);
							psDeleteTicketStatus.setString(3, seatNum);
							psDeleteTicketStatus.setString(4, username);
							psDeleteTicketStatus.setString(5, departureTime);
							psDeleteTicketStatus.executeUpdate();
			    			PreparedStatement psDeleteTicket = con.prepareStatement("DELETE FROM includes WHERE ticketNum = ? and flight_number = ? and "
									+ "airlineID = ? and seatNum = ? and departure_time = ?");
			    			psDeleteTicket.setString(1, ticketNum);
			    			psDeleteTicket.setString(2, flightNumber);
			    			psDeleteTicket.setString(3, removeAirlineID);
			    			psDeleteTicket.setString(4, seatNum);	
			    			psDeleteTicket.setString(5, departureTime);		
			    			psDeleteTicket.executeUpdate();
							out.println(removeAirlineID + flightNumber + " has been removed.");
		    			}
	    			}
	    		}
				break;
	    	default:
	    		break;
		}
	%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
	/* PreparedStatement psTakenSeats = con.prepareStatement("select * from operates_flight join includes on " + 
		"operates_flight.flight_number = includes.flight_number and operates_flight.airlineID = "
		+ " includes.airlineID where operates_flight.airlineID = ? and operates_flight.flight_number = ?");
	psTakenSeats.setString(1, "AB");
	psTakenSeats.setString(2, "1");
	ResultSet rsTakenSeats = psTakenSeats.executeQuery();
	ResultSetMetaData rsmd2 = rsTakenSeats.getMetaData();
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
	while (rsTakenSeats.next()) {
		rowCount++;
	  	out.println("<TR>");
	  	for (int i = 0; i < columnCount; i++) {
	    	out.println("<TD>" + rsTakenSeats.getString(i + 1) + "</TD>");
	    }
	  	out.println("</TR>");
	 }
	 out.println("</TABLE></P>"); */
%>

<br>
</body>
</html>
<%
	out.println("<br/><a href='repHome.jsp'>Go Back Home</a>");
%>