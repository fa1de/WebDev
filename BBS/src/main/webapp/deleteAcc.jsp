<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>
<%@ page import="java.io.PrintWriter" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%
		String userID = (String) session.getAttribute("userID");
	
		UserDAO userDAO = new UserDAO();
	    int result = userDAO.delete(userID);
		
		if (result > 0) {
	        session.invalidate();
	        PrintWriter script = response.getWriter();
	        script.println("<script>");
	        script.println("alert('회원 탈퇴가 완료되었습니다.');");
	        script.println("location.href = 'main.jsp';");
	        script.println("</script>");
	        script.close();
	    } else {
	        PrintWriter script = response.getWriter();
	        script.println("<script>");
	        script.println("alert('회원 탈퇴 중 오류가 발생했습니다.');");
	        script.println("history.back();");
	        script.println("</script>");
	        script.close();
	    }
	%>
</body>
</html>