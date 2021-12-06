<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
	<title>Update Customer</title>
</head>
<body>
<%
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}


// Make connection
String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
String uid = "SA";
String pw = "YourStrong@Passw0rd";

// Write query to retrieve all order summary records
try (Connection con = DriverManager.getConnection(url, uid, pw);
		Statement stmt = con.createStatement();)
{
	int id = request.getParameter("id");
	String first = request.getParameter("first name");
	String last = request.getParameter("last name");
	String email = request.getParameter("email");
	String phone = request.getParameter("phone number");
	String address = request.getParameter("address");
	String city = request.getParameter("city");
	String state = request.getParameter("state");
	String postal = request.getParameter("postal code");
	String country = request.getParameter("country");
	String userId = request.getParameter("address");
	String password = request.getParameter("password");

	String SQL = "UPDATE customer SET firstName = ?, lastName = ?, email = ?, phonenum = ?, address = ?, city = ?, state = ?, postalCode  = ?, country = ?, userid = ?, password = ? WHERE customerId = ?";


	PreparedStatement pst = con.prepareStatement(SQL);
	pst.setString(1,first);
	pst.setString(2,last);
	pst.setString(3,email);
	pst.setString(4,phone);
	pst.setString(5,address);
	pst.setString(6,city);
	pst.setString(7,state);
	pst.setString(8,postal);
	pst.setString(9,country);
	pst.setString(10,userId);
	pst.setString(11,password);
	pst.setInt(12, id);


	int check = pst.executeUpdate();
	if(check >0) out.println("Customer updated");
	else out.println("failed to update Customer");
}
catch (Exception e)
{
    out.print(e);
}



// Close connection
%>

</body>
</html>