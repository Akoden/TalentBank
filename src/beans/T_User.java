package beans;

import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;

import com.google.appengine.api.datastore.Key;
/**
 * The users of the application
 * we wanted to manage the users for accessing the application
 * @author michelvoula
 *
 */
@PersistenceCapable
public class T_User 
{
	@PrimaryKey
	@Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
	private Key key;
	
	@Persistent
	private String lg_User_ID; 
	
	@Persistent
	private String strUserEmail;
	
    @Persistent
	private String strFirstName;
	
	@Persistent
	private String strLastName;

	public String getStrUserEmail() {
		return strUserEmail;
	}

	public void setStrUserEmail(String strUserEmail) {
		this.strUserEmail = strUserEmail;
	}

	public String getStrFirstName() {
		return strFirstName;
	}

	public void setStrFirstName(String strFirstName) {
		this.strFirstName = strFirstName;
	}

	public String getStrLastName() {
		return strLastName;
	}

	public void setStrLastName(String strLastName) {
		this.strLastName = strLastName;
	}

	public Key getKey() {
		return key;
	}

	public void setKey(Key key) {
		this.key = key;
	}

	public String getLg_User_ID() {
		return lg_User_ID;
	}

	public void setLg_User_ID(String lgUserID) {
		lg_User_ID = lgUserID;
	}
	
	
	
}
