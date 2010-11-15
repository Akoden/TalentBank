<%@page import="com.google.appengine.api.datastore.Key"%>
<%@page import="java.util.ArrayList"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.List"%>
<%@ page import="javax.jdo.*"%>
<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ page import="beans.*"%>
<%@ page import="java.text.*"%>
<%@ page import="controller.*"%>
<%@ page import="java.net.*"%>
<%@ page import="utils.*"%>
<%@ page import="com.google.appengine.repackaged.org.json.*"%>
<%@ page import="java.util.logging.Logger"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<%@page import="java.net.URLEncoder"%><html
	xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta name="Description"
	content="Information architecture, Web Design, Web Standards." />
<meta name="Keywords" content="limbelabs, voula" />
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<meta name="Distribution" content="Global" />
<meta name="Author" content="LimbeLabs - michelvooulqgmail.com" />
<meta name="Robots" content="index,follow" />
<link rel="stylesheet" href="images/Techmania.css" type="text/css" />
<link rel="stylesheet" href="common.css" type="text/css" />
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
<script type="text/javascript" src="jquery/email_validator.js"></script>
<script type="text/javascript" src="common.js"></script>

<script type="text/javascript">

    $(document).ready(function()
    	    {
        	
			

 });
    
    
    duplicateAction=function()
    {  var rbKeepOldCV=document.getElementById("rbKeepOldCV");
       var rbDeleteOld=document.getElementById("rbDeleteOld");
    var lg_CV_ID="";
    if((rbKeepOldCV.checked==false )&&(rbDeleteOld.checked==false))
    {
       
        showPopup(150,100,1000,"please choose an option");
		closePopUp(1000);
    }
    else
    {
    if(rbKeepOldCV.checked==true)
    {
    	lg_CV_ID=rbKeepOldCV.value;
    }
    else if(rbDeleteOld.checked==true)
    {
    	lg_CV_ID=document.getElementById("rbDeleteOld").value;
    }
    	
    	var dataString = 'task=deleteCV&lg_CV_ID='
        	+lg_CV_ID;   	
    	//alert(dataString);		   

     $.ajax({
      type: "GET",
      url: "requests.jsp",
      data: dataString,
      success: function(msg){
    	 if(msg.indexOf("OK")>=0)
	      {
    		 $('#wrap').fadeOut();
    		 showPopUp('div#divresult');
    		 var j=0;
    		 for(var i=0;i<100;i++)
    		 {
    		 	j++;
    		 }
    		 window.location.replace('http://careers.limbelabs.com/');
		  
	      }
	      else{
	    	  //alert("CV deletion Failed");
	    	  showPopup(150,100,1000,"operation failed!!!!!");
	  		closePopUp(1000);
	      }
    				
       }
     });
    }
    }
    </script>
<link type="text/css" href="sample-style/ui-sui.css" rel="stylesheet" />
<script type="text/javascript">
if(window.ixedit){ixedit.deployed = true};
if(window.jQuery){jQuery(function(){



	$('#main').ajaxStart( showWaiting); 

    $('#main').ajaxStop( closeWaiting); 
	})};

showPopUp=function(divId)
{
	$(divId).removeClass("invisible");
	var target = jQuery(divId);
	target.show();
	if (!target.dialog('isOpen')) {
		target.dialog( {
			autoOpen :false,
			bgiframe :true,
			modal :true,
			resizable :false,
			width :400,
			height :300,
			position : [ 'center', 'center' ],
			draggable :true,

		})
	}
	;
	target.dialog('open');
};
</script>
</head>

<body>
<!-- wrap starts here -->
<div id="wrap">

<div id="header">

<table id="tabLogo" width="100%">
	<tr>
		<td id="tdLogoImg"><img src="images/logo.png" alt="LimbeLabs"
			id="imgLogo" /></td>
	</tr>
	<tr>
		<td id='tdTalentBank'>Talent Bank</td>
	</tr>

</table>
<h2 id="slogan"></h2>

<div id="header-tabs">
<ul>
	<li class="current" id="liHome"><a href="welcome.jsp"><span>Home</span></a></li>
	<li id="link_admin"><a href="admin.jsp"><span>Admin</span></a></li>
</ul>
</div>

</div>

<!-- content-wrap starts here -->
<div id="content-wrap">


<div id="main">
<h1></h1>
<div id="waiting_message" class="invisible"><img
	src="ajax-loader.gif" /></div>
<div id="popMessage" class="invisible"></div>
<div id="divresult" class="invisible">
<p class='popUpwindow'>Your CV has been uploaded, you will receive a
notification by Email</p>
<p>Redirecting to <a href='http://careers.limbelabs.com/'>http://careers.limbelabs.com/</a></p>
<img src="ajax-loader.gif" /></div>
<div id="waiting_message" class="invisible"><img
	src="ajax-loader.gif" /></div>

