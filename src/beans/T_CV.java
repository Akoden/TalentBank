package beans;

import java.util.Date;

import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;

import com.google.appengine.api.datastore.Blob;
import com.google.appengine.api.datastore.Key;
/*
 * The persistent class for the CV uploaded
 * 
 */
@PersistenceCapable
public class T_CV 
{

	public static String STATUS_NON_SORTED="unsorted";
	public static String STATUS_ACCEPTED="accepted";
	public static String STATUS_REJECTED="rejected";

	@PrimaryKey
	@Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
	private Key key;
	@Persistent
	private String lg_CV_ID;
	@Persistent
	private long lgFileSize;// the size of the PDF file
	@Persistent
	private String  strFileName;//the Name of the file
	@Persistent
	private String strUserEmail;// the email of the user
	@Persistent
	private String strUserName;
	@Persistent
	private String strStatus=STATUS_NON_SORTED;// the status of the CV 
	
	@Persistent
	private String strFirstName;//the first name of the user
	
	
	@Persistent
	private String lg_Job_Category_ID;// the id of the job category the user applied for
	
	@Persistent
	private String strLastName;// the user last name
	
	@Persistent
	private Blob blbCVFile;// the blob content of the CV pdf file
	@Persistent
	private Date dtReceivedDate;// the date the CV was received
	@Persistent
	private String strDuplicateID;
	
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
	public long getLgFileSize() {
		return lgFileSize;
	}
	public void setLgFileSize(long lgFileSize) {
		this.lgFileSize = lgFileSize;
	}
	public String getStrFileName() {
		return strFileName;
	}
	public void setStrFileName(String strFileName) {
		this.strFileName = strFileName;
	}
	public String getStrUserEmail() {
		return strUserEmail;
	}
	public void setStrUserEmail(String strUserEmail) {
		this.strUserEmail = strUserEmail;
	}
	public String getStrUserName() {
		return strUserName;
	}
	public void setStrUserName(String strUserName) {
		this.strUserName = strUserName;
	}
	public Blob getBlbCVFile() {
		return blbCVFile;
	}
	public void setBlbCVFile(Blob blbCVFile) {
		this.blbCVFile = blbCVFile;
	}
	public Date getDtReceivedDate() {
		return dtReceivedDate;
	}
	public void setDtReceivedDate(Date dtReceivedDate) {
		this.dtReceivedDate = dtReceivedDate;
	}
	public String getStrDuplicateID() {
		return strDuplicateID;
	}
	public void setStrDuplicateID(String strDuplicateID) {
		this.strDuplicateID = strDuplicateID;
	}
	public String getStrLastName() {
		return strLastName;
	}
	public void setStrLastName(String strLastName) {
		this.strLastName = strLastName;
	}
	public String getStrFirstName() {
		return strFirstName;
	}
	public void setStrFirstName(String strFirstName) {
		this.strFirstName = strFirstName;
	}
	public String getStrStatus() {
		return strStatus;
	}
	public void setStrStatus(String strStatus) {
		this.strStatus = strStatus;
	}
	public String getLg_Job_Category_ID() {
		return lg_Job_Category_ID;
	}
	public void setLg_Job_Category_ID(String lgJobCategoryID) {
		lg_Job_Category_ID = lgJobCategoryID;
	}
	
	
	

	

	

}
