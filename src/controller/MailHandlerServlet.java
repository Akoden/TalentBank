package controller;
import java.io.IOException; 
import java.util.Properties; 
import java.util.logging.Logger;

import javax.mail.MessagingException;
import javax.mail.Session; 
import javax.mail.internet.MimeMessage; 
import javax.servlet.http.*; 
/**
 * servlet for handling mail to this app
 * not yed used
 * @author michelvoula
 *
 */
@SuppressWarnings("serial")
public class MailHandlerServlet extends HttpServlet { 
    public void doPost(HttpServletRequest req, 
                       HttpServletResponse resp) 
            throws IOException { 
        Properties props = new Properties(); 
        Session session = Session.getDefaultInstance(props, null); 
        Logger log = Logger.getLogger(this.getClass().getName());
        try {
			MimeMessage message = new MimeMessage(session, req.getInputStream());
			log.info("Mail RECU "+message.getDescription()+ " subject "+message.getSubject());
			
		} catch (MessagingException e) 
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
}
