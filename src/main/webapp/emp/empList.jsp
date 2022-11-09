<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.util.*" %>
<%
	// 1
	// 페이지 알고리즘
	int currentPage = 1; // 첫페이지는 무조건 1
	if (request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	int rowPerPage = 10; // 한페이장 볼 정보의 개수
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "dmstj1004");
	
	// lastPage 구하기
	String countSql="SELECT COUNT(*) FROM employees";
	PreparedStatement countStmt = conn.prepareStatement(countSql);
	ResultSet countRs = countStmt.executeQuery();
	int count = 0;
	
	if (countRs.next()) {
		count = countRs.getInt("COUNT(*)");
	}
	
	int lastPage = count / rowPerPage;
	if (count % rowPerPage != 0) { // 
		lastPage++;
	}
	
	// 한페이지당 출력할 emp 목록
	String empSql = "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees ORDER BY emp_no ASC LIMIT ?, ?";
	PreparedStatement empStmt = conn.prepareStatement(empSql);
	empStmt.setInt(1, rowPerPage * (currentPage - 1));
	empStmt.setInt(2, rowPerPage);
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
	</head>
	<body>
		<h1>사원목록</h1>
		<table>
			<tr>
				<th>사원번호</th>
				<th>firstName</th>
				<th>lastName</th>
			</tr>
		<%
			for (Employee e : empList) {
		%>
				<tr>
					<td><%=e.empNo %></td>
					<td><a href=""><%=e.firstName %></a></td>
					<td><%=e.lastName %></td>
				</tr>
		<%
			}
		%>
		</table>
		<div>
			현재 페이지 : <%=currentPage %>
		</div>
		<div>
			<a href="<%=request.getContextPath() %>/emp/empList.jsp?currentPage=1">처음</a>
		<%
			if (currentPage > 1) { // 첫번째 페이지가 아닐때에만 출력
		%>	
				<a href="<%=request.getContextPath() %>/emp/empList.jsp?currentPage=<%=currentPage-1 %>">이전</a>
		<% 		
			}
		%>
		<%
			if (currentPage < lastPage) { // 마지막 페이지가 아닐때에만 출력
		%>
				<a href="<%=request.getContextPath() %>/emp/empList.jsp?currentPage=<%=currentPage+1 %>">다음</a>
		<%
			}
		%>
			<a href="<%=request.getContextPath() %>/emp/empList.jsp?currentPage=<%=lastPage %>">마지막</a>
		</div>
	</body>
</html>