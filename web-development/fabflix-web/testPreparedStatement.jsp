<%@page import="java.sql.*,
javax.sql.*,
java.io.IOException,
javax.servlet.http.*,
javax.servlet.*,
java.util.Enumeration,
javax.naming.InitialContext,
javax.naming.Context,
javax.sql.DataSource"
%>
<%@ page import="java.io.*"  %>

<html>
<body>

<%

out.println("<br>");
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

String selectSQL = "SELECT id, title FROM MOVIES WHERE ? ";
String likeSQL = "SELECT * FROM movies INNER JOIN stars_in_movies on stars_in_movies.movie_id = movies.id INNER JOIN stars on stars.id = stars_in_movies.star_id WHERE (last_name LIKE ? AND first_name LIKE ? AND title LIKE ? AND year LIKE ? AND director LIKE ? ) GROUP BY movies.id;";
PreparedStatement p = connection.prepareStatement(likeSQL);
p.setString(1,"%%");
p.setString(2,"%%");
p.setString(3,"%%");
p.setString(4,"%199%");
p.setString(5,"%%");
//selectSQL += " OR id=907003;";
//p = connection.prepareStatement(selectSQL);
ResultSet rs = p.executeQuery();
System.out.println(p);
while (rs.next()) {
	//String userid = rs.getString("id");
	//String username = rs.getString("USERNAME");
	out.println(rs.getString("title"));
}
out.println("<form action=\"movieList.jsp\" method=\"GET\"><input type=\"hidden\" name=\"numberOfPages\" value=10 /><input type=\"hidden\" name=\"offset\" value=6 /><input type=\"submit\" value=\"Next\" /> </form>");


String str = "print me";
//always give the path from root. This way it almost always works.
String nameOfTextFile = "C://Users//inist//workspace-java//CS122B-Project2//WebContent//logFile.txt";
try {   
    PrintWriter pw = new PrintWriter(new FileOutputStream(nameOfTextFile), true);
    pw.println(str);
    //clean up
    pw.close();
} catch(IOException e) {
   out.println(e.getMessage());
}
%>

</body>
</html>