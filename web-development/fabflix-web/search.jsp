<%@page import="java.sql.*,
javax.sql.*,
java.io.IOException,
javax.servlet.http.*,
javax.servlet.*"
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

input[type=text], input[type=password] {
    width: 50%;
    padding: 12px 20px;
    margin: 8px 0;
    display: inline-block;
    border: 1px solid #ccc;
    box-sizing: border-box;
}

.searchToolBar{
	background-color: white;
    border-style: solid;
    border: 2px solid;
    border-radius: 8px;
    margin-top: 50px;
    margin-bottom: 50px;
    margin-right: 15%;
    margin-left: 15%;
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

.searchToolBar{
	text-align: center;
}

.form-group{
	text-align: right;
    margin-right: 30%;
}

</style>


<style>
.suggestionBox {
    position: relative;
    display: inline-block;
    float: right;
    
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
    <a class="weblinks" href="main.jsp?fromOtherPages=true" id="browse">Home</a>|
    <a class="weblinks" href="search.jsp" >Advanced Search</a>|
    <a class="weblinks" href="theCart.jsp" >My Cart</a>|
    <a class="weblinks" href="login.jsp" >Logout</a>
    </div>
</div>

<hr></hr>

<div class="searchToolBar">
	<h3>ADVANCED SEARCH</h3>
	<form action="movieList.jsp" method="get">
	
	<div class="form-group">
	<label for="Title">TITLE: </label>
	<input type="text" name="title" size="55"><br>
	</div>
	
	<div class="form-group">
	<label for="Year">YEAR: </label>
	<input type="text" name="year" size="55"><br>
	</div>
	
	<div class="form-group">
	<label for="Director">DIRECTOR: </label>
	<input type="text" name="director" size="55"><br>
	</div>
	
	<div class="form-group">
	<label for="StarFirstName">STAR FRIST NAME: </label>
	<input type="text" name="starFirstName" size="55"><br>
	</div>
	
	<div class="form-group">
	<label for="StarLastName">STAR LAST NAME: </label>
	<input type="text" name="starLastName" size="55"><br>
	</div>
	<input type="hidden" name="offset" value="0" />
	<input type="hidden" name="numberOfPages" value="10" />
	<input type="hidden" name="purpose" value="searchPage" />
	<button type="submit" class="btn btn-default">Submit</button>
	</form>
</div>

<%
/**
try{
HttpSession cookie = request.getSession(false);

if(cookie.getAttribute("username") == null){
	out.println("<script> alert(\"Must be Logged in\");</script>");
	response.sendRedirect("login.jsp");
}


	String title = request.getParameter("title");
	String year = request.getParameter("year");
	String director = request.getParameter("director");
	String starFirstName = request.getParameter("starFirstName");
	String starLastName = request.getParameter("starLastName");
	
	String sqlStatement = "";
	
	if (title != null || year != null || director != null || starFirstName != null || starLastName != null)
	{
		if(starFirstName != null && starLastName != null && !starFirstName.equals("") && !starLastName.equals("")){
			sqlStatement = "SELECT * FROM movies INNER JOIN stars_in_movies on stars_in_movies.movie_id = movies.id INNER JOIN stars on stars.id = stars_in_movies.star_id WHERE (";
			
			sqlStatement = sqlStatement + "last_name LIKE '%" + starLastName + "%' ";
			sqlStatement = sqlStatement + "AND first_name LIKE '%" + starFirstName + "%' ";
			
			if(title != null && !title.equals(""))
				sqlStatement = sqlStatement + " AND title LIKE '%" + title + "%' ";
			if(year != null && !year.equals(""))
					sqlStatement = sqlStatement + "AND year LIKE '%" + year + "%' ";
			if(director != null && !director.equals(""))
					sqlStatement = sqlStatement + "AND director LIKE '%" + director + "%' ";

			sqlStatement = sqlStatement + ") GROUP BY movies.id ";
		}
		else if(starLastName != null && !starLastName.equals("")){
			sqlStatement = "SELECT * FROM movies INNER JOIN stars_in_movies on stars_in_movies.movie_id = movies.id INNER JOIN stars on stars.id = stars_in_movies.star_id WHERE (";
			
			sqlStatement = sqlStatement + "last_name LIKE '%" + starLastName + "%' ";
			
			if(title != null && !title.equals(""))
				sqlStatement = sqlStatement + " AND title LIKE '%" + title + "%' ";
			if( year != null && !year.equals(""))
					sqlStatement = sqlStatement + "AND year LIKE '%" + year + "%' ";
			if(director != null && !director.equals(""))
					sqlStatement = sqlStatement + "AND director LIKE '%" + director + "%' ";

			sqlStatement = sqlStatement + ") GROUP BY movies.id ";
		}
		else if(starFirstName != null && !starFirstName.equals("")){
			sqlStatement = "SELECT * FROM movies INNER JOIN stars_in_movies on stars_in_movies.movie_id = movies.id INNER JOIN stars on stars.id = stars_in_movies.star_id WHERE (";
			
			sqlStatement = sqlStatement + "first_name LIKE '%" + starFirstName + "%' ";
			
			if(title != null && !title.equals(""))
				sqlStatement = sqlStatement + " AND title LIKE '%" + title + "%' ";
			if(year != null && !year.equals(""))
				sqlStatement = sqlStatement + "AND year LIKE '%" + year + "%' ";
			if(director != null && !director.equals(""))
				sqlStatement = sqlStatement + "AND director LIKE '%" + director + "%' ";

			sqlStatement = sqlStatement + ") GROUP BY movies.id ";
		}else{
			
			sqlStatement = "SELECT * FROM movies WHERE (";
			boolean firstTime = true;
			if(title != null && !title.equals("")){
				sqlStatement = sqlStatement + "title LIKE '%" + title + "%' ";
				firstTime = false;
			}
			if(year != null && !year.equals("")){
				if(firstTime){
					sqlStatement = sqlStatement + "year LIKE '%" + year + "%' ";
					firstTime = false;
				}
				else
					sqlStatement = sqlStatement + "AND year LIKE '%" + year + "%' ";
			}
			if(director != null && !director.equals("")){
				if(firstTime){
					sqlStatement = sqlStatement + "director LIKE '%" + director + "%' ";
					firstTime = false;
				}
				else
					sqlStatement = sqlStatement + "AND director LIKE '%" + director + "%' ";
			}
			
			sqlStatement = sqlStatement + ") ";
		}
		
		
		System.out.println(sqlStatement);
		
		cookie.setAttribute("sqlStatement", sqlStatement);
		cookie.setAttribute("offset", "0");
		//request.getSession().setAttribute("sqlStatement", sqlStatement);
		//cookie.setAttribute("sqlStatement", sqlStatement);
		out.println(cookie.getAttribute("sqlStatement"));
		response.sendRedirect("movieList.jsp");

	}
}catch(Exception e){
	System.out.println("Error");
	//e.printStackTrace();
}
*/
%>
</body>
</html>