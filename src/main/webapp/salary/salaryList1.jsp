<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
	// 1. 요청분석
	request.setCharacterEncoding("utf-8");
	String name = request.getParameter("name");
	int currentPage = 1;
	if (request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// 2
	int rowPerPage = 10;
	int beginRow = (rowPerPage * (currentPage - 1));

	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "dmstj1004");
	
	// 검색
	String salSql = null;
	String cntSql = null;
	ResultSet salRs = null;
	ResultSet cntRs = null;
	PreparedStatement salStmt = null;
	PreparedStatement cntStmt = null;
	
	if(name == null) {
		salSql = "SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, s.to_date toDate, e.first_name firstName, e.last_name lastName FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no ORDER BY s.emp_no ASC limit ?, ?";
		salStmt = conn.prepareStatement(salSql);
		salStmt.setInt(1, beginRow);
		salStmt.setInt(2, rowPerPage);
		cntSql = "SELECT COUNT(*) cnt FROM salaries";
	} else {

	}
	
	
	
	cntStmt = conn.prepareStatement(cntSql);
	cntRs = cntStmt.executeQuery();
	int cnt = 0;
	if(cntRs.next()) {
		cnt = cntRs.getInt("cnt");
	}
	
	int lastPage = cnt / rowPerPage;
	if (cnt % rowPerPage != 0) {
		lastPage++;
	}
	
	salRs = salStmt.executeQuery();
	ArrayList<Salary> salaryList = new ArrayList<>();
	while(salRs.next()) {
		Salary s = new Salary();
		s.emp = new Employee();
		s.emp.empNo = salRs.getInt("empNo");
		s.salary = salRs.getInt("salary");
		s.fromDate = salRs.getString("fromDate");
		s.toDate = salRs.getString("toDate");
		s.emp.firstName = salRs.getString("firstName");
		s.emp.lastName = salRs.getString("lastName");
		salaryList.add(s);
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
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>
		<div class="container" >
		<h1>연봉내역</h1>
		<div>
		<%
			if(name == null) {
		%>
				<form action="<%=request.getContextPath() %>/salary/salaryList1.jsp" method="post">
					<input type="text" name="name">
					<button type="submit">검색</button>
				</form>
		<%
			} else {
		%>
				<form action="<%=request.getContextPath() %>/salary/salaryList1.jsp" method="post">
					<input type="text" name="name" value="<%=name %>">
					<button type="submit">검색</button>
				</form>
		<%
			}
		%>
		</div>
			<table class="table">
				<tr>
					<td>사원번호</td>
					<td>연봉($)</td>
					<td>입사일자</td>
					<td>협상일자</td>
					<td>firstName</td>
					<td>lastName</td>
				</tr>
				<%
					for(Salary s : salaryList) {
				%>
						<tr>
							<td><%=s.emp.empNo %></td>
							<td><%=s.salary %></td>
							<td><%=s.fromDate %></td>
							<td><%=s.toDate %></td>
							<td><%=s.emp.firstName %></td>
							<td><%=s.emp.lastName %></td>
						</tr>
				<%
					}
				%>
			</table>
			<div>
			<%
				if (name == null) {
			%>
					<a href="<%=request.getContextPath() %>/salary/salaryList1.jsp?currentPage=1">처음</a>
				<%
					if (currentPage > 1) {
				%>
						<a href="<%=request.getContextPath() %>/salary/salaryList1.jsp?currentPage=<%=currentPage-1 %>">이전</a>
				<%
					}
				%>
				<%
					if (currentPage < lastPage) {
				%>
						<a href="<%=request.getContextPath() %>/salary/salaryList1.jsp?currentPage=<%=currentPage+1 %>">다음</a>
				<%
					}
				%>
					<a href="<%=request.getContextPath() %>/salary/salaryList1.jsp?currentPage=<%=lastPage %>">마지막</a>
			<%
				} else {
			%>
					<a href="<%=request.getContextPath() %>/salary/salaryList1.jsp?currentPage=1>&name=<%=name%>">처음</a>
				<%
					if (currentPage > 1) {
				%>
						<a href="<%=request.getContextPath() %>/salary/salaryList1.jsp?currentPage=<%=currentPage-1 %>>&name=<%=name%>">이전</a>
				<%
					}
				%>
				<%
					if (currentPage < lastPage) {
				%>
						<a href="<%=request.getContextPath() %>/salary/salaryList1.jsp?currentPage=<%=currentPage+1 %>>&name=<%=name%>">다음</a>
				<%
					}
				%>
					<a href="<%=request.getContextPath() %>/salary/salaryList1.jsp?currentPage=<%=lastPage %>>&name=<%=name%>">마지막</a>
			<%
				}
			%>
			</div>
		</div>
	</body>
</html>