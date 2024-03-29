<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	// 1. 요청분석
	request.setCharacterEncoding("utf-8");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String msg = request.getParameter("msg");
	String msg1 = request.getParameter("msg1");
	
	// 2. 업무처리
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	
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
		<style>
			body {
				background: #f8f9fa
			}
			
			.container {
				background: white;
			}
			
			#header {
				margin-top: 100px;
				box-shadow: 1px 1px 1px 1px gray;
				width: 1500px;
				height:100%;
				border-radius: 20px;
				margin-left:auto;
    			margin-right:auto;
			}
			
			table {
				width:100%;
				height: 100%;
				border-spacing: 20px;
				border-collapse: separate;
				margin-left:auto;
    			margin-right:auto;
			}
			
			textarea {
				resize: none;
			  }
			  
		</style>
	</head>
	<body>
		<div>
			<jsp:include page="/inc/menu.jsp"></jsp:include>
   		</div>
		<div class="container" id="header">
			<form action="<%=request.getContextPath() %>/board/updateBoardAction.jsp">
				<table class="table table-borderless">
					<%
						if (msg != null) {
					%>
							<div><%=msg %></div>
					<%
						} else if (msg1 != null) {
					%>
							<div><%=msg1 %>;</div>
					<%
						}
					%>
					<tr>
						<th>게시글수정</th>
						<td><input type="hidden" name="boardNo" value="<%=boardNo %>"></td>
					</tr>
					<tr>
						<td>제목</td>
						<td><input type="text" name="boardTitle" value="<%=board.boardTitle %>"></td>
					</tr>
					<tr>
						<td>작성자</td>
						<td><input type="text" name="boardWrite" readonly="readonly" value="<%=board.boardWrite %>"></td>
					</tr>
					<tr>
						<td>내용</td>
						<td><textarea name="boardContent" cols="100" rows="15"><%=board.boardContent %></textarea></td>
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