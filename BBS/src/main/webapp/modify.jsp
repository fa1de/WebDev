<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="user.User" %>
<%@ page import="user.UserDAO" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%
	    User user = null;
	    // 세션에서 userID가 있을 때 사용자 정보 가져오기
	    if (session.getAttribute("userID") != null) {
	        String userID = (String) session.getAttribute("userID");
	        UserDAO userDAO = new UserDAO();
	        
	        // user 객체에 성별과 이메일 포함된 사용자 정보를 가져옴
	        user = userDAO.getUserByUserID(userID);
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
				<li><a href="main.jsp">메인</a></li>
				<li><a href="bbs.jsp">게시판</a></li>
			</ul>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">접속하기<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li class="active"><a href="modify.jsp"><%= user.getUserName() %></a></li>
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul>
				</li>
			</ul>
		</div>
	</nav>
	<div class="container">
		<div class="col-lg-4"></div>
		<div class="col-lg-4">
			<div class="jumbotron" style="padding-top: 20px;">
				<form method="post" action="modifyAction.jsp">
					<h1 style="text-align: center; white-space: nowrap;">My Page</h1>	
					<hr style="border-top: 2px solid #000; width: 100%; margin: 20px auto;">
					<div class="form-group">
						<h4>Name :</h4>
						<input type="text" class="form-control" placeholder="Name Input"  name="userName" value="<%= (user != null) ? user.getUserName() : "" %>" maxlength="20">
					</div>
					<div class="form-group">
						<h4>Password :</h4>
						<input type="password" class="form-control" placeholder="Password Input" name="userPassword" maxlength="20">
					</div>
					<div class="form-group" style="text-align: center;">
						<div class="btn-group" data-toggle="buttons">
						<h4>성별</h4>
                            <label class="btn btn-primary <%= user.getUserGender().equals("남자") ? "active" : "" %>">
                                <input type="radio" name="userGender" autocomplete="off" value="남자" <%= user.getUserGender().equals("남자") ? "checked" : "" %>>남자
                            </label>
                            <label class="btn btn-primary <%= user.getUserGender().equals("여자") ? "active" : "" %>">
                                <input type="radio" name="userGender" autocomplete="off" value="여자" <%= user.getUserGender().equals("여자") ? "checked" : "" %>>여자
                            </label>
						</div>
					</div>
					<div class="form-group">
						<h4>Email :</h4>
						<input type="email" class="form-control" placeholder="Email Input" name="userEmail" value="<%= user.getUserEmail() %>" maxlength="20">
					</div>
					<input type="submit" class="btn btn-info" value="수정하기">
					<button type="button" class="btn btn-danger" onclick="if(confirm('탈퇴 하시겠습니까?')) location.href='deleteAcc.jsp?id=<%= session.getAttribute("userID") %>'">탈퇴하기</button>
				</form>
			</div>
			<% 
				} else {
			%>
				<script>alert('존재하지 않는 사용자입니다.'); location.href = 'main.jsp';</script>
			<%
				}
			%>
		</div>
		<div class="col-lg-4"></div>
	</div>
	<script src="http://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>