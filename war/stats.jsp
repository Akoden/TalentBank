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

//THIS PAGE SHOWS THE SUMMARY ON CVS
//



int nbReceived=0;//number of cv in talent bank
int nbAccepted=0;//number of accepted CV 
int nbRejected=0;//number of rejected Cvs
int nbUnsort=0;//number of unsort CV

session.setAttribute("dateDeb", null);
session.setAttribute("dateFin", null);
session.setAttribute("strStatus", null);
session.setAttribute("lg_Job_Category_ID", null);


    PersistenceManager pm = null;
    pm = PMF.get().getPersistenceManager();
    
	Query query =null;
	
	//unsorted
	
	query=pm.newQuery(T_CV.class,"strStatus==strStatusP");
	query.declareParameters("String strStatusP");
	
	
	List<T_CV> lsT_CV = (List<T_CV>)query.execute(T_CV.STATUS_NON_SORTED);
	nbUnsort=lsT_CV.size();

	//accepted
	query=pm.newQuery(T_CV.class,"strStatus==strStatusP");
	query.declareParameters("String strStatusP");

	 lsT_CV = (List<T_CV>)query.execute(T_CV.STATUS_ACCEPTED);
	 nbAccepted=lsT_CV.size();


	 //rejected 
	query=pm.newQuery(T_CV.class,"strStatus==strStatusP");
	query.declareParameters("String strStatusP");
	 lsT_CV = (List<T_CV>)query.execute(T_CV.STATUS_REJECTED);
	nbRejected=lsT_CV.size();
     
	
	
	  //all CVS
	 query=pm.newQuery(T_CV.class);
	 lsT_CV = (List<T_CV>)query.execute();
	 nbReceived=lsT_CV.size();
	 List<T_Job_Category> lstJobCategories=JobCategController.getJobCategs();
	

 %>

<h1></h1>
<%if (request.getParameter("noResult")!=null)
	{
     // if a search has empty resultset 
	%>
<script type="text/javascript">


showPopup(200,50,1000,"No Result Found!!!!");
closePopUp(1000);

</script>

<%	System.out.println("NO RESULT");
} %>
<h2 class="widgettitle">Over all CVs</h2>
<center>
<table class="tabduplicate">
	<tr>
		<th class="colVgrid"></th>
		<th class="colVgrid"></th>
		<th class="colVgrid"></th>
		<th class="colVgrid"></th>
	</tr>
	<tr>
		<td class="td1">Unsorted CV:<b class="bNumber"> <%=nbUnsort %></b></td>

		<td class="td22">
		<%if(nbUnsort>0){ %> <a
			href="javascript:showInGrid('<%=T_CV.STATUS_NON_SORTED %>','ALL');">Grid</a>
		<%} %>
		</td>
		<td class="td22">
		<%if(nbUnsort>0){ %> /<%} %>
		</td>
		<td class="td22">
		<%if(nbUnsort>0){ %> <a
			href="javascript:viewList('<%=T_CV.STATUS_NON_SORTED %>','ALL');">Viewer</a>
		<%} %>
		</td>
	</tr>



	<tr>
		<td class="td11">Accepted CV: <b class="bNumber"><%=nbAccepted %></b>
		</td>
		<td class="td22">
		<%if(nbAccepted>0){ %> <a
			href="javascript:showInGrid('<%=T_CV.STATUS_ACCEPTED %>','ALL');">Grid</a>
		<%} %>
		</td>
		<td class="td22">
		<%if(nbAccepted>0){ %> /<%} %>
		</td>
		<td class="td22">
		<%if(nbAccepted>0){ %> <a
			href="javascript:viewList('<%=T_CV.STATUS_ACCEPTED %>','ALL');">Viewer</a>
		<%} %>
		</td>
	</tr>


	<tr>
		<td class="td11">Rejected CV: <b class="bNumber"><%=nbRejected %></b></td>




		<td class="td22">
		<%if(nbRejected>0){ %> <a
			href="javascript:showInGrid('<%=T_CV.STATUS_REJECTED %>','ALL');">Grid</a>
		<%} %>
		</td>
		<td class="td22">
		<%if(nbRejected>0){ %> /<%} %>
		</td>
		<td class="td22">
		<%if(nbRejected>0){ %> <a
			href="javascript:viewList('<%=T_CV.STATUS_REJECTED %>','ALL');">Viewer</a>
		<%} %>
		</td>
	</tr>


	<tr>
		<td class="td1">All the CV: <b class="bNumber"><%=nbReceived%></b></td>
		<td class="td22">
		<%if(nbReceived>0){ %> <a href="javascript:showInGrid('ALL','ALL');">Grid</a>
		<%} %>
		</td>
		<td class="td22">
		<%if(nbReceived>0){ %> /<%} %>
		</td>
		<td class="td22">
		<%if(nbReceived>0){ %> <a href="javascript:viewList('ALL','ALL');">Viewer</a>
		<%} %>
		</td>
	</tr>


