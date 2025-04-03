<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="user" class="user.User" scope="page" />
<jsp:setProperty name="user" property="userID" />
<jsp:setProperty name="user" property="userPassword" />
<jsp:setProperty name="user" property="userName" />
<jsp:setProperty name="user" property="userGender" />
<jsp:setProperty name="user" property="userEmail" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%
		String userID = (String) session.getAttribute("userID");
	 	System.out.println("Session userID: " + userID);
		
		String userName = request.getParameter("userName");
		String userPassword = request.getParameter("userPassword");
		String userGender = request.getParameter("userGender");
		String userEmail = request.getParameter("userEmail");
	
		if(userName.isEmpty() || userPassword.isEmpty() || userGender.isEmpty() || userEmail.isEmpty() ) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('입력이 안 된 사항이 있습니다')");
			script.println("history.back()");
			script.println("</script>");
		} else {
	
			UserDAO userDAO = new UserDAO();
			int result = userDAO.modify(userID, userName, userPassword, userGender, userEmail);
				
			if (result == -1) {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('이미 존재하는 아이디입니다.')");
				script.println("history.back()");
				script.println("</script>");
			}
			else {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('수정되었습니다.')");
				script.println("location.href = 'main.jsp'");
				script.println("</script>");
			}
		}	
	%>
</body>
</html>