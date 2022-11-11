<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	// 1. 요청분석
	int currentPage = 1; //넘어오지않을수도 있으니 1로 초기화
	if (request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// 2. 필요시 요청처리 후 모델데이터를 생성
	final int ROW_PER_PAGE = 10; // final을 붙여주면 상수가 됨 (외부에 의해 바뀔 수 없음)
	int beginRow = ((currentPage - 1) * ROW_PER_PAGE); // LIMIT beginRow, ROW_PER_PAGE
	
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("드라이버로딩 성공"); // 디버깅
	
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "dmstj1004");
	System.out.println(conn + " <-- conn"); // 디버깅
	
	// 
	String cntSql = "SELECT COUNT(*) cnt FROM board"; 
	PreparedStatement cntStmt = conn.prepareStatement(cntSql);
	ResultSet cntRs = cntStmt.executeQuery();
	int cnt = 0;
	if (cntRs.next()) {
		cnt = cntRs.getInt("cnt");
	}
	
	int lastPage = cnt / ROW_PER_PAGE;
	if (cnt % ROW_PER_PAGE != 0) {
		lastPage++;
	}
	
	// 2-2
	String listSql = "SELECT board_no boardNo, board_title boardTitle FROM board ORDER BY board_no ASC LIMIT ?, ?";
	PreparedStatement listStmt = conn.prepareStatement(listSql);
	listStmt.setInt(1, beginRow);
	listStmt.setInt(2, ROW_PER_PAGE);
	ResultSet listRs = listStmt.executeQuery(); // 모델 source 
	
	ArrayList<Board> boardList = new ArrayList<Board>(); // 모델의 new data
	while(listRs.next()) {
		Board b = new Board();
		b.boardNo = listRs.getInt("boardNo");
		b.boardTitle = listRs.getString("boardTitle");
		boardList.add(b);
	}
	
	// view
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
      		#header {
            	text-align: center;
            	margin-top: 100px; 
         	}
         	
         	#thNo {
         		width:200px;
         	}
         	
         	#th {
         		text-align: left;
         		width:400px
         	}
		</style>
	</head>
	<body>
		<div>
			<jsp:include page="/inc/menu.jsp"></jsp:include>
   		</div>
		<div class="container" id="header">
			<div>
           	<h1>DEPT LIST</h1>
        </div>
        <div>
        	<ul class="nav justify-content-end">
            	<li class="nav-item">
                	<a class="nav-link" href="<%=request.getContextPath()%>/board/insertBoardForm.jsp">글쓰기</a>
              	</li>
          	</ul>
		</div>
	   		<!--  3-1. 모델데이터(ArrayList<Board>) 출력 -->
	   		<table class="table">
	   			<tr>
	   				<th id="thNo">no</th>
	   				<th id="th">제목</th>
	   			</tr>
	   			
	   		<%
	   				for (Board b : boardList) {
	   		%>
	   				<tr>
	   					<td id="thNo"><%=b.boardNo%></td>
		   				<td id="th">
							<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=b.boardNo%>"><%=b.boardTitle%></a>
						</td>
					</tr>
	   		<%
	   				}
	   		%>
	   		</table>
	   		<!--  3-2. 페이징 -->
	   		<div>
	   			<ul class="pagination pagination-sm justify-content-center">
	   				<li class="page-item">
		   				<a class="page-link" href="<%=request.getContextPath() %>/board/boardList.jsp?currentPage=1">처음</a>
		   			</li>
		   			<%
		   				if (currentPage > 1) {
		   			%>
		   					<li class="page-item">
		   						<a class="page-link" href="<%=request.getContextPath() %>/board/boardList.jsp?currentPage=<%=currentPage-1 %>"> ◀</a>
		   					</li>
		   			<%
		   				}
		   			%>
		   					<li>
		   						<a class="page-link"><%=currentPage %></a>
		   					</li>
		   			<%
		   				if (currentPage < lastPage) {
		   			%>
		   					<li class="page-item">
		   						<a class="page-link" href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage+1 %>"> ▶ </a>
		   					</li>
		   			<%
		   				}
		   			%>
		   			<li class="page-item">
		   				<a class="page-link" href="<%=request.getContextPath() %>/board/boardList.jsp?currentPage=<%=lastPage%>">마지막</a>
	   				</li>
	   			</ul>
	   		</div>
   		</div>
	</body>
</html>