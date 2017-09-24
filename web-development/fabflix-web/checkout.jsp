<%@page import="java.sql.*,
javax.sql.*,
java.io.IOException,
javax.servlet.http.*,
javax.servlet.*, 
java.util.ArrayList,
java.util.Date,
java.text.DateFormat,
java.text.SimpleDateFormat,
javax.naming.InitialContext,
javax.naming.Context,
javax.sql.DataSource"
%>

<html>
<style>
img {
    padding-top: 10px;
    padding-right: 10px;
    padding-bottom: 10px;
    padding-left: 10px;
    height: 55px;
    width: 20%;
}

hr {
	background-color: black; 
	height: 1px; 
	border: 0; 
}

body{
	background-color: #33BDFF;
	font-family: Arial, Helvetica, sans-serif;
    font-weight: bold;
}

input[type=text] {
    width: 50%;
    padding: 12px 20px;
    margin: 8px 0;
    display: inline-block;
    border: 1px solid #ccc;
    box-sizing: border-box;
}

.payment-box{
	background-color: white;
    border-style: solid;
    border: 2px solid;
    border-radius: 8px;
    margin-top: 50px;
    margin-bottom: 50px;
    margin-right: 15%;
    margin-left: 15%;
}

.form-group{
	text-align: right;
    margin-right: 30%;
}
.weblinks{
	text-align: right;
	font-family: Arial, Helvetica, sans-serif;
}
</style>
<body>

<div class="media-left media-top">
    <img src="Fabflix Logo.png" class="media-object">
    <div class="weblinks">
    <a class="weblinks" href="main.jsp?fromOtherPages=true" id="browse">Home</a>|
    <a class="weblinks" href="search.jsp" >Advanced Search</a>|
    <a class="weblinks" href="theCart.jsp" >My Cart</a>|
    <a class="weblinks" href="login.jsp" >Logout</a>
    </div>
</div>
<hr></hr>
<div class="payment-box">
	<h3> CHECKOUT</h3>
	<form action="checkout.jsp" method="POST">
	<div class="form-group">
	<label for="firstname">Firstname:</label>
	<input type="text" class="form-control" name="firstname" id="firstname" placeholder="firstname">
	</div>
	<div class="form-group">
	<label for="lastname">Lastname:</label>
	<input type="text" class="form-control" name="lastname" id="lastname" placeholder="lastname">
	</div>
	<div class="form-group">
	<label for="creditcard">Credit Card:</label>
	<input type="text" class="form-control" name="creditcard" id="creditcard" placeholder="creditcard">
	</div>
	<div class="form-group">
	<label for="expirationdate">Expiration Date:</label>
	<input type="text" class="form-control" name="expirationdate" id="expirationdate" placeholder="expirationdate">
	</div>
	<button type="submit" align="middle" class="btn btn-default">Submit</button>
	</form>
</div>
<%
try{
HttpSession cookie = request.getSession(false);

	String firstname = request.getParameter("firstname");
	String lastname = request.getParameter("lastname");
	String creditcard = request.getParameter("creditcard");
	String expirationdate = request.getParameter("expirationdate");
	
	if(firstname != null && lastname != null && creditcard != null && expirationdate != null){
		Class.forName("com.mysql.jdbc.Driver").newInstance();
		Context initCtx = new InitialContext();
		if (initCtx == null)
		    out.println("initCtx is NULL");

		Context envCtx = (Context) initCtx.lookup("java:comp/env");
		if (envCtx == null)
		    out.println("envCtx is NULL");
		DataSource ds = (DataSource) envCtx.lookup("jdbc/TestDB");
		if (ds == null)
		    out.println("ds is null.");

		Connection connection = ds.getConnection();

		if (connection == null)
		    out.println("dbcon is null.");
		Statement select = connection.createStatement();
		
		ResultSet result = select.executeQuery("SELECT count(*) FROM creditcards WHERE first_name ='" + firstname + "' and last_name='" + lastname + "' and id='" + creditcard + "' and expiration='" + expirationdate + "'");
		result.next();
		
		if(result.getInt(1) == 0){
			out.println("<script>alert(\"Transaction Failed\");</script>");
		}
		else{
			//out.println("Working");
			
			
			ResultSet userResult = select.executeQuery("SELECT customers.id FROM customers WHERE email='" + cookie.getAttribute("username") + "' and password='" + cookie.getAttribute("password") + "'");
			userResult.next();
			
			Integer customerID = new Integer(userResult.getInt(1));
			DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd");
			Date date = new Date();
			
			int original = 0;
			int bought = 0;
			ArrayList<ArrayList<Object>> outerCart = (ArrayList<ArrayList<Object>>) cookie.getAttribute("cart");
			for (ArrayList<Object> innerCart: outerCart)
			{
				//out.println(innerCart.get(0));
				original++;
				String sqlQuery = "INSERT INTO sales(customer_id, movie_id, sale_date) VALUES (" + customerID + ", " + innerCart.get(0) + ", '" + dateFormat.format(date) + "');";
				int resultFinal = select.executeUpdate(sqlQuery);
		    	
		    	if(resultFinal != 0)
		    	{
		    		bought++;
		    	}
			}
			
			if(original == bought){
				cookie.setAttribute("bought", bought);
				response.sendRedirect("confirmationPage.jsp");
			}
			
		}
		connection.close();
	}
}catch(Exception e){
	out.println("<script>alert(\"Transaction Failed\");</script>");
	System.out.println("Error");
}
%>
</body>
</html>
