<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.util.*" %>
<%
	// 1 요청분석
	request.setCharacterEncoding("utf-8");
	String name = request.getParameter("name");
	

	int currentPage = 1; // 현재페이지 초기화 첫페이지는 무조건 1
	if (request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	int rowPerPage = 10; // 한페이지당 볼 사원정보담긴 열 개수
	int beginRow = (rowPerPage * (currentPage - 1)); // 처음 시작할 열의 값
	
	// 2 요청처리 후 모델데이터 생성
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	
	// 검색쿼리
	String empSql = null;
	String countSql = null;
	PreparedStatement empStmt = null;
	ResultSet empRs = null;
	PreparedStatement countStmt = null;
	ResultSet countRs = null;
	
	if (name == null) {
		empSql = "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees ORDER BY emp_no ASC LIMIT ?, ?";
		empStmt = conn.prepareStatement(empSql);
		empStmt.setInt(1, beginRow); 
		empStmt.setInt(2, rowPerPage);
		empRs = empStmt.executeQuery();
		countSql="SELECT COUNT(*) cnt FROM employees";
		countStmt = conn.prepareStatement(countSql);
	} else {
		empSql = "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees WHERE first_name LIKE ? OR last_name LIKE ? ORDER BY emp_no ASC LIMIT ?, ?";
		empStmt = conn.prepareStatement(empSql);
		empStmt.setString(1, "%"+name+"%");
		empStmt.setString(2, "%"+name+"%");
		empStmt.setInt(3, beginRow); 
		empStmt.setInt(4, rowPerPage);
		empRs = empStmt.executeQuery();
		countSql="SELECT COUNT(*) cnt FROM employees WHERE first_name LIKE ? OR last_name LIKE ?";
		countStmt = conn.prepareStatement(countSql);
		countStmt.setString(1, "%"+name+"%");
		countStmt.setString(2, "%"+name+"%");
	}

	// if문을 이용한 사원정보의 개수 구하기
	countRs = countStmt.executeQuery();
	int count = 0;
	if (countRs.next()) {
		count = countRs.getInt("cnt");
	}
	
	// 사원정보 총개수와 한페이지에 나올 열을 나눈 나머지가 0이 아닐때 lastPage + 1을 해줌
	int lastPage = count / rowPerPage;
	if (count % rowPerPage != 0) { 
		lastPage++;
	}
	
	ArrayList<Employee> empList = new ArrayList<Employee>();
	while(empRs.next()) {
		Employee e = new Employee();
		e.empNo = empRs.getInt("empNo");
		e.firstName = empRs.getString("firstName");
		e.lastName = empRs.getString("lastName");
		empList.add(e);
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
      		#header {
            	text-align: center;
            	margin-top: 100px; 
         	}
         
         	tabl, tr, td {
            	height: 50px;
         	}
         
         	a:link, a:visited {
         		color: #000;
         		text-decoration: none;
         	}
         	
         	a:hover, a:active {
         		text-decoration: underline;
         	}
         	
         	#tdNo {
         	 width: 300px;
         	}
         	
         	#tdName {
         		width: 500px;
         	}
         	
         	.search {
         		float:right;
         	}
         	
         	input[type=text] {
         		width:450px;
				border-right: hidden;
				border-left: hidden;
				border-top: hidden;
				font-align:center;
         	}
      	</style>
	</head>
	<body>
		<div>
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>
		<div class="container" id="header">
			<h1>사원목록</h1>
			<div>
		<%
				if (name == null) {
		%>
		        	<form action="<%=request.getContextPath() %>/emp/empList.jsp" method="post" class="search">
		        		<input type="text" name="name" placeholder="검색어를 입력해주세요">
		        		<button type="submit">검색</button>
		        	</form>
		<%
				} else {
	    %>
		        	<form action="<%=request.getContextPath() %>/emp/empList.jsp" method="post" class="search">
		        		<input type="text" name="name" value="<%=name %>">
		        		<button type="submit">검색</button>
		        	</form>	
	    <%
				}
        %>
        	</div>
			<table class="table">
				<thead>
					<th id="tdNo">사원번호</th>
					<th id="tdName">firstName</th>
					<th id="tdName">lastName</th>
				</thead>
			<%
				for (Employee e : empList) {
			%>
					<tr>
						<td id="tdNo"><%=e.empNo %></td>
						<td id="tdName"><a href=""><%=e.firstName %></a></td>
						<td id="tdName"><%=e.lastName %></td>
					</tr>
			<%
				}
			%>
			</table>

			<div>
				<ul class="pagination pagination-sm justify-content-center">
				<%
					if (name == null) {
				%>
						<li class="page-item">
							<a class="page-link" href="<%=request.getContextPath() %>/emp/empList.jsp?currentPage=1">처음</a>
						</li>
						<%
							if (currentPage > 1) { // 첫번째 페이지가 아닐때에만 출력
						%>	
								<li class="page-item">
									<a class="page-link" href="<%=request.getContextPath() %>/emp/empList.jsp?currentPage=<%=currentPage-1 %>">이전</a>
								</li>
						<% 		
							}
						%>
						<%
							if (currentPage < lastPage) { // 마지막 페이지가 아닐때에만 출력
						%>		
								<li class="page-item">
									<a class="page-link" href="<%=request.getContextPath() %>/emp/empList.jsp?currentPage=<%=currentPage+1 %>">다음</a>
								</li>
						<%
							}
						%>		
						<li class="page-item">
							<a class="page-link" href="<%=request.getContextPath() %>/emp/empList.jsp?currentPage=<%=lastPage %>">마지막</a>
						</li>
				<%
					} else {
				%>
						<li class="page-item">
							<a class="page-link" href="<%=request.getContextPath() %>/emp/empList.jsp?currentPage=1&name=<%=name%>">처음</a>
						</li>
						<%
							if (currentPage > 1) { // 첫번째 페이지가 아닐때에만 출력
						%>	
								<li class="page-item">
									<a class="page-link" href="<%=request.getContextPath() %>/emp/empList.jsp?currentPage=<%=currentPage-1 %>&name=<%=name%>">이전</a>
								</li>
						<% 		
							}
						%>
						<%
							if (currentPage < lastPage) { // 마지막 페이지가 아닐때에만 출력
						%>		
								<li class="page-item">
									<a class="page-link" href="<%=request.getContextPath() %>/emp/empList.jsp?currentPage=<%=currentPage+1 %>&name=<%=name%>">다음</a>
								</li>
						<%
							}
						%>		
						<li class="page-item">
							<a class="page-link" href="<%=request.getContextPath() %>/emp/empList.jsp?currentPage=<%=lastPage %>&name=<%=name%>">마지막</a>
						</li>
				<%
					}
				%>
				</ul>
			</div>
		</div>
	</body>
</html>