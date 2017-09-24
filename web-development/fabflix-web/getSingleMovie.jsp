<%@page import="java.sql.*,
javax.sql.*,
java.io.IOException,
javax.servlet.http.*,
javax.servlet.*,
javax.naming.InitialContext,
javax.naming.Context,
javax.sql.DataSource"
%>
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


</script>
<%


HttpSession cookie = request.getSession(false);

	if (request.getParameter("movieID") != null){
		String movieID = request.getParameter("movieID");
		
		
		
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
		

		out.println("<br><img onclick=\"communicator('"+ movieResult.getString(1) +"','"+ movieResult.getString(2) +"')\" src=\"addtocart.png\" width=\"300\" height=\"200\" />");
	
		connection.close();
	}

	

%>