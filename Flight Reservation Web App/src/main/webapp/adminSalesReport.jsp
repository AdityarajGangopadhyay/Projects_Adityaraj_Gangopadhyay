<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<html>
<head>
<title>Sales Report</title>
</head>
<html>

<%
	String month = request.getParameter("month");
    String year = request.getParameter("year");
    
    
	ApplicationDB db = new ApplicationDB();	
	Connection con = db.getConnection();

    try {
        String sql = "SELECT SUM(t.totalFare) AS totalFare " +
        			 "FROM buys b " +
        			 "INNER JOIN ticket t ON b.ticketNum = t.ticketNum " +
        			 "WHERE MONTH(b.purchaseDateTime) = ? AND YEAR(b.purchaseDateTime) = ?";
        
        PreparedStatement stmt = con.prepareStatement(sql);
        
        stmt.setInt(1, Integer.parseInt(month));
        stmt.setInt(2, Integer.parseInt(year));
        
        ResultSet rs = stmt.executeQuery();
        
        if (rs.next()) {
            int totalFare = rs.getInt("totalFare");
            out.println("Sales Report for " + month + "/" + year + ": $" + totalFare + ", return back to <a href='adminHome.jsp'>Admin Home</a>");
        } else {
            out.println("No fare information found for " + month + "/" + year + ", Return back to <a href='adminHome.jsp'>Admin Home</a>");
        }
    } catch (Exception e){
    	out.println(e);
    }
%>