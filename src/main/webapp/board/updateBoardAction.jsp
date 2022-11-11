<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%@ page import="vo.*" %>
<%
	// 1. 수정 요청 분석
	request.setCharacterEncoding("utf-8");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String boardPw = request.getParameter("boardPw");
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");

	if ( request.getParameter("boardTitle") == null || request.getParameter("boardPw") == null 
			|| request.getParameter("boardContent") == null
			|| boardTitle.equals("") || boardContent.equals("") || boardPw.equals("")) {
		String msg = URLEncoder.encode("작성되지않은 항목이 있습니다.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/updateBoardForm.jsp?boardNo="+boardNo+"&msg="+msg);
		return;
	}
	
	
	Board board = new Board();
	board.boardNo = boardNo;
	board.boardPw = boardPw;
	board.boardTitle = boardTitle;
	board.boardContent = boardContent;
	
	// 2. 업무처리
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "dmstj1004");
	
	
	// 사원 정보 수정 쿼리
	String sql = "UPDATE board SET board_title = ?, board_content = ? WHERE board_no = ? AND board_pw = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	
	stmt.setString(1, boardTitle);
	stmt.setString(2, boardContent);
	stmt.setInt(3, boardNo);
	stmt.setString(4, boardPw);
	
	int row = stmt.executeUpdate();
	if (row == 1) {
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+board.boardNo);
	} else {
		String msg1 = URLEncoder.encode("틀린비밀번호입니다.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/updateBoardForm.jsp?boardNo="+boardNo+"&msg="+msg1);
	}
	
%>