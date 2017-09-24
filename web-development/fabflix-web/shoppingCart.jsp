<%@page import="java.sql.*,
javax.sql.*,
java.io.IOException,
javax.servlet.http.*,
javax.servlet.*"
%>
<%@ page import="java.util.ArrayList" %>

<html>
<h1> This is a heading</h1>
<head>
<script>

var newWin = window.open();
$.ajax
({
    type: "GET",           
    data: "input=" + $('#username').val(),
    url: url,
    success: function(data){
        newWin.document.write(data);
        newWin.document.close();
        newWin.focus();
        newWin.print();
        newWin.close();
    }
    ,error: function() {
    }
});
</script>
</head>
<body>
<button type="button" onclick="loadDoc()">Request data</button>

<p id="demo">testing</p>
 
<script>
function loadDoc() {
  var xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
      document.getElementById("demo").innerHTML = this.responseText;
    }
  };
  xhttp.open("POST", "demo_post2.asp", true);
  xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
  xhttp.send("fname=Henry&lname=Ford");
}
</script>
</body>
<body  onload="checkCookie()">

<%
try{
HttpSession cookie = request.getSession(false);

	
	ArrayList<ArrayList<Object>> outerCart = (ArrayList<ArrayList<Object>>) cookie.getAttribute("cart");
	//out.println(outerCart.toString());
	//outCart.add(new Arraylist)
	out.println("<ul>");
	
	for(ArrayList<Object> innerCart : outerCart){
		
		out.println("<li>" + innerCart.get(0) + " <form action=\"shopptingCart.jsp\" method=\"POST\">" + 
		"<input type=\"text\" value=\"" + innerCart.get(1) + "\"> </form></li>");
	}
	
	out.println("</ul>");
}catch(Exception e){
	System.out.println("Error");
}
%>
</body>
</html>