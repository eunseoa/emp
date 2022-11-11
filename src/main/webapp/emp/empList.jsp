<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.util.*" %>
<%
	// 1
	// 페이지 알고리즘
	int currentPage = 1; // 현재페이지 초기화 첫페이지는 무조건 1
	if (request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	int rowPerPage = 10; // 한페이지당 볼 사원정보담긴 열 개수
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "dmstj1004");
	
	// lastPage 구하기
	String countSql="SELECT COUNT(*) FROM employees";
	PreparedStatement countStmt = conn.prepareStatement(countSql);
	ResultSet countRs = countStmt.executeQuery();
	
	// if문을 이용한 사원정보의 개수 구하기
	int count = 0;
	if (countRs.next()) {
		count = countRs.getInt("COUNT(*)");
	}
	
	// 사원정보 총개수와 한페이지에 나올 열을 나눈 나머지가 0이 아닐때 lastPage + 1을 해줌
	int lastPage = count / rowPerPage;
	if (count % rowPerPage != 0) { // 
		lastPage++;
	}
	
	// 한페이지당 출력할 emp 목록
	String empSql = "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees ORDER BY emp_no ASC LIMIT ?, ?";
	PreparedStatement empStmt = conn.prepareStatement(empSql);
	empStmt.setInt(1, rowPerPage * (currentPage - 1)); // 한페이지의 열 개수 * (현재페이지 - 1)
	empStmt.setInt(2, rowPerPage); // 한페이지 당 볼 사원정보담긴 열 개수
	ResultSet empRs = empStmt.executeQuery();
	
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
      	</style>
	</head>
	<body>
		<div>
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>
		<div class="container" id="header">
			<h1>사원목록</h1>
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
				</ul>
			</div>
		</div>
	</body>
</html>