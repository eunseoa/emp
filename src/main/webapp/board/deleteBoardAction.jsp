<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%@ page import="vo.*" %>
<%
	// 1. 요청 분석
	request.getParameter("utf-8");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String boardPw = request.getParameter("boardPw");
	
	// 2. 업무 처리
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	
	// 사원 정보 삭제 쿼리
	// 쿼리 문자열 생성
	String sql ="DELETE FROM board WHERE board_no = ? AND board_pw = ?"; // and는 둘 다 참일때만 진행
	// 쿼리 셋팅
	PreparedStatement stmt = conn.prepareStatement(sql);	
	stmt.setInt(1, boardNo);
	stmt.setString(2, boardPw);

	// 쿼리 실행
	int row = stmt.executeUpdate();
	// 쿼리실행결과 
	if (row == 1) {
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
	} else {
		String msg = URLEncoder.encode("틀린비밀번호입니다.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/deleteBoardForm.jsp?boardNo="+boardNo+"&msg="+msg);
	}
%>
