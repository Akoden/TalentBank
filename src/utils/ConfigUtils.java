package utils;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.jdo.*;

import com.google.appengine.api.datastore.Text;

import controller.PMF;
import beans.*;
/*
 * class to retrieve configuration values
 */
public class ConfigUtils {
	
	/*
	 * get the value of the config
	 */
	@SuppressWarnings("unchecked")
	public static String getConfigValue(String str_Name)
	{String strValue="";
		PersistenceManager pm=null;
	       Logger log = Logger.getLogger(ConfigUtils.class.getName());
	       
	       
	       
			try {
				pm = PMF.get().getPersistenceManager();
				Query query = pm.newQuery(T_Config.class,
						"str_Name == str_NameParam");
				query.declareParameters("String str_NameParam");
				List<T_Config> lsT_Config = (List<T_Config>) query.execute(str_Name);
				if (lsT_Config.isEmpty()) {
					System.out.println("valeur non existante");
				} else {
					System.out.println(lsT_Config.size() + " Name=   "
							+ lsT_Config.get(0).getStr_Name()+" Value= "+lsT_Config.get(0).getStrValue());
					log.info(lsT_Config.size() + " Name=   "
							+ lsT_Config.get(0).getStr_Name()+" Value= "+lsT_Config.get(0).getStrValue());
					
							T_Config oT_Config=lsT_Config.get(0);
						strValue=oT_Config.getTextValue().getValue();
					
					
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
	
	//set the value of a config
	@SuppressWarnings("unchecked")
	public static boolean updateConfig(String str_Name	,String strValue)
	{
		PersistenceManager pm=null;
       Logger log = Logger.getLogger(ConfigUtils.class.getName());
       boolean bResult=false;
       
       
       
		try {
			pm = PMF.get().getPersistenceManager();
			Query query = pm.newQuery(T_Config.class,
					"str_Name == str_NameParam");
			query.declareParameters("String str_NameParam");
			List<T_Config> lsT_Config = (List<T_Config>) query.execute(str_Name);
			if (lsT_Config.isEmpty()) {
				System.out.println("valeur non existante");
			} else {
				System.out.println(lsT_Config.size() + " Name=   "
						+ lsT_Config.get(0).getStr_Name()+" Value= "+lsT_Config.get(0).getStrValue());
				log.info(lsT_Config.size() + " Name=   "
						+ lsT_Config.get(0).getStr_Name()+" Value= "+lsT_Config.get(0).getStrValue());
				
						T_Config oT_Config=lsT_Config.get(0);
						oT_Config.setTextValue(new Text(strValue));
				pm.makePersistent(oT_Config);	
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
