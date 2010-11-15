
package controller;

import java.io.*;

import java.util.*;

import javax.jdo.PersistenceManager;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.util.logging.*;
import javax.jdo.*;

import beans.T_CV;


/**
 * Class for handling download the CV 
 * @author michelvoula
 *
 */
public class DownloadServlet  extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public void doGet(HttpServletRequest req, HttpServletResponse res)
			throws IOException 
			{
		
		
		
			if("viewCV".equals(req.getParameter("task")))
			{
				
				downloadCV(req, res);
			}
			   
	}

	/**
	 * this method retrieve the PDF content of a CV, in the blob and enable 
	 * the browser to display it as PDF File
	 * in some browser it is displayed and in other, the file is downloaded with a default name
	 * a difficulty is how to give a name to the downloaded file in this case 
	 * @param req
	 * @param res
	 */
	@SuppressWarnings("unchecked")
	public void downloadCV(HttpServletRequest req, HttpServletResponse res)
	{
		
		Logger log = Logger.getLogger(this.getClass().getName());

		PersistenceManager pm = null;
		try {
			pm = PMF.get().getPersistenceManager();
			
			//if the user wants to view the CV
			
			    //get the CV ID
				String lg_CV_ID = req.getParameter("lg_CV_ID");
				
				
		   //fetch on datastore		
			Query query = pm.newQuery(T_CV.class,
					"lg_CV_ID == lg_CV_IDParam");
			query.declareParameters("String lg_CV_IDParam");
			//get the List of CV with this ID ,it should only one
			List<T_CV> lsTCV = (List<T_CV>) query.execute(lg_CV_ID);
			if (lsTCV.isEmpty()) 
			  {

			  }
			else 
			  {
				
				try
				{
				  log.info(lsTCV.size() + "   "+ lsTCV.get(0).getStrUserEmail());
				  
				  //get the CV
				    T_CV ocCv=lsTCV.get(0);
				    
				    //get the blob content
				    com.google.appengine.api.datastore.Blob lstByte=ocCv.getBlbCVFile();
				    
				    //to enable display as PDF
				    res.setContentType("application/pdf");
				    
				    //display as PDF
				   res.getOutputStream().write(lstByte.getBytes());
				}
				catch(Exception ex)
				{
					log.log(Level.SEVERE, "Can not display the CV", ex);
				}
			  }
			
			
		} catch (Exception e) 
		{log.log(Level.SEVERE, "CV operation Failed "+e.getMessage());
			//e.printStackTrace();
		} finally {
			try {
				pm.close();
			} catch (Exception e) {
				log.log(Level.SEVERE, "can not close pm Failed "+e.getMessage());
				
			}
		}
		
		
		
	}
	public void doPost(HttpServletRequest req, HttpServletResponse res)
			throws ServletException, IOException 
			{
		downloadCV(req, res);

	}
}