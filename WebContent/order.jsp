<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Konbini Grocery Order Processing</title>
<style>
	@font-face{
		font-family: customFont;
		src: url(NikkyouSans-mLKax.ttf);
	}
	h1{
		text-align: center;
		font-family: customFont;
		font-size: 40px;
		padding: 0px;
	}
	h3{
		text-align: center;
		font-family: sans-serif;
		font-size: 25px;
	}
	table{
		width: 100%;
	}
	table, td{
		border: 1px solid #7E8193;
	}
	td{
		font-family: sans-serif;
		font-size: 14px;
		text-align: center;
		height: 25px;
	}
	.tableheader{
		height: 30px;
		font-size: 18px;
		font-family: customFont;
		text-align: center;
		background-color: #F5CEC5;
	}
	.button{
		font-family: sans-serif;
		font-size: 18px;
		text-align:center;
		padding: 8px;
		margin: 4px 2px;
		background: #F5CEC5;
		transition-duration: 0.4s;
		cursor: pointer;
		float: center;
	}
	.button:hover{
		background-color: #FAAA96;
	}
</style>
</head>
<body>

<%-- coppied from showcart.jsp --%>
<%
// Get the current list of products
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (productList == null || productList.isEmpty())
{	out.println("<H1>Your shopping cart is empty!</H1>");
	out.println("<h3><a href=listprod.jsp><button class='button'><b>Begin Shopping 🛍 </b></button></a>");
	out.println("<a href=index.jsp><button class='button'><b>Main Menu 🏠</b></button></a></h3>");
	productList = new HashMap<String, ArrayList<Object>>();
}
else
{
	NumberFormat currFormat = NumberFormat.getCurrencyInstance(Locale.US);

	// Get customer id
	String custId = request.getParameter("customerId");
	// @SuppressWarnings({"unchecked"})
	// HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

	// Make connection
	// Determine if valid customer id was entered
	String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
	String uid = "SA";
	String pw = "YourStrong@Passw0rd";
	try(Connection con = DriverManager.getConnection(url, uid, pw); 
		Statement stmt = con.createStatement();)
	{	
		int id = Integer.parseInt(custId);
		PreparedStatement pstmt1 = con.prepareStatement("SELECT customerId, address, city, state, postalCode, country, firstName, lastName FROM customer WHERE customerId = ?");
		pstmt1.setInt(1, id);
		ResultSet rs1 = pstmt1.executeQuery();
		if(rs1.next())
		{	
			String customerName = rs1.getString(7) + " " + rs1.getString(8);
			// Save order information to database
			String sql = "INSERT INTO ordersummary(orderDate, shiptoAddress, shiptoCity, shiptoState, shiptoPostalCode, shiptoCountry, customerId) VALUES (?, ?, ?, ?, ?, ?, ?)";
			// Use retrieval of auto-generated keys.
			PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
			LocalDateTime now = LocalDateTime.now();
			pstmt.setTimestamp(1, java.sql.Timestamp.valueOf(now));
			pstmt.setString(2, rs1.getString(2));
			pstmt.setString(3, rs1.getString(3));
			pstmt.setString(4, rs1.getString(4));
			pstmt.setString(5, rs1.getString(5));
			pstmt.setString(6, rs1.getString(6));
			pstmt.setInt(7, id);
			pstmt.executeUpdate();		
			ResultSet keys = pstmt.getGeneratedKeys();
			keys.next();
			int orderId = keys.getInt(1);
			
			String insertSql = "INSERT INTO orderproduct VALUES (?, ?, ?, ?)";
			pstmt = con.prepareStatement(insertSql);
			double totPrice = 0;
			Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
			while (iterator.hasNext())
			{ 
				Map.Entry<String, ArrayList<Object>> entry = iterator.next();
				ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
				String productId = (String) product.get(0);
				String price = (String) product.get(2);
				double pr = Double.parseDouble(price);
				int qty = ( (Integer)product.get(3)).intValue();
				pstmt.setInt(1, orderId);
				pstmt.setString(2, productId);
				pstmt.setInt(3, qty);
				pstmt.setDouble(4, pr);
				pstmt.executeUpdate();
				totPrice += pr*qty;
			}
			stmt.executeUpdate("UPDATE ordersummary SET totalAmount ="+ totPrice +" WHERE orderId  = " + orderId);
			

			// Print out order summary
			out.println("<h1>Your Order Summary</h1>");
			out.print("<table><tr><td class='tableheader'>Product Id</td><td class='tableheader'>Product Name</td><td class='tableheader'>Quantity</td>");
			out.println("<td class='tableheader'>Price</td><td class='tableheader'>Subtotal</td></tr>");

			double total = 0;
			Iterator<Map.Entry<String, ArrayList<Object>>> iterator1 = productList.entrySet().iterator();
			while (iterator1.hasNext()) 
			{	Map.Entry<String, ArrayList<Object>> entry = iterator1.next();
				ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
				if (product.size() < 4)
				{
					out.println("Expected product with four entries. Got: "+product);
					continue;
				}
				
				out.print("<tr><td>"+product.get(0)+"</td>");
				out.print("<td>"+product.get(1)+"</td>");

				out.print("<td align=\"center\">"+product.get(3)+"</td>");
				Object price = product.get(2);
				Object itemqty = product.get(3);
				double pr = 0;
				int qty = 0;
				
				try
				{
					pr = Double.parseDouble(price.toString());
				}
				catch (Exception e)
				{
					out.println("Invalid price for product: "+product.get(0)+" price: "+price);
				}
				try
				{
					qty = Integer.parseInt(itemqty.toString());
				}
				catch (Exception e)
				{
					out.println("Invalid quantity for product: "+product.get(0)+" quantity: "+qty);
				}		

				out.print("<td align=\"right\">"+currFormat.format(pr)+"</td>");
				out.print("<td align=\"right\">"+currFormat.format(pr*qty)+"</td></tr>");
				out.println("</tr>");
				total += pr*qty;
			}
			out.println("<tr><td colspan='4' style='text-align: right;' class='tableheader'><b>Order Total</b></td>"
					+"<td style='font-size: 18px;'><b>"+currFormat.format(total)+"</b></td></tr>");
			out.println("</table>");

			out.println("<h1>Order completed. Will be shipped soon...</h1>");
			out.println("<h3>Your order reference number is: "+ orderId +"</h3>");
			out.println("<h3>Shipping to customer id: "+ id + " Name: "+ customerName +"</h3>");
			out.println("<h2><a href='index.jsp'><button class='button'><b>Return to Main Menu 🏠</b></button></a></h2>");
			// Clear cart if order placed successfully
			session.removeAttribute("productList");
		}
		else{
			out.println("<h1>Invalid customer id!</h1>");
			out.println("<h3>Go back to the previous page and try again.</h3>");
		}
	}
	catch(NumberFormatException e){
		out.println("<h1>Invalid customer id. Go back to the previous page and try again.</h1>");
	}
	catch(Exception e){
		out.println(e);
	}

	
}

// Determine if there are products in the shopping cart
// If either are not true, display an error message


// Save order information to database


	/*
	// Use retrieval of auto-generated keys.
	PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);			
	ResultSet keys = pstmt.getGeneratedKeys();
	keys.next();
	int orderId = keys.getInt(1);
	*/

// Insert each item into OrderProduct table using OrderId from previous INSERT

// Update total amount for order record

// Here is the code to traverse through a HashMap
// Each entry in the HashMap is an ArrayList with item 0-id, 1-name, 2-quantity, 3-price

/*
	Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
	while (iterator.hasNext())
	{ 
		Map.Entry<String, ArrayList<Object>> entry = iterator.next();
		ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
		String productId = (String) product.get(0);
        String price = (String) product.get(2);
		double pr = Double.parseDouble(price);
		int qty = ( (Integer)product.get(3)).intValue();
            ...
	}
*/

// Print out order summary

// Clear cart if order placed successfully
%>
</BODY>
</HTML>
