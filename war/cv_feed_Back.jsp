<%@page import="com.google.appengine.api.datastore.Key"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="javax.jdo.*"%>
<%@ page import="com.google.appengine.api.users.*"%>
<%@ page import="beans.*"%>
<%@ page import="controller.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.util.logging.*"%>
<%@ page import="com.google.appengine.repackaged.org.json.*"%>
<%PersistenceManager pm=null;
Logger log = Logger.getLogger(this.getClass().getName());
T_CV ocCv=null;
	try {
		pm = PMF.get().getPersistenceManager();
		String task = request.getParameter("task");
		
		
			String lg_CV_ID = request.getParameter("lg_CV_ID");
			Query query = pm.newQuery(T_CV.class,
					"lg_CV_ID == lg_CV_IDParam");
			query.declareParameters("String lg_CV_IDParam");
			List<T_CV> lsTCV = (List<T_CV>) query.execute(lg_CV_ID);
			if (lsTCV.isEmpty()) {

			} else {
				
				
				System.out.println(lsTCV.size() + "   "
						+ lsTCV.get(0).getStrUserEmail());
				ocCv=lsTCV.get(0);
					
				

			}
		 if(ocCv!=null)
		 {
		
		%>
<div id="divFeedBack">
<table border="0">
	<tr>
		<td width="76">To</td>
		<td width="487"><input type="text" name="strUserEmail"
			id="strUserEmail" value="<%=ocCv.getStrUserEmail()%>"> <input
			type="hidden" name="lg_CV_ID" id="lg_CV_ID"
			value="<%=ocCv.getLg_CV_ID()%>"></td>
	</tr>
	<tr>
		<td>Title</td>
		<td><input type="text" name="strTitle" value="Feed back"
			id="strTitle"></td>
	</tr>
	<tr>
		<td colspan="2"><textarea name="strEmailcontent"
			id="strEmailcontent" cols="45" rows="5"></textarea></td>
	</tr>
	<tr>
		<td colspan="2">
		<button id="btnAddMatch" onclick="sendFeedBack();">save</button>
		</td>
	</tr>
</table>
<script type="text/javascript">

sendFeedBack=function () {
	
	var lg_CV_ID=document.getElementById("lg_CV_ID").value;
	var strTitle=document.getElementById("strTitle").value;
	var strEmailcontent=document.getElementById("strEmailcontent").value;	
	{
	
	//alert(str);
	var dataString = 'task=feedBackCV&lg_CV_ID='
    	+lg_CV_ID+'&strTitle='+strTitle
    	+'&strEmailcontent='+strEmailcontent ;   	
	//alert(dataString);		   

 $.ajax({
  type: "GET",
  url: "/download",
  data: dataString,
  success: function(msg){
		//alert("Feed back sent");
		showPopup(100,75,1000,"Feed back sent");
		$("#divFeedBack").fadeOut(0);	
				
   }
 });
}
	};

</script></div>

<%
		 
		 }
	} catch (Exception e) {
		//e.printStackTrace();
	}
	finally
	{
		try
		{pm.close();
		}
		catch(Exception ex)
		{
			//ex.printStackTrace();
		}
	}
	%>