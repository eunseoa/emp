<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	// 요청분석
	request.setCharacterEncoding("utf-8");
	String deptNo = request.getParameter("deptNo");
	if (deptNo == null ) { // 올바르지않은 경로로 들어오거나 주소창에 직접호출하면 deptNo은 null값이 됨
		response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
		return;
	}
	
	// 업무 처리
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "dmstj1004");
	
	// 부서이름 수정할 쿼리
	String sql = "SELECT dept_name deptName FROM departments WHERE dept_no=?";
	
	// 수정 쿼리 실행
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, deptNo);
	ResultSet rs = stmt.executeQuery();
	
	Department dept = null;

	if (rs.next()) {
		dept = new Department();
		dept.deptNo = deptNo;
		dept.deptName = rs.getString("deptName");
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
				background: #f5f6f7;
			}
			
			.container {
				background: white;
			}
			
			#header {
				text-align: center;
				margin-top: 100px;
				box-shadow: 1px 1px 1px 1px gray;
				width: 600px;
				height: 400px;
				border-radius: 20px;
			}
			
			
			input[type=text] {
				width:450px;
				border-right: hidden;
				border-left: hidden;
				border-top: hidden;
				font-align:center;
			}
			
			input:focus {
				outline: none;
			}
			
			table {
				 border-spacing: 10px;
				 border-collapse: separate;
			}
			
			#button {
				text-align: center;
				width: 460px;
				margin-left:auto; 
    			margin-right:auto;
			}
		</style>
	</head>
	<body>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
		<div class="container" id="header">
			<form method="post" action="<%=request.getContextPath() %>/dept/updateDeptAction.jsp">
				<table class="table table-borderless">
					<tr>
						<th>부서정보를 수정해주세요.</th>
					</tr>
					<tr><td>부서번호</td></tr>
					<tr>
						<td>
							<input type="text" name="deptNo" value="<%=dept.deptNo%>" readonly="readonly">
					</tr>
					<tr>
					<tr><td>부서이름</td></tr>
					<tr>
						<td>
							<input type="text" name="deptName" value="<%=dept.deptName%>">
						</td>
					</tr>
					<tr>
				</table>
				<div class="d-grid" id="button">
					<button type="submit" class="btn btn-outline-secondary btn-block">수정</button>
				</div>
			</form>
			<br>
		</div>
	</body>
</html>