<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="javax.servlet.http.Cookie" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.varun.Dao.*" %>
<%@ page import="com.varun.Model.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.security.*" %>
<%@ page import="javax.crypto.*" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="com.varun.Model.*" %>
<%@ page import="com.varun.Security.CookieEncrypt" %> 
<%@ page import="javax.servlet.RequestDispatcher" %>
<%@ page import="com.varun.Security.EncryptionHandler" %> 
<%@ page import="com.varun.Logger.LoggerUtil"%>
<%@ page import="java.util.logging.*"%>

<html>
   <head> 
         <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script> 
         <script src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/3.1.2/rollups/aes.js" integrity="sha256-/H4YS+7aYb9kJ5OKhFYPUjSJdrtV6AeyJOtTkw6X72o=" crossorigin="anonymous"></script>
         <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
       
       <%  
           //<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
           System.out.println("inside userpage");
	       String sessioninfo="";
	       UserinfoTableModel dataObj=null;
	       Integer userid=null;
	       String username=null;
	       String email=null;
	       
	       List<EmailTableModel> emailList=null;
	       List<MobileTableModel> mobileList=null;
	       if(request.getAttribute("dataobj")!=null){
	    	   System.out.println("data obj from request attribute123123");
	    	   dataObj=(UserinfoTableModel)request.getAttribute("dataobj");
	       }
	       
	       if(dataObj!=null){
	    	    System.out.println("dataobj not null");
	            int flag=0;
	            userid=dataObj.getUser_id();
	            username=dataObj.getUser_name();
	       }else{
	    	   System.out.println("dataobj null");
	    	   response.sendRedirect("log");
	       }
	       
           request.setAttribute("dataobj",dataObj);
           session.setAttribute("dataobj",dataObj);
           //response.setIntHeader("Refresh",1);
           response.setHeader("Expires","0");
       %>

       <link rel="stylesheet" href="/WebServlet/src/main/webapp/webfiles/NewFile.css">       
    </head>
   <body>
       <% response.setHeader("Cache-Control","no-cache,no-store,must-revalidate"); %>
       <div name="logout_container" style="display:flex;">
	       <h1> Welcome to the page,</h1><h1> <%out.println(username); %> </h1>  
	       <form action="logout" style="padding-left:135vh; padding-top:50px;">
	          <button type="submit" style="height:30px;width:60px;">Logout</button>
	          <a href="profileEdit.jsp">Editprofile</a> 
	       </form>           
       </div>
       
       <div name="chats" id="chats" style="display:flex;height:800px;">
	            <div name="list" style="width:200px;height:600px;">
		               <div style="display:flex;">
				           <h1>Chats</h1>
				           <button placeholder="create" style="height:40px;width:70px" id="cg">CREATE GROUP</button>
				           <br>
			           </div>
		           <div id="chat_list"></div>
		           
                </div>
           <div class="conv" style="width:800px;height:900px;">
	            <div Class="msg_form" style= "padding-top:10px;height:900px;">
		               <h2 id=1></h2>
		               <div id=2 Class="messages" style="height:60%;width:80%;overflow:scroll;"> </div>
		               <div></div>
		               <input id="chat_message" name="chat_message" style= "width:60% ;height:23px;" id="chat-writer" type="text">
		               <div id="send_btn"></div>
	             </div>
	       </div>
	       
	       <div id="create_group">
	                <h2 id="create_grp_header"></h2>
                    <div id="users_for_group"></div>
                    <div id="group_list"></div>
           </div>
           <div >
           <button onclick="showPopup()">Show Details</button>
           <div style="display:none" id="user_contacts">
              <h2>USER DETAILS</h2>
              <h3>USER EMAIL ID</h3>
              <%  
	              emailList=dataObj.getEmailTableObj();
	              mobileList=dataObj.getMobileTableObj();
                  System.out.println("em mob ret frm db"+emailList.size());
                  for(EmailTableModel emailData:emailList){
                      out.println(emailData.getEmailid()+"<br>");
                  }
              %>
              <h3>USER MOBILE NUMBER</h3>
              <%  System.out.println(mobileList.size());
                  for(MobileTableModel mobileData:mobileList){
                      out.println(mobileData.getMobileno()+"<br>");
                  }
              %>
              <br><button onclick="closeGroupCreation()">Close</button>
           </div>
           
           </div>
            </div> 
           <script>
	           var popup = document.getElementById("user_contacts");
	           var createGroupObj = document.getElementById("create_group");
	           function showPopup(){
	             popup.style.display = "block";
	           }
	           function hidePopup(){
	             popup.style.display = "none";
	           }
	           function closeGroupCreation(){
	        	   createGroupObj.innerHTML="";
	           }
		     <% 
		        EncryptionHandler handler=new EncryptionHandler();
		        JSONObject json=new JSONObject();
		        json.put("userid",userid);
		        out.println("var uid="+userid+";");%>
		            $(document).ready(function(){
		           	 $("#cg").click(function(){
		           		  <% out.println("$.get(\"GroupFormation?uid="+userid+"\",function(data){");%>
		           		     $("#create_grp_header").html("CREATE GROUP");
		           			 $("#users_for_group").html(data);
		           			 
				    	})
		          	 })  
		        	}); 
                    
                    
		        	$(document).ready(function(){
		            	/* setInterval(function(){
		            		 
		           		 
					     },3000);  */
					     $.ajax({
		               		 url:"chatlist", 
		               		 type:"POST",
		               		 data:JSON.stringify({userid:uid}),
		               		 success: function(result){
		               			$("#chat_list").html(result);
		               	     }
		               	});
			        });
		        	
		        	var interval;
		        	var offsetInMillis = new Date().getTimezoneOffset() * 60 * 1000;
		        	const timezone=Intl.DateTimeFormat().resolvedOptions().timeZone;
		        	function chat(sid,rid,isgroup,reciever){
		        		console.log(offsetInMillis+" "+Intl.DateTimeFormat().resolvedOptions().timeZone);
		        		/*clearInterval(interval); */
		        		$("#send_btn").html("<button onclick=\"sendmsg("+sid+","+rid+","+isgroup+",'"+reciever+"');\">send</button>");
		        		$(document).ready(function(){
		        			$("#1").html(reciever);
			            	/*interval=setInterval(function(){
			            		
			           			
			           		 },1000); */
			           		/* var jsondat=JSON.stringify({encrypted:encrypted});
			           		var encrypted = CryptoJS.AES.encrypt(
			           	            jsondat,"pass"
			           	         );
			           		console.log(encrypted);
			           		var decrypted = CryptoJS.AES.decrypt(
			           	            encrypted,"pass"
			           	         ).toString(CryptoJS.enc.Utf8);
			           		console.log(decrypted); */
		        			$.ajax({
			               		 url:"ShowMessages", 
			               		 type:"POST",
			               		 headers:{"auth":"secret"},
			               		 datatype:"json",
			               		 data:JSON.stringify({senderid:sid,recieverid:rid,groupyn:isgroup,timezone:timezone}),
			               		 success: function(result){
			               			$("#2").html(result);
			               	     }
			               	});
				        });
		        	}
	           	    
		        	function sendmsg(sid,rid,isgroup,reciever){
		        		var text=document.getElementById("chat_message").innerHTML;
		        		$(document).ready(function(){
		        			const text = $("#chat_message").val()+"";
		        			console.log(text+reciever);
		        			$("#chat_message").val('');
		        			$.ajax({
			               		 url:"sendmessage", 
			               		 type:"POST",
			               		 data:JSON.stringify({senderid:sid,recieverid:rid,groupyn:isgroup,text:text}),
			              	});
                        });
		        	}
			</script>
   </body>
 </html>