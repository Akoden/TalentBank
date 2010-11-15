package beans;

import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;

import com.google.appengine.api.datastore.Key;
/**
 * job category available for applyment§
 * @author michelvoula
 *
 */
@PersistenceCapable
public class T_Job_Category 
{
	@PrimaryKey
	@Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
	private Key key;
	@Persistent
	private String lg_Job_Category_ID;
	@Persistent
	private String strJobCategoryName;// the job name
	@Persistent
	private String strJobCategoryDesc;// the job description
	public Key getKey() {
		return key;
	}
	public void setKey(Key key) {
		this.key = key;
	}
	public String getLg_Job_Category_ID() {
		return lg_Job_Category_ID;
	}
	public void setLg_Job_Category_ID(String lgJobCategoryID) {
		lg_Job_Category_ID = lgJobCategoryID;
	}
	public String getStrJobCategoryName() {
		return strJobCategoryName;
	}
	public void setStrJobCategoryName(String strJobCategoryName) {
		this.strJobCategoryName = strJobCategoryName;
	}
	public String getStrJobCategoryDesc() {
		return strJobCategoryDesc;
	}
	public void setStrJobCategoryDesc(String strJobCategoryDesc) {
		this.strJobCategoryDesc = strJobCategoryDesc;
	}
	

}
