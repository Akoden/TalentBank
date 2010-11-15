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
if (user != null)
{
	PersistenceManager pm = null;
	
	pm = PMF.get().getPersistenceManager();
	Query query = pm.newQuery(T_User.class,
	"strUserEmail == strUserEmailParam");
query.declareParameters("String strUserEmailParam");
query.setOrdering("strFirstName ASC,strLastName ASC");
List<T_User> lsTCV = (List<T_User>) query.execute(user.getEmail());
if (!lsTCV.isEmpty() || ("michelvoula@gmail.com".equals(user.getEmail()))) 
{
session.setAttribute("dateDeb",null);
session.setAttribute("dateFin",null);
session.setAttribute("strStatus",null);
Date dateDeb;
Date dateFin;
SimpleDateFormat fmt = new SimpleDateFormat(
"MM/dd/yyyy");
Calendar cal=Calendar.getInstance();
dateFin=new Date();
cal.setTime(dateFin);
cal.set(Calendar.DAY_OF_MONTH,cal.get(Calendar.DAY_OF_MONTH)-10);
dateDeb=cal.getTime();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>

<meta name="Description"
	content="Information architecture, Web Design, Web Standards." />
<meta name="Keywords" content="your, keywords" />
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<meta name="Distribution" content="Global" />
<meta name="Author" content="Erwin Aligam - ealigam@gmail.com" />
<meta name="Robots" content="index,follow" />

<link rel="stylesheet" href="images/Techmania.css" type="text/css" />

<title>Talent Bank</title>

<style type="text/css">
<!--
.style1 {
	font-size: 24%
}
-->
</style>
<link rel="stylesheet" type="text/css"
	href="css/flexigrid/flexigrid.css">
<script type="text/javascript" src="jquery/jquery-plus-jquery-ui.js"></script>
<script type="text/javascript" src="flexigrid.js"></script>
<script type="text/javascript">
    $(document).ready(function()
    	    {
    
    	
    	

    		
    		$('#link_user').addClass("current");
    		$('#liHome').removeClass("current");
    		$('#link_user').click()
    		{
    		
    		 $.ajax({
			      type: "GET",
			      url: "users.html.jsp",
			      data: "",
			      success: function(msg){
			      //alert(msg);
    			 $('#main').html(msg);
				   }
			     });
    		};
     
    	

 });
    
    

    </script>
</head>

<body>
<!-- wrap starts here -->
<div id="wrap">

<div id="header">

<h1 id="logo-text">Talent Bank <span class="gray">2010</span></h1>
<h2 id="slogan">LimbeLabs
<p>Hello, <%= user.getNickname() %>! (You can <a
	href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign
out</a>.)</p>
</h2>

<div id="header-tabs">
<ul>
	<li class="current" id="liHome"><a href="admin.jsp"><span>Home</span></a></li>
	<li id="link_user"><a href="users.admin.jsp"><span>Users</span></a></li>
</ul>
</div>

</div>

<!-- content-wrap starts here -->
<div id="content-wrap">




<div id="main"></div>





<div id="footer"><span id="footer-left"> &copy; 2010 <strong>LimbeLabs</strong>
| Design by: <strong><a href="index.html">Michel VOULA</a></strong> </span> <span
	id="footer-right"> <a href="#">Home</a> </span></div>

<!-- wrap ends here --></div>
</body>
</html>
<%}
else
{
    response.sendRedirect(userService.createLoginURL(request.getRequestURI()));
	
}
}
else {
    response.sendRedirect(userService.createLoginURL(request.getRequestURI()));
}%>
