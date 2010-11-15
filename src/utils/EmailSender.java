package utils;
import java.util.Properties;

import java.util.logging.Level;
import java.util.logging.Logger;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

import controller.JobCategController;

import beans.T_CV;
import beans.T_Job_Category;

/*
 * generic class for sending email n HTML format
 */
public class EmailSender {

	
	public static String ACCEPTED_CV="Hello, we have received your CV and we have decided to keep it in our talent bank, we will contant you when an opportunity will be available. thanks regards";
	public static String REJECTED_CV="Hello, we have received your CV and are very honoured with your interest. Your CV will not be kept in our talent bank. Thank regards";
	public boolean send(String strTO,String strToTitle,String strTitle,String strTexte)
	{Logger log = Logger.getLogger(this.getClass().getName());

		Properties props = new Properties();
		boolean res=false;
        Session session = Session.getDefaultInstance(props, null);			       
        try {
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress("activecollab@limbelabs.com", "Limbe Labs Talent Bank"));
            msg.addRecipient(Message.RecipientType.TO,
                             new InternetAddress(strTO,strToTitle));
            msg.setSubject(strTitle);
            Multipart mp = new MimeMultipart();

            MimeBodyPart htmlPart = new MimeBodyPart();
            htmlPart.setContent(strTexte, "text/html"); 
            mp.addBodyPart(htmlPart);
            msg.setContent(mp);
            Transport.send(msg);
            log.info("Email sent to: "+strTO);
            res=true;
        } catch (AddressException e)
        {
        	log.log(Level.SEVERE, "AddressException "+e.getMessage());
        } catch (MessagingException e) {
        	log.log(Level.SEVERE, "MessagingException "+e.getMessage());
        }
        catch(Exception ex)
		{
			
		}
	return res;
	}
	
	public static String getCVReceivedMessage(T_CV ocv)
	{
		
		T_Job_Category job=JobCategController.getJobCategsByID(ocv.getLg_Job_Category_ID());
		String result="<p>Hello,</p><p>Your CV has been successfully registererd to Limbe Labs talent bank with these information:</p>";
		result=result+"<ul>";
		result=result+"<li>First name:"+ocv.getStrFirstName()+"</li>";
		result=result+"<li>Last name:"+ocv.getStrLastName()+"</li>";
		result=result+"<li>Email:  "+ocv.getStrUserEmail()+"</li>";
		result=result+"<li>File name:"+ocv.getStrFileName()+"</li>";
		result=result+"<li>Job category:"+job.getStrJobCategoryName()+"</li>";
		result=result+"</ul>";
		result=result+"It will be checked manually and we will send you a feedback.";
		result=result+"<p><em><strong>Limbe Labs</strong></em></p>";
		//result=result+"";
		//result=result+"";
		//result=result+"";
		
		
		return result;
	}
	
}
