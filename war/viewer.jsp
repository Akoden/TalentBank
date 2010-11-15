<%@page import="com.google.appengine.api.datastore.Key"%>
<%@page import="java.util.ArrayList"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.*"%>
<%@ page import="javax.jdo.*"%>
<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ page import="beans.*"%>
<%@ page import="java.text.*"%>
<%@ page import="controller.*"%>
<%@ page import="utils.*"%>
<%@ page import="com.google.appengine.repackaged.org.json.*"%>
<%@ page import="java.util.logging.Logger"%>
<%
	UserService userService = UserServiceFactory.getUserService();
	User user = userService.getCurrentUser();
	String current=request.getParameter("lg_CV_ID");
	
	if (user != null) 
	{
	
		%>

<iframe
	src="http://docs.google.com/viewer?url=http%3A%2F%2Flimbelabstalent.appspot.com%2Fdownload%3Ftask%3DviewCV%26lg_CV_ID%3D<%=current%>&embedded=true"
	width="100%" height="780" style="border: none;"></iframe>
<%
	}
		
	else {
		response.sendRedirect(userService.createLoginURL(request
				.getRequestURI()));
	}
	
%>
	