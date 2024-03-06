<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<%
    if (session.getAttribute("user") == null || !"customer".equals(session.getAttribute("type"))) {
         out.println("Unauthorized Access.<br/>");
         out.println("<a href='login.jsp'>Please Login</a>");
    } else {
        out.println("Question Confirmation<br/>");
        out.println("<a href='customerQuestionHome.jsp'>Back</a>");
%>

<br>

<html>
<head>
<title>Question Confirmation</title>
</head>
<body>
	<%
	String question = request.getParameter("question");

	if (question != null && !question.trim().isEmpty()) {
        try {
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();
            PreparedStatement pstmt = con.prepareStatement("INSERT INTO questions (question, customer) VALUES (?, ?)");
            pstmt.setString(1, question);
            pstmt.setString(2, (String) session.getAttribute("user"));
            pstmt.executeUpdate();
            db.closeConnection(con);
    		out.print("Question Submitted!");
        } catch (SQLException e) {
            out.println("Error: " + e.getMessage());
        }
    } else {
        out.println("Error: The question cannot be null or empty.");
    }
	%>
</body>
</html>

<%
    }
%>
