<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>


<%
    if (session.getAttribute("user") == null || !"rep".equals(session.getAttribute("type"))) {
         out.println("Unauthorized Access.<br/>");
         out.println("<a href='login.jsp'>Please Login</a>");
    } else {
        out.println("Answer Confirmation<br/>");
        out.println("<a href='repQuestionHome.jsp'>Back</a>");
%>

<br>

<html>
<head>
<title>Answer Confirmation</title>
</head>
<body>
	<%
	String answer = request.getParameter("answer");
	int questionID = Integer.parseInt(request.getParameter("questionID"));

	if (answer != null && !answer.trim().isEmpty()) {
        try {
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();
            PreparedStatement pstmt = con.prepareStatement("UPDATE questions SET answer=?, rep=? WHERE questionID=?");
            pstmt.setString(1, answer);
            pstmt.setString(2, (String) session.getAttribute("user"));
            pstmt.setInt(3, questionID);
            
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                out.println("Answer updated successfully");
            } else {
                out.println("Failed to answer question");
            }
    		
        } catch (SQLException e) {
            out.println("Error: " + e.getMessage());
        }
    } else {
        out.println("Error: The answer cannot be null or empty.");
    }
	%>
</body>
</html>

<%
    }
%>


