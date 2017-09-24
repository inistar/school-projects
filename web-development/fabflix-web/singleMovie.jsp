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
}

.weblinks{
	text-align: right;
	font-family: Arial, Helvetica, sans-serif;
}

.single-movie{
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
<div class="single-movie">
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

	if (request.getParameter("movieID") != null)
	{
		String movieSQL = "SELECT * from movies WHERE id=" + request.getParameter("movieID") ;
		Statement select = connection.createStatement();
		ResultSet movieResult = select.executeQuery(movieSQL);
		out.println("<br>");
		while(movieResult.next()){
			out.println("<img align=\"center\" class=\"movie-image\" src=\""+movieResult.getString(5)+"\"><br>");
			out.println("	ID:"+ movieResult.getString(1) +"<br>");
			out.println("	TITLE:"+ movieResult.getString(2)+"<br>");
			out.println("	YEAR:"+ movieResult.getString(3)+"<br>");
			out.println("	DIRECTOR:"+ movieResult.getString(4)+"<br>");
			out.println("TRAILER URL:<a href=\""+ movieResult.getString(6)+"\">Click To See Trailer</a><br>");
			break;
		}
			
		String starSQL = "SELECT stars.id, stars.first_name, stars.last_name from stars_in_movies, stars WHERE stars_in_movies.movie_id=" + request.getParameter("movieID") + " AND stars_in_movies.star_id=stars.id";
		Statement selectStar = connection.createStatement();
		ResultSet starResult = selectStar.executeQuery(starSQL);
		out.print("STARS: ");
		while(starResult.next()){
			out.print("<a href=\"singleStar.jsp?starID="+ starResult.getInt(1) +"\">"+starResult.getString(2)+" "+starResult.getString(3)+"</a>");
			break;
		}
		while(starResult.next())
		{
			out.print(", " + "<a href=\"singleStar.jsp?starID=" + starResult.getInt(1) +"\">" + starResult.getString(2)+" "+starResult.getString(3)+"</a>");
		}
		
		String genreSQL = "SELECT genres.name FROM genres_in_movies, genres WHERE genres_in_movies.movie_id=" + request.getParameter("movieID") + " AND genres_in_movies.genre_id=genres.id";
		Statement selectGenre = connection.createStatement();
		ResultSet genreResult = selectStar.executeQuery(genreSQL);
		
		out.println("<br>GENRE: ");
		String query; 
		while(genreResult.next()){

			out.println("<a href=\"movieList.jsp?t=" + Math.random()+"&genres="+genreResult.getString(1)+"\">" + genreResult.getString(1) + " </a>");
			break;
		}
		while (genreResult.next())
		{

			out.println(", <a href=\"movieList.jsp?t=" + Math.random()+"&genres="+genreResult.getString(1)+"\">" + genreResult.getString(1) + " </a>");

		}
		

		out.println("<br><a href=\"theCart.jsp?addSingleMovie=true&movieID="+movieResult.getString(1)+"&movieTitle="+movieResult.getString(2)+"&quantity=1\"><img src=\"addtocart.png\" width=\"300\" height=\"200\" /></a>");
	}

		connection.close();
		
}catch(Exception e){
	System.out.println("Error");
}
%>

</div>

</body>
</html>
