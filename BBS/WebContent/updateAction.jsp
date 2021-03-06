<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="bbs.Bbs" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="java.io.PrintWriter" %> <!-- 자바스크립트 문장 작성 위해 필요 -->
<%request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<% 
	    String userID = null;
	    if(session.getAttribute("userID") != null){ 
	    	userID = (String)session.getAttribute("userID");
	    }
	    if(userID == null){  //로그인이 되어 있지 않은 유저 처리
	    	PrintWriter script = response.getWriter();
	    	script.println("<script>");
	    	script.println("alert('로그인이 필요합니다.')");
	    	script.println("location.href = 'login.jsp'");
	    	script.println("</script>");
	    } 
	    int bbsID = 0;
		if(request.getParameter("bbsID") != null){  //매개변수로 넘어온 bbsID라는 id가 존재한다면
			bbsID = Integer.parseInt(request.getParameter("bbsID"));
		}
		if(bbsID == 0){  //번호가 존재하지 않을 시 글을 볼 수 없다.
			PrintWriter script = response.getWriter();
	    	script.println("<script>");
	    	script.println("alert('유효하지 않은 글입니다.')");
	    	script.println("location.href = 'bbs.jsp'");
	    	script.println("</script>");
		}
		Bbs bbs = new BbsDAO().getBbs(bbsID);
		if(!userID.equals(bbs.getUserID())){
			PrintWriter script = response.getWriter();
	    	script.println("<script>");
	    	script.println("alert('수정 권한이 없습니다.')");
	    	script.println("location.href = 'bbs.jsp'");
	    	script.println("</script>");
		} else {	//권한이 있는 경우
	    	 if(request.getParameter("bbsTitle") == null || request.getParameter("bbsContent") == null
	    	 	|| request.getParameter("bbsTitle").equals("") || request.getParameter("bbsContent").equals("")){	//제목이나 내용이 null값이거나 입력되지 않은 사항이 존재할 시 알려주는 코드
	    		PrintWriter script = response.getWriter();
	    		script.println("<script>");
	    		script.println("alert('입력되지 않은 사항이 존재합니다.')");
	    		script.println("history.back()");
	    		script.println("</script>");
	    	} else {
	    		BbsDAO bbsDAO = new BbsDAO();
	    		int result = bbsDAO.update(bbsID, request.getParameter("bbsTitle"), request.getParameter("bbsContent")); 
	    		if(result == -1){  //db오류
	    			PrintWriter script = response.getWriter();
	    			script.println("<script>");
	    			script.println("alert('글 수정에 실패했습니다.')");
	    			script.println("history.back()");
	    			script.println("</script>");
	    		} 
	    		else {  //수정 성공
	    			PrintWriter script = response.getWriter();
	    			script.println("<script>");
	    			script.println("location.href = 'bbs.jsp'");
	    			script.println("</script>");
	    		}  
	    	}
		}
	%>
</body>
</html>