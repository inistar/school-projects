<%@page import="java.sql.*,
javax.sql.*,
java.io.IOException,
javax.servlet.http.*,
javax.servlet.*,
javax.naming.InitialContext,
javax.naming.Context,
javax.sql.DataSource"
%>
<%@ page import="java.util.ArrayList" %>
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
    height: 55px;
    width: 20%;
}

hr {
	background-color: black; 
	height: 1px; 
	border: 0; 
}

.form-group{
	text-align: right;
    margin-right: 30%;
}
body{
	background-color: #33BDFF;
	font-family: Arial, Helvetica, sans-serif;
    font-weight: bold;
    text.align: right;
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
    text-align: center;
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
        <a class="weblinks" href="addNewStar.jsp" >Add New Star</a>|
	    <a class="weblinks" href="_dashboard.jsp" >Logout</a>
	    </div>
    </div>
    <hr></hr>
    <div class="login-box">
        <h3>Metadata Information</h3>
        <hr></hr>
        
    

<%
try{
	HttpSession cookie = request.getSession(false);
	
	cookie.setAttribute("firstTimeStar", "true");
	cookie.setAttribute("firstTimeMovie", "true");
try{
	ArrayList<String> tables = new ArrayList<String>();
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
	
	int index = 0;
	DatabaseMetaData m = connection.getMetaData();
	ResultSet tab = m.getTables(null, null, "%", null);
	while (tab.next()) {
	  tables.add(tab.getString(3));
	}
	
	
	for(int j = 0; j < tables.size(); j++){
    	ResultSet result = select.executeQuery("SELECT * FROM " + tables.get(j));
    	
    	ResultSetMetaData metadata = result.getMetaData();
    	
    	out.println("<b>" + tables.get(j) + ": " + metadata.getColumnCount() + " columns</b><br><br>");
    	
    	for(int i = 1; i <= metadata.getColumnCount(); i++){
    		out.println(metadata.getColumnName(i) + ": " + metadata.getColumnTypeName(i) + "<br>");
    	}
    	
    	out.println("<hr></hr>");
	}
	
	connection.close();
	}catch(Exception e){
	System.out.println("Metadata failed");
}
}catch(Exception e){
	System.out.println("Error");
}
%>
</div>
</body>
</html>
