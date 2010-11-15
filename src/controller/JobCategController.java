package controller;

import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.jdo.PersistenceManager;
import utils.DateUtils;
import beans.T_CV;
import beans.T_Job_Category;
import javax.jdo.*;
import controller.PMF;

/**
 * this class manages the job categories
 * List,create,delete
 * @author michelvoula
 *
 */
public class JobCategController
{
	/**
	 * create a job category
	 * @param strJobCategoryName the name parameter
	 * @param strJobCategoryDesc the description parameter
	 * @return true if the operation is successful and false otherwise
	 */
	public static boolean createJobCateg(String strJobCategoryName,String strJobCategoryDesc)
	{
		boolean res=false;//variable that contains the result
	    PersistenceManager pm=null;
	    Logger log = Logger.getLogger(JobCategController.class.getName());
	
        try
        {
		   pm = PMF.get().getPersistenceManager();
		   
		   //create the new object and set the values
		   T_Job_Category oJobCategory=new T_Job_Category();
		   oJobCategory.setLg_Job_Category_ID(DateUtils.getTimeId());
		   oJobCategory.setStrJobCategoryName(strJobCategoryName);
		   oJobCategory.setStrJobCategoryDesc(strJobCategoryDesc);
		   
		   //save the object in datastore
		   pm.makePersistent(oJobCategory);
		   
		   res=true;
	    }
        catch (Exception e)
           {
		    e.printStackTrace();
		    log.log(Level.SEVERE,e.getMessage()+" error in saving jobcateg",e);
		    res=false;
	       }
        finally
           {
    	    pm.close();
           }
	
		return res;
	}
	
	
	
	/**
	 * update a job category
	 * @param lg_Job_Category_ID the ID of the job to update
	 * @param strJobCategoryName the new name
	 * @param strJobCategoryDesc the new description
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public static boolean updateJobCateg(String lg_Job_Category_ID,String strJobCategoryName,String strJobCategoryDesc)
	{
		boolean res=false;
	    PersistenceManager pm=null;
	    Logger log = Logger.getLogger(JobCategController.class.getName());
	
        try 
          {
		   pm = PMF.get().getPersistenceManager();
		   
		   //search for the job category to update
		   List<T_Job_Category> lstT_Job_Category=null;
		   Query query=pm.newQuery(T_Job_Category.class,"lg_Job_Category_ID==lg_Job_Category_IDP");
		   query.declareParameters("String lg_Job_Category_IDP");				
		   query.setOrdering("strJobCategoryName ASC");
		   lstT_Job_Category=(List<T_Job_Category> )query.execute(lg_Job_Category_ID);
		
		   
		    //if the job exists,
		    if(!lstT_Job_Category.isEmpty())
		     {
		    	 // set new values
		         T_Job_Category oJobCategory=lstT_Job_Category.get(0);
		         oJobCategory.setStrJobCategoryName(strJobCategoryName);
		         oJobCategory.setStrJobCategoryDesc(strJobCategoryDesc);
		         
		         //persist the object
		         pm.makePersistent(oJobCategory);
		         
		         
		         res=true;
		      }
	     }
        catch (Exception e) 
        {
		   e.printStackTrace();
		   log.log(Level.SEVERE,e.getMessage()+" error in saving jobcateg");
		   res=false;
	    }
        finally
        {
    	  pm.close();
        }
	
		return res;
	}
	/**
	 * get all the job catehories available on the datastore
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public static List<T_Job_Category> getJobCategs()
	{
		List<T_Job_Category> lstT_Job_Category=null;
	    PersistenceManager pm=null;
	    Logger log = Logger.getLogger(JobCategController.class.getName());
	
		 try {
				pm = PMF.get().getPersistenceManager();
			
				Query query=pm.newQuery(T_Job_Category.class);
				query.setOrdering("strJobCategoryName ASC");
				lstT_Job_Category=(List<T_Job_Category> )query.execute();
				
				
			 } 
		 catch (Exception e)
		    {
				e.printStackTrace();
				log.log(Level.SEVERE,e.getMessage()+" error in saving jobcateg");
				lstT_Job_Category=null;
			}
		 finally
		    {
		    //	pm.close();
		    }
		    return lstT_Job_Category;
	}
	
	/**
	 * get a specific job category by his ID
	 * @param lg_Job_Category_ID the ID of the job to search
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public static T_Job_Category getJobCategsByID(String lg_Job_Category_ID)
	{
	 	List<T_Job_Category> lstT_Job_Category=null;
	    T_Job_Category res=null;
	    PersistenceManager pm=null;
	   Logger log = Logger.getLogger(JobCategController.class.getName());
	
		 try {
				pm = PMF.get().getPersistenceManager();
			
				Query query=pm.newQuery(T_Job_Category.class,"lg_Job_Category_ID==lg_Job_Category_IDP");
				query.declareParameters("String lg_Job_Category_IDP");				
				query.setOrdering("strJobCategoryName ASC");
				
				lstT_Job_Category=(List<T_Job_Category> )query.execute(lg_Job_Category_ID);
				
				if(!lstT_Job_Category.isEmpty())
				{
					res=lstT_Job_Category.get(0);
					System.out.print("nombre de categ ="+lstT_Job_Category.size());
					log.info("nombre de categ ="+lstT_Job_Category.size());
				}
				
			} 
		 catch (Exception e) 
		 {
				e.printStackTrace();
				log.log(Level.SEVERE,e.getMessage()+" error in retrieving jobcateg");
				lstT_Job_Category=null;
		 }
		 finally
		 {
		    //	pm.close();
		 }
		    return res;
	}
	
	/**
	 * delete a specific job category
	 * @param lg_Job_Category_ID
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public boolean delete(String lg_Job_Category_ID)
	{
		List<T_Job_Category> lstT_Job_Category=null;
		boolean res=false;
		PersistenceManager pm=null;
		Logger log = Logger.getLogger(JobCategController.class.getName());
		
			 try
			 {
					pm = PMF.get().getPersistenceManager();
				
					Query query=pm.newQuery(T_Job_Category.class,"lg_Job_Category_ID==lg_Job_Category_IDP");
					query.declareParameters("String lg_Job_Category_IDP");
                    lstT_Job_Category=(List<T_Job_Category> )query.execute(lg_Job_Category_ID);
					
					pm.deletePersistentAll(lstT_Job_Category);
					res=true;
					
				} catch (Exception e) {
					e.printStackTrace();
					log.log(Level.SEVERE,e.getMessage()+" error in saving jobcateg");
					lstT_Job_Category=null;
					res=false;
				}
			    finally
			    {
			    	pm.close();
			    }
			    return res;
	}
	
	/**
	 * get the CV of a specific job category
	 * @param lg_Job_Category_ID
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public static List<T_CV> getJobsCV(String lg_Job_Category_ID)
	{
		List<T_CV> lstT_CV=null;
		
		PersistenceManager pm=null;
		Logger log = Logger.getLogger(JobCategController.class.getName());
		
			 try {
					pm = PMF.get().getPersistenceManager();
				
					Query query=pm.newQuery(T_CV.class,"lg_Job_Category_ID==lg_Job_Category_IDP");
					query.declareParameters("String lg_Job_Category_IDP");
                    lstT_CV=(List<T_CV> )query.execute(lg_Job_Category_ID);
                    
                  } 
			 catch (Exception e) 
                  {
					e.printStackTrace();
					log.log(Level.SEVERE,e.getMessage()+" error in saving jobcateg");
					lstT_CV=null;
				  }
			finally
			     {
			    	//pm.close();
			     }
			    return lstT_CV;
	}

}
