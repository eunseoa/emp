<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
	// 1. 요청분석
	int currentPage = 1;
	if (request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// 2
	int rowPerPage = 10;
	int beginRow = (rowPerPage * (currentPage - 1));

	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "dmstj1004");
	
	String sql = "SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, s.to_date toDate, e.first_name firstName, e.last_name lastName FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no ORDER BY s.emp_no ASC limit ?, ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, beginRow);
	stmt.setInt(2, rowPerPage);
	ResultSet rs = stmt.executeQuery();
	ArrayList<Salary> salaryList = new ArrayList<>();
	while(rs.next()) {
		Salary s = new Salary();
		s.emp = new Employee();
		s.emp.empNo = rs.getInt("empNo");
		s.salary = rs.getInt("salary");
		s.fromDate = rs.getString("fromDate");
		s.toDate = rs.getString("toDate");
		s.emp.firstName = rs.getString("firstName");
		s.emp.lastName = rs.getString("lastName");
		salaryList.add(s);
	}
	
	String cntSql = "SELECT COUNT(*) cnt FROM salaries";
	PreparedStatement cntStmt = conn.prepareStatement(cntSql);
	ResultSet cntRs = cntStmt.executeQuery();
	int cnt = 0;
	if(cntRs.next()) {
		cnt = cntRs.getInt("cnt");
	}
	
	int lastPage = cnt / rowPerPage;
	if (cnt % rowPerPage != 0) {
		lastPage++;
	}
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Insert title here</title>
	</head>
	<body>
		<table>
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
		</div>
	</body>
</html>