package beans;


import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.Text;
/*
 *Persistent class for the configuration values of
 *the application e.g:accept message, reject message
 *the value str_Name corresponds to a ley in Parameters Enum
 */
@PersistenceCapable
public class T_Config 
{
	
	@PrimaryKey
	@Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
	private Key key;
	@Persistent
	private String lg_Key_ID;
	@Persistent
	private String str_Name;
	@Persistent
	private String strDescription;
	
	@Persistent
	private Text  textValue;
	
	public Text getTextValue() {
		return textValue;
	}
	public void setTextValue(Text textValue) {
		this.textValue = textValue;
	}
	@Persistent
	private String  strValue;
	public Key getKey() {
		return key;
	}
	public void setKey(Key key) {
		this.key = key;
	}
	public String getLg_Key_ID() {
		return lg_Key_ID;
	}
	public void setLg_Key_ID(String lgKeyID) {
		lg_Key_ID = lgKeyID;
	}
	public String getStrDescription() {
		return strDescription;
	}
	public void setStrDescription(String strDescription) {
		this.strDescription = strDescription;
	}
	public String getStrValue() {
		return strValue;
	}
	public void setStrValue(String strValue) {
		this.strValue = strValue;
	}
	public String getStr_Name() {
		return str_Name;
	}
	public void setStr_Name(String strName) {
		str_Name = strName;
	}
	

}
