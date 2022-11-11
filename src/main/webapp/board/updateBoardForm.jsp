<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	// 1. 요청분석
	request.setCharacterEncoding("utf-8");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String msg = request.getParameter("msg");
	
	// 2. 업무처리
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "dmstj1004");
	
	// 수정할 글 
	String sql = "SELECT board_pw boardPw, board_title boardTitle, board_content boardContent, board_write boardWrite, createdate FROM board WHERE board_no=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, boardNo);
	ResultSet rs = stmt.executeQuery();
	
	Board board = null;
	if (rs.next()) {
		board = new Board();
		board.boardTitle = rs.getString("boardTitle");
		board.boardContent = rs.getString("boardContent");
		board.boardWrite = rs.getString("boardWrite");
		board.boardPw = rs.getString("boardPw");
		board.createdate = rs.getString("createdate");
	}
	
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Insert title here</title>
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"></script>
	</head>
	<body>
		<div>
			<form action="<%=request.getContextPath() %>/board/updateBoardAction.jsp">
				<table class="table table-borderless">
					<tr>
						<td>no</td>
						<td><input type="number" name="boardNo" readonly="readonly" value="<%=boardNo %>"></td>
					</tr>
					<tr>
						<td>작성자</td>
						<td><input type="text" name="boardWrite" readonly="readonly" value="<%=board.boardWrite %>"></td>
					</tr>
					<tr>
						<td>제목</td>
						<td><input type="text" name="boardTitle"value="<%=board.boardTitle %>"></td>
					</tr>
					<tr>
						<td>내용</td>
						<td><input type="text" name="boardContent" value="<%=board.boardContent %>"></td>
					</tr>
					<tr>
						<td>비밀번호</td>
						<td><input type="password" name="boardPw"></td>
					</tr>
					<tr>
						<td>작성일자</td>
						<td><input type="text" name="createdate" readonly="readonly" value="<%=board.createdate %>"></td>
					</tr>
				</table>
				<div>
					<button type="submit">수정</button>
				</div>
			</form>
		</div>
	</body>
</html>