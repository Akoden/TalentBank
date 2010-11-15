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

<!-- Grid for the job category -->



<div id="message"></div>

<center>

<div id="forms"></div>

<table id="flex1" style="display: none"></table>
</center>
<style>
.flexigrid div.fbutton .add {
	background: url(css/images/add.png) no-repeat center left;
}

.flexigrid div.fbutton .delete {
	background: url(css/images/close.png) no-repeat center left;
}

.flexigrid div.fbutton .edit {
	background: url(images/leaf.gif) no-repeat center left;
}
</style>
<script type="text/javascript">

 function loadData()
 {

			$('.flexme1').flexigrid();
			$('.flexme2').flexigrid({height:'auto',striped:false});
			
	    	
			$("#flex1").flexigrid
			(
			{
			url: 'jobs.jsp',
			dataType: 'json',
			colModel : [
			    {display: 'Name', name : 'strJobCategoryName', width : 250, sortable : false, align: 'left'},
				{display: 'Description', name : 'strJobCategoryDesc', width : 450, sortable : false, align: 'left'}	
               	
						],
			buttons : [
		
				{name: 'NEW', bclass: 'add', onpress : test},
				{separator: true},				
				{name: 'EDIT', bclass: 'edit', onpress : test},
				{separator: true},				
				{name: 'DELETE', bclass: 'delete', onpress : test},
				{separator: true}
				
				],
			searchitems : [
                {display: 'Name', name : 'strJobCategoryName', isdefault: true}
				],
			sortname: "strJobCategoryName",
			sortorder: "ASC",
			usepager: true,
			title: 'Job Categories',
			useRp: false,
			rp: 10,
			showTableToggleBtn: false,
			width: 700,
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


				 if (com=='EDIT')
					{ 	
					var str= $('.trSelected',grid)[0].id;
			    	var dataString = 'lg_Job_Category_ID='+str.substring(3,str.length);
			    	 $.ajax({
					      type: "get",
					      url: "edit_job_categ.jsp",
					      data: dataString,
					      success: function(msg)
					      {
				   		$('#forms').html(msg);
						   }
					     });
			    	}
				 else if (com=='DELETE')
				{ 	
				
			
				
				
				
	    $('#divConfirmDialog').removeClass("invisible");
		$('#divConfirmDialog').html("confirm the deletion of this Job?");
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
				var str= $('.trSelected',grid)[0].id;
		    	var dataString = 'task=deleteJob&lg_Job_Category_ID='+str.substring(3,str.length);
				$.ajax({
				      type: "POST",
				      url: "requests.jsp",
				      data: dataString,
				      success: function(msg)
				      {
					      if(msg.indexOf("OK")>=0)
					      {
						     // alert("Job deleted");
						      showPopup(300,100,1000,"Job deleted");
						      $("#flex1").flexReload();
						      closePopUp(1000);
					      }
					      else{
					    	//  alert("Job deletion Failed");
					    	  showPopup(300,100,1000,"Job deletion Failed");
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
				
				else if (com=='NEW')
				{ 	
					
			    	var dataString = '';

			   	 $.ajax({
				      type: "get",
				      url: "createJobCateg.jsp",
				      data: dataString,
				      success: function(msg)
				      {
			   		$('#forms').html(msg);
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


		
 
 loadData();
</script>

