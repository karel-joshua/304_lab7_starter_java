<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="authAdmin.jsp"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Konbini Grocery Shipment List</title>
    <style>
            @font-face{
                font-family: customFont;
                src: url(NikkyouSans-mLKax.ttf);
            }
			h2{
				text-align: left;
				font-family: customFont;
				font-size: 30px;
				padding: 0px;
			}
			table{
				width: 100%;
				border: 1px solid #7E8193;
			}
            td{
                font-family: sans-serif;
                font-size: 14px;
                font-weight: bold;
				height: 25px;
				border: 1px solid #7E8193;
            }
			p{
				font-family:sans-serif;
				font-size: 25px;
				text-align: left;
				font-weight: bold;
			}
			a{
        		color: black;
    		}
    		a:hover{
        		color:#FAAA96;
    		}
			.tableheader{
				height: 30px;
				font-size: 18px;
				font-family: customFont;
				text-align: center;
				background-color: #F5CEC5;
			}
			.button, .input2{
				font-family: sans-serif;
				font-size: 18px;
				text-align:center;
				font-weight: bold;
				padding: 6px;
				margin: 4px 2px;
				background: #F5CEC5;
				transition-duration: 0.4s;
				cursor: pointer;
				float:right;
			}
			.button:hover, .input2:hover{
				background-color: #FAAA96;
			}
            .input2{
                font-size: 18px;
				float:left
            }
    </style>
</head>
<body>
<%@ include file="header.jsp" %>

	<h2>Warehouse List
		<a href=index.jsp><button class="button">Main Menu &#127968</button></a>
		<a href=admin.jsp><button class="button">Admin Page &#128100</button></a>
	</h2>

<%
// Write query to retrieve all order summary records
try
{
	getConnection();
	String SQL = "SELECT shipmentId, shipmentDate, shipmentDesc FROM shipment";
	PreparedStatement pst = con.prepareStatement(SQL);
	ResultSet rst = pst.executeQuery();
	ResultSetMetaData rstmd = rst.getMetaData();

	out.println("<table><tr>");
		for(int i = 1; i<4; i++) {
			out.println("<td class='tableheader'>"+rstmd.getColumnName(i)+"</td>");
		}
	out.println("</tr>");

	while(rst.next()){
		out.println("<tr>");
		for(int i = 1; i<4; i++) {
			out.println("<td>"+rst.getString(i)+"</td>");
		}
		out.println("</tr>");
	}
	out.println("</table><br>");

    out.println("<hr>");

    out.println("<h2>Update Shipment Status</h2>");
	out.println("<form method='get' action='updateShipment.jsp'>");
		out.println("<table style='width:30%'>");
		out.println("<tr><td>Shipment ID:</td><td><input type='text' name='shipmentId' size='20' class='input2'></td></tr>");
        out.println("<tr><td>Shipment Description:</td><td><input type='text' name='shipmentDesc' size='20' class='input2'></td></tr>");
		out.println("</table>");
		out.println("<input class='input2' type='submit' value='Submit'>");
	out.println("</form>");
   
	out.println("<h2>Add New Shipment</h2>");
	out.println("<form method='get' action='addShipment.jsp'>");
		out.println("<table style='width:30%'>");
		out.println("<tr><td>Shipment Description:</td><td><input type='text' name='shipmentDesc' size='20' class='input2'></td></tr>");
		out.println("<tr><td>Warehouse ID:</td><td><input type='text' name='warehouseId' size='20' class='input2'></td></tr>");
		out.println("</table>");
		out.println("<input class='input2' type='submit' value='Submit'>");
	out.println("</form>");


    out.println("<br>");
	out.println("<br>");
	out.println("<br>");
}
catch (Exception e)
{
    out.print(e);
}
finally
{	
	closeConnection();	
}
// Close connection
%>

</body>
</html>