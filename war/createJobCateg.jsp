<!-- jsp to create a job category -->

<div id="divCreateMatch">
<center>
<table border="0">
	<tr>
		<td width="200" height="34">Job Category Name:</td>
		<td width="150"><input type="text" name="strJobCategoryName"
			id="strJobCategoryName" /></td>
	</tr>
	<tr>
		<td width="200">Job Description</td>
		<td><textarea name="strJobCategoryDesc" id="strJobCategoryDesc"
			cols="45" rows="5"></textarea></td>

	</tr>

	<tr>
		<td colspan="2">
		<button id="addJob" onclick="addJobClick()">add Job</button>
		</td>
	</tr>
</table>
</center>
</div>
<script type="text/javascript">

addJobClick=function () {

	//get the values
	var strJobCategoryName=document.getElementById("strJobCategoryName").value;
	var strJobCategoryDesc=document.getElementById("strJobCategoryDesc").value;
	var bError=false;

	//check categ name
	if ((strJobCategoryName==null)||(strJobCategoryName=="")){
		$('#strJobCategoryName').addClass('invalid_text');
		bError=true;
		
	}
	
	//check description
	if ((strJobCategoryDesc==null)||(strJobCategoryDesc=="")){
		$('#strJobCategoryDesc').addClass('invalid_text');
		bError=true;
		
	}
	//if errors show alert box
    if(bError==true)
    {
        
        showPopup(100,75,1000,"Enter mandatory fields....");
        closePopUp(1000);
    }

    //if no errors
	else (bError=false)
	{
	//alert(str);
	
	//build the request
	var dataString = 'task=createJob&strJobCategoryName='
    	+strJobCategoryName+'&strJobCategoryDesc='+strJobCategoryDesc;		   

	   //ajax function to save
       $.ajax(
    	     {
                type: "POST",
                url: "requests.jsp",
                data: dataString,
                success: function(msg)
                {
	                $("#divCreateMatch").fadeOut(0);	
		            $("#flex1").flexReload();
		            showPopup(100,75,1000,"job saved");
		            closePopUp(1000);
				}
             }
             );
	}
};

</script>