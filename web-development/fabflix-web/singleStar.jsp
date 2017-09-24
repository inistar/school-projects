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
<style>
img {
    padding-top: 10px;
    padding-right: 10px;
    padding-bottom: 10px;
    padding-left: 10px;
    height: 55px;
    width: 20%;
}

.movie-image{
	height: 400px;
    width: 280px;
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
    alighn-text: center;
}

.weblinks{
	text-align: right;
	font-family: Arial, Helvetica, sans-serif;
}

P{
	align-text: center;
}
.single-star{
	background-color: white;
    border-style: solid;
    border: 2px solid;
    border-radius: 8px;
    margin-top: 50px;
    margin-bottom: 50px;
    margin-right: 15%;
    margin-left: 15%;
    aligh-text: center;
}

</style>

<style>
.suggestionBox {
    position: relative;
    display: inline-block;
  
    
}

.suggestionBox-content {
    display: none;
    position: absolute;
    background-color: #f9f9f9;
    min-width: 160px;
    box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
    padding: 12px 16px;
    z-index: 1;
    border-radius: 5px;
    border: 2px solid #1664B0;
    text-align: left;   
}

.suggestionBox:hover .suggestionBox-content {
    display: block;
}



#buttonField:hover {
    background: #409FFB;
    text-align: left;   
}
</style>

<script>
function changeInputValue(movieID)
{
	document.getElementById("inputID").value = movieID.replace("&&&&","'");
}
function getMovieSuggestions(keyword)
{
	
	 var url="/CS122B-Project2/getMovieSuggestions.jsp?t=" + Math.random() + "&keyword="+keyword;
	 var tempArray;
	 var subArray;
	 var stringForGUI="";
	 
	 if(window.XMLHttpRequest){  
			request=new XMLHttpRequest();  
		}  
		else if(window.ActiveXObject){  
			request=new ActiveXObject("Microsoft.XMLHTTP");  
		}  
	 try  
		{  
			request.onreadystatechange=function(){
				if (this.readyState == 4 && this.status == 200){	
					tempArray = request.responseText.split("|");
					
					if (tempArray != null){
						
						for (var i =1; i< tempArray.length-1; i++)
						{
							
							stringForGUI += "<p id=\"buttonField\" onclick=\"changeInputValue('"+tempArray[i].trim().replace("'","&&&&")+"')\">" + tempArray[i] + "</p>";
						
						}
						
						
						}
					document.getElementById("movieList").innerHTML = stringForGUI;
				}
			};
			request.open("GET",url,true);  
			request.send();  
		}  
		catch(e)  
		{  
			alert("Cannot connect to server");  
		} 
	
}



</script>
<body>

<div class="media-left media-top">
    <img src="Fabflix Logo.png" class="media-object">
    <div class="weblinks">
    <div class="suggestionBox">
  <form action="/CS122B-Project2/movieList.jsp" method="get">
	<input type="text" size="30" onkeyup="getMovieSuggestions(this.value)" id="inputID" name="fullSearchInput" >
	<input type="hidden" name="numberOfPages" value="10" />
	<input type="hidden" name="offset" value="0" />
	<input type="hidden" name="purpose" value="fullTextSearch" />
	<input type="submit" value="Search" >
	</form>
  <div class="suggestionBox-content">
    <span id="movieList"></span>
  </div>
	</div><br>
    <a class="weblinks" href="main.jsp?fromOtherPages=true" >Home</a>|
    <a class="weblinks" href="search.jsp" >Advanced Search</a>|
    <a class="weblinks" href="theCart.jsp" >My Cart</a>|
    <a class="weblinks" href="login.jsp" >Logout</a>
    </div>
</div>

<hr></hr>
<div class="single-star">
<%
try{
HttpSession cookie = request.getSession(false);

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
	if (request.getParameter("starID") != null)
	{
		String starSQL = "SELECT * from stars WHERE id=" + request.getParameter("starID")+";" ;
		Statement select = connection.createStatement();
		ResultSet starResult = select.executeQuery(starSQL);
		
		String starInMovie = "SELECT movies.id, movies.title FROM movies, stars_in_movies WHERE movies.id = stars_in_movies.movie_id and stars_in_movies.star_id = " + request.getParameter("starID")+";";
		Statement starInMovieSelect = connection.createStatement();
		ResultSet starMovieResult = starInMovieSelect.executeQuery(starInMovie);
		while(starResult.next())
		{
			out.println("<p>");
			out.println("<img class=\"movie-image\" src=\""+starResult.getString(5)+"\"><br>");
			//out.println("<img src=\"https://scontent-lax3-1.xx.fbcdn.net/v/t1.0-0/q83/p75x225/12360291_1141600069184320_8149719078830876276_n.jpg?oh=f1124f088598d8e96d60a3bc707b2d27&oe=5915CE35\" align=\"left\">");
			out.println("STAR NAME: " + starResult.getString(2) + " " + starResult.getString(3)+"<br>");
			out.println("DATE OF BIRTH: "+ starResult.getDate(4)+"<br>");
			out.println("STAR ID: " + starResult.getInt(1)+"<br>");
			break;
		}
		while(starMovieResult.next()){
			out.print("STARRED IN: " + "<a href=\"singleMovie.jsp?movieID="+ starMovieResult.getInt(1) +"\">"+starMovieResult.getString(2) + "</a>");
			break;
		}
		while (starMovieResult.next())
		{
			out.print(", "+ "<a href=\"singleMovie.jsp?movieID="+ starMovieResult.getInt(1) +"\">"+starMovieResult.getString(2) + "</a>");	
		}
		out.println("<p>");
	}
	connection.close();
		
}catch(Exception e){
	System.out.println("Error");
}
%>
</div>
</body>
</html>