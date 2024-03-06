<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<%
    if (session.getAttribute("user") == null || !"rep".equals(session.getAttribute("type"))) {
         out.println("Unauthorized Access.<br/>");
         out.println("<a href='login.jsp'>Please Login</a>");
    } else {
    	out.println("Modify Airports<br/>");
        out.println("<a href='repHome.jsp'>Back</a>");
%>


<html>
<head>
    <title>Modify Airports</title>
</head>
<body>
<%
    try {
        ApplicationDB db = new ApplicationDB();    
        Connection con = db.getConnection();       
        String sql = "SELECT * FROM airport";
        PreparedStatement pstmt = con.prepareStatement(sql);
        ResultSet result = pstmt.executeQuery();
%>
    
    <table style="width: 100%; border-collapse: collapse; margin-top: 20px;">
        <tr>
        	<th style="background-color: #f2f2f2; border: 1px solid #dddddd; text-align: left; padding: 8px;">Airport ID</th>
        </tr>
        <% while (result.next()) { %>
            <tr>
            	<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= result.getString("airportID") %></td>
            </tr>
            
            
            
            
        <% }
        db.closeConnection(con);
        %>
        
        
    </table>
    
    <%  } catch (Exception e) {
            out.print("Error: " + e);
        }%>
    <br>

    Add an airport:
    	<br>
        <form method="post" action="repModifyAirportsAdd.jsp">
			Airport ID: <input type="text" name="airportID" required/> <br/>
			<input type="submit" value="Submit"/>
		</form>
    Edit an airport:
        <form method="post" action="repModifyAirportsEdit.jsp">
        	Airport ID to edit: <input type="text" name="airportID" required/> <br/>
        	New Airport ID: <input type="text" name="newAirportID"/> <br/>
			<input type="submit" value="Submit"/>
		</form>
    Delete an airport:
        <form method="post" action="repModifyAirportsDelete.jsp">
			Airport ID: <input type="text" name="airportID" required/> <br/>
			<input type="submit" value="Submit"/>
		</form>
    	<br>
   
</body>
</html>

<%
    }
%>

