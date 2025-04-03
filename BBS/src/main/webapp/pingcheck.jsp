<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.BufferedReader, java.io.InputStreamReader, java.nio.charset.Charset" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="user.User" %>
<%@ page import="user.UserDAO" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>Ping Check</title>
</head>
<body>
	<%
		String userID = null;
	 	User user = null;
	 	String userName = "알 수 없음";
	
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");		
		}
		if (userID != null) {
	        UserDAO userDAO = new UserDAO();
	        user = userDAO.getUserByUserID(userID);
	    }
	%>
	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-expanded="false">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				</button>
				<a class="navbar-brand" href="main.jsp">JSP 게시판 웹 사이트</a>
		</div>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li class="active"><a href="main.jsp">메인</a></li>
				<li><a href="bbs.jsp">게시판</a></li>
			</ul>
			<ul class="nav navbar-nav navbar-right">
				<% 
					if("admin".equals(session.getAttribute("userID"))) {
				%>
					<li><a href="pingcheck.jsp">Ping Check</a></li>
				<%
					}
				%>
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">회원관리<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="modify.jsp"><%= user.getUserName() %></a></li>
						<li><a href="logoutAction.jsp">로그아웃</a></li>	
					</ul>
				</li>
			</ul>
		</div>
	</nav>
	<%
	    String ip = request.getParameter("ip");
	    String result = "";
	
	    if (ip != null && !ip.isEmpty()) {
	        try {
	            Process process;
	            if (System.getProperty("os.name").toLowerCase().contains("win")) {
	                // Windows 환경에서는 ping -n 사용
	                process = Runtime.getRuntime().exec("cmd.exe /c ping " + ip);
	            } else {
	                // Linux/macOS 환경에서는 ping -c 사용
	                process = Runtime.getRuntime().exec("ping -c 4 " + ip);
	            }
	
	            // Windows에서는 MS949, 나머지는 UTF-8
	            String encoding = System.getProperty("os.name").toLowerCase().contains("win") ? "MS949" : "UTF-8";
	            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream(), encoding));
	
	            String line;
	            StringBuilder output = new StringBuilder();
	            while ((line = reader.readLine()) != null) {
	                output.append(line).append("<br>");
	            }
	            reader.close();
	            result = output.toString();
	        } catch (Exception e) {
	            result = "오류 발생: " + e.getMessage();
	        }
	    }
	%>
	<div class="container">
		<div class="jumbotron">
		    <h2>Ping Check</h2>
		    <form method="POST">
		        <label>Ping</label>
		        <input type="text" name="ip" placeholder="IP(ex:192.168.0.100)">
		        <button type="submit">확인</button>
		    </form>
		    <hr>
		    <h3>Ping 결과:</h3>
			<div>
				<%= result %>
			</div>
		</div>
	</div>
	<script src="http://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>
