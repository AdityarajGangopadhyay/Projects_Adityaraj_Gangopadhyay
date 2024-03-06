<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<%
    if (session.getAttribute("user") == null || !"customer".equals(session.getAttribute("type"))) {
        out.println("Unauthorized Access.<br/>");
        out.println("<a href='login.jsp'>Please Login</a>");
    } else {
        out.println("Question Search<br/>");
        out.println("<a href='customerQuestionHome.jsp'>Back</a>");
%>

<html>
<head>
    <title>Question Search</title>
</head>
<body>
<%
    try {
        String keyword = request.getParameter("keyword");
        ApplicationDB db = new ApplicationDB();    
        Connection con = db.getConnection();  
        String sql = "SELECT q.question, c1.Fname AS asked_by_first, c1.Lname AS asked_by_last, " +
                     "q.customer AS asked_by_username, q.answer, q.rep, c2.Fname AS answered_by_first, " +
                     "c2.Lname AS answered_by_last, q.rep AS answered_by_username " +
                     "FROM questions q " +
                     "INNER JOIN users c1 ON q.customer = c1.username " +
                     "LEFT JOIN users c2 ON q.rep = c2.username " +
                     "WHERE LOWER(q.question) LIKE LOWER(?) OR LOWER(q.answer) LIKE LOWER(?)";
                     
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, "%" + keyword + "%");
        pstmt.setString(2, "%" + keyword + "%");
        ResultSet result = pstmt.executeQuery();
%>
    <table style="width: 100%; border-collapse: collapse; margin-top: 20px;">
        <tr>
            <th style="background-color: #f2f2f2; border: 1px solid #dddddd; text-align: left; padding: 8px;">Question</th>
            <th style="background-color: #f2f2f2; border: 1px solid #dddddd; text-align: left; padding: 8px;">Asked By</th>
            <th style="background-color: #f2f2f2; border: 1px solid #dddddd; text-align: left; padding: 8px;">Answer</th>
            <th style="background-color: #f2f2f2; border: 1px solid #dddddd; text-align: left; padding: 8px;">Answered By</th>
        </tr>
        <% while (result.next()) { %>
            <tr>
                <td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= result.getString("question") %></td>
                <td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= result.getString("asked_by_first") + " " + result.getString("asked_by_last") %></td>
                <td style="border: 1px solid #dddddd; text-align: left; padding: 8px;">
                         <% 
                        if (result.getString("answer") != null) {
                            out.print(result.getString("answer"));
                        } else {
                            out.print("-");
                        }
                    %>
                </td>
                <td style="border: 1px solid #dddddd; text-align: left; padding: 8px;">
                      <% 
			            if (result.getString("answered_by_first") != null || result.getString("answered_by_last") != null) {
			                out.print(result.getString("answered_by_first") + " " + result.getString("answered_by_last"));
			            } else {
			                out.print("-");
			            }
       				 %>
                </td>
            </tr>
        <% }
        db.closeConnection(con);
        %>
    </table>
    
    <%  } catch (Exception e) {
            out.print("Error: " + e);
        }%>
    <br>
</body>
</html>

<%
    }
%>
