<%@page import="java.sql.*,
javax.sql.*,
java.io.IOException,
javax.servlet.http.*,
javax.servlet.*, 
java.util.ArrayList"
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

.weblinks{
	text-align: right;
	font-family: Arial, Helvetica, sans-serif;
}

.cart-box{
	background-color: white;
    border-style: solid;
    border: 2px solid;
    border-radius: 8px;
    margin-top: 50px;
    margin-bottom: 50px;
    margin-right: 15%;
    margin-left: 15%;
}

input[type=submit]{
    width: 50%;
    padding: 12px 20px;
    margin: 8px 0;
    display: inline-block;
    border: 1px solid #ccc;
    box-sizing: border-box;
}

.quantity-box{
	text-align: right;
}

.total-price{
	text-align: right;
}
</style>
<body>

<div class="media-left media-top">
    <img src="Fabflix Logo.png" class="media-object">
    <div class="weblinks">
    <a class="weblinks" href="main.jsp?fromOtherPages=true" >Home</a>|
    <a class="weblinks" href="search.jsp" >Advanced Search</a>|
    <a class="weblinks" href="theCart.jsp" >My Cart</a>|
    <a class="weblinks" href="login.jsp" >Logout</a>
    </div>
</div>

<hr></hr>

<div class="cart-box">
<form action="theCart.jsp" method="POST">
  
<%
try{
HttpSession cookie = request.getSession(false);


ArrayList<ArrayList<Object>> outerCart = (ArrayList<ArrayList<Object>>) cookie.getAttribute("cart");
ArrayList<Integer> positionToRemove = new ArrayList<Integer>();
if (request.getParameter("addSingleMovie") != null)
{
	boolean flag = true;
	for (int i =0; i < outerCart.size(); i++)
	{
		if (((String)outerCart.get(i).get(0)).equals(request.getParameter("movieID")))
		{
			flag = false;
			outerCart.get(i).set(2, Integer.toString(Integer.parseInt((String)outerCart.get(i).get(2))+1));
			break;
		}
	}
	if (flag == true){
		ArrayList<Object> innerCart = new ArrayList<Object>();
		innerCart.add(new String(request.getParameter("movieID")));
		innerCart.add(new String(request.getParameter("movieTitle")));
		innerCart.add(new String(request.getParameter("quantity")));
		outerCart.add(innerCart);
	}
}
else{
	if (request.getParameter("updateRequest") != null)
	{
		for (int i =0; i < outerCart.size(); i++)
		{
			if (request.getParameter((String)outerCart.get(i).get(0)) != null)
			{
				
				outerCart.get(i).set(2, request.getParameter((String)outerCart.get(i).get(0)));
				if (((String)outerCart.get(i).get(2)).equals("0"))
				{
					positionToRemove.add(i);
				}
			}
		}
		for (int element: positionToRemove)
		{
			outerCart.remove(element);
		}
		cookie.setAttribute("cart", outerCart);
	}
}

Integer quantity = new Integer(0);

for (ArrayList<Object> innerCart: outerCart)
{
	out.println(innerCart.get(1)  + "<div class=\"quantity-box\"> $5 <input type=\"text\" name=\"" + innerCart.get(0) + "\" value=\""+innerCart.get(2)+"\" size=\"3\" style=\"text-align:center;\"></div><br>" );
	out.println("<hr></hr>");
	quantity = quantity + Integer.parseInt((String)innerCart.get(2));
}

out.println("<div>");
out.println("<input type=\"hidden\" name=\"updateRequest\" value=\"true\">");
out.println("<input type=\"submit\" value=\"Update\">");

out.println("<p align=\"right\"> Total: $" + quantity*5 + "   </p>");
out.println("</div>");
}catch(Exception e){
	System.out.println("Error");
}
%>

</form>

<form action="checkout.jsp" method="POST">
<input type="submit" value="Checkout">
</form>
</div>
</body>
</html>