</table>
</center>

<%
//list the job categories CVS
if(lstJobCategories==null) 
	{
	lstJobCategories=new ArrayList<T_Job_Category>();
	
	}
if(!lstJobCategories.isEmpty())
{%>
<h1></h1>
<h2 class="widgettitle">Job Category statistics</h2>
<center>
<table class="tabduplicate">
	<tr>
		<th class="colVgrid"></th>
		<th class="colVgrid"></th>
		<th class="colVgrid"></th>
	</tr>
	<%
	for(T_Job_Category job:lstJobCategories)
	{
		List<T_CV> lstT_CV=JobCategController.getJobsCV(job.getLg_Job_Category_ID());
		int nbCV=lstT_CV==null?0:lstT_CV.size();
%>


	<tr>
		<td class="td11"><%=job.getStrJobCategoryName() %>:<b
			class="bNumber"> <%=nbCV %></b></td>

		<td class="td22">
		<%if(nbCV>0){ %> <a
			href="javascript:showInGrid('ALL','<%=job.getLg_Job_Category_ID()%>');">Grid</a>
		<%} %>
		</td>
		<td class="td22">
		<%if(nbCV>0){ %> /<%} %>
		</td>
		<td class="td22">
		<%if(nbCV>0){ %> <a
			href="javascript:viewList('ALL','<%=job.getLg_Job_Category_ID()%>');">Viewer</a>
		<%} %>
		</td>
	</tr>

	<%
} 
%>
</table>
</center>
<%
}
%>
<table class="tabSearchBar">
	<tr>
		<th width="15%">Job</th>
		<th width="15%">Status</th>
		<th width="20%">Email</th>
		<th width="25%">Name</th>
		<th width="15%">Display</th>
		<th width="10%"></th>
	</tr>
	<tr>
		<td><select name="lg_Job_Category_ID" id="lg_Job_Category_IDs">
			<option value="ALL">ALL</option>
			<%for(T_Job_Category job:lstJobCategories) 
    {%>
			<option value="<%=job.getLg_Job_Category_ID() %>"><%=job.getStrJobCategoryName()%></option>
			<%} %>
		</select></td>
		<td><select name="strStatus" id="strStatus0">
			<option value="ALL">ALL</option>
			<option value="unsorted">Unsorted</option>
			<option value="accepted">Accepted</option>
			<option value="rejected">Rejected</option>
		</select></td>
		<td><input type="text" name="strUserEmail" id="strUserEmails0"
			value="" onchange="echeck(this.value)" /><b id="lblValid"></b></td>
		<td><input type="text" name="strUserName" id="strUserName0"
			value="" /></td>
		<td><select name="strDisplay" id="strDisplay">
			<option value="viewer">Viewer</option>
			<option value="grid">Grid</option>

		</select></td>
		<td>
		<button class='uibutton' onclick="searchFromBar();" >search</button>
		</td>
	</tr>
</table>
<script type="text/javascript">
	
</script>