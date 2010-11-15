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
List<T_CV> lstT_CV=(List<T_CV>)session.getAttribute("lstT_CV");
T_CV oCv=null;
T_CV oCvNext=null;
T_CV oCvPrevious=null;
int lg_Next=0;
int lg_Previous=0;

if(lstT_CV != null)
{
	
	int intNum=Integer.parseInt(request.getParameter("lg_CV_ID"));
	lg_Next=intNum+1;
	lg_Previous=intNum-1;
	if(intNum==0) 
	{
		lg_Previous=lstT_CV.size()-1;
	}
	else if(intNum==(lstT_CV.size()-1))
	{
		lg_Next=0;
	}
	if(lstT_CV.size()==1)
	{
		lg_Next=0;
		lg_Previous=0;
	}
	oCv=lstT_CV.get(intNum);
	oCvNext=lstT_CV.get(lg_Next);
	oCvPrevious=lstT_CV.get(lg_Previous);
%>
<center>
<table width="100%" border="0">
	<tr>
		<td width="50%" style="text-align: left;"><a
			href="javascript:window.location.replace('viewCV.jsp?lg_CV_ID=<%=oCvPrevious.getLg_CV_ID() %>&lg_CV_ID_pos=<%=lg_Previous%>');">
		<< PREVIOUS </a></td>
		<td width="50%" style="text-align: right"><a
			href="viewCV.jsp?lg_CV_ID=<%=oCvNext.getLg_CV_ID() %>&lg_CV_ID_pos=<%=lg_Next%>">
		NEXT >> </a></td>
	</tr>
</table>
</center>

<%}%>