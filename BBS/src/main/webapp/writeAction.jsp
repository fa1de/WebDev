<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.io.File" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="bbs" class="bbs.Bbs" scope="page" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%
        // 로그인 체크
        String userID = null;
        if (session.getAttribute("userID") != null) {
            userID = (String) session.getAttribute("userID");
        }
        if (userID == null) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('로그인을 해야 합니다.');");
            script.println("location.href = 'login.jsp';");
            script.println("</script>");
            script.close();
            return;
        }

        // 파일 업로드 설정
        String directory = application.getRealPath("/upload/");
        int maxSize = 1024 * 1024 * 100; // 최대 파일 크기 100MB
        String encoding = "UTF-8";

        MultipartRequest multipartRequest = null;
        try {
            multipartRequest = new MultipartRequest(request, directory, maxSize, encoding, new DefaultFileRenamePolicy());
        } catch (Exception e) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('파일 업로드 중 문제가 발생했습니다.');");
            script.println("history.back();");
            script.println("</script>");
            script.close();
            return;
        }

        // 글 제목과 내용 받기
        String bbsTitle = multipartRequest.getParameter("bbsTitle");
        String bbsContent = multipartRequest.getParameter("bbsContent");

        // 파일 이름 받기
        String fileName = multipartRequest.getOriginalFileName("file");
        String fileRealName = multipartRequest.getFilesystemName("file");

        // 제목이나 내용이 없는 경우 처리
        if (bbsTitle == null || bbsContent == null || bbsTitle.trim().isEmpty() || bbsContent.trim().isEmpty()) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('제목이나 내용이 입력되지 않았습니다.');");
            script.println("history.back();");
            script.println("</script>");
            script.close();
            return;
        }

        // 데이터베이스 저장
        BbsDAO bbsDAO = new BbsDAO();
        int result = bbsDAO.write(bbsTitle, userID, bbsContent, fileName, fileRealName);

        if (result == -1) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('글쓰기에 실패했습니다.');");
            script.println("history.back();");
            script.println("</script>");
            script.close();
        } else {
            if (fileName != null && fileRealName != null) {
                // FileDAO를 사용하여 파일 정보 저장 (추가 구현 필요)
                // new FileDAO().upload(fileName, fileRealName, result); // result는 게시글 ID
            }
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('글쓰기가 완료되었습니다.');");
            script.println("location.href = 'bbs.jsp';");
            script.println("</script>");
            script.close();
        }
    %>
</body>
</html>