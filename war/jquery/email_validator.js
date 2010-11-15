//this function checks if an email is correct, syntax not if it really exist
function echeck(str) 
{
	
		var at="@"
		var dot="."
		var lat=str.indexOf(at)
		var lstr=str.length
		var ldot=str.indexOf(dot)		
		if (str.indexOf(at)==-1){
			$('#lblValid').html("Invalid E-mail ID");
		   
		   return false
		}

		if (str.indexOf(at)==-1 || str.indexOf(at)==0 || str.indexOf(at)==lstr){
			$('#lblValid').html("Invalid E-mail ID");
		   return false
		}

		if (str.indexOf(dot)==-1 || str.indexOf(dot)==0 || str.indexOf(dot)==lstr){
			$('#lblValid').html("Invalid E-mail ID");
		    return false
		}

		 if (str.indexOf(at,(lat+1))!=-1){
			 $('#lblValid').html("Invalid E-mail ID");
		    return false
		 }

		 if (str.substring(lat-1,lat)==dot || str.substring(lat+1,lat+2)==dot){
			 $('#lblValid').html("Invalid E-mail ID");
		    return false
		 }

		 if (str.indexOf(dot,(lat+2))==-1){
			 $('#lblValid').html("Invalid E-mail ID");
		    return false
		 }
		
		 if (str.indexOf(" ")!=-1){
			 $('#lblValid').html("Invalid E-mail ID");
		    return false
		 }
		 $('#lblValid').html("");
 		 return true					
	}


//function called when click on submit button in welcome.jsp
function ValidateForm()
{
	
	//step 1 : get the field from the input
	var strUserEmail= document.getElementById('strUserEmail').value;
	var strFirstName= document.getElementById('strFirstName').value;
	var strLastName= document.getElementById('strLastName').value;
	var strFileName= document.getElementById('strFileName').value;
	var lg_Job_Category_ID= document.getElementById('lg_Job_Category_ID').value;
	
	//this variable indicate if a field is not valid
	var bError=false;
	
	// check the email
	if ((strUserEmail==null)||(strUserEmail==""))
	{
		$('#strUserEmail').addClass('invalid_text');		
		bError=true;
	}
	if (echeck(strUserEmail)==false)
	{
		$('#strUserEmail').addClass('invalid_text');
		
		bError=true;	
	}
	
	//check the job categ
	if ((lg_Job_Category_ID==null)||(lg_Job_Category_ID==""))
	{
		$('#lg_Job_Category_ID').addClass('invalid_text');
		bError=true;
		
	}
	
	//check the lastname
	if ((strLastName==null)||(strLastName==""))
	{
		$('#strLastName').addClass('invalid_text');
		bError=true;
		
	}
	
	//check the first name
	if ((strFirstName==null)||(strFirstName==""))
	{
		$('#strFirstName').addClass('invalid_text');
		bError=true;
		
	}
	
	//check the filemae is not empty
	if ((strFileName==null)||(strFileName==""))
	{
		$('#strFileName').addClass('invalid_text');
		bError=true;
		
	}
	
	
	//check the file is a pdf file
	if((strFileName.indexOf(".pdf")!=(strFileName.length-4))&&(strFileName.indexOf(".PDF")!=(strFileName.length-4)))
	{
		 $('#lblValidFile').html("please select a pdf file");
		 document.getElementById('strFileName').value="";
		 bError=true;
	}
	
	//if there are not error then submit the form
	if(bError==false)
	{
		$('#filesForm').submit();
	}
		
 }