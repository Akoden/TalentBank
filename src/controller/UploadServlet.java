package controller;

import java.io.*;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Date;
import java.util.Hashtable;
import java.util.List;

import javax.jdo.PersistenceManager;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import org.apache.commons.fileupload.FileItemIterator;
import org.apache.commons.fileupload.FileItemStream;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.fileupload.util.Streams;
import org.apache.commons.io.IOUtils;

import utils.DateUtils;
import utils.EmailSender;

import java.util.logging.Level;
import java.util.logging.Logger;
import com.google.appengine.api.datastore.Blob;
import javax.jdo.*;

import beans.T_CV;

/**
 * servlet that handles CV upload to the server
 * @author michelvoula
 *
 */
public class UploadServlet extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws IOException 
	{
		resp.setContentType("text/plain");
		resp.getWriter().println("Hello, world");
	}

	@SuppressWarnings({ "unchecked", "deprecation" })
	public void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException
	{
		
		//here we just receive data from the form in welcome.jsp
		Logger log = Logger.getLogger(this.getClass().getName());

		PersistenceManager pm = null;
		List<String> lstErrors = new ArrayList<String>();
		String result="";
		String lg_CV_ID_OLD=null;
		String lg_CV_ID_NEW=null;
		String adP="";
		try 
		{
			res.setContentType("text/plain");
			
			
			pm = PMF.get().getPersistenceManager();
			
			//create a new CV entty
			T_CV oCv = new T_CV();
			
			//this hashtable will contain the value retrieved from the form
			Hashtable<String, String> hash = new Hashtable<String, String>();

			ServletFileUpload upload = new ServletFileUpload();
			FileItemIterator iter = upload.getItemIterator(req);

			// Parse the request
			while (iter.hasNext()) 
			{
				FileItemStream item = iter.next();
				String name = item.getFieldName();
				InputStream stream = item.openStream();
				
				//if it is a form field add it to hashtable
				if (item.isFormField()) 
				{
					String value = Streams.asString(stream);
					hash.put(name, value);
					System.out.println("Form field " + name + " with value "
							+ value + " detected.");
				} 
				else
				{
					//  if it is the PDF file set the blob value if the CV entity
					if ("application/pdf".equals(item.getContentType())) 
					{
						byte[] lstByte = IOUtils.toByteArray(stream); // read the bytes
						
						oCv.setLgFileSize(lstByte.length);  //set the file size
						
						Blob cvBlob = new Blob(lstByte);   //create the blob object
						oCv.setBlbCVFile(cvBlob);// set the cv blob content
						
						//in this step, the goal is to save only the file name, not all the path
						String fileName = item.getName();
						int lastIndex = fileName.lastIndexOf("\\");
						if (lastIndex == -1)
						{
							lastIndex = fileName.lastIndexOf("/");
						}
						if (lastIndex != -1) 
						{
							fileName = fileName.substring(lastIndex + 1);
						}

						
						oCv.setStrFileName(fileName);

					 } 
					else 
					{
						lstErrors.add("The CV must be a PDF File");
						result=" The CV must be a PDF File";
						
					}

				}
			}
			if (lstErrors.size() == 0) 
			{
				
				//get the values from the Hashtable
				oCv.setStrFirstName(hash.get("strFirstName"));
				oCv.setStrUserEmail(hash.get("strUserEmail"));
				oCv.setStrLastName(hash.get("strLastName"));
				oCv.setDtReceivedDate(new Date());
				oCv.setLg_Job_Category_ID(hash.get("lg_Job_Category_ID"));
				oCv.setLg_CV_ID(DateUtils.getTimeId());
				
				
				//check if we already have a CV with the email,filename and file size
				Query query = pm.newQuery(T_CV.class,"strUserEmail == strUserEmailParam && strFileName==strFileNameParam && lgFileSize==lgFileSizeParam");
				query.declareParameters("String strUserEmailParam,String strFileNameParam,long lgFileSizeParam");
				query.setOrdering("dtReceivedDate ASC,strFirstName ASC,strLastName ASC");
				
				List<T_CV> lsTCV =(List<T_CV>) query.execute(oCv.getStrUserEmail(), oCv.getStrFileName(), oCv.getLgFileSize());
				
				
				//if a CV is found
				if (!lsTCV.isEmpty()) 
				{ 
					//set as duplicate
					oCv.setStrDuplicateID(lsTCV.get(0).getLg_CV_ID());
					
					log.info(" CV is duplicate OF "+oCv.getStrDuplicateID());
					result="CV is duplicate OF "+oCv.getStrDuplicateID();
					lg_CV_ID_OLD=oCv.getStrDuplicateID();
					lg_CV_ID_NEW=oCv.getLg_CV_ID();
					adP=adP+"lg_CV_ID_NEW="+lg_CV_ID_NEW;
					adP=adP+"&lg_CV_ID_OLD="+lg_CV_ID_OLD;
					
				}
				//check if the email is not already used
				else
				{
					Query query0 = pm.newQuery(T_CV.class,"strUserEmail == strUserEmailParam");
					query0.declareParameters("String strUserEmailParam");
					query0.setOrdering("dtReceivedDate ASC");
					lsTCV =(List<T_CV>) query0.execute(oCv.getStrUserEmail());
					
					if (!lsTCV.isEmpty()) 
					{
						
						oCv.setStrDuplicateID(lsTCV.get(0).getLg_CV_ID());
						log.info(" CV is duplicate OF "+oCv.getStrDuplicateID());
						result="CV is duplicate OF "+oCv.getStrDuplicateID();
						lg_CV_ID_OLD=oCv.getStrDuplicateID();
						lg_CV_ID_NEW=oCv.getLg_CV_ID();
						adP=adP+"lg_CV_ID_NEW="+lg_CV_ID_NEW;
						adP=adP+"&lg_CV_ID_OLD="+lg_CV_ID_OLD;
						
					}
				}
				log.info(oCv.getLg_CV_ID() + " " + oCv.getLgFileSize());
                
				
				//persist the CV
				pm.makePersistent(oCv);
				
				//send the email notification to the user
				String receivedMessage=EmailSender.getCVReceivedMessage(oCv);
				new EmailSender().send(oCv.getStrUserEmail(), oCv.getStrFirstName(),"CV saved in talent bak", receivedMessage);
				result=" CV saved you will receive a feed back";
			}
			
			result = URLEncoder.encode(result);
			
			res.sendRedirect("/welcome.jsp?"+adP+"&result="+result);
		} 
		catch (Exception e) 
		{
			log.log(Level.SEVERE, "CV save Failed "+e.getMessage(),e);
			//e.printStackTrace();
		} 
		finally 
		{
			try 
			{
				pm.close();
			} 
			catch (Exception e) 
			{
				log.log(Level.SEVERE, "can not close pm Failed "+e.getMessage(),e);
				
			}
		}

	}
}