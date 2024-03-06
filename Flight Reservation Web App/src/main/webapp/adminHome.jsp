<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>


<%
    if (session.getAttribute("user") == null || !"admin".equals(session.getAttribute("type"))) {
         out.println("Unauthorized Access.<br/>");
         out.println("<a href='login.jsp'>Please Login</a>");
    } else {
   	 out.println("Welcome to RU Flight, " + session.getAttribute("user") + "<br/>");
%>

<html>
<head>
<title>Admin Home</title>
</head>
<body>
<br>
<form method="post" action="adminAddUser.jsp">
	Username*: <input type="text" name="Username" required /> First Name*: <input type="text" name="Fname" required /> Last Name*: <input type="text" name="Lname" required /> Password*: <input type="password" name="Password" required />
	<select name="Type" required >
		<option value="">Select Type*</option>
		<option value="customer">Customer</option>
		<option value="rep">Representative</option>
	</select>
	<input type="submit" value="Add Customer/Rep" />
</form>
<form method="post" action="adminEditUser.jsp">
	UserID*: <input type="number" name="UserID" required /> Username: <input type="text" name="Username" /> First Name: <input type="text" name="Fname" /> Last Name: <input type="text" name="Lname" /> Password: <input type="password" name="Password" />
	<input type="submit" value="Edit Customer/Rep" />
</form>
<form method="post" action="adminDeleteUser.jsp">
	Username*: <input type="text" name="Username" required />
	<input type="submit" value="Delete Customer/Rep" />
</form>

<form method="post" action="adminSalesReport.jsp">
<label for="month">Month:</label>
<select id="month" name="month" required>
  <option value="">Select Month*</option>
  <option value="01">January</option>
  <option value="02">February</option>
  <option value="03">March</option>
  <option value="04">April</option>
  <option value="05">May</option>
  <option value="06">June</option>
  <option value="07">July</option>
  <option value="08">August</option>
  <option value="09">September</option>
  <option value="10">October</option>
  <option value="11">November</option>
  <option value="12">December</option>
  </select>

<select id="year" name="year" required>
  <option value="">Select Year*</option>
  <%
    for (int year = 2000; year <= 2023; year++) {
      out.println("<option value='" + year + "'>" + year + "</option>");
    }
  %>
</select>
<input type="submit" value="Obtain Sales Report" />
</form>

<form method="post" action="adminFlightNumberReservations.jsp">
 	Airline ID*: <input type="text" name="airlineIDReserve" required/> Flight Number*: <input type="number" name="flightNumberReserve" required/>
 	<input type="submit" value="Produce List of Reservations" />
</form>
<form method="post" action="adminCustomerNameNumberReservations.jsp">
 	Customer First Name*: <input type="text" name="customerFnameReserve" required/> Customer Last Name*: <input type="text" name="customerLnameReserve" required/>
 	<input type="submit" value="Produce List of Reservations" />
</form>
<form method="post" action="adminSummaryRevFlight.jsp">
 	Airline ID*: <input type="text" name="airlineIDRev" required/> Flight Number*: <input type="number" name="flightNumberRev" required/>
 	<input type="submit" value="Summary Listing of Revenue" />
</form>
<form method="post" action="adminSummaryRevAirline.jsp">
 	Airline ID*: <input type="text" name="airlineIDRev" required/>
 	<input type="submit" value="Summary Listing of Revenue" />
</form>
<form method="post" action="adminSummaryRevCustomer.jsp">
 	CustomerID*: <input type="number" name="customerIDRev" required/>
 	<input type="submit" value="Summary Listing of Revenue" />
</form>
<form method="post" action="adminCustomerMostRevenue.jsp">
 	<input type="submit" value="Customer with Most Total Revenue" />
</form>
<form method="post" action="adminMostActiveFlight.jsp">
 	<input type="submit" value="Most Active Flights" />
</form>
</body>
</html>

<%
		out.println("<a href='logout.jsp'>Log out</a>");
    }
%>
