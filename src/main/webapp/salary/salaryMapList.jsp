<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %> <!-- HashMap<키, 값>, ArrayList<요소> -->
<%
	// 1) 요청분석
	request.setCharacterEncoding("utf-8");
	String name = request.getParameter("name");
	
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	// 2) 요청처리
	int rowPerPage = 10;
	int beginRow = (rowPerPage * (currentPage - 1));
	
	// db연결 
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/employees";
	String dbUser = "root";
	String dbPw = "dmstj1004";
	Class.forName(driver); // 접근
	// 연결한 db를 저장(모델생성)
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw); //("프로토콜://주소:포트번호", "", "")
	
	// 검색
	String salSql = null;
	String cntSql = null;
	PreparedStatement salStmt = null;
	PreparedStatement cntStmt = null;
	ResultSet salRs = null;
	ResultSet cntRs = null;
	
	if (name == null || name.equals("")) {
		salSql = "SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, CONCAT(e.first_name, ' ', e.last_name) name FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no ORDER BY s.emp_no ASC LIMIT ?, ?";
		salStmt = conn.prepareStatement(salSql);
		salStmt.setInt(1, beginRow);
		salStmt.setInt(2, rowPerPage);
		cntSql = "SELECT COUNT(*) cnt FROM salaries";
		cntStmt = conn.prepareStatement(cntSql);
	} else {
		salSql = "SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, CONCAT(e.first_name, ' ', e.last_name) name FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no WHERE e.first_name LIKE ? OR e.last_name LIKE ? ORDER BY s.emp_no ASC LIMIT ?, ?";
		salStmt = conn.prepareStatement(salSql);
		salStmt.setString(1, "%"+name+"%");
		salStmt.setString(2, "%"+name+"%");
		salStmt.setInt(3, beginRow);
		salStmt.setInt(4, rowPerPage);
		cntSql = "SELECT COUNT(*) cnt FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no WHERE e.first_name LIKE ? OR e.last_name LIKE ?";
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1, "%"+name+"%");
		cntStmt.setString(2, "%"+name+"%");
	}
	
	salRs = salStmt.executeQuery();
	cntRs = cntStmt.executeQuery();

	int cnt = 0;
	if(cntRs.next()) {
		cnt = cntRs.getInt("cnt");
	}
	
	int lastPage = cnt / rowPerPage;
	if (cnt % rowPerPage != 0) {
		lastPage++;
	}
	
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while (salRs.next()) {
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("empNo", salRs.getInt("empNo"));
		m.put("salary", salRs.getInt("salary"));
		m.put("fromDate", salRs.getString("fromDate"));
		m.put("name", salRs.getString("name"));
		list.add(m);
	}
	
	// 저장한 순서 반대로 종료
	salRs.close();
	salStmt.close(); 
	conn.close(); // 연결된 db를 종료
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
	      		background: #f8f9fa;
	      	}
	      	
			.container {
	           	text-align: center;
	           	margin-top: 70px; 
	        }
      	</style>
	</head>
	<body>
		<div>
			<jsp:include page="/inc/menu.jsp"></jsp:include>
   		</div>
   		<div class="container">
   			<div>
           		<h1>연봉 목록</h1>
       		</div>
			<div>
			<%
				if(name == null || name.equals("")) {
			%>
					<form action="<%=request.getContextPath() %>/salary/salaryMapList.jsp" method="post">
						<input type="text" name="name">
						<button type="submit">검색</button>
					</form>
			<%
				} else {
			%>
					<form action="<%=request.getContextPath() %>/salary/salaryMapList.jsp" method="post">
						<input type="text" name="name" value="<%=name %>">
						<button type="submit">검색</button>
					</form>
			<%	
				}
			%>
			</div>
			<table class="table">
				<tr>
					<th>사원번호</th>
					<th>사원이름</th>
					<th>연봉($)</th>
					<th>계약일자</th>
				</tr>
				<%
					for(HashMap<String, Object> m : list) {
				%>
						<tr>
							<td><%=m.get("empNo") %></td>
							<td><%=m.get("name") %></td>
							<td><%=m.get("salary") %></td>
							<td><%=m.get("fromDate") %></td>
						</tr>
				<%
					}
				%>
			</table>
			<div>
			<%
				if (name == null || name.equals("")) {
			%>
						<a href="<%=request.getContextPath() %>/salary/salaryMapList.jsp?currentPage=1">처음</a>
					<%
						if (currentPage > 1) {
					%>
							<a href="<%=request.getContextPath() %>/salary/salaryMapList.jsp?currentPage=<%=currentPage - 1 %>">이전</a>
					<% 
						}
					%>
					<%
						if (currentPage < lastPage) {
					%>
							<a href="<%=request.getContextPath() %>/salary/salaryMapList.jsp?currentPage=<%=currentPage + 1 %>">다음</a>
					<%
						}
					%>
						<a href="<%=request.getContextPath() %>/salary/salaryMapList.jsp?currentPage=<%=lastPage %>">마지막</a>
			<%
				} else {
			%>
						<a href="<%=request.getContextPath() %>/salary/salaryMapList.jsp?currentPage=1&name=<%=name %>">처음</a>
					<%
						if (currentPage > 1) {
					%>
							<a href="<%=request.getContextPath() %>/salary/salaryMapList.jsp?currentPage=<%=currentPage - 1 %>&name=<%=name %>">이전</a>
					<% 
						}
					%>
					<%
						if (currentPage < lastPage) {
					%>
							<a href="<%=request.getContextPath() %>/salary/salaryMapList.jsp?currentPage=<%=currentPage + 1 %>&name=<%=name %>">다음</a>
					<%
						}
					%>
						<a href="<%=request.getContextPath() %>/salary/salaryMapList.jsp?currentPage=<%=lastPage %>&name=<%=name %>">마지막</a>
			<%
				}
			%>
			</div>
		</div>
	</body>
</html>