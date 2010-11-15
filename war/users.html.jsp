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
<%@ page import="utils.*"%>
<%@ page import="com.google.appengine.repackaged.org.json.*"%>
<%@ page import="java.util.logging.Logger"%>

<div id="message"></div>

<center>

<div id="forms1"></div>

<table id="flex2" style="display: none"></table>
</center>
<style>
.flexigrid div.fbutton .add {
	background: url(css/images/add.png) no-repeat center left;
}

.flexigrid div.fbutton .delete {
	background: url(css/images/close.png) no-repeat center left;
}
</style>
<script type="text/javascript">

 function loadDataUsers()
 {

			$('.flexme1').flexigrid();
			$('.flexme2').flexigrid({height:'auto',striped:false});
			
	    	
			$("#flex2").flexigrid
			(
			{
			url: 'users.jsp',
			dataType: 'json',
			colModel : [
			    {display: 'User Email', name : 'strUserEmail', width : 200, sortable : false, align: 'left'},
				  {display: 'First name', name : 'strFirstName', width : 200, sortable : false, align: 'left'},
				  {display: 'Last name', name : 'strLastName', width : 200, sortable : false, align: 'left'}					
               	
						],
			buttons : [
		
				{name: 'add User', bclass: 'add', onpress : test},
				{separator: true},				
				{name: 'Delete', bclass: 'delete', onpress : test},
				{separator: true}
				
				],
			searchitems : [
                {display: 'First name', name : 'strFirstName'},
				{display: 'Last name', name : 'strLastName'},
				{display: 'User Email', name : 'strUserEmail', isdefault: true}
				],
			sortname: "strUserEmail",
			sortorder: "desc",
			usepager: true,
			title: 'Users',
			useRp: false,
			rp: 10,
			showTableToggleBtn: false,
			width: 600,
			height: 230,
			}
			);
			
 }
 function RowSelected(id, row, grid)
 {
     //alert("row id is " + id);
 }
			function test(com,grid)
			{
				 if (com=='Delete')
				{ 	
				var str= $('.trSelected',grid)[0].id;
		    	var dataString = 'task=deleteUser&lg_User_ID='+str.substring(3,str.length);



		    	$('#divConfirmDialog').removeClass("invisible");
	    		$('#divConfirmDialog').html("confirm the deletion ?");
				var target = jQuery('div#divConfirmDialog');
				target.show();
				if (!target.dialog('isOpen')) {
					target.dialog( {
						autoOpen :false,
						bgiframe :true,
						modal :true,
						resizable :false,
						width :200,
						height :100,
						minHeight:100,
						position : [ 'center', 'center' ],
						draggable :true,
						buttons:
						{
						"yes" :function()
						 {
						$(this).dialog("close");

						$.ajax({
						      type: "POST",
						      url: "/user",
						      data: dataString,
						      success: function(msg)
						      {
							      if(msg.indexOf("OK")>=0)
							      {
								      
								      showPopup(100,100,1000,"User deleted");
								      $("#flex2").flexReload();
								      closePopUp(1000);
							      }
							      else{
							    	  showPopup(100,100,1000,"User deletion Failed");
							    	  closePopUp(1000);
							    	
							      }
							   }
						     });
					      
						 },
							"no" :function()
							 {
							$(this).dialog("close");
							 }
						}

					})
				}
				;
				target.dialog('open');
			
		
				}	
				
				else if (com=='add User')
				{ 	
					
			    	var dataString = '';

			   	 $.ajax({
				      type: "get",
				      url: "createUser.jsp",
				      data: dataString,
				      success: function(msg)
				      {
			   		$('#forms1').html(msg);
					   }
				     });

			    														
					}				
			}

			

		$('b.top').click
		(
			function ()
				{
					$(this).parent().toggleClass('fh');
				}
		);


		
 
 loadDataUsers();
</script>

