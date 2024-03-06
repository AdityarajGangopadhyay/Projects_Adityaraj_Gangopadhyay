<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<%
    if (session.getAttribute("user") == null || !"rep".equals(session.getAttribute("type"))) {
         out.println("Unauthorized Access.<br/>");
         out.println("<a href='login.jsp'>Please Login</a>");
    } else {
    	out.println("Aircraft Delete Confirmation<br/>");
        
%>



<html>
<head>
<title>Aircraft Delete Confirmation</title>
</head>
<body>
	<%
	String aircraftID = request.getParameter("aircraftID");

	if (aircraftID != null && !aircraftID.trim().isEmpty()) {
        try {
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();
            
            String sql = "DELETE FROM owns_aircraft WHERE aircraftID = ?";	
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setString(1, aircraftID);
            int rowsAffected = pstmt.executeUpdate();
            db.closeConnection(con);
            if (rowsAffected > 0) {
                out.print("Aircraft " + aircraftID + " has been deleted.");
            } else {
                out.print("No aircraft found with aircraftID " + aircraftID);
            }
        } catch (SQLException e) {
            out.println("Error: " + e.getMessage());
        }
    } else {
        out.println("Error: The aircraftID cannot be null or empty.");
    }
	%>
</body>
</html>

<%
out.println("<br/><a href='repModifyAircrafts.jsp'>Back</a>");
    }
%>
