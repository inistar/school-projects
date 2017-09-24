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
    
    <div class="weblinks" >
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
    <a class="weblinks" href="main.jsp?fromOtherPages=true" id="browse">Home</a>|
    <a class="weblinks" href="search.jsp" >Advanced Search</a>|
    <a class="weblinks" href="theCart.jsp" >My Cart</a>
    </div>
</div>

<hr></hr>

<div class="genre">
<h3>Browse By Movie Genre</h3>




<%
try{
HttpSession cookie = request.getSession(false);

ArrayList<ArrayList<Object>> outerCart = new ArrayList<ArrayList<Object>>();
if (request.getParameter("fromOtherPages") == null)
	cookie.setAttribute("cart", outerCart);


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
	
	ResultSet result = select.executeQuery("SELECT * FROM genres order by name;");
	ArrayList<String> genres = new ArrayList<String>();
	
	while(result.next()){
		genres.add(result.getString(2));
	}

	for(int i = 0; i < genres.size(); i++){
		//String query = "SELECT * FROM movies INNER JOIN genres_in_movies on genres_in_movies.movie_id = movies.id INNER JOIN genres on genres_in_movies.genre_id = genres.id WHERE genres.name = '" + genres[i] + "'";
		out.println("<a href=\"movieList.jsp?t=" + Math.random()+"&purpose=searchGenre&offset=0&numberOfPages=10&genres="+genres.get(i)+"\">" + genres.get(i) + " |</a>");
	}
	
connection.close();
}catch(Exception e){
	System.out.println("Error");
}
%>

</div>


<div class="title">
<h3>Browse By Movie Title</h3>
<%
try{
String[] title = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", 
		"U", "V", "W", "X", "Y", "Z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"};

	for(int i = 0; i < title.length; i++){
		//String query = "SELECT * FROM movies WHERE (title LIKE '" + title[i] + "%25' )";
		//out.println("<a href=\"movieList.jsp?t=" + Math.random()+"&query="+query+"\">" + title[i] + " |</a>");
		out.println("<a href=\"movieList.jsp?t=" + Math.random()+"&purpose=searchLetter&offset=0&numberOfPages=10&letter="+title[i]+"\">" + title[i] + " |</a>");
	}
}catch(Exception e){
	System.out.println("Error");
}
	%>

 </div>
</body>
</html>
