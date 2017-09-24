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

<%

HttpSession cookie = request.getSession(false);



String bought = Integer.toString((Integer)cookie.getAttribute("bought"));
out.println("<h2>Congratulations, you have bought " + bought + " items<h2>");
ArrayList<ArrayList<Object>> outerCart = new ArrayList<ArrayList<Object>>();
cookie.setAttribute("cart", outerCart);

%>
</body>
</html>