<%boolean bDuplicate=false;
	  		if(request.getParameter("lg_CV_ID_OLD")!=null && request.getParameter("lg_CV_ID_NEW")!=null)
{bDuplicate=true;
%> <center>
<table border="0" id="tabduplicatecheck">
	<tr>
		<td id="cvDuplicateMess">We already have a <a
			title="Click to view the CV"
			href="javascript:window.open('/download?task=viewCV&lg_CV_ID=<%= request.getParameter("lg_CV_ID_OLD")%>');">CV
		File</a> with the same <a title="Click to view the CV"
			href="javascript:window.open('/download?task=viewCV&lg_CV_ID=<%= request.getParameter("lg_CV_ID_NEW")%>');">name
		and file size</a> on your email, want to you want to do?</td>
	</tr>
	<tr class="trLigne2">
		<td class="optionDuplicate"><input type="radio" name="radio"
			id="rbDeleteOld" value="<%=request.getParameter("lg_CV_ID_OLD")%>" />
		delete the old CV and keep this new version <input type="hidden"
			name="lg_CV_ID_OLD" id="lg_CV_ID_OLD"
			value="<%=request.getParameter("lg_CV_ID_OLD")%>" /></td>
	</tr>
	<tr class="trLigne2">
		<td class="optionDuplicate"><input type="radio" name="radio"
			id="rbKeepOldCV" value="<%=request.getParameter("lg_CV_ID_NEW")%>" />
		keep the old CV and do not consider the new <input type="hidden"
			name="lg_CV_ID_NEW" id="lg_CV_ID_NEW"
			value="<%=request.getParameter("lg_CV_ID_NEW")%>" /></td>
	</tr>
	<tr>
		<td id='btnForDuplicate'><center>
		<button onclick="duplicateAction();" class='uibutton'
			id="btnSaveDuplicate">save</button>
		</center></td>
	</tr>
</table>
</center> <%} else
{
	List<T_Job_Category> lstJobCategories=JobCategController.getJobCategs();
	if(lstJobCategories==null) 
		{
		lstJobCategories=new ArrayList<T_Job_Category>();
		
		}
%> <script type="text/javascript">
function getDescription(value)
{
    if(value=='')  $("#lblJobDesc").html("");
    <%for(T_Job_Category job:lstJobCategories) 
    {
    	JSONArray arrayObj1 = new JSONArray();
    	
    	arrayObj1.put(job.getStrJobCategoryDesc());
    	String val=arrayObj1.toString();
    	val=val.substring(2,val.length()-2);
    %>
    else if(value=="<%=job.getLg_Job_Category_ID() %>") 
        {
        
        $("#lblJobDesc").html("<%=val%>");
        }
    <%} %>
    else $("#lblJobDesc").html("");
    
}
</script>
<div id="divUpload" class="<%=bDuplicate==true?"invisible":"" %>">
<%if(request.getParameter("result")!=null){
	  			%> <script type="text/javascript">
	  			$('#wrap').fadeOut();
showPopUp('div#divresult');

window.location.replace('http://careers.limbelabs.com/');
</script> <%	
	  		} else{ %> <center>
<table border="0" id="tabWelcome" width="100%">
	<tr>
		<form id="filesForm" name="filesForm" action="/upload" method="post"
			enctype="multipart/form-data" onSubmit="return false;">
		<td class="wLabel">Email:</td>
		<td class="wInput"><input type="text" id="strUserEmail"
			name="strUserEmail" onchange="echeck(this.value)" /><br />
		<b id="lblValid" class="lblDescription">your email e.g :
		michel@limbelabs.com</b></td>
	</tr>
	<tr>
		<td class="wLabel">First name:</td>
		<td class="wInput"><input type="text" id="strFirstName"
			name="strFirstName" /></td>

	</tr>

	<tr>
		<td class="wLabel">Last name:</td>
		<td class="wInput"><input type="text" id="strLastName"
			name="strLastName" /></td>

	</tr>
	<tr>
		<td class="wLabel">Job category:</td>
		<td class="wInput"><select name="lg_Job_Category_ID"
			id="lg_Job_Category_ID" onchange="getDescription(this.value);">
			<option value=""></option>
			<%for(T_Job_Category job:lstJobCategories) 
    {
    	
    %>
			<option value="<%=job.getLg_Job_Category_ID() %>"><%=job.getStrJobCategoryName()%></option>
			<%} %>
		</select> <br />
		<b id="lblJobDesc" class="lblDescription"></b></td>

	</tr>
	<tr>
		<td class="wLabel">CV(PDF):</td>
		<td class="wInput"><input type="file" id="strFileName"
			name="strFileName" /> <b id="lblValidFile"></b></td>
		</form>
	</tr>
	<tr>

		<td colspan="2" id='tdButtonUpload'>

		<button onclick="ValidateForm()" id="btnUpload" class="uibutton">
		submit</button>
	</tr>
</table>
</center> <%}
	  		}%>
</div>
<!-- content-wrap ends here --></div>
<script type="text/javascript">
		</script>
<div id="footer"><span id="footer-left"> &copy;<strong><a
	href="http://limbelabs.com">Copyright Limbe Labs Solutions 2010.
All rights reserved</a></strong> </span> <span id="footer-right"> </span></div>

<!-- wrap ends here --></div>
</body>
</html>
