<!-- create a new user, not usefull now -->
<div id="divCreateMatch">
<center>
<table width="386" border="0">
	<tr>
		<td width="114" height="34">Email:</td>
		<td width="125"><input type="text" name="strUserEmail"
			id="strUserEmail" /></td>
	</tr>
	<tr>
		<td>First name</td>
		<td height="41"><input type="text" name="strFirstName"
			id="strFirstName" /></td>

	</tr>

	<tr>
		<td>Last name</td>
		<td height="41"><input type="text" name="strLastName"
			id="strLastName" /></td>

	</tr>
	<tr>
		<td colspan="2">
		<button id="addUser" onclick="addUserClick()">add User</button>
		</td>
	</tr>
</table>
</center>
</div>
<script type="text/javascript">

addUserClick=function () {
	
	var strUserEmail=document.getElementById("strUserEmail").value;
	var strFirstName=document.getElementById("strFirstName").value;
	var strLastName=document.getElementById("strLastName").value;
	
	
	
	//alert(str);
	var dataString = 'task=createUser&strUserEmail='
    	+strUserEmail+'&strFirstName='+strFirstName
    	+'&strLastName='+strLastName;	
	//alert(dataString);		   

 $.ajax({
  type: "POST",
  url: "/user",
  data: dataString,
  success: function(msg){
	 $("#divCreateMatch").fadeOut(0);	
		$("#flex2").flexReload();
		//alert("user saved");
		showPopup(100,75,1000,"user saved");
		$("#forms1").fadeOut();
		closePopUp(1000);
				
   }
 });
};

</script>