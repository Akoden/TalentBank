<%@ page import="javax.jdo.*"%>
<%@ page import="com.google.appengine.api.users.*"%>
<%@ page import="beans.*"%>
<%@ page import="utils.*"%>
<%@ page import="controller.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.util.logging.*"%>
<%@ page import="com.google.appengine.repackaged.org.json.*"%>
<%


// DISPLAY AND UPDATE THE NOTE ON A CV



String strNote="";
String lg_CV_ID=request.getParameter("lg_CV_ID");//get the CV ID
strNote=NoteUtils.getNoteValue(lg_CV_ID);//get the CV note
%>

<table border="0">
	<tr>
		<td><textarea name="strNote" id="strNote" cols="45" rows="5"><%=strNote %></textarea></td>
	</tr>
	<tr>
		<td>
		<button onclick="saveNote();">save</button>
		</td>
	</tr>
</table>
<script type="text/javascript">
//save the note using ajax
saveNote=function()
{
var strNote=document.getElementById("strNote").value;
var dataString="task=saveNote&strNote="+strNote+"&lg_CV_ID=<%=lg_CV_ID%>";
$.ajax({
      type: "GET",
      url: "requests.jsp",
      data:dataString,
      success: function(msg)
      {
	if(msg.indexOf("OK")>=0)
    {
	   
	      showPopup(300,100,1000,"Note saved");
	      closePopUp(1000);
	      var target = jQuery('div#popNote');
			target.dialog('close');
	      //$("#flex1").flexReload();
    }
    else{
    	showPopup(300,100,1000,"CV operation Failed");
    	closePopUp(1000);
    	
  	  //alert("CV operation Failed");
    }
	   
	   }
     });
	
	}
</script>