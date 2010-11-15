package beans;

import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;

import com.google.appengine.api.datastore.Key;
/**
 * note on a CV. actually we can have only one note per CV
 * a note is a comment made by administrator on a CV
 * @author michelvoula
 *
 */
@PersistenceCapable
public class T_Note {
	@PrimaryKey
	@Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
	private Key key;
	@Persistent
	private String lg_CV_ID;//the CV ID
	@Persistent
	private String strNote;// the Note ID
	public Key getKey() {
		return key;
	}
	public void setKey(Key key) {
		this.key = key;
	}
	public String getLg_CV_ID() {
		return lg_CV_ID;
	}
	public void setLg_CV_ID(String lgCVID) {
		lg_CV_ID = lgCVID;
	}
	public String getStrNote() {
		return strNote;
	}
	public void setStrNote(String strNote) {
		this.strNote = strNote;
	}
	
}
