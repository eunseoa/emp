<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%
	// 요청분석
	request.setCharacterEncoding("utf-8");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	String commnetPw = request.getParameter("commnetPw");
	System.out.println("댓글삭제버튼");
	System.out.println(boardNo);
	System.out.println(commentNo);
	System.out.println(commnetPw);
	
	// 업무처리
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	
	// 삭제쿼리
	String sql = "DELETE FROM comment WHERE comment_no = ? AND commnet_pw = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, commentNo);
	stmt.setString(2, commnetPw);
	
	System.out.println(commentNo);
	System.out.println(commnetPw);
	
	
	int row = stmt.executeUpdate();
	
	if (row == 1) {
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo);
		System.out.println("댓글삭제버튼");
	} else {
		String msg = URLEncoder.encode("틀린비밀번호입니다.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/deleteCommentForm.jsp?commentNo="+commentNo+"&msg="+msg);
		return;
	}
%>