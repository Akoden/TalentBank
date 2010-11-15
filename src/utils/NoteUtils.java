package utils;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.jdo.*;

import controller.PMF;
import beans.*;


/*
 * manage notes on CV
 */
public class NoteUtils 
{   //get the note on a CV
	@SuppressWarnings("unchecked")
	public static String getNoteValue(String lg_CV_ID)
	{   String strValue="";
		PersistenceManager pm=null;
	       Logger log = Logger.getLogger(ConfigUtils.class.getName());
	       
	       
	       
			try {
				pm = PMF.get().getPersistenceManager();
				Query query = pm.newQuery(T_Note.class,
						"lg_CV_ID == lg_CV_IDParam");
				query.declareParameters("String lg_CV_IDParam");
				List<T_Note> lsT_Note = (List<T_Note>) query.execute(lg_CV_ID);
				if (lsT_Note.isEmpty()) {
					
					T_Note oNote=new T_Note();
					oNote.setLg_CV_ID(lg_CV_ID);
					oNote.setStrNote("");
					pm.makePersistent(oNote);
					System.out.println("note  non existante et enregistree");
					
				} else {
					System.out.println(lsT_Note.size() + " CV=   "
							+ lsT_Note.get(0).getLg_CV_ID()+" Note= "+lsT_Note.get(0).getStrNote());
					log.info(lsT_Note.size() + " Name=   "
							+ lsT_Note.get(0).getLg_CV_ID()+" Value= "+lsT_Note.get(0).getStrNote());
					
							T_Note oT_Note=lsT_Note.get(0);
						strValue=oT_Note.getStrNote();
					
					
				}
			} catch (Exception e) {

				e.printStackTrace();
				log.log(Level.SEVERE,e.getMessage()+" fail to update Config  ");
				
				
			}
			finally
			{
				pm.close();
			}
			return strValue;
	}
	//update the note on a CV
	@SuppressWarnings("unchecked")
	public static boolean updateNote(String lg_CV_ID	,String strValue)
	{
		PersistenceManager pm=null;
       Logger log = Logger.getLogger(ConfigUtils.class.getName());
       boolean bResult=false;
       
       
       
		try {
			pm = PMF.get().getPersistenceManager();
			Query query = pm.newQuery(T_Note.class,
					"lg_CV_ID == lg_CV_IDParam");
			query.declareParameters("String lg_CV_IDParam");
			List<T_Note> lsT_Note = (List<T_Note>) query.execute(lg_CV_ID);
			if (lsT_Note.isEmpty()) {
				System.out.println("valeur non existante");
				
			} else {
				System.out.println(lsT_Note.size() + " Name=   "
						+ lsT_Note.get(0).getStrNote()+" modif CV= "+lsT_Note.get(0).getStrNote());
				log.info(lsT_Note.size() + " CV=   "
						+ lsT_Note.get(0).getStrNote()+" Note= "+lsT_Note.get(0).getStrNote());
				
						T_Note oT_Note=lsT_Note.get(0);
						oT_Note.setStrNote(strValue);
				pm.makePersistent(oT_Note);	
				bResult=true;
				
				
			}
		} catch (Exception e) {

			e.printStackTrace();
			log.log(Level.SEVERE,e.getMessage()+" fail to update Config  ");
			bResult=false;
			
		}
		finally
		{
			pm.close();
		}
		return bResult;
	}

}
