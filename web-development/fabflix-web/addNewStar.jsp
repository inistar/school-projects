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
div{
	text-align: center;
}

img {
    padding-top: 10px;
    padding-right: 10px;
    padding-bottom: 10px;
    padding-left: 10px;
    height: 80px;
    width: 30%;
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

.g-recaptcha{
	text-align: center;
}

.form-group{
	text-align: right;
    margin-right: 30%;
}

.weblinks{
	text-align: right;
}
</style>

<body>	
    <div>
        <img src="Fabflix Logo.png" class="media-object">
        <div class="weblinks">
        <a class="weblinks" href="addNewMovie.jsp" >Add New Movie</a>|
        <a class="weblinks" href="metadata.jsp" >MetaData</a>|
	    <a class="weblinks" href="_dashboard.jsp" >Logout</a>
	    </div>
    </div>
    <hr></hr>
    <div class="login-box">
        <h3>Add New Star to DB</h3>
        <form action="addNewStar.jsp" method="POST" >
            <div class="form-group">
            <label for="firstlast">First and Last Name:</label>
            <input type="text" class="form-control" name = "firstlast" id="firstlast" placeholder="Enter first and last name">
            </div>
            <div class="form-group">
            <label for="dob">DOB:</label>
            <input type="text" class="form-control" name ="dob" id="dob" placeholder="yyyy/mm/dd">
            </div>
   			<div class="form-group">
            <label for="photourl">Photo URL:</label>
            <input type="text" class="form-control" name ="photourl" id="photourl" placeholder="Enter Photo URL">
            </div>
            <button type="submit" class="btn btn-default">ADD</button>
        </form>
    </div>

<%
try{
	HttpSession cookie = request.getSession(false);
		

	
	String name = request.getParameter("firstlast");
	String dob = request.getParameter("dob");
	String photoURL = request.getParameter("photourl");
	
	if(name != null && dob != null && name != "" && dob != ""){
			
		try{
	    	String[] firstLast = name.split(" ");
	    	
	    	if(dob.equals(""))
	    		dob = "NULL";
	    	else{
	    		dob = "'" + dob + "'";
	    	}
	    	
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
			
	    	int result;
	    	String sqlQuery;
	    	
	    	if(firstLast.length == 1)
	    		sqlQuery= "INSERT INTO stars(first_name, last_name, dob, photo_url) VALUES('','" + firstLast[0] + "'," + dob + ",'" + photoURL + "');";
	    	else
	    		sqlQuery = "INSERT INTO stars(first_name, last_name, dob, photo_url) VALUES('" + firstLast[0] + "','" + firstLast[1] + "'," + dob + ",'" + photoURL + "');";
	    		
	    	result = select.executeUpdate(sqlQuery);
	    	
	    	if(result == 0)
	    		out.println("<script> alert(\"Insert Failed\");</script>");
	    	else
	    		out.println("<script> alert(\"Insert Passed\");</script>");
	    	
	    	connection.close();
		}catch(Exception e){
			out.println("<script> alert(\"Insert Failed\");</script>");
		}
	}
	else{
		if(cookie.getAttribute("firstTimeStar").equals("false"))
    		out.println("<script> alert(\"Insert Failed\");</script>");
	}
	
	cookie.setAttribute("firstTimeStar", "false");
	cookie.setAttribute("firstTimeMovie", "true");
}catch(Exception e){
	System.out.println("Error");
}
%>

</body>
</html>
