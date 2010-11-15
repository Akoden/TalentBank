<%@page import="beans.T_Job_Category"%>

<%@page import="controller.JobCategController"%>

<%

String lg_Job_Category_ID=request.getParameter("lg_Job_Category_ID");

T_Job_Category job=JobCategController.getJobCategsByID(lg_Job_Category_ID);

%>
<div id="divCreateMatch">
<center>
<table border="0">
	<tr>
		<td width="200" height="34">Job Category Name:</td>
		<td width="150"><input type="text" name="strJobCategoryName"
			id="strJobCategoryName" value="<%=job.getStrJobCategoryName() %>" /></td>
	</tr>
	<tr>
		<td width="200">Job Description</td>
		<td><textarea name="strJobCategoryDesc" id="strJobCategoryDesc"
			cols="45" rows="5"><%=job.getStrJobCategoryDesc() %></textarea></td>

	</tr>

	<tr>
		<td colspan="2">
		<button id="addJob" onclick="editJobClick()">save Job</button>
		</td>
	</tr>
</table>
</center>
</div>
<script type="text/javascript">

editJobClick=function () {
	var lg_Job_Category_ID='<%=request.getParameter("lg_Job_Category_ID")%>';
	var strJobCategoryName=document.getElementById("strJobCategoryName").value;
	var strJobCategoryDesc=document.getElementById("strJobCategoryDesc").value;
	var bError=false;
	if ((strJobCategoryName==null)||(strJobCategoryName=="")){
		$('#strJobCategoryName').addClass('invalid_text');
		bError=true;
		
	}
	if ((strJobCategoryDesc==null)||(strJobCategoryDesc=="")){
		$('#strJobCategoryDesc').addClass('invalid_text');
		bError=true;
		
	}
    if(bError==true)
    {
        
        showPopup(100,75,1000,"Enter mandatory fields....");
    }
	else (bError=false)
	{
	//alert(str);
	var dataString = 'task=editJob&strJobCategoryName='
    	+strJobCategoryName+'&strJobCategoryDesc='+strJobCategoryDesc+'&lg_Job_Category_ID='+lg_Job_Category_ID;	
	//alert(dataString);		   

 $.ajax({
  type: "POST",
  url: "requests.jsp",
  data: dataString,
  success: function(msg){
	 $("#divCreateMatch").fadeOut(0);	
		$("#flex1").flexReload();
		//alert("job saved");
		showPopup(100,75,1000,"job saved");
		closePopUp(1000);
				
   }
 });
	}
};

</script>