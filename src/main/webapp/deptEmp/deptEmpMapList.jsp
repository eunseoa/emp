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
	
	// 요청처리
	int rowPerPage = 10;
	int begintRow = (rowPerPage * (currentPage - 1));
	
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/employees";
	String dbUser = "root";
	String dbPw = "dmstj1004";
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	String mapSql = null;
	String cntSql = null;
	PreparedStatement mapStmt = null;
	PreparedStatement cntStmt = null;
	ResultSet mapRs = null;
	ResultSet cntRs = null;
	
	if (name == null || name.equals("")) {
		mapSql = "SELECT de.emp_no empNo, CONCAT(e.first_name, ' ', e.last_name) name, d.dept_name deptName, de.from_date fromDate, de.to_date toDate FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no LIMIT ?, ?";
		mapStmt = conn.prepareStatement(mapSql);
		mapStmt.setInt(1, begintRow);
		mapStmt.setInt(2, rowPerPage);
		cntSql = "SELECT COUNT(*) cnt FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no";
		cntStmt = conn.prepareStatement(cntSql);
	} else {
		mapSql = "SELECT de.emp_no empNo, CONCAT(e.first_name, ' ', e.last_name) name, d.dept_name deptName, de.from_date fromDate, de.to_date toDate FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no WHERE e.first_name LIKE ? OR e.last_name LIKE ? LIMIT ?, ?";
		mapStmt = conn.prepareStatement(mapSql);
		mapStmt.setString(1, "%"+name+"%");
		mapStmt.setString(2, "%"+name+"%");
		mapStmt.setInt(3, begintRow);
		mapStmt.setInt(4, rowPerPage);
		cntSql = "SELECT COUNT(*) cnt FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no WHERE e.first_name LIKE ? OR e.last_name LIKE ?";
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1, "%"+name+"%");
		cntStmt.setString(2, "%"+name+"%");
	}
	
	
	mapRs = mapStmt.executeQuery();
	cntRs = cntStmt.executeQuery();
	int cnt = 0;
	if(cntRs.next()) {
		cnt = cntRs.getInt("cnt");
	}
	int lastPage = cnt / rowPerPage;
	if (cnt % rowPerPage != 0) {
		lastPage++;
	}
	
	ArrayList<HashMap<String, Object>> mapList = new ArrayList<HashMap<String, Object>>();
	while(mapRs.next()) {
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("empNo", mapRs.getInt("empNo"));
		m.put("name", mapRs.getString("name"));
		m.put("deptName", mapRs.getString("deptName"));
		m.put("fromDate", mapRs.getString("fromDate"));
		m.put("toDate", mapRs.getString("toDate"));
		mapList.add(m);
	}
	
	// 저장한 순서 반대로 종료
	mapRs.close();
	mapStmt.close(); 
	conn.close();
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Insert title here</title>
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
		<%
			if (name == null || name.equals("")) {
		%>
				<form action="<%=request.getContextPath() %>/deptEmp/deptEmpMapList.jsp" method="post">
					<input type="text" name="name">
					<button type="submit">검색</button>
				</form>
		<%
			} else {
		%>
				<form action="<%=request.getContextPath() %>/deptEmp/deptEmpMapList.jsp" method="post">
					<input type="text" name="name">
					<button type="submit">검색</button>
				</form>
		<%
			}
		%>
		</div>
		<table>
			<tr>
				<th>사원번호</th>
				<th>사원이름</th>
				<th>부서이름</th>
				<th>입사일자</th>
				<th>퇴사일자</th>
			</tr>
			<%
				for(HashMap<String, Object> m : mapList) {
			%>
					<tr>
						<td><%=m.get("empNo") %></td>
						<td><%=m.get("name") %></td>
						<td><%=m.get("deptName") %></td>
						<td><%=m.get("fromDate") %></td>
						<td><%=m.get("toDate") %></td>
					</tr>
			<%
				}
			%>
		</table>
		<div>
		<%
			if (name == null || name.equals("")) {
		%>
					<a href="<%=request.getContextPath() %>/deptEmp/deptEmpMapList.jsp?currentPage=1">처음</a>
				<%
					if (currentPage > 1) {
				%>
						<a href="<%=request.getContextPath() %>/deptEmp/deptEmpMapList.jsp?currentPage=<%=currentPage - 1 %>">이전</a>
				<%
					}
				%>
				<%
					if (currentPage < lastPage) {
				%>
						<a href="<%=request.getContextPath() %>/deptEmp/deptEmpMapList.jsp?currentPage=<%=currentPage + 1 %>">다음</a>
				<%
					}
				%>
					<a href="<%=request.getContextPath() %>/deptEmp/deptEmpMapList.jsp?currentPage=<%=lastPage %>">마지막</a>
		<%
			} else {
		%>
					<a href="<%=request.getContextPath() %>/deptEmp/deptEmpMapList.jsp?currentPage=1&name=<%=name %>">처음</a>
				<%
					if (currentPage > 1) {
				%>
						<a href="<%=request.getContextPath() %>/deptEmp/deptEmpMapList.jsp?currentPage=<%=currentPage - 1 %>&name=<%=name %>">이전</a>
				<%
					}
				%>
				<%
					if (currentPage < lastPage) {
				%>
						<a href="<%=request.getContextPath() %>/deptEmp/deptEmpMapList.jsp?currentPage=<%=currentPage + 1 %>&name=<%=name %>">다음</a>
				<%
					}
				%>
					<a href="<%=request.getContextPath() %>/deptEmp/deptEmpMapList.jsp?currentPage=<%=lastPage %>&name=<%=name %>">마지막</a>
		<%
			}
		%>
		</div>
	</body>
</html>