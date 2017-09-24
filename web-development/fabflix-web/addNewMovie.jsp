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

.weblinks{
	text-align: right;
}

</style>

<body>	
    <div>
        <img src="Fabflix Logo.png" class="media-object">
        <div class="weblinks">
        <a class="weblinks" href="addNewStar.jsp" >Add New Star</a>|
        <a class="weblinks" href="metadata.jsp" >MetaData</a>|
	    <a class="weblinks" href="_dashboard.jsp" >Logout</a>
	    </div>
    </div>
    <hr></hr>
    <div class="login-box">
        <h3>Add New Movie to DB</h3>
        <form action="addNewMovie.jsp" method="POST" >
            <div class="form-group">
            <label for="title">Title:</label>
            <input type="text" class="form-control" name = "title" id="title" placeholder="Enter movie title">
            </div>
            <div class="form-group">
            <label for="year">Year:</label>
            <input type="text" class="form-control" name ="year" id="year" placeholder="yyyy">
            </div>
   			<div class="form-group">
            <label for="director">Director:</label>
            <input type="text" class="form-control" name ="director" id="director" placeholder="Enter Director">
            </div>
            <div class="form-group">
            <label for="bannerurl">Banner URL:</label>
            <input type="text" class="form-control" name ="bannerurl" id="bannerurl" placeholder="Enter Banner Url">
            </div>
            <div class="form-group">
            <label for="trailerurl">Trailer URL:</label>
            <input type="text" class="form-control" name ="trailerurl" id="trailerurl" placeholder="Enter Trailer Url">
            </div>
            <div class="form-group">
            <label for="firstname">Star First Name:</label>
            <input type="text" class="form-control" name ="firstname" id="firstname" placeholder="Enter Star First Name">
            </div>
            <div class="form-group">
            <label for="lastname">Star Last Name:</label>
            <input type="text" class="form-control" name ="lastname" id="lastname" placeholder="Enter Star Last Name">
            </div>
            <div class="form-group">
            <label for="dob">Star DOB:</label>
            <input type="text" class="form-control" name ="dob" id="dob" placeholder="yyyy/mm/dd">
            </div>
            <div class="form-group">
            <label for="photourl">Photo URL:</label>
            <input type="text" class="form-control" name ="photourl" id="photourl" placeholder="Enter Photo Url">
            </div>
            <div class="form-group">
            <label for="genre">Genre:</label>
            <input type="text" class="form-control" name ="genre" id="genre" placeholder="Enter Genre Name">
            </div>
            <button type="submit" class="btn btn-default">ADD</button>
        </form>
    </div>

<%
	try{
	HttpSession cookie = request.getSession(false);
	

	
	String title = request.getParameter("title");
	String year = request.getParameter("year");
	String director = request.getParameter("director");
	String bannerurl = request.getParameter("bannerurl");
	String trailerurl = request.getParameter("trailerurl");
	String firstname = request.getParameter("firstname");
	String lastname = request.getParameter("lastname");
	String dob = request.getParameter("dob");
	String photourl = request.getParameter("photourl");
	String genre = request.getParameter("genre");

	if(title != null){
		try{
			
			   	
			   	String sqlQuery = "call add_movie(?,?,?,?,?,?,?,?,?,?,?)";
			   	Class.forName("com.mysql.jdbc.Driver").newInstance();
				
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
				CallableStatement statement = connection.prepareCall(sqlQuery);
				
				statement.setString(1, title);
				statement.setInt(2, Integer.parseInt(year));
				statement.setString(3, director);
				statement.setString(4, bannerurl);
				statement.setString(5, trailerurl);
				statement.setString(6, firstname);
				statement.setString(7, lastname);
				statement.setString(8, dob);
				statement.setString(9, photourl);
				statement.setString(10, genre);
				statement.registerOutParameter(11, Types.INTEGER);
			   	
			   	int exe = statement.executeUpdate();
			   	
			   	Integer result = statement.getInt(11);
			   	
			 	System.out.println(exe + " " + result);
			 	
			   	if(exe == 0 || result != 999)
			   		out.println("<script> alert(\"Insert Failed\");</script>");
			   	else
			   		out.println("<script> alert(\"Insert Passed\");</script>");
			
			   	connection.close();
		}catch(Exception e){
			out.println("<script> alert(\"Insert Failed\");</script>");
			e.printStackTrace();
		}
	}
	else{
		if(cookie.getAttribute("firstTimeMovie").equals("false"))
	   		out.println("<script> alert(\"Insert Failed\");</script>");
	}
	cookie.setAttribute("firstTimeStar", "true");
	cookie.setAttribute("firstTimeMovie", "false");
	}catch(Exception e){
		System.out.println("Error");
	}
%>

</body>
</html>
