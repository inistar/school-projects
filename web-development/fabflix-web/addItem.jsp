<%@page import="java.sql.*,
javax.sql.*,
java.io.IOException,
javax.servlet.http.*,
javax.servlet.*, 
java.util.ArrayList"
%>

<%
//out.println("Hello");
//out.println(request.getParameter("movieID")+":"+request.getParameter("movieTitle"));
/**
HttpSession cookie = request.getSession(false);
String tempStr = (String)cookie.getAttribute("testString");
tempStr += "<br>"+request.getParameter("movieID")+":"+request.getParameter("movieTitle");
cookie.removeAttribute("testString");
cookie.setAttribute("testString", tempStr);
out.print(tempStr);
**/
try{
HttpSession cookie = request.getSession(false);

ArrayList<ArrayList<Object>> outerCart = (ArrayList<ArrayList<Object>>) cookie.getAttribute("cart");



if (request.getParameter("showCart") != null && request.getParameter("showCart").equals("true"))
{
	String result = "";
	for (int i =0; i< outerCart.size(); i++)
	{
		result += (String)outerCart.get(i).get(0) + "%20" + (String)outerCart.get(i).get(1) + "%20" + (String)outerCart.get(i).get(2) +"|";
	}
	out.print(result);
}
else{
	if (request.getParameter("movieID") != null && request.getParameter("movieTitle") != null)
	{
		boolean flag = true;
		
		int temp;
		for (int j = 0; j< outerCart.size(); j++)
		{
			if (outerCart.get(j).get(0).equals(request.getParameter("movieID")))
			{
				flag = false;
				outerCart.get(j).set(2, Integer.toString(Integer.parseInt((String)outerCart.get(j).get(2))+1));
				break;
			}
			
		}
		
		if (flag == true)
		{
			ArrayList<Object> innerCart = new ArrayList<Object>();
			innerCart.add(new String(request.getParameter("movieID")));
			innerCart.add(new String(request.getParameter("movieTitle")));
			innerCart.add(new String("1"));
			outerCart.add(innerCart);
		}
		
		
		
		cookie.setAttribute("cart", outerCart);
		String result = "";
	
		
		
		for (int i = 0; i< outerCart.size(); i++)
		{
			result += (String)outerCart.get(i).get(1) +": "+ (String)outerCart.get(i).get(2)+"<br>";
		}
		
		out.print(result);
		
		
	}
}
}catch(Exception e){
	System.out.println("Error");
}
%>



