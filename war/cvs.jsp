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


/**
This Jsp is the datesource for the grid in cvd.html.jsp
**/

//variables
String result =  "";
String strOrdering="dtReceivedDate DESC"; // order the CV
String strConstraints="dtReceivedDate>=dateDeb && dtReceivedDate<=dateFin";// constraints
String strParams="java.util.Date dateDeb,java.util.Date dateFin";//parameters for the request
String spage="1";//page to display
String rp;
String sortname;//name field to search on
String sortorder;//DESC or ASC
String squery;//query e.g strFirstName=
String qqtype;//value to search
Date dateDeb;//
Date dateFin;
String strStatus;
String lg_Job_Category_ID="ALL";
Logger log = Logger.getLogger(this.getClass().getName());

	try {
		PersistenceManager pm = PMF.get().getPersistenceManager();
		SimpleDateFormat fmt = new SimpleDateFormat("MM/dd/yyyy");
		strStatus="ALL";
		Calendar cal=Calendar.getInstance();
		dateFin=new Date();
		dateDeb=fmt.parse("01/01/2008");
		
		if(session.getAttribute("dateDeb")!=null)
		{   cal=Calendar.getInstance();
			dateDeb=(Date)session.getAttribute("dateDeb");
			
		}
		
		if(session.getAttribute("dateFin")!=null)
		{   cal=Calendar.getInstance();
			dateFin=(Date)session.getAttribute("dateFin");
			cal.setTime(dateFin);
	        cal.set(Calendar.DAY_OF_MONTH,cal.get(Calendar.DAY_OF_MONTH)+1);
	        dateFin=cal.getTime();
			
		}
		
		
		if(session.getAttribute("strStatus")!=null)
		{   
		strStatus=session.getAttribute("strStatus").toString();
        }
		
		
		if(session.getAttribute("lg_Job_Category_ID")!=null&& !"".equals(session.getAttribute("lg_Job_Category_ID")))
		{   
			lg_Job_Category_ID=session.getAttribute("lg_Job_Category_ID").toString();
        }
		
		
		  System.out.println(fmt.format(dateFin)+"  "+fmt.format(dateDeb));
	      
        JSONArray arrayObj = new JSONArray();
        
        int pages = 1;
        
        
        //params sent by the grid
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
    		
    	//order
		if(sortorder!=null && sortname!=null)
		{
			strOrdering=sortname+" "+sortorder.toUpperCase();
		}
		System.out.println("strOrdering=  "+strOrdering);
		
		Query query=null;
		String lg_group_ID=null;
		System.out.println("lg_Job_Category_ID= "+lg_Job_Category_ID);
		
		//build the constraints if strStatus or lg_Job_Category_ID are not equal to 'ALL' we have to search only the 
		//CD that corresponds to the specific value to search
		strConstraints=strConstraints+ ("ALL".equals(strStatus)?"":(" && strStatus=='"+strStatus+"'"));
		strConstraints=strConstraints+ ("ALL".equals(lg_Job_Category_ID)?"":(" && lg_Job_Category_ID=='"+lg_Job_Category_ID+"'"));
        
		
		//build the query
		query = pm.newQuery(T_CV.class,strConstraints);
        query.declareParameters(strParams);
        query.setOrdering(strOrdering);
        
        //get the list result list
        List<T_CV> lsT_CV;
        lsT_CV = (List<T_CV>)query.execute(dateDeb,dateFin);
		
		if(squery!=null && squery.length()>0 && qqtype!=null)
		{
			strConstraints=strConstraints+"&&"+qqtype+"=="+qqtype+"Param";
			strParams=strParams+ ", String "+qqtype+"Param";
			 query = pm.newQuery(T_CV.class,strConstraints);
			 query.declareParameters(strParams);
			 query.setOrdering(strOrdering);
			 lsT_CV = (List<T_CV>) query.execute(dateDeb,dateFin,squery);
		}
		
        int i = 0;
        
        //if there are CV found
		if (!lsT_CV.isEmpty()) 
		{
			System.out.println("lsT_CV  --" + lsT_CV.size());
			
			//build the json array data
			for (T_CV g : lsT_CV) 
			{
				

					JSONObject json = new JSONObject();
					json.put("id", g.getLg_CV_ID());
					JSONArray arrayObj1 = new JSONArray();
				
					SimpleDateFormat formatter = new SimpleDateFormat(
							"dd/MM/yyyy HH:mm");
					arrayObj1.put(g.getStrUserEmail());
					arrayObj1.put(g.getStrFirstName());
					arrayObj1.put(g.getStrLastName());
					arrayObj1.put(g.getStrFileName());
					arrayObj1.put(g.getLgFileSize());	                   
                    arrayObj1.put(formatter.format(g.getDtReceivedDate()));									
					json.put("cell", arrayObj1);
					arrayObj.put(json);
					i++;
				}

			
			JSONObject json = new JSONObject();

			result = "{\"page\":" + pages + ",\"total\":" + lsT_CV.size()
					+ ",\"rows\":" + arrayObj.toString() + "}";
		} 
		else 
		{
			result = "{\"page\":" + 1 + ",\"total\":" + 0
					+ ",\"rows\":[]}";

		}

	} 
	catch (Exception ex)
	{
		 log.info("Error survenu :"+ex.getMessage());
		 out.print("{\"page\":" + 1 + ",\"total\":" + 0
					+ ",\"rows\":[]}");
	}
	out.print(result);
%>