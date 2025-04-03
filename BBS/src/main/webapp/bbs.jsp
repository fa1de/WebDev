<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="user.UserDAO" %>
<%@ page import="user.User" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>JSP 게시판 웹 사이트</title>
<style type"text/css">
	a, a:hover {
		color:#000000;
		text-decoration: none;
	}
</style>
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
	        user = userDAO.getUserByUserID(userID); // userID로 userName을 가져옴
	    }
		int pageNumber = 1;
		if (request.getParameter("pageNumber") != null) {
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
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
				<li><a href="main.jsp">메인</a></li>
				<li  class="active"><a href="bbs.jsp">게시판</a></li>
			</ul>
			<%
				if(userID == null) {
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">접속하기<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="login.jsp">로그인</a></li>	
						<li><a href="join.jsp">회원가입</a></li>
					</ul>
				</li>
			</ul>
			<%		
				} else {
			%>
			<ul class="nav navbar-nav navbar-right">
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
			<%		
				}
			%>
		</div>
	</nav>
	<div class="container">
    <form method="GET" action="bbs.jsp" class="form-inline text-center" style="margin-bottom: 20px;">
        <input type="text" name="search" class="form-control" placeholder="검색어 입력" value="<%= request.getParameter("search") == null ? "" : request.getParameter("search") %>">
        <button type="submit" class="btn btn-primary">검색</button>
    </form>
    </div>
	<div class="container">
		<div class="row">
			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th style="background-color: #eeeeee; text-align: center;">번호</th>
						<th style="background-color: #eeeeee; text-align: center;">제목</th>
						<th style="background-color: #eeeeee; text-align: center;">작성자</th>
						<th style="background-color: #eeeeee; text-align: center;">작성일</th>
					</tr>
				</thead>
				<tbody>
					<%
						BbsDAO bbsDAO = new BbsDAO();
		                String search = request.getParameter("search"); // 검색어 가져오기
		                ArrayList<Bbs> list;
		                    	
		                if (search != null && !search.trim().isEmpty()) {
		                	list = bbsDAO.searchList(search, pageNumber); // 검색 기능 사용
		                } else {
		                    list = bbsDAO.getList(pageNumber); // 기존 리스트 가져오기
		                }

		                for (int i = 0; i < list.size(); i++) {  	
					%>
					<tr>
						<td><%= list.get(i).getBbsID() %></td>
						<td><a href="view.jsp?bbsID=<%= list.get(i).getBbsID() %>"><%= list.get(i).getBbsTitle().replaceAll("\n", "<br>") %></a></td>
						<td><%= list.get(i).getUserName() %></td>
						<td><%= list.get(i).getBbsDate().substring(0,11) + list.get(i).getBbsDate().substring(11,13) + "시" + list.get(i).getBbsDate().substring(14,16) + "분" %></td>
					</tr>
					<%
						}					
					%>
				</tbody>
			</table>
			
			<%	// 검색을 했을 경우 (bbs.jsp?search=)
				if (search != null && !search.trim().isEmpty()) { 
			%>
				<% if (pageNumber > 1) { %>
				        <a href="bbs.jsp?search=<%= search %><%= (pageNumber - 1 > 1) ? "&pageNumber=" + (pageNumber - 1) : "" %>" class="btn btn-success btn-arrow-left">이전</a>
				<% 
					} 
				%>
				    
				<% if (bbsDAO.SearchNextPage(search, pageNumber)) { %>
				        <a href="bbs.jsp?search=<%= search %>&pageNumber=<%= pageNumber + 1 %>" class="btn btn-success btn-arrow-left">다음</a>
				<% 
					} 
				%>
				
			<%  // 검색을 안 했을 경우 (bbs.jsp)
				} else { 
			%>
				<% if (pageNumber > 1) { %>
					<a href="bbs.jsp<%= (pageNumber - 1 > 1) ? "?pageNumber=" + (pageNumber - 1) : "" %>" class="btn btn-success btn-arrow-left">이전</a>
				<% } %>
				
				<% if (bbsDAO.nextPage(pageNumber + 1)) { %>
				        <a href="bbs.jsp?pageNumber=<%= pageNumber + 1 %>" class="btn btn-success btn-arrow-left">다음</a>
				<% 
					} 
				%>
				<% 
					} 
				%>
			
			<a href="write.jsp" class="btn btn-primary pull-right">글쓰기</a>
		</div>	
	</div>						
	<script src="http://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>