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
String result =  "";
String strOrdering="strUserEmail DESC";
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
	   query = pm.newQuery(T_User.class);
        
       query.setOrdering(strOrdering);
        List<T_User> lsT_User;
        lsT_User = (List<T_User>)query.execute();
		
		if(squery!=null && squery.length()>0 && qqtype!=null)
		{
			strConstraints=qqtype+"=="+qqtype+"Param";
			strParams=strParams+ ", String "+qqtype+"Param";
			 query = pm.newQuery(T_User.class,strConstraints);
			 query.declareParameters(strParams);
			 query.setOrdering(strOrdering);
			 lsT_User = (List<T_User>) query.execute(squery);
		}
        int i = 0;
		if (!lsT_User.isEmpty()) {
			System.out.println("lsT_User  --" + lsT_User.size());
			for (T_User g : lsT_User) {
				

					JSONObject json = new JSONObject();
					json.put("id", g.getLg_User_ID());
					JSONArray arrayObj1 = new JSONArray();
				
					SimpleDateFormat formatter = new SimpleDateFormat(
							"dd/MM/yyyy HH:mm");
					arrayObj1.put(g.getStrUserEmail());
					arrayObj1.put(g.getStrFirstName());
					arrayObj1.put(g.getStrLastName());
					json.put("cell", arrayObj1);
					arrayObj.put(json);
					i++;
				}

			
			JSONObject json = new JSONObject();

			result = "{\"page\":" + pages + ",\"total\":" + lsT_User.size()
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