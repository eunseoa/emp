<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*" %>
<%
	// 요청분석
	request.setCharacterEncoding("utf-8");
	String name = request.getParameter("name");
	int currentPage = 1;
	if (request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	// 요청 처리
	int rowPerPage = 10;
	int beginRow = (rowPerPage * (currentPage - 1));
	
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/employees";
	String dbUser = "root";
	String dbPw = "dmstj1004";
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	String empSql = null;
	String cntSql = null;
	PreparedStatement empStmt = null;
	PreparedStatement cntStmt = null;
	ResultSet empRs = null;
	ResultSet cntRs = null;
	
	if (name == null || name.equals("") ) {
		empSql = "SELECT de.emp_no empNo, CONCAT(e.first_name, ' ', e.last_name) name, d.dept_name deptName, de.from_date fromDate, de.to_date toDate FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no LIMIT ?, ?";
		empStmt = conn.prepareStatement(empSql);
		empStmt.setInt(1, beginRow);
		empStmt.setInt(2, rowPerPage);
		cntSql = "SELECT COUNT(*) cnt FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no";
		cntStmt = conn.prepareStatement(cntSql);
	} else {
		empSql = "SELECT de.emp_no empNo, CONCAT(e.first_name, ' ', e.last_name) name, d.dept_name deptName, de.from_date fromDate, de.to_date toDate FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no WHERE e.first_name LIKE ? OR e.last_name LIKE ? LIMIT ?, ?";
		empStmt = conn.prepareStatement(empSql);
		empStmt.setString(1, "%"+name+"%");
		empStmt.setString(2, "%"+name+"%");
		empStmt.setInt(3, beginRow);
		empStmt.setInt(4, rowPerPage);
		cntSql = "SELECT COUNT(*) cnt FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no WHERE e.first_name LIKE ? OR e.last_name LIKE ?";
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1, "%"+name+"%");
		cntStmt.setString(2, "%"+name+"%");
	}
	
	empRs = empStmt.executeQuery();
	cntRs = cntStmt.executeQuery();
	
	int cnt = 0;
	if (cntRs.next()) {
		cnt = cntRs.getInt("cnt");
	}
	int lastPage = cnt / rowPerPage;
	if (cnt % rowPerPage != 0) {
		lastPage++;
	}
	
	ArrayList<DeptEmp> list = new ArrayList<DeptEmp>();
	while(empRs.next()) {
		DeptEmp de = new DeptEmp();
		de.emp = new Employee();
		de.emp.empNo = empRs.getInt("empNo");
		de.emp.firstName = empRs.getString("name");
		de.dept = new Department();
		de.dept.deptName = empRs.getString("deptName");
		de.fromDate = empRs.getString("fromDate");
		de.toDate = empRs.getString("toDate");
		list.add(de);
	}
	
	// 저장한 순서 반대로 종료
	empRs.close();
	empStmt.close(); 
	conn.close();
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
   				<h1>DEPT EMP LIST</h1>
   			</div>
   			<div>
			<%
				if (name == null || name.equals("")) {
			%>
					<form action="<%=request.getContextPath() %>/deptEmp/deptEmpList.jsp" method="post">
						<input type="text" name="name">
						<button type="submit">검색</button>
					</form>
			<%
				} else {
			%>
					<form action="<%=request.getContextPath() %>/deptEmp/deptEmpList.jsp" method="post">
						<input type="text" name="name" value="<%=name %>"> 
						<button type="submit">검색</button>
					</form>
			<%
				}
			%>
		</div>
   			<div>
				<table class="table">
					<tr>
						<th>사원번호</th>
						<th>사원이름</th>
						<th>부서이름</th>
						<th>입사일자</th>
						<th>퇴사일자</th>
					</tr>
					<%
						for(DeptEmp de : list) {
					%>
							<tr>
								<td><%=de.emp.empNo %></td>
								<td><%=de.emp.firstName %></td>
								<td><%=de.dept.deptName %></td>
								<td><%=de.fromDate %></td>
								<td><%=de.toDate %></td>
							</tr>
					<%
						}
					%>
				</table>
				<div>
				<%
					if (name == null || name.equals("")) {
				%>
						<a href="<%=request.getContextPath() %>/deptEmp/deptEmpList.jsp?currentPage=1">처음</a>
					<%
						if (currentPage > 1) {
					%>
							<a href="<%=request.getContextPath() %>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage - 1 %>">이전</a>
					<%
						}
					%>
					<%
						if (currentPage < lastPage) {
					%>
							<a href="<%=request.getContextPath() %>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage + 1 %>">다음</a>
					<%
						}
					%>
						<a href="<%=request.getContextPath() %>/deptEmp/deptEmpList.jsp?currentPage=<%=lastPage %>">마지막</a>
				<%
					} else {
				%>
						<a href="<%=request.getContextPath() %>/deptEmp/deptEmpList.jsp?currentPage=1&name=<%=name %>">처음</a>
					<%
						if (currentPage > 1) {
					%>
							<a href="<%=request.getContextPath() %>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage - 1 %>&name=<%=name %>">이전</a>
					<%
						}
					%>
					<%
						if (currentPage < lastPage) {
					%>
							<a href="<%=request.getContextPath() %>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage + 1 %>&name=<%=name %>">다음</a>
					<%
						}
					%>
						<a href="<%=request.getContextPath() %>/deptEmp/deptEmpList.jsp?currentPage=<%=lastPage %>&name=<%=name %>">마지막</a>
				<%
					}
				%>
				</div>
			</div>
		</div>
	</body>
</html>