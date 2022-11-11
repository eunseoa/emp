<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%
	request.getParameter("utf-8");
	String boardTitle = request.getParameter("boardTitle");
	String boardWrite = request.getParameter("boardWrite");
	String boardPw = request.getParameter("boardPw");
	String boardContent = request.getParameter("boardContent");
	

	if (request.getParameter("boardTitle") == null || request.getParameter("boardWrite") == null 
		|| request.getParameter("boardPw") == null || request.getParameter("boardContent") == null
		|| boardTitle.equals("") || boardContent.equals("") || boardWrite.equals("") || boardPw.equals("")) {
		String msg = URLEncoder.encode("작성되지않은 항목이 있습니다.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/insertBoardForm.jsp?msg="+msg);
		return;
	}
	
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "dmstj1004");
	
	// 게시글 내용 저장
	String sql = "INSERT into board (board_pw, board_title, board_content, board_write, createdate) values(?, ?, ?, ?, curdate())";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, boardPw);
	stmt.setString(2, boardTitle);
	stmt.setString(3, boardContent);
	stmt.setString(4, boardWrite);
	int row = stmt.executeUpdate();
	
	if (row == 1) {
		System.out.println("입력성공");
	} else {
		System.out.println("입력실패");
	}
	
	response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
%>
