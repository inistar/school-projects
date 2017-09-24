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
<body>
<%
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
//ResultSet result = select.executeQuery(sqlStatement);
if (request.getParameter("keyword") != null)
{
	String keyword = request.getParameter("keyword").trim();
	String keywordSplit[] = keyword.split(" ");
	String sqlStatement = "select title from movies where match(title) against('";
	
	if (keywordSplit.length > 1){
		for(int i = 0; i < keywordSplit.length; i++){
			
			if(i == keywordSplit.length-1){
				sqlStatement = sqlStatement + "' in boolean mode) AND match(title) against('" + keywordSplit[i].trim() + "*' in boolean mode) LIMIT 10;";
				break;
			}
			
			sqlStatement = sqlStatement + " +" + keywordSplit[i].trim();
		}
	}
	else if (keywordSplit.length == 1){
		sqlStatement +=  keywordSplit[0].trim() + "*' in boolean mode) LIMIT 10;";
	}
	else
	{
		sqlStatement +=  "' in boolean mode) LIMIT 10;";
	}
	
	System.out.println(sqlStatement);
	ResultSet result = select.executeQuery(sqlStatement);
	String output = "";
	while(result.next())
	{
		output +=  "|" + result.getString(1) ;
	}
	if (output.equals(""))
		out.println("No Result!");
	else{
		output += "|";
		out.println(output);
	}
	
	
}

connection.close();
%>
</body>
</html>