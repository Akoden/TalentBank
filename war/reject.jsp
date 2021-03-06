<%@ page import="javax.jdo.*"%>
<%@ page import="com.google.appengine.api.users.*"%>
<%@ page import="beans.*"%>
<%@ page import="utils.*"%>
<%@ page import="controller.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.util.logging.*"%>
<%@ page import="com.google.appengine.repackaged.org.json.*"%>
<%@ page import="com.google.appengine.api.datastore.Text"%>
<%


//REJECT MESSAGE 



UserService userService = UserServiceFactory.getUserService();
User user = userService.getCurrentUser();
PersistenceManager pm=null;
String reject_message="";
String reject_message_Title="";
try
{
pm = PMF.get().getPersistenceManager();
Query query=pm.newQuery(T_Config.class,"str_Name== str_NameP");
query.declareParameters("String str_NameP");

T_Config tConfig=null;
List<T_Config> lstConfigs=(List<T_Config>)query.execute(Parameters.reject_message.name());//get the config value

if(!lstConfigs.isEmpty())
{
	//if found set the value
	reject_message=lstConfigs.get(0).getTextValue().getValue();
}
else
{
	
	//if the parameter does not exist, create it
	
	tConfig=new T_Config();
	tConfig.setLg_Key_ID(DateUtils.getTimeId());
	tConfig.setStr_Name(Parameters.reject_message.name());
	tConfig.setStrDescription("content sent when a CV is rejected");
	tConfig.setTextValue(new Text(EmailSender.ACCEPTED_CV));
	
	pm.makePersistent(tConfig);
	
	System.out.print("save config"+Parameters.reject_message.name());
}

//get the title

query=pm.newQuery(T_Config.class,"str_Name== str_NameP");
query.declareParameters("String str_NameP");

tConfig=null;
lstConfigs=(List<T_Config>)query.execute(Parameters.reject_message_Title.name());
if(!lstConfigs.isEmpty())
{
	//if exist set value
	reject_message_Title=lstConfigs.get(0).getTextValue().getValue();
	System.out.print("config "+reject_message_Title);
}

else
{
	//if not exists create it
	tConfig=new T_Config();
	
	tConfig.setLg_Key_ID(DateUtils.getTimeId());
	tConfig.setStr_Name(Parameters.reject_message_Title.name());
	tConfig.setStrDescription("title of content sent when a CV is rejected");
	tConfig.setTextValue(new Text("CV rejected"));
	
	pm.makePersistent(tConfig);
	
	System.out.print("save config");
}
}
catch(Exception ex)
{
	ex.printStackTrace();
}
finally
{
	pm.close();
}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<script type="text/javascript" src="jquery/jquery-plus-jquery-ui.js"></script>
<link type="text/css" href="sample-style/ui-sui.css" rel="stylesheet" />
<link rel="stylesheet" href="tinyeditor/style.css" />
<link rel="stylesheet" href="common.css" type="text/css" />
<script type="text/javascript" src="tinyeditor/tinyeditor.js"></script>
<script type="text/javascript" src="common.js"></script>
<script type="text/javascript">
	/* ------ Code generated by IxEdit (ixedit.com). ------ */
	if(window.ixedit){ixedit.deployed = true};
	if(window.jQuery){jQuery(function(){
		




		
	    $('#tabRejectMessage').ajaxStart( showWaiting); 

	    $('#tabRejectMessage').ajaxStop( closeWaiting); 
	    
		})};



		
</script>

</head>
<body>
<div id="divConfirmDialog" class="invisible" style="text-align: center"></div>
<div id="popMessage" class="invisible"></div>
<div id="popNote" class="invisible"></div>
<div id="waiting_message" class="invisible"><img
	src="ajax-loader.gif" /></div>
<table border="0" id="tabRejectMessage">
	<tr>
		<td>Title</td>
	</tr>
	<tr>
		<td style="text-align: left;" id="tdRejectMessage"><input
			type="text" name="strRejectTitle" id="strRejectTitle"
			value="<%=reject_message_Title %>"></td>
	</tr>
	<tr>
		<td>Content</td>
	</tr>
	<tr>
		<td style="text-align: left;"><textarea name="strRejectMessage"
			id="strRejectMessage" cols="45" rows="5"><%=reject_message %></textarea></td>
	</tr>
	<tr>
		<td>
		<div align="center">
		<button onclick="saveValue();" class="uibutton">save</button>
		</div>
		</td>
	</tr>
</table>
<script type="text/javascript">
var txtRejectMessage = new TINY.editor.edit('editor',{
	id:'strRejectMessage',
	width:584,
	height:175,
	cssclass:'te',
	controlclass:'tecontrol',
	rowclass:'teheader',
	dividerclass:'tedivider',
	controls:['bold','italic','underline','strikethrough','|','subscript','superscript','|',
			  'orderedlist','unorderedlist','|','outdent','indent','|','leftalign',
			  'centeralign','rightalign','blockjustify','|','unformat','|','undo','redo','n',
			  'font','size','style','|','image','hr','link','unlink','|','cut','copy','paste','print'],
	footer:true,
	fonts:['Verdana','Arial','Georgia','Trebuchet MS'],
	xhtml:true,
	cssfile:'tinyeditor/style.css',
	bodyid:'editor',
	footerclass:'tefooter',
	toggle:{text:'source',activetext:'wysiwyg',cssclass:'toggle'},
	resize:{cssclass:'resize'}
});

saveValue=function()
{
	txtRejectMessage.post() ;

	var strRejectTitle=document.getElementById("strRejectTitle").value;
var strRejectMessage=document.getElementById("strRejectMessage").value;





var dataString = 'task=updateRejectMessage&strRejectTitle='
	+strRejectTitle+'&strRejectMessage='+strRejectMessage
;	

//alert(dataString);
	
  		$.ajax({
		      type: "GET",
		      url: "requests.jsp",
		      data: dataString ,
		      success: function(msg)
		      {
		    
  			if(msg.indexOf("OK")>=0)
		      {
			     // alert("message saved");
			      showPopup(300,100,1000,"message saved");
			      closePopUp(1000);
			     // $("#flex1").flexReload();
		      }
		      else{
		    	//  alert("operation failed try again");
		    	  showPopup(300,100,1000,"operation failed try again");
		    	  closePopUp(1000);
		      }
			   }
		     });

};

</script>
</body>
</html>