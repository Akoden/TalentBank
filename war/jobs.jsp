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


// datasource for jobs.html.jsp



String result =  "";
String strOrdering="strJobCategoryName DESC";
String strConstraints="";
String strParams="";
String spage;
String rp;
String sortname;
String sortorder;
String squery;
String qqtype;
Logger log = Logger.getLogger(this.getClass().getName());

	try {
		PersistenceManager pm = PMF.get().getPersistenceManager();
		SimpleDateFormat fmt = new SimpleDateFormat(
		"MM/dd/yyyy");
		
        JSONArray arrayObj = new JSONArray();
        int pages = 1;
        spage=request.getParameter("page");
		rp=request.getParameter("rp");
		sortname=request.getParameter("sortname");
		sortorder=request.getParameter("sortorder");
		squery=request.getParameter("query");
		qqtype=request.getParameter("qtype");
		System.out.println(spage+" "+rp+" "+sortname+" "+sortorder+" "+squery+" "+qqtype);
		
    		
		try
        {
        	pages=Integer.parseInt(spage);
        }
        catch(Exception ex)
        {
        	pages = 1;
        }
		if(sortorder!=null && sortname!=null)
		{
			strOrdering=sortname+" "+sortorder.toUpperCase();
		}
		System.out.println("strOrdering=  "+strOrdering);
		Query query=null;
		String lg_group_ID=null;
	   query = pm.newQuery(T_Job_Category.class);
        
       query.setOrdering(strOrdering);
        List<T_Job_Category> lsT_Job_Category;
        lsT_Job_Category = (List<T_Job_Category>)query.execute();
		
		if(squery!=null && squery.length()>0 && qqtype!=null)
		{
			strConstraints=qqtype+"=="+qqtype+"Param";
			strParams=strParams+ ", String "+qqtype+"Param";
			 query = pm.newQuery(T_Job_Category.class,strConstraints);
			 query.declareParameters(strParams);
			 query.setOrdering(strOrdering);
			 lsT_Job_Category = (List<T_Job_Category>) query.execute(squery);
		}
        int i = 0;
		if (!lsT_Job_Category.isEmpty()) {
			System.out.println("lsT_Job_Category  --" + lsT_Job_Category.size());
			for (T_Job_Category g : lsT_Job_Category) {
				

					JSONObject json = new JSONObject();
					json.put("id", g.getLg_Job_Category_ID());
					JSONArray arrayObj1 = new JSONArray();
				
					SimpleDateFormat formatter = new SimpleDateFormat(
							"dd/MM/yyyy HH:mm");
					arrayObj1.put(g.getStrJobCategoryName());
					arrayObj1.put(g.getStrJobCategoryDesc());
					
					json.put("cell", arrayObj1);
					arrayObj.put(json);
					i++;
				}

			
			JSONObject json = new JSONObject();

			result = "{\"page\":" + pages + ",\"total\":" + lsT_Job_Category.size()
					+ ",\"rows\":" + arrayObj.toString() + "}";
		} else {
			result = "{\"page\":" + 1 + ",\"total\":" + 0
					+ ",\"rows\":[]}";

		}

	} catch (Exception ex) {
		 log.info("Error survenu :"+ex.getMessage());
		 out.print("{\"page\":" + 1 + ",\"total\":" + 0
					+ ",\"rows\":[]}");
	}
	out.print(result);
%>