<%@page import="java.sql.*,
javax.sql.*,
java.io.IOException,
javax.servlet.http.*,
javax.servlet.*"
%>

<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <script src='https://www.google.com/recaptcha/api.js'></script>
</head>

<style>
img {
    padding-top: 10px;
    padding-right: 10px;
    padding-bottom: 10px;
    padding-left: 10px;
    height: 80px;
    width: 50%;
}

hr {
	background-color: black; 
	height: 1px; 
	border: 0; 
}

input[type=text], input[type=password] {
    width: 50%;
    padding: 12px 20px;
    margin: 8px 0;
    display: inline-block;
    border: 1px solid #ccc;
    box-sizing: border-box;
}

body{
	background-color: #33BDFF;
	font-family: Arial, Helvetica, sans-serif;
    font-weight: bold;
}

.login-box{
	background-color: white;
    border-style: solid;
    border: 2px solid;
    border-radius: 8px;
    margin-top: 50px;
    margin-bottom: 50px;
    margin-right: 15%;
    margin-left: 15%;
}

div{
	text-align: center;
    
}

.g-recaptcha{
	text-align: center;
}

.form-group{
	text-align: right;
    margin-right: 30%;
}
</style>

<body>	
    <div class="media-left media-top">
        <img src="Fabflix Logo.png" class="media-object">
    </div>
    <hr></hr>
    <div class="login-box">
        <h3>EMPLOYEE LOGIN</h3>
        <form action="/CS122B-Project2/servlet/TomcatFormReCaptchaEmployee" method="POST" >
            <div class="form-group">
            <label for="username">Email:</label>
            <input type="text" class="form-control" name = "username" id="username" placeholder="Enter username">
            </div>
            <div class="form-group">
            <label for="pwd">Password:</label>
            <input type="password" class="form-control" name ="password" id="pwd" placeholder="Enter password">
            </div>
            <div class="g-recaptcha" data-sitekey="6Ldf2RQUAAAAANltNGAlw_R2tybEXQOEQVmZ2FQ1"></div>
            <button type="submit" class="btn btn-default">Submit</button>
        </form>
        <form action="newEmployee.jsp"  method="POST">
        	<div class="form-group">
        	<button type="submit" class="btn btn-default">Register New Employee</button>
        	</div>
        </form>
    </div>

<%
	try{
	HttpSession cookie = request.getSession(false);
	if(cookie.getAttribute("error") != null){
		if(cookie.getAttribute("error").equals("recaptcha"))
			out.println("<script> alert(\"Error with ReCaptcha\");</script>");
		else if(cookie.getAttribute("error").equals("password"))
			out.println("<script> alert(\"Wrong Username or Password\");</script>");
	}
	cookie.setAttribute("error", "none");
	cookie.setAttribute("firstTimeStar", "true");
	cookie.setAttribute("firstTimeMovie", "true");
	}catch(Exception e){
		System.out.println("Error");
	}
%>

</body>
</html>
