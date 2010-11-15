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

/**
Main page for the administration of the talent bank
in this page we have  <div id="main">
in this div, we will display the content CV on grid or in viewer or the configuration page
the objective is to use ajax, so e will never reload all the page but display only the data

**/
	UserService userService = UserServiceFactory.getUserService();
	User user = userService.getCurrentUser();
	if (user != null) {
		PersistenceManager pm = null;

		pm = PMF.get().getPersistenceManager();
		Query query = null;
		if (userService.isUserAdmin()) 
		{
            //set session values used in searches
			session.setAttribute("dateDeb", null); //CV received after dateDeb
			session.setAttribute("dateFin", null);//CV received before dateFin
			session.setAttribute("strStatus", null);//CV with status
			session.setAttribute("lg_Job_Category_ID", null);//CV on this job category
			
			//variables 
			Date dateDeb;
			Date dateFin;
			SimpleDateFormat fmt = new SimpleDateFormat("MM/dd/yyyy");
			Calendar cal = Calendar.getInstance();
			dateFin = new Date();
			cal.setTime(dateFin);
			cal.set(Calendar.DAY_OF_MONTH, cal
					.get(Calendar.DAY_OF_MONTH) - 10);
			dateDeb = cal.getTime();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta name="Description" content="Information architecture, Web Design, Web Standards." />
<meta name="Keywords" content="your, keywords" />
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<meta name="Distribution" content="Global" />
<meta name="Author" content="Erwin Aligam - ealigam@gmail.com" />
<meta name="Robots" content="index,follow" />

<title>Talent Bank</title>

<style type="text/css">
<!--
.style1 {
	font-size: 24%;
}
-->
</style>
<link rel="stylesheet" type="text/css" href="css/flexigrid/flexigrid.css">
<script type="text/javascript" src="jquery/jquery-plus-jquery-ui.js"></script>
<script type="text/javascript" src="flexigrid.js"></script>
<script type="text/javascript" src="jquery/email_validator.js"></script>
<link rel="stylesheet" href="common.css" type="text/css" />
<link rel="stylesheet" href="images/Techmania.css" type="text/css" />

<script type="text/javascript">
    $(document).ready(function()
    	    {

        //when you click on dashboard link
    	$('#liHome').click(function()
        		{
    		$('#liHome').addClass("current");
    		$('#link_config').removeClass("current");

    		//using jquery ajax to load the content of stats.jsp and display it in div id=main
    		$.ajax({
    		      type: "GET",
    		      url: "stats.jsp",
    		      data: "",
    		      success: function(msg){
    		      //alert(msg);
    			 $('#main').html(msg);
    			   }
    		     });
        		});


            //when click on configuration 
    		$('#link_config').click(function()
    	    		{   

	    		        $('#link_config').addClass("current");
    	        		$('#liHome').removeClass("current");

    	        		//using jquery ajax to load the content of configs.jsp and display it in div id=main
    	        		$.ajax({
    	  			      type: "GET",
    	  			      url: "configs.jsp",
    	  			      data: "",
    	  			      success: function(msg){
    	  			      //alert(msg);
    	      			 $('#main').html(msg);
    	  				   }
    	  			     });
    	    		});
   
 });



    //view cv in viewer
    viewList=function(strStatusP,lg_Job_Category_IDP)
    {
        //window.open("requests.jsp?task=viewCVList&strStatusP="+strStatusP);
        $('#liCVs').addClass("current");
		$('#link_user').removeClass("current");
		$('#liHome').removeClass("current");

		
	   $.ajax({
	      type: "GET",
	      url: "requests.jsp",
	      data: "task=viewCVList&strStatusP="+strStatusP+"&lg_Job_Category_IDP="+lg_Job_Category_IDP,
	      success: function(msg)
	      {
		      
		  $('#main').html(msg);
		  
		   }
	     });
    };

    //view single CV
    viewCV=function(lg_CV_ID,lg_CV_ID_pos)
    {
    	$('#liCVs').addClass("current");
		//$('#link_user').removeClass("current");
		$('#liHome').removeClass("current");
	  $.ajax
	  (
			  {
	           type: "GET",
	           url: "viewCV.jsp",
	           data: "lg_CV_ID="+lg_CV_ID+"&lg_CV_ID_pos="+lg_CV_ID_pos,
	           success: function(msg)
	           {
                $('#main').html(msg);
		       }
	          }
	   );
    };


    //
    viewListElement=function(strStatusP)
    {
  
        $('#liCVs').addClass("current");
		$('#liHome').removeClass("current");
	  $.ajax
	  (
			  {
	            type: "GET",
	            url: "requests.jsp",
	            data: "task=viewCVList&strStatusP="+strStatusP,
	            success: function(msg)
	            {
		         $('#main').html(msg);
		        } 
	          }
	   );
    };

    //show CV of status and job category in grid
    showInGrid=function(strStatusP,lg_Job_Category_IDP)
    { 
    	
    		        $('#liCVs').addClass("current");
            		$('#liHome').removeClass("current");
            		
        		$.ajax({
      		      type: "GET",
      		      url: "cvs.html.jsp",
      		      data: "strStatus="+strStatusP+"&lg_Job_Category_ID="+lg_Job_Category_IDP,
      		     
      		      success: function(msg)
      		      {
      		    
          		$('#main').html(msg);
      			   }
      		     });
      		     };
 
    downloadCV=function(lg_CV_ID)
    {
    	var dataString = 'task=viewCV&lg_CV_ID='+lg_CV_ID;
    	window.open("/download?"+dataString);
    } 


    
    var newwindow;

    //view CV note
    function popCVNote(lg_CV_ID)
    {  var  dataString="lg_CV_ID="+lg_CV_ID;
        $.ajax( {
			type :"GET",
			url :"note.jsp",
			data :dataString,
			success : function(msg) {


    		$('#popNote').removeClass("invisible");
    		$('#popNote').html(msg);
			var target = jQuery('div#popNote');
			target.show();
			if (!target.dialog('isOpen')) {
				target.dialog( {
					autoOpen :false,
					bgiframe :true,
					modal :true,
					resizable :false,
					width :430,
					height :200,
					position : [ 'center', 'center' ],
					draggable :true,

				})
			}
			;
			target.dialog('open');
			

		}
		});
    }   



    //search CV
    searchFromBar = function()
     {
		var strUserEmail = document.getElementById("strUserEmails0").value;
		var strUserName = document.getElementById("strUserName0").value;
		var strStatus = document.getElementById("strStatus0").value;
		var strDisplay = document.getElementById("strDisplay").value;
		var lg_Job_Category_ID = document.getElementById("lg_Job_Category_IDs").value;

		var dataString = 'task=statSearch&strUserEmail=' + strUserEmail + '&strUserName='
				+ strUserName + "&strStatus=" + strStatus + "&lg_Job_Category_ID="
				+ lg_Job_Category_ID+ "&strDisplay="
				+ strDisplay;
		//alert(dataString);		   

		$.ajax( {
			type :"GET",
			url :"requests.jsp",
			data :dataString,
			success : function(msg) {
				//alert(msg);
			//$("#flex1").flexReload();
			$('#main').html(msg);

		}
		});
	}	      		     
    </script>

<link type="text/css" href="sample-style/ui-sui.css" rel="stylesheet" />
  <script type="text/javascript">
	/* ------ Code generated by IxEdit (ixedit.com). ------ */
	if(window.ixedit){ixedit.deployed = true};
	if(window.jQuery){jQuery(function(){
		(function(){ var target = jQuery('input#dateDeb'); target.datepicker({dateFormat:'mm/dd/yy',dayNamesMin:['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'],dayNamesShort:['Sun', 'Mon', 'Tue', 'Wed', 'Thr', 'Fri', 'Sat'],monthNames:['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],monthNamesShort:['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],showOn:'button',showButtonPanel: true,currentText: 'This Month',closeText: 'Close'}); })();
		(function(){ var target = jQuery('input#dateFin'); target.datepicker({dateFormat:'mm/dd/yy',dayNamesMin:['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'],dayNamesShort:['Sun', 'Mon', 'Tue', 'Wed', 'Thr', 'Fri', 'Sat'],monthNames:['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],monthNamesShort:['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],showOn:'button',showButtonPanel: true,currentText: 'This Month',closeText: 'Close'}); })();





		
	    $('#main').ajaxStart( showWaiting); 

	    $('#main').ajaxStop( closeWaiting); 
		})};



		
</script>
<script type="text/javascript" src="common.js"></script>
</head>

<body>
<!-- wrap starts here -->
<div id="wrap">

<div id="header">
<table id="tabLogo" width="100%">
	<tr>
		<td id='tdLogout'>
		<p>Hello, <%=user.getNickname()%>! (You can <a
			href="<%=userService.createLogoutURL(request
									.getRequestURI())%>">sign
		out</a>.)</p>
		</td>
		<td id="tdLogoImg2">
         <img src="images/logo.png" alt="LimbeLabs" id="imgLogo" />
       </td>
	</tr>
	<tr>
		<td id='tdTalentBank' colspan="2">Talent Bank</td>
	</tr>

</table>

<h2 id="slogan"></h2>
<div id="header-tabs">

<ul>
	<li class="current" id="liwelcome"><a href="welcome.jsp"><span>Home</span></a></li>
	<li id="liHome"><a href="#"><span>Dash Board</span></a></li>
	<li id="link_config"><a href="#"><span>Configuration</span></a></li>
</ul>
</div>

</div>

<!-- content-wrap starts here -->
<div id="content-wrap">

<div id="divConfirmDialog" class="invisible" style="text-align: center"></div>
<div id="popMessage" class="invisible"></div>
<div id="popNote" class="invisible"></div>
<div id="waiting_message" class="invisible"><img
	src="ajax-loader.gif" /></div>
<div id="main">
<script type="text/javascript">
$.ajax({
      type: "GET",
      url: "stats.jsp",
      data: "",
      success: function(msg){
      //alert(msg);
	 $('#main').html(msg);
	   }
     });
</script></div>


<div id="footer"><span id="footer-left"> &copy;<strong><a
	href="http://limbelabs.com">Copyright Limbe Labs Solutions 2010.
All rights reserved</a></strong> </span> <span id="footer-right"> </span></div>

<!-- wrap ends here --></div>
</body>
</html>
<%
	} else {
			response.sendRedirect(userService.createLoginURL(request
					.getRequestURI()));

		}
	} else {
		response.sendRedirect(userService.createLoginURL(request
				.getRequestURI()));
	}
%>