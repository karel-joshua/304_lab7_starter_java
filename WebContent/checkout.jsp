<!DOCTYPE html>
<html>
<head>
<title>Konbini Grocery CheckOut Line</title>
<style>
    @font-face{
            font-family: customFont;
            src: url(NikkyouSans-mLKax.ttf);
    }
    h2{
            display: block;
            text-align: left;
            font-family: customFont;
            font-size: 30px;
            padding: 0px;
    }
    td{
		font-family: sans-serif;
		font-size: 14px;
		text-align: left;
        font-weight: bold;
		height: 25px;
	}
    .button, input{
        font-family: sans-serif;
        font-size: 16px;
        text-align:center;
        font-weight: bold;
        padding: 8px;
        margin: 4px 2px;
        background: #F5CEC5;
        transition-duration: 0.4s;
        cursor: pointer;
    }
    .button{
        float: right;
    }
    .input2{
        background: white;
        text-align: left;
        font-size: 18px;
    }
    .button:hover, input:hover{
        background-color: #FAAA96;
    }
    .input2:hover{
        background-color: #FCFBF6;
    }
</style>
</head>
<body>
    <header>
		<h2>Enter your customer id to complete the transaction:</h2>
		<p>
			<a href=index.jsp><button class='button'>Main Menu &#127968</button></a>
            <a href=showcart.jsp><button class='button'>Your Cart &#128722</button></a>
		</p>
		<br>
	</header>

<form method="get" action="order.jsp">
    <table>
    <tr><td>Customer ID:</td><td><input type="text" name="customerId" size="30" class="input2"></td></tr>
    <tr><td>Password:</td><td><input type="password" name="password" size="30" class="input2"></td></tr>
    <tr><td><input type="submit" value="Submit"></td><td><input type="reset" value="Reset"></td></tr>
    </table>
</form>

</body>
</html>

