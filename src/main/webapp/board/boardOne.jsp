<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	// 1. 요청분석
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int currentPage = 1; // 댓긆페이지
	if (request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}

	// 2. 요청 처리
	// 2-1. 게시글
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "dmstj1004");
	String boardSql ="SELECT board_title boardTitle, board_content boardContent, board_write boardWrite, createdate FROM board WHERE board_no=?";
	PreparedStatement boardStmt = conn.prepareStatement(boardSql);
	boardStmt.setInt(1, boardNo);
	ResultSet boardRs = boardStmt.executeQuery();
	Board board = null;
	if(boardRs.next()){
		board = new Board();
		board.boardNo = boardNo;
		board.boardTitle = boardRs.getString("boardTitle");
		board.boardContent = boardRs.getString("boardContent");
		board.boardWrite = boardRs.getString("boardWrite");
		board.createdate = boardRs.getString("createdate");
	}
	
	// 2-2. 댓글목록
	int rowPerPage = 5; // 한 페이지당 보일 댓글의 수
	int beginRow = (currentPage - 1) * rowPerPage; // 페이지당 LIMIT 첫번째 물음표
	
	String commentSql = "SELECT comment_no commentNo, comment_content commentContent FROM comment WHERE board_no = ? ORDER BY comment_no DESC LIMIT ?, ?"; 
	PreparedStatement commentStmt = conn.prepareStatement(commentSql);
	commentStmt.setInt(1, boardNo);
	commentStmt.setInt(2, beginRow);
	commentStmt.setInt(3, rowPerPage);
	ResultSet commentRs = commentStmt.executeQuery();
	ArrayList<Comment> commentList = new ArrayList<Comment>();
	while (commentRs.next()) {
		Comment c = new Comment();
		c.commentNo = commentRs.getInt("commentNo");
		c.commentContent = commentRs.getString("commentContent");
		commentList.add(c);
	}
	
	
	// 2-3. 댓글의 전체 행의 수로 lastPage구하기
	// 댓글의 갯수 구하는 쿼리
	String cntSql = "SELECT COUNT(board_no) cnt FROM comment WHERE board_no = ?";
	PreparedStatement cntStmt = conn.prepareStatement(cntSql);
	cntStmt.setInt(1, boardNo);
	ResultSet cntRs = cntStmt.executeQuery();
	int cnt = 0;
	if (cntRs.next()) {
		cnt = cntRs.getInt("cnt");
	}
	
	int lastPage = cnt / rowPerPage;
	if (cnt % rowPerPage != 0) {
		lastPage++;
	}
	
	// 3. 출력
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
			}
			
			#comment {
				margin-left:auto;
    			margin-right:auto;
			}
			 
			textarea {
				resize: none;
			  }
			  
			 textarea:focus, input:focus {
			 	outline: none;
			 }
		</style>
	</head>
	<body>
		<div>
			<jsp:include page="/inc/menu.jsp"></jsp:include>
   		</div>
   		<div class="container" id="header">
			<table class="table">
				<tr>
					<th><%=board.boardTitle %>
					<span style="float:right;"><a href="<%=request.getContextPath() %>/board/updateBoardForm.jsp?boardNo=<%=boardNo%>">수정</a>
							<a href="<%=request.getContextPath() %>/board/deleteBoardForm.jsp?boardNo=<%=boardNo%>">삭제</a></span>
					</th>
				</tr>
				<tr>
					<td><%=board.boardWrite %> ・  <%=board.createdate %></td>
				</tr>
				<tr>
					<td><%=board.boardContent %></td>
				</tr>
			</table>
			
			<div id="comment">
				<!-- 댓글입력폼 -->
				<form action="<%=request.getContextPath() %>/board/insertCommentAction.jsp" method="post">
					<input type="hidden" name ="boardNo" value="<%=board.boardNo %>">
					<table>
						<tr>
							<td>댓글</td>
							<td>
								<textarea cols="80" rows="3" name="commentContent"></textarea>
							</td>
						</tr>
						<tr>
							<td></td>
							<td>
								<input type="password" name="commentPw" placeholder="비밀번호">
								<button type="submit" class="btn btn-outline-secondary btn-sm">등록</button>
							</td>
						</tr>
					</table>
				</form>
			</div>

			<div id="comment">
				<table class="table">
					<!-- 댓글 목록 -->
					<%
						for(Comment c : commentList) {
					%>		
							<tr>
								<td><%=c.commentNo %></td>
								<td><%=c.commentContent %></td>
								<td><a href="<%=request.getContextPath() %>/board/deleteCommentForm.jsp?commentNo=<%=c.commentNo %>&boardNo=<%=boardNo %>">삭제</a></td>
							</tr>
					<%		
						}
					%>
					<!-- 댓글 페이징 -->
						<tr>
						<%
							if(currentPage > 1) {
						%>
								<td><a href="<%=request.getContextPath() %>/board/boardOne.jsp?boardNo=<%=boardNo %>&currentPage=<%=currentPage-1%>">이전</a></td>
						<%
							}
						%>
						<%
							if(currentPage < lastPage) {
						%>
								<td><a href="<%=request.getContextPath() %>/board/boardOne.jsp?boardNo=<%=boardNo %>&currentPage=<%=currentPage+1 %>">다음</a></td>
						<%
							}
						%>
						</tr>
				</table>
			</div>
		</div>
	</body>
</html>