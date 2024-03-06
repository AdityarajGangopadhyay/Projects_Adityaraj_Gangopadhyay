<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>


<html>
	<body>
		<p>Registration Complete</p>
	</body>
</html>

<% 
	String fname = request.getParameter("First Name");
	String lname = request.getParameter("Last Name");
	String userid = request.getParameter("Username");
	String pwd = request.getParameter("Password");
	
	ApplicationDB db = new ApplicationDB();	
	Connection con = db.getConnection();
	PreparedStatement ps = con.prepareStatement("SELECT count(*) FROM users WHERE username = ?");
	ps.setString(1, userid);
	ResultSet rs = ps.executeQuery();
	
	if(rs.next()){
		int exists = rs.getInt(1);
		if (exists != 0){
			response.sendRedirect("registerPage(2).jsp");
			
		} else {
			PreparedStatement prep = con.prepareStatement("INSERT INTO `users` (type, fname, lname, username, password) VALUES ('customer', ?, ?, ?, ?)");
			prep.setString(1, fname);
			prep.setString(2, lname);
			prep.setString(3, userid);
			prep.setString(4, pwd);
			
			prep.execute();
			
			prep = con.prepareStatement("Select userid from users where username = ?");
			prep.setString(1, userid);
			
			rs = prep.executeQuery();
			if (rs.next()){
				out.println("UserID: " + rs.getInt(1));
			}	
			out.println("<a href='login.jsp'>Back To Login</a>");
		
		}
	}
%>