package controller;

import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.jdo.PersistenceManager;
import javax.jdo.Query;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import utils.DateUtils;
import beans.T_User;
/**
 * class to manage users for the application
 * unused service for now
 * @author michelvoula
 *
 */
public class UserServlet extends HttpServlet 

{
	/**
	 * 
	 */
	private static final long serialVersionUID = -7052622913503125514L;

	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
		resp.setContentType("text/plain");
		resp.getWriter().println("Hello, world");
	}

	@SuppressWarnings("unchecked")
	public void doPost(HttpServletRequest req, HttpServletResponse res)
			throws ServletException, IOException {
		Logger log = Logger.getLogger(this.getClass().getName());

		PersistenceManager pm = null;
		String task = req.getParameter("task");
		String result = "";

		try {
			res.setContentType("text/plain");

			pm = PMF.get().getPersistenceManager();
			if ("createUser".equals(task)) {
				T_User oUser = new T_User();
				{
					
					oUser.setStrFirstName(req.getParameter("strFirstName"));
					oUser.setStrUserEmail(req.getParameter("strUserEmail"));
					oUser.setStrLastName(req.getParameter("strLastName"));
					oUser.setLg_User_ID(DateUtils.getTimeId());

					Query query = pm.newQuery(T_User.class,
							"strUserEmail == strUserEmailParam");
					query.declareParameters("String strUserEmailParam");
					query.setOrdering("strFirstName ASC,strLastName ASC");
					List<T_User> lsTCV = (List<T_User>) query.execute(oUser
							.getStrUserEmail());
					
					if (!lsTCV.isEmpty()) 
					{

						log.info(" user is duplicate OF "
								+ oUser.getStrUserEmail());
						result = "duplicate";

					} 
					else 
					{
						pm.makePersistent(oUser);
						System.out.println(oUser.getStrUserEmail() +" enregistrer");
					}

					res.getWriter().print(result);
				}

			} else if ("deleteUser".equals(task)) {
				String lg_User_ID = req.getParameter("lg_User_ID");
				Query query = pm.newQuery(T_User.class,
						"lg_User_ID == lg_User_IDParam");
				query.declareParameters("String lg_User_IDParam");
				query.setOrdering("strFirstName ASC,strLastName ASC");
				List<T_User> lsTCV = (List<T_User>) query.execute(lg_User_ID);
				if (!lsTCV.isEmpty()) {

					T_User oUser = lsTCV.get(0);
					pm.deletePersistent(oUser);
					result = "OK";

				}
				res.getWriter().print(result);
			}

		} catch (Exception e) {
			res.getWriter().print("failure");
			log.log(Level.SEVERE, "CV save Failed " + e.getMessage());
			// e.printStackTrace();
		} finally {
			try {
				pm.close();
			} catch (Exception e) {
				log.log(Level.SEVERE, "can not close pm Failed "
						+ e.getMessage());

			}
		}

	}

}
