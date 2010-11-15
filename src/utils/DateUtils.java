package utils;
import java.util.*;
/*
 * Genererate random String ID
 */
public class DateUtils {
	
    public static String getTimeId() {
    	 String catime;
      
        int mm, ss, hh, mois, jour, annee, mls;
      
        Calendar now = Calendar.getInstance();
        mm = now.get(Calendar.MINUTE);
        ss = now.get(Calendar.SECOND);
        mls = now.get(Calendar.MILLISECOND);
        hh = now.get(Calendar.HOUR_OF_DAY);
        mois = now.get(Calendar.MONTH) + 1;
        jour = now.get(Calendar.DAY_OF_MONTH);
        annee = now.get(Calendar.YEAR);
       catime = (String.valueOf(annee) + "" + String.valueOf(mois) + "" + String.valueOf(jour) + "" + String.valueOf(hh) + "" + String.valueOf(mm) + "" + String.valueOf(ss) + "" + String.valueOf(mls));

        return catime + GetNumberRandom();
    }
    public static String GetNumberRandom() {
        return String.valueOf((int) (Math.random() * 10000 + 1));
    }
}
