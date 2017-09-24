<%@page import="java.sql.*,
javax.sql.*,
java.io.IOException,
javax.servlet.http.*,
javax.servlet.*,
javax.naming.InitialContext,
javax.naming.Context,
javax.sql.DataSource"
%>

<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
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
        <h3>New Employee Information</h3>
        <form action="newEmployee.jsp" method="POST" >
            <div class="form-group">
            <label for="username">Email:</label>
            <input type="text" class="form-control" name = "username" id="username" placeholder="Enter email">
            </div>
            <div class="form-group">
            <label for="pwd">Password:</label>
            <input type="password" class="form-control" name ="password" id="pwd" placeholder="Enter password">
            </div>
            <div class="form-group">
            <label for="pwd">Full Name:</label>
            <input type="text" class="form-control" name ="fullname" id="fullname" placeholder="Enter full name">
            </div>
   
            <button type="submit" class="btn btn-default">Register</button>
        </form>
    </div>

<%
try{
	
	String username = request.getParameter("username");
	String password = request.getParameter("password");
	String fullname = request.getParameter("fullname");
	
	System.out.println(":" + username + " " + password + ":");
	int result = 0;
	
	if(username != null && password != null && username != "" && password != ""){
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
		
		Statement select = connection.createStatement();
		
		try{
		result = select.executeUpdate("INSERT INTO employees(email, password, fullname) VALUES ('" + username + "', '" + password + "', '" + fullname + "');");
		}catch(Exception e){
			out.println("<script> alert(\"Insert Failed\");</script>");
		}
		
		if(result != 0){
			out.println("<script> alert(\"Insert Passed\");</script>");
			response.sendRedirect("_dashboard.jsp");
		}
		else
			out.println("failed");
			out.println("<script> alert(\"Insert Failed\");</script>");
			
			connection.close();
	}
}catch(Exception e){
	System.out.println("Error");
}
%>

</body>
</html>
