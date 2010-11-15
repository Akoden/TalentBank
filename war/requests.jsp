<%@page import="com.google.appengine.api.datastore.Key"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html;charset=UTF-8" language="java"%>
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
/**
this jsp is the main controller of the application
Many Request are submitted here
every request has a "task" parameter that indicates what to do 
some other parameters can be available according to whar is needed

**/
%>
<%

//get the connected user ,using GOOGLE API
UserService userService = UserServiceFactory.getUserService();
User user = userService.getCurrentUser();


PersistenceManager pm=null;


//check if it is and admin who is connected
if((user != null)&&(userService.isUserAdmin()==true)) 
{
try 
{

     Logger log = Logger.getLogger(this.getClass().getName());
      pm = PMF.get().getPersistenceManager();
    
      {
	
		 pm = PMF.get().getPersistenceManager();
		 
		String task = request.getParameter("task");//get the task
		
		
		//creating a job category 
		if("createJob".equals(task))
		{
			String strJobCategoryName=request.getParameter("strJobCategoryName");
			String strJobCategoryDesc=request.getParameter("strJobCategoryDesc");
			boolean res=JobCategController.createJobCateg(strJobCategoryName,strJobCategoryDesc);
			if(res)
			{
				out.print("OK".trim());
			}
		}
		
		//edit a job category
		else if("editJob".equals(task))
		{
			String strJobCategoryName=request.getParameter("strJobCategoryName");
			String strJobCategoryDesc=request.getParameter("strJobCategoryDesc");
			String lg_Job_Category_ID=request.getParameter("lg_Job_Category_ID");
			boolean res=JobCategController.updateJobCateg(lg_Job_Category_ID,strJobCategoryName,strJobCategoryDesc);
			if(res)
			{
				out.print("OK".trim());
			}
		}
		
		//delete a job category
		else if ("deleteJob".equals(task)) 
		{
			String lg_Job_Category_ID = request.getParameter("lg_Job_Category_ID");
			Query query = pm.newQuery(T_Job_Category .class,
					"lg_Job_Category_ID == lg_Job_Category_IDParam");
			query.declareParameters("String lg_Job_Category_IDParam");
			List<T_Job_Category > lsT_Job_Category  = (List<T_Job_Category >) query.execute(lg_Job_Category_ID);
			if (lsT_Job_Category.isEmpty()) {

			} else {
				System.out.println(lsT_Job_Category .size() + "   "
						+ lsT_Job_Category .get(0).getStrJobCategoryName());
				pm.deletePersistent(lsT_Job_Category .get(0));
				out.print("OK".trim());
			}
		 
		
		}
		
		//delete a CV from the Grid
		else if ("deleteCV".equals(task))
		{
			String lg_CV_ID = request.getParameter("lg_CV_ID");
			
			log.info("delete cv lg_CV_ID= "+lg_CV_ID);
			
			Query query = pm.newQuery(T_CV.class,"lg_CV_ID == lg_CV_IDParam");
			query.declareParameters("String lg_CV_IDParam");
			
			List<T_CV> lsTCV = (List<T_CV>) query.execute(lg_CV_ID);
			if (lsTCV.isEmpty()) 
			{
				
				log.warning("Toi tu supprimes quelqu'un qui n'existe pas?!!!!");

			} 
			else 
			{
			
				
				System.out.println(lsTCV.size() + "   "
						+ lsTCV.get(0).getStrUserEmail());
				T_CV ocv=lsTCV.get(0);
				
				
				//new EmailSender().send(ocv.getStrUserEmail(),ocv.getStrFirstName()+" "+ocv.getStrLastName(),ConfigUtils.getConfigValue(Parameters.accept_message_Title.name()),ConfigUtils.getConfigValue(Parameters.accept_message.name()));
				pm.deletePersistent(ocv);
				pm.close();
				
				out.print("OK".trim());
			}
		 	
		}
		
		
		//accept a CV from the Grid
		else if ("acceptCV".equals(task)) 
		{
			String lg_CV_ID = request.getParameter("lg_CV_ID");
			Query query = pm.newQuery(T_CV.class,
					"lg_CV_ID == lg_CV_IDParam");
			query.declareParameters("String lg_CV_IDParam");
			List<T_CV> lsTCV = (List<T_CV>) query.execute(lg_CV_ID);
			if (lsTCV.isEmpty())
			{

			} 
			else 
			{
				System.out.println(lsTCV.size() + "   "
						+ lsTCV.get(0).getStrUserEmail());
				T_CV ocv=lsTCV.get(0);
				ocv.setStrStatus(T_CV.STATUS_ACCEPTED);
				pm.makePersistent(ocv);
				new EmailSender().send(ocv.getStrUserEmail(),ocv.getStrFirstName()+" "+ocv.getStrLastName(),ConfigUtils.getConfigValue(Parameters.accept_message_Title.name()),ConfigUtils.getConfigValue(Parameters.accept_message.name()));
				
				out.print("OK".trim());
			}
		 
		
		}
		
		//update a configuration value
		else if ("updateConfig".equals(task)) 
		{
			String str_Name = request.getParameter("str_Name");
			String strValue=request.getParameter("strValue");
			Query query = pm.newQuery(T_Config.class,
					"str_Name == str_NameParam");
			query.declareParameters("String str_NameParam");
			List<T_Config> lsT_Config = (List<T_Config>) query
					.execute(str_Name);
			if (lsT_Config.isEmpty()) 
			{

			} else {
				System.out.println(lsT_Config.size() + "   "
						+ lsT_Config.get(0).getStr_Name());
						T_Config oT_Config=lsT_Config.get(0);
						oT_Config.setStrValue(strValue);
				pm.makePersistent(oT_Config);	
				
				out.print("OK".trim());
			}
		 
		
		}
		
		//update the accept message
		else if ("updateAcceptMessage".equals(task))
		{
			String strAcceptTitle = request.getParameter("strAcceptTitle");
			String strAcceptMessage=request.getParameter("strAcceptMessage");
			
			
			
			
			
			boolean b1=ConfigUtils.updateConfig(Parameters.accept_message.name(),strAcceptMessage);
			
			boolean b2=ConfigUtils.updateConfig(Parameters.accept_message_Title.name(),strAcceptTitle);
		  
			if(b1 && b2)
			{
				out.print("OK".trim());
			}
		
		}
		
		
		//update the reject message
		else if ("updateRejectMessage".equals(task))
		{
			String strRejectTitle = request.getParameter("strRejectTitle");
			String strRejectMessage=request.getParameter("strRejectMessage");
			System.out.println("New strRejectMessage Message = "+strRejectMessage);
			
			boolean b1=ConfigUtils.updateConfig(Parameters.reject_message.name(),strRejectMessage);
			
			boolean b2=ConfigUtils.updateConfig(Parameters.reject_message_Title.name(),strRejectTitle);
		  
			if(b1 && b2)
			{
				out.print("OK".trim());
			}
		
		}
		
		
		//save the Note on a CV
		else if ("saveNote".equals(task)) 
		{
			String lg_CV_ID = request.getParameter("lg_CV_ID");
			String strNote=request.getParameter("strNote");
			System.out.println(strNote+" CV "+lg_CV_ID);
			boolean b=NoteUtils.updateNote(lg_CV_ID,strNote);
			if(b)
			{
				out.print("OK".trim());
			}
			
		}
		
		//delete a CV from the viewer
		else if ("deleteCVList".equals(task))
		{
			String lg_CV_ID = request.getParameter("lg_CV_ID");
			int lg_CV_ID_pos=Integer.parseInt(request.getParameter("lg_CV_ID_pos"));
			
			Query query = pm.newQuery(T_CV.class,
					"lg_CV_ID == lg_CV_IDParam");
			query.declareParameters("String lg_CV_IDParam");
			List<T_CV> lsTCV = (List<T_CV>) query.execute(lg_CV_ID);
			if (lsTCV.isEmpty()) {
				response.sendRedirect("stats.jsp");
			} 
			else
			{
				System.out.println(lsTCV.size() + "   "
						+ lsTCV.get(0).getStrUserEmail());
				T_CV ocv=lsTCV.get(0);
				
				
				//new EmailSender().send(ocv.getStrUserEmail(),ocv.getStrFirstName()+" "+ocv.getStrLastName(),ConfigUtils.getConfigValue(Parameters.accept_message_Title.name()),ConfigUtils.getConfigValue(Parameters.accept_message.name()));
				pm.deletePersistent(ocv);
				List<String> lstT_CV=(List<String>)session.getAttribute("lstT_CV");
				lstT_CV.remove(lg_CV_ID);
				if(lstT_CV.size()==0)
				{
					response.sendRedirect("stats.jsp");
					   
				}
				else 
			   {if(lg_CV_ID_pos==lstT_CV.size())
				{
					lg_CV_ID_pos=0;
				}
				response.sendRedirect("viewCV.jsp?lg_CV_ID="+lstT_CV.get(lg_CV_ID_pos)+"&lg_CV_ID_pos="+lg_CV_ID_pos);
		
			}
		 
			}
		}
		
		//accept a CV from viewer
		else if ("acceptCVList".equals(task)) 
		{
			String lg_CV_ID = request.getParameter("lg_CV_ID");
			int lg_CV_ID_pos=Integer.parseInt(request.getParameter("lg_CV_ID_pos"));
			
			Query query = pm.newQuery(T_CV.class,"lg_CV_ID == lg_CV_IDParam");
			query.declareParameters("String lg_CV_IDParam");
			List<T_CV> lsTCV = (List<T_CV>) query.execute(lg_CV_ID);
			
			if (lsTCV.isEmpty()) 
			{
				response.sendRedirect("stats.jsp");//back to dash board

			} else 
			{
				System.out.println(lsTCV.size() + "   "
						+ lsTCV.get(0).getStrUserEmail());
				T_CV ocv=lsTCV.get(0);
				ocv.setStrStatus(T_CV.STATUS_ACCEPTED);
				pm.makePersistent(ocv);
				new EmailSender().send(ocv.getStrUserEmail(),ocv.getStrFirstName()+" "+ocv.getStrLastName(),ConfigUtils.getConfigValue(Parameters.accept_message_Title.name()),ConfigUtils.getConfigValue(Parameters.accept_message.name()));
				
				List<String> lstT_CV=(List<String>)session.getAttribute("lstT_CV");
				lstT_CV.remove(lg_CV_ID);
				if(lstT_CV.size()==0)
				{
					response.sendRedirect("stats.jsp");
					   
				}
				else 
				{
					if(lg_CV_ID_pos==lstT_CV.size())
					{
					  lg_CV_ID_pos=0;
					}
				response.sendRedirect("viewCV.jsp?lg_CV_ID="+lstT_CV.get(lg_CV_ID_pos)+"&lg_CV_ID_pos="+lg_CV_ID_pos);
				}
		   }
		}
		
		
		//reject CV from list
		else if ("rejectCVList".equals(task)) 
		{
			String lg_CV_ID = request.getParameter("lg_CV_ID");
			int lg_CV_ID_pos=Integer.parseInt(request.getParameter("lg_CV_ID_pos"));
			
			Query query = pm.newQuery(T_CV.class,"lg_CV_ID == lg_CV_IDParam");
			query.declareParameters("String lg_CV_IDParam");
			List<T_CV> lsTCV = (List<T_CV>) query.execute(lg_CV_ID);
			if (lsTCV.isEmpty()) 
			{
				response.sendRedirect("stats.jsp");

			} 
			else 
			{
				System.out.println(lsTCV.size() + "   "
						+ lsTCV.get(0).getStrUserEmail());
				T_CV ocv=lsTCV.get(0);
				ocv.setStrStatus(T_CV.STATUS_REJECTED);
				pm.makePersistent(ocv);	
				
				new EmailSender().send(ocv.getStrUserEmail(),ocv.getStrFirstName()+" "+ocv.getStrLastName(),ConfigUtils.getConfigValue(Parameters.reject_message_Title.name()),ConfigUtils.getConfigValue(Parameters.reject_message.name()));
				List<String> lstT_CV=(List<String>)session.getAttribute("lstT_CV");
				lstT_CV.remove(lg_CV_ID);
				if(lstT_CV.size()==0)
				{
					response.sendRedirect("stats.jsp");
					   
				}
				else 
			   {if(lg_CV_ID_pos==lstT_CV.size())
				{
					lg_CV_ID_pos=0;
				}
				response.sendRedirect("viewCV.jsp?lg_CV_ID="+lstT_CV.get(lg_CV_ID_pos)+"&lg_CV_ID_pos="+lg_CV_ID_pos);
				  
			   }
			}
		}
		
		//reject CV from grid
		else if ("rejectCV".equals(task)) {
			String lg_CV_ID = request.getParameter("lg_CV_ID");
			Query query = pm.newQuery(T_CV.class,
					"lg_CV_ID == lg_CV_IDParam");
			query.declareParameters("String lg_CV_IDParam");
			List<T_CV> lsTCV = (List<T_CV>) query
					.execute(lg_CV_ID);
			if (lsTCV.isEmpty()) 
			{

			} else 
			{
				System.out.println(lsTCV.size() + "   "
						+ lsTCV.get(0).getStrUserEmail());
				T_CV ocv=lsTCV.get(0);
				ocv.setStrStatus(T_CV.STATUS_REJECTED);
				pm.makePersistent(ocv);	
				
				new EmailSender().send(ocv.getStrUserEmail(),ocv.getStrFirstName()+" "+ocv.getStrLastName(),ConfigUtils.getConfigValue(Parameters.reject_message_Title.name()),ConfigUtils.getConfigValue(Parameters.reject_message.name()));
				out.print("OK".trim());
			}
		 
		
		}
		
		
		//search from dash board
		else if("statSearch".equals(task))
		{
			System.out.println("start search");
			pm = PMF.get().getPersistenceManager();
			Query query =null;
			
			
			String strStatusP = request.getParameter("strStatus");//CV status to search
			String lg_Job_Category_IDP = request.getParameter("lg_Job_Category_ID");//job category to search
			String strUserEmail = request.getParameter("strUserEmail");//email to searh
			String strUserName = request.getParameter("strUserName");//user name to search
			String strDisplay = request.getParameter("strDisplay");//where to display :viewer or grid
			
			
			
			
			String strFilter="";
			query=pm.newQuery(T_CV.class);
			
			if(!"ALL".equals(strStatusP))
			{
				strFilter="strStatus=='"+strStatusP+"'";//add status parameter for search
				
			}
			if(!"ALL".equals(lg_Job_Category_IDP) && lg_Job_Category_IDP!=null && !"".equals(lg_Job_Category_IDP) )
			{
			
				strFilter=strFilter+("".equals(strFilter)?"":" && ");
                strFilter=strFilter+"lg_Job_Category_ID=='"+lg_Job_Category_IDP+"'"; //add job categ search param
			}
			if(strUserEmail!=null && !"".equals(strUserEmail) )
			{
				
				strFilter=strFilter+("".equals(strFilter)?"":" && ");
			
				strFilter=strFilter+"strUserEmail=='"+strUserEmail+"'";//add an user Email parameter 
				
			}
			
			if(!"".equals(strFilter))
			{
				
			query.setFilter(strFilter);
			
			}
			
			
			List<T_CV> lsTCVP = (List<T_CV>)query.execute();
			
			
			
			List<T_CV> lsTCV=new ArrayList<T_CV>();
			//if we have to search on the userName
			if(strUserName!=null && !"".equals(strUserName) )
			{
				for(T_CV cv:lsTCVP)
				{
					
					//lowercase everythin before doing the comparison
					String strUserNameL=strUserName.toLowerCase();
					String strFirstNameL=cv.getStrFirstName().toLowerCase();
					String strLastNameL=cv.getStrLastName().toLowerCase();
					
					//check if there is the search value 
					if((strUserNameL.contains(strFirstNameL))||(strUserNameL.contains(strLastNameL))||(strLastNameL.contains(strUserNameL))||(strFirstNameL.contains(strUserNameL)))
							{
						       
						    lsTCV.add(cv);
						    
							}
				}
			}
			else
			{
				lsTCV=lsTCVP;
			}
			List<String> listIDCVS=new ArrayList<String>();
			
			//if there are no retrieved CV
			if (lsTCV.isEmpty()) 
			{
             log.log(Level.WARNING,"pas de cv "+strStatusP);
             response.sendRedirect("stats.jsp?noResult=true");//back to dash board
			   
			} 
			else 
			{
				
				try
				{
					
					
					//generate the String list of IDS, we could not put the List of CV because our CV class is not serialisizable
					for(T_CV cv:lsTCV)
					{
						listIDCVS.add(cv.getLg_CV_ID());
					}
					
					session.setAttribute("lstT_CV",listIDCVS);
					session.setAttribute("strStatus",strStatusP);
					session.setAttribute("lg_Job_Category_ID",lg_Job_Category_IDP);
					
					
					
				System.out.println("Nombre dans liste =   "+lsTCV.size() + "   "
						+ lsTCV.get(0).getStrUserEmail());
				log.info("Nombre dans liste =   "+lsTCV.size() + "   "+ lsTCV.get(0).getStrUserEmail());
				T_CV ocCv=lsTCV.get(0);
				
				
				//display in viewer
				if("viewer".equals(strDisplay))
				{
				response.sendRedirect("viewCV.jsp?lg_CV_ID="+ocCv.getLg_CV_ID()+"&lg_CV_ID_pos=0");
				}
				
				
				//display in grid, still have to work on it
				else
				{
					response.sendRedirect("cvs.html.jsp?strStatus="+strStatusP+"&lg_Job_Category_ID="+lg_Job_Category_IDP);
					
				}
				}
				catch(Exception ex)
				{
					ex.printStackTrace();
				}

			}
		}
		
		
		//view a CV in viewer
		else if ("viewCVList".equals(task))
		{
			pm = PMF.get().getPersistenceManager();
			Query query =null;
			String strStatusP = request.getParameter("strStatusP");
			String lg_Job_Category_IDP = request.getParameter("lg_Job_Category_IDP");
			String strFilter="";
			query=pm.newQuery(T_CV.class);
			if(!"ALL".equals(strStatusP))
			{
				strFilter="strStatus=='"+strStatusP+"'";
				
			}
			if(!"ALL".equals(lg_Job_Category_IDP) && lg_Job_Category_IDP!=null && !"".equals(lg_Job_Category_IDP) )
			{
				
				strFilter=strFilter+("".equals(strFilter)?"":"&& ");
			
				strFilter=strFilter+"lg_Job_Category_ID=='"+lg_Job_Category_IDP+"'";
			}
			if(!"".equals(strFilter))
			{
			query.setFilter(strFilter);
			}
			List<T_CV> lsTCV = (List<T_CV>)query.execute();
			List<String> listIDCVS=new ArrayList<String>();
			if (lsTCV.isEmpty()) 
			{
             log.log(Level.WARNING,"pas de cv "+strStatusP);
             response.sendRedirect("stats.jsp?noResult=true");
			   
			} 
			else 
			{
				
				try
				{
					for(T_CV cv:lsTCV)
					{
						listIDCVS.add(cv.getLg_CV_ID());
					}
					session.setAttribute("lstT_CV",listIDCVS);
					session.setAttribute("strStatus",strStatusP);
					session.setAttribute("lg_Job_Category_ID",lg_Job_Category_IDP);
				System.out.println("Nombre dans liste =   "+lsTCV.size() + "   "
						+ lsTCV.get(0).getStrUserEmail());
				log.info("Nombre dans liste =   "+lsTCV.size() + "   "
						+ lsTCV.get(0).getStrUserEmail());
				T_CV ocCv=lsTCV.get(0);
				response.sendRedirect("viewCV.jsp?lg_CV_ID="+ocCv.getLg_CV_ID()+"&lg_CV_ID_pos=0");
			    }
				catch(Exception ex)
				{
					
				}

			}
		 
		}
		
		
		//view a CV in browser some browser will automatically start the download of the file
		else if ("viewCV".equals(task))
		{
			String lg_CV_ID = request.getParameter("lg_CV_ID");
			Query query = pm.newQuery(T_CV.class,
					"lg_CV_ID == lg_CV_IDParam");
			query.declareParameters("String lg_CV_IDParam");
			List<T_CV> lsTCV = (List<T_CV>) query.execute(lg_CV_ID);
			if (lsTCV.isEmpty()) {

			} else {
				
				try
				{
				System.out.println(lsTCV.size() + "   "
						+ lsTCV.get(0).getStrUserEmail());
				T_CV ocCv=lsTCV.get(0);
				com.google.appengine.api.datastore.Blob lstByte=ocCv.getBlbCVFile();		
				response.setContentType("application/pdf");
				response.getOutputStream().write(lstByte.getBytes());
				}
				catch(Exception ex)
				{
					
				}

			}
		 
		
		}
		
		//search from the viewer
		else  if ("viewerSearch".equals(task))
		{
			try
			{
			SimpleDateFormat formatter = new SimpleDateFormat(
			"MM/dd/yyyy");
			String sdateDeb=request.getParameter("dateDeb");
			String sdateFin=request.getParameter("dateFin");
			String strStatus=request.getParameter("strStatus");
			String strUserEmail=request.getParameter("strUserEmail");
			String  lg_Job_Category_ID=request.getParameter("lg_Job_Category_ID");
			Date dateDeb=formatter.parse("01/01/2009");
			Date dateFin=new Date();
			String strOrdering="dtReceivedDate DESC";
			String strConstraints="dtReceivedDate>=dateDeb && dtReceivedDate<=dateFin";
			String strParams="java.util.Date dateDeb,java.util.Date dateFin";
			List<String> listIDCVS=new ArrayList<String>();
            if(strStatus==null || "".equals(strStatus))
            {
            	strStatus="ALL";
            }
            if(lg_Job_Category_ID==null || "".equals(lg_Job_Category_ID))
            {
            	lg_Job_Category_ID="ALL";
            }
			if(sdateDeb!=null & sdateFin!=null)
			{
				try
				{
					dateDeb=formatter.parse(sdateDeb);
				dateFin=formatter.parse(sdateFin);
				}
				catch(Exception ex)
				{
				    dateDeb=formatter.parse("01/01/2009");
					dateFin=new Date();
				
				}
				session.setAttribute("strStatus",strStatus);
				
			}
			Query query=null;
			String lg_group_ID=null;
			strConstraints=strConstraints+ ("ALL".equals(strStatus)?"":(" && strStatus=='"+strStatus+"'"));
			strConstraints=strConstraints+ ("ALL".equals(lg_Job_Category_ID)?"":(" && lg_Job_Category_ID=='"+lg_Job_Category_ID+"'"));
			query = pm.newQuery(T_CV.class,strConstraints);
	        query.declareParameters(strParams);
	       query.setOrdering(strOrdering);
	        List<T_CV> lsT_CV;
	        lsT_CV = (List<T_CV>)query.execute(dateDeb,dateFin);
	        if(strUserEmail!=null && strUserEmail.length()>0 )
	        {
	        	strConstraints=strConstraints+"&&strUserEmail==strUserEmailParam";
				strParams=strParams+ ", String strUserEmailParam";
				 query = pm.newQuery(T_CV.class,strConstraints);
				 query.declareParameters(strParams);
				 query.setOrdering(strOrdering);
				 lsT_CV = (List<T_CV>) query.execute(dateDeb,dateFin,strUserEmail);
	        }
	        
	        String strCV="";
	        if(lsT_CV!=null && !lsT_CV.isEmpty())
	        {
	        for(T_CV cv:lsT_CV)
			{
				listIDCVS.add(cv.getLg_CV_ID());
			}
			
			
		     System.out.println("Nombre dans liste =   "+lsT_CV.size() + "   "
				+ lsT_CV.get(0).getStrUserEmail());
		      log.info("Nombre dans liste =   "+lsT_CV.size() + "   "
				+ lsT_CV.get(0).getStrUserEmail());
		     T_CV ocCv=lsT_CV.get(0);
		     strCV=ocCv.getLg_CV_ID();
		     session.setAttribute("lstT_CV",listIDCVS);
		     response.sendRedirect("viewCV.jsp?lg_CV_ID="+strCV+"&lg_CV_ID_pos=0");

	      }
	        else
	        {
	        	 response.sendRedirect("stats.jsp");

	        }
	        

			}
			catch(Exception ex)
			{
				log.log(Level.SEVERE,"Echec set search "+ex.getMessage());
				ex.printStackTrace();
			}
		}
		
		//search from grid
		else  if ("setSearch".equals(task))
		{
			try
			{
			SimpleDateFormat formatter = new SimpleDateFormat(
			"MM/dd/yyyy");
			String sdateDeb=request.getParameter("dateDeb");
			String sdateFin=request.getParameter("dateFin");
			String strStatus=request.getParameter("strStatus");
			String lg_Job_Category_ID=request.getParameter("lg_Job_Category_ID");
			
			if(sdateDeb!=null & sdateFin!=null)
			{
				try
				{
				session.setAttribute("dateDeb",formatter.parse(sdateDeb));
				session.setAttribute("dateFin",formatter.parse(sdateFin));
				}
				catch(Exception ex)
				{
					session.setAttribute("dateDeb",null);
					session.setAttribute("dateFin",null);
				
				}
				session.setAttribute("strStatus",strStatus);
				session.setAttribute("lg_Job_Category_ID",strStatus);
				
			}
			response.sendRedirect("cvs.html.jsp?strStatus="+strStatus+"&lg_Job_Category_ID="+lg_Job_Category_ID);
			}
			catch(Exception ex)
			{
				log.log(Level.SEVERE,"Echec set search "+ex.getMessage());
				ex.printStackTrace();
			}
		}
	} 

	}

  catch (Exception e) {
		e.printStackTrace();
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
} else {
	response.sendRedirect(userService.createLoginURL(request
			.getRequestURI()));
}
%>