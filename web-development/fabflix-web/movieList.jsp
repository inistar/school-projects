<%@page import="java.sql.*,
javax.sql.*,
java.io.IOException,
javax.servlet.http.*,
javax.servlet.*,
javax.naming.InitialContext,
javax.naming.Context,
javax.sql.DataSource"
%>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.io.BufferedWriter" %>
<%@ page import="java.io.FileWriter" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.io.*"  %>

<html>




<!-- Need to modify -->
<style>


theBox {
    display: none;
    border:2px solid #000;
    width: 400px;
    margin-left: 50%;
    font-size: 150%
}

a:hover + theBox {
    display: block;
  } 
.smallBox {
    display:none;
    width:100%;
    height:100%;
    top:0; left:0;
    text-align:center;
    border-style: solid;
    color:black;
}
.thePicture {
    position:relative;
    display:table;
}
.thePicture:hover .smallBox {
    display:block;

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


<!-- NEED to modify -->
<script>  
var request; 
function communicator(movieID, movieTitle)  
{  
	 
	var url="addItem.jsp?t=" + Math.random()+"&movieID="+movieID+"&movieTitle="+movieTitle;  
	  
	if(window.XMLHttpRequest){  
		request=new XMLHttpRequest();  
	}  
	else if(window.ActiveXObject){  
		request=new ActiveXObject("Microsoft.XMLHTTP");  
	}  
	  
	try  
	{  
		request.open("GET",url,true);  
		request.send();  
	}  
	catch(e)  
	{  
		alert("Cannot connect to server");  
	}  
}  

function displayCart(allMovieID)
{
	var currentID = [];
	var tempArray = allMovieID;
	var tempStr = "";
	var cartOutput = "";
	var url="addItem.jsp?t=" + Math.random() + "&showCart=true";
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
				tempArray = request.responseText;
				var splitArray = allMovieID.split(",")
				tempArray = (request.responseText).split("|");
				var innerArray = [];
				for (var i =0; i< tempArray.length-1; i++)
				{
					innerArray = tempArray[i].split("%20");
					currentID.push(innerArray[0]);
					cartOutput += innerArray[1] +":"+ innerArray[2]+"<br>";
				}
				for (var i =0; i< splitArray.length; i++)
				{
					document.getElementById("item"+i).innerHTML = cartOutput;
				}
					
					
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
var dict = {};
 function getMovieInfo(movieID)
 {
	 if ((movieID in dict) == false){
		 var url="getSingleMovie.jsp?t=" + Math.random() + "&movieID="+movieID;
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
						
						document.getElementById(movieID).innerHTML = request.responseText;
						dict[movieID] = request.responseText;
							
							
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
	 else{
		 document.getElementById(movieID).innerHTML = dict[movieID];
	 }
 }
  
 
 
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


<!-- ------------------------------------------------------------ -->

<style>

img {
    padding-top: 10px;
    padding-right: 10px;
    padding-bottom: 10px;
    padding-left: 10px;
    height: 80px;
    width: 50%;
}

.movie-image{
	height: 400px;
    width: 280px;
}

.show-details{
	height: 50px;
	width: 50px;
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

.number-of-pages{
	text-align right;
}
.weblinks{
	text-align: right;   
	font-family: Arial, Helvetica, sans-serif;
}

.movie-button{
	text-align: center;
}

hr {
	background-color: black; 
	height: 1px; 
	border: 0; 
}

input[type=button] {
	align-text: center;
	background-color:green;
    width: 50%;
    padding: 12px 20px;
    margin: 8px 0;
    display: inline-block;
    border: 1px solid #ccc;
    box-sizing: border-box;
}

.sortingToolBar{
	background-color: white;
    border-style: solid;
    border: 2px solid;
    border-radius: 8px;
    margin-top: 20px;
    margin-bottom: 20px;
    margin-right: 40%;
    margin-left: 40%;
    text-align: center;
    font-family: Arial, Helvetica, sans-serif;
}

.movies{
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

</style>
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
     <a class="weblinks" href="main.jsp?fromOtherPages=true" >Home</a>|
    <a class="weblinks" href="search.jsp" >Advanced Search</a>|
    <a class="weblinks" href="theCart.jsp" >My Cart</a>|
    <a class="weblinks" href="login.jsp" >Logout</a>
    </div>
</div>

<hr></hr>


<%
long tempQuery = System.nanoTime();
long JDBCTime = 0;
long servletTime = 0;

String sqlStatement = "";
HttpSession cookie = request.getSession(false);

//Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/moviedb", "testuser", "testpass");
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
boolean nextFlag = true;
String offset ;
String numberOfPages;
Map<String, String> queryDict = new HashMap<String, String>();

try{	
	Object temp = cookie.getAttribute("preparedObject");
	if (temp == null)
	{
		queryDict = new HashMap<String, String>();
		String likeSQL = "SELECT movies.id, movies.title, movies.year, movies.director, movies.banner_url, movies.trailer_url FROM movies INNER JOIN stars_in_movies on stars_in_movies.movie_id = movies.id INNER JOIN stars on stars.id = stars_in_movies.star_id WHERE (last_name LIKE variable1 AND first_name LIKE variable2 AND title LIKE variable3 AND year LIKE variable4 AND director LIKE variable5 ) GROUP BY movies.id ";
		String letterSQL = "SELECT * FROM movies WHERE (title LIKE variable )";
		String genreSQL = "SELECT * FROM movies INNER JOIN genres_in_movies on genres_in_movies.movie_id = movies.id INNER JOIN genres on genres_in_movies.genre_id = genres.id WHERE genres.name = variable";
		String fullTextSQL = "SELECT * FROM movies WHERE title = variable ";
		String starSQL = "SELECT stars.id, stars.first_name, stars.last_name from stars_in_movies, stars WHERE stars_in_movies.movie_id=variable AND stars_in_movies.star_id=stars.id";
		String genreInfoSQL = "SELECT genres.name FROM genres_in_movies, genres WHERE genres_in_movies.movie_id=variable AND genres_in_movies.genre_id=genres.id";
		queryDict.put("searchPage", likeSQL);
		queryDict.put("searchLetter", letterSQL);
		queryDict.put("searchGenre", genreSQL);
		queryDict.put("fullTextSearch", fullTextSQL);
		queryDict.put("starInfo", starSQL);
		queryDict.put("genreInfo", genreInfoSQL);
		cookie.setAttribute("queryObject", (Object)queryDict );

	}
	else
	{
		queryDict = (Map<String, String>) cookie.getAttribute("queryObject");
		
		
	}
}
catch(Exception e)
{
	System.out.println("Error");
	e.printStackTrace();
}

%>
<form action="movieList.jsp" method="GET">
	<div class="number-of-pages">
	#RESULTS
	<select name="numberOfPages">
<%
Enumeration<String> paramFromPath1 = request.getParameterNames();

try{	
	
	//---------------Number Of Page Section ---------------
	
	String[] inputArray = {"10", "25", "50", "100"};
	if (request.getParameter("numberOfPages") != null)
	{
		for (int i = 0; i< inputArray.length; i++)
		{
			if (request.getParameter("numberOfPages").equals(inputArray[i]))
				out.println("<option value=\""+inputArray[i]+"\" selected=\"selected\">"+inputArray[i]+"</option>");
			else
				out.println("<option value=\""+inputArray[i]+"\">"+inputArray[i]+"</option>");
					
		}
	}
	else
	{
		out.println("<option value=\"10\">10</option>");
		out.println("<option value=\"25\">25</option>");
		out.println("<option value=\"50\">50</option>");
		out.println("<option value=\"100\">100</option>");
	}
}catch(Exception e){
	System.out.println("Error1");
}
%>
	
	</select>
	
<%

	String strNumPage = "";

	while (paramFromPath1.hasMoreElements())
	{
	    String param = paramFromPath1.nextElement();
	    if (param.equals("numberOfPages"))
	    	continue;
	    String[] paramValues = request.getParameterValues(param);
	    for (String value: paramValues) 
	    {
	    	out.println("<input type=\"hidden\" name=\"" +  param + "\" value=\"" + value + "\" />");
	    }
	    
	}
	

%>
	<input type="submit" value="Submit">
	</div>
</form>

<%


try{
	Enumeration<String> paramFromPath2 = request.getParameterNames();
	String str = "";
	while (paramFromPath2.hasMoreElements())
	{
	    String param = paramFromPath2.nextElement();
	    if (param.equals("titleAncestor") || param.equals("titleDescendant") || param.equals("yearAncestor") || param.equals("yearDescendant") || param.equals("offset"))
	    	continue;
	    String[] paramValues = request.getParameterValues(param);
	    for (String value: paramValues) 
	    {
	        str +=  param + "=" + value;
	    }
	    str = str + "&";
	}
	
	
	
	out.println("<div class=\"sortingToolBar\"> <a class=\"sorting\" href=\"movieList.jsp?titleAncestor=true&offset=0&"+ str.substring(0,str.length()-1)+"\">TitleASC</a>");
	out.println("<a class=\"sorting\" href=\"movieList.jsp?titleDescendant=true&offset=0&"+ str.substring(0,str.length()-1)+"\">TitleDSC</a>");
	out.println("<a class=\"sorting\" href=\"movieList.jsp?yearAncestor=true&offset=0&"+ str.substring(0,str.length()-1)+"\">YearASC</a>");
	out.println("<a class=\"sorting\" href=\"movieList.jsp?yearDescendant=true&offset=0&"+ str.substring(0,str.length()-1)+"\">YearDSC</a><br><br></div>");
	
	//PreparedStatement p;
	Statement select = connection.createStatement();
	if (request.getParameter("purpose") != null)
	{
		//PreparedStatement p = preparedStatementDict.get(request.getParameter("purpose"));
		String sqlQuery = queryDict.get(request.getParameter("purpose"));
		if (request.getParameter("titleAncestor") != null)
		{
			sqlQuery += " ORDER BY title ASC";
		}
		else if (request.getParameter("titleDescendant") != null)
		{
			sqlQuery += " ORDER BY title DESC";
		}
		else if (request.getParameter("yearAncestor") != null)
		{
			sqlQuery += " ORDER BY year ASC";
		}
		else if (request.getParameter("yearDescendant") != null)
		{
			sqlQuery += " ORDER BY year DESC";
		}
		sqlQuery = sqlQuery + " LIMIT " + request.getParameter("numberOfPages") + " OFFSET " + request.getParameter("offset") + ";";
		//p = connection.prepareStatement(sqlQuery);
		if (request.getParameter("purpose").equals("searchPage"))
		{
			//p = connection.prepareStatement(sqlQuery);
			String[] paramList = {"last_name", "first_name", "title", "year", "director"};
			for (int i =0; i < paramList.length; i++)
			{
				/*
				if (request.getParameter(paramList[i]) != null)
				{
					p.setString(i+1,"%"+request.getParameter(paramList[i])+"%");
				}
				else
					p.setString(i+1,"%%");
				*/
				if (request.getParameter(paramList[i]) != null)
				{
					sqlQuery = sqlQuery.replace("variable"+Integer.toString(i+1),"'%"+request.getParameter(paramList[i])+"%'");
				}
				else
					sqlQuery = sqlQuery.replace("variable"+Integer.toString(i+1),"'%%'");
			}
			
		}
		else if (request.getParameter("purpose").equals("searchLetter"))
		{
			
			//p.setString(1, request.getParameter("letter")+"%");
			sqlQuery = sqlQuery.replace("variable", "'" + request.getParameter("letter") + "%'");
			
		}
		else if (request.getParameter("purpose").equals("searchGenre"))
		{
			
			//p.setString(1, request.getParameter("genres"));
			sqlQuery = sqlQuery.replace("variable", "'" + request.getParameter("genres") + "'");
		}
		else if (request.getParameter("purpose").equals("fullTextSearch"))
		{
			
			//p.setString(1, request.getParameter("fullSearchInput"));
			sqlQuery = sqlQuery.replace("variable", "'" + request.getParameter("fullSearchInput")+ "'");
			
		}
		out.println("<div class=\"movies\">");
		int initial=0;
		Statement selectGenre;
		ResultSet genreResult;
		
		System.out.println(sqlQuery);
		long tempJDBC = System.nanoTime();
		//ResultSet result = p.executeQuery();
		ResultSet result = select.executeQuery(sqlQuery);
		JDBCTime = System.nanoTime() - tempJDBC;
		
		String itemID = "item0";
		
		
		while(result.next())
		{
			nextFlag = false;
			String starSQLStatement = "SELECT stars.id, stars.first_name, stars.last_name from stars_in_movies, stars WHERE stars_in_movies.movie_id=" + result.getString(1) + " AND stars_in_movies.star_id=stars.id";
			
			tempJDBC = System.nanoTime();
			Statement selectStar = connection.createStatement();
			JDBCTime = JDBCTime + (System.nanoTime() - tempJDBC);
			
			ResultSet starResult = selectStar.executeQuery(starSQLStatement);
			out.println("<img class=\"movie-image\" src=\""+result.getString(5)+"\">");
			out.println("<br><center>TITLE: <div class=\"suggestionBox\"><a class=\"show-details\" href=\"singleMovie.jsp?movieID="+result.getString(1)+"\"  onmouseover=\"getMovieInfo('"+ result.getString(1) +"')\" >"+ result.getString(2)+"</a><div class=\"suggestionBox-content\"><span id=\""+ result.getString(1) +"\"></span></div></div></center>");
			out.println("<pre> YEAR:"+ result.getString(3)+"</pre>");
			out.println("<pre> DIRECTOR: "+ result.getString(4)+"</pre>");
			out.println("<pre> ID:"+ result.getString(1) +"</pre>");
			out.println("<pre> TRAILER URL:<a href=\""+ result.getString(6)+"\">Click To See Trailer</a></pre>");
			out.print("<pre> STARS: ");
			while(starResult.next()){
				out.print("<a href=\"singleStar.jsp?starID="+ starResult.getInt(1) +"\">"+starResult.getString(2)+" "+starResult.getString(3)+"</a>");
				break;
			}
			while(starResult.next())
			{
				out.print(", " + "<a href=\"singleStar.jsp?starID=" + starResult.getInt(1) +"\">" + starResult.getString(2)+" "+starResult.getString(3)+"</a>");
			}
			out.println("</pre>");
			String genreSQLStatement = "SELECT genres.name FROM genres_in_movies, genres WHERE genres_in_movies.movie_id=" + result.getString(1) + " AND genres_in_movies.genre_id=genres.id";
			selectGenre = connection.createStatement();
			
			tempJDBC = System.nanoTime();
			genreResult = selectStar.executeQuery(genreSQLStatement);
			JDBCTime = JDBCTime + (System.nanoTime() - tempJDBC);
			
			out.println("<pre> GENRE: ");
			while(genreResult.next()){
				out.print(genreResult.getString(1));
				break;
			}
			while (genreResult.next())
			{
				out.print(", "+genreResult.getString(1));
			}
			out.println("</pre>");
			out.println("<div class=\"movie-button\"><input type=\"button\" value=\"Add to Cart\" onClick=\"communicator("+ result.getString(1) +",'"+ result.getString(2)+"')\"><br></div>");
			out.println("<center><div class=\"thePicture\"><img class=\"show-details\"  onmouseover=\"displayCart('"+itemID+"')\" src=\"instruction_icon.png\"/><div class=\"smallBox\"><span id=\"item"+initial+"\"></span><br><a href=\"theCart.jsp\">Click here to change quantity</a></div></div></center>");
			
			out.println("<br>");
			out.println("<hr></hr>");
			initial++;
			starResult.close();
			genreResult.close();
		}
		out.println("</div>");
		numberOfPages = request.getParameter("numberOfPages");
		offset = request.getParameter("offset");
	
		select.close();
		result.close();
		
		
	}
	

	//<form action="movieList.jsp" method="GET"><input type="hidden" name="numberOfPages" value=10 /><input type="hidden" name="offset" value=6 /><input type="submit" value="Next" /> </form>
	if (nextFlag == false){
		out.println("<form action=\"movieList.jsp\" method=\"GET\">");
		Enumeration<String> paramFromPath3 = request.getParameterNames();
	
		while (paramFromPath3.hasMoreElements())
		{
		    String param = paramFromPath3.nextElement();
		    //String[] paramValues = request.getParameterValues(param);
		    String value = request.getParameter(param);
		    if (param.equals("offset")){
		    	value = Integer.toString(Integer.parseInt(value) + Integer.parseInt(request.getParameter("numberOfPages")));
		    }
		    out.println("<input type=\"hidden\" name=\"" +  param + "\" value=\"" + value + "\" />");
		    
		    
		}
		out.println("<input type=\"submit\" value=\"Next\" /> </form>");
	}
	out.println("<form action=\"movieList.jsp\" method=\"GET\">");
	Enumeration<String> paramFromPath4 = request.getParameterNames();
	int offsetValue = 0;
	while (paramFromPath4.hasMoreElements())
	{
	    String param = paramFromPath4.nextElement();
	    //String[] paramValues = request.getParameterValues(param);
	    String value = request.getParameter(param);
	    if (param.equals("offset")){
	    	offsetValue = Integer.parseInt(value) - Integer.parseInt(request.getParameter("numberOfPages"));
	    	if (offsetValue < 0)
	    		offsetValue = 0;
	    	value = Integer.toString(offsetValue);
	    }
	    out.println("<input type=\"hidden\" name=\"" +  param + "\" value=\"" + value + "\" />");
	    
	    
	}
	out.println("<input type=\"submit\" value=\"Prev\" /> </form>");
	
	servletTime = System.nanoTime() - tempQuery;
	
	FileWriter fileWriter = null;
    BufferedWriter bufferedWriter = null;
    PrintWriter printWriter = null;
    
	connection.close();
	
	
}catch(Exception e){
	System.out.println("Error3");
	e.printStackTrace();
}finally{
try {
		
		File f = new File("logFile.txt");
		String file = application.getRealPath("/") + "logFile.txt";
		System.out.println(file);
		
		PrintWriter pw = new PrintWriter(new FileOutputStream(file, true));	    
	    pw.println("ST: " + servletTime + " JDBC: " + JDBCTime);
	    System.out.println("Written");
	    pw.close();
	} catch (IOException e) {
	    System.out.println("Error Writing to file");
	    e.printStackTrace();
	}
	
	
}
%>



<!-- --------------------------------- -->

</body>
</html>
