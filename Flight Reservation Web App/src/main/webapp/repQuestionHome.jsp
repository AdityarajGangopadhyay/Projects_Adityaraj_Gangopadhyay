<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<%
    if (session.getAttribute("user") == null || !"rep".equals(session.getAttribute("type"))) {
         out.println("Unauthorized Access.<br/>");
         out.println("<a href='login.jsp'>Please Login</a>");
    } else {
    	out.println("Question Home<br/>");
        out.println("<a href='repHome.jsp'>Back</a>");
%>


<html>
<head>
    <title>Question Home</title>
</head>
<body>
<%
    try {
        ApplicationDB db = new ApplicationDB();    
        Connection con = db.getConnection();       
        String sql = "SELECT * FROM questions";
        PreparedStatement pstmt = con.prepareStatement(sql);
        ResultSet result = pstmt.executeQuery();
%>
    
    <table style="width: 100%; border-collapse: collapse; margin-top: 20px;">
        <tr>
        	<th style="background-color: #f2f2f2; border: 1px solid #dddddd; text-align: left; padding: 8px;">Question ID</th>
            <th style="background-color: #f2f2f2; border: 1px solid #dddddd; text-align: left; padding: 8px;">Question</th>
            <th style="background-color: #f2f2f2; border: 1px solid #dddddd; text-align: left; padding: 8px;">Asked By</th>
            <th style="background-color: #f2f2f2; border: 1px solid #dddddd; text-align: left; padding: 8px;">Answer</th>
            <th style="background-color: #f2f2f2; border: 1px solid #dddddd; text-align: left; padding: 8px;">Answered By</th>
        </tr>
        <% while (result.next()) { %>
            <tr>
            	<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= result.getString("questionID") %></td>
                <td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= result.getString("question") %></td>
                <td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= result.getString("customer") %></td>
                <td style="border: 1px solid #dddddd; text-align: left; padding: 8px;">
                    <% 
                        String answer = result.getString("answer");
                        if (answer != null) {
                            out.print(answer);
                        } else {
                            out.print("-");
                        }
                    %>
                </td>
                <td style="border: 1px solid #dddddd; text-align: left; padding: 8px;">
                    <% 
                        String rep = result.getString("rep");
                        if (rep != null) {
                            out.print(rep);
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
    
    Asnwer a question:
    <br>
        <form method="post" action="repQuestionSubmitted.jsp">
			Question ID: <input type="text" name="questionID"/> <br/>
			Answer:		 <input type="text" name="answer"/> <br/>
			<input type="submit" value="Submit"/>
		</form>
    <br>
   
</body>
</html>

<%
    }
%>

