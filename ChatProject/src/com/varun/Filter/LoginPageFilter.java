package com.varun.Filter;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.varun.Dao.UserDao;
import com.varun.Model.SessionModel;

/**
 * Servlet Filter implementation class LoginPageFilter
 */
public class LoginPageFilter implements Filter{

    /**
     * Default constructor. 
     */
    public LoginPageFilter() {
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see Filter#destroy()
	 */
	public void destroy() {
		// TODO Auto-generated method stub
	}

	/**
	 * @see Filter#doFilter(ServletRequest, ServletResponse, FilterChain)
	 */
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		// TODO Auto-generated method stub
		// place your code here
        System.out.println("login filter");
        HttpServletRequest httpRequest =(HttpServletRequest)request;
		HttpServletResponse httpResponse =(HttpServletResponse)response;
		String sessionid="";
        int sessionFlag=0;
        Cookie[] cookies=httpRequest.getCookies();
        if(cookies!=null){
	        for(Cookie c:cookies){
	        	if(c.getName().equals("sessionid")){
		       		sessionid=c.getValue();
                }
	        }
	        if(sessionid!=null){
	       	    UserDao dao=new UserDao();
	        	SessionModel sessionObject=dao.getSessionObject(sessionid);
	       	    if(sessionObject!=null){
	       	    	httpResponse.sendRedirect("/WebProject/userpage.jsp");
            	}
			}
        }
		// pass the request along the filter chain
		chain.doFilter(request, response);
	}

	/**
	 * @see Filter#init(FilterConfig)
	 */
	public void init(FilterConfig fConfig) throws ServletException {
		// TODO Auto-generated method stub
	}

}
