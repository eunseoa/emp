<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	request.getParameter("utf-8");
	String commentContent = request.getParameter("commentContent");
	String commentPw = request.getParameter("commentPw");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	
	// 댓글 등록 쿼리
	String sql = "INSERT INTO COMMENT (board_no, commnet_pw, comment_content, createdate) VALUE (?, ?, ?, CURDATE())";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, boardNo);
	stmt.setString(2, commentPw);
	stmt.setString(3, commentContent);
	
	int row = stmt.executeUpdate();
	
	response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo);
%>
