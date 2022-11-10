<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
			
			.container {
				background: white;
			}
			
			#header {
				text-align: center;
				margin-top: 100px;
				box-shadow: 1px 1px 1px 1px gray;
				width: 600px;
				height:400px;
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
				 border-spacing: 40px;
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
		<!-- msg 파라메타값이 있으면 출력 -->
			<form action="<%=request.getContextPath()%>/dept/insertDeptAction.jsp" method="post">
				<table class="table table-borderless">
					<tr>
						<th>추가할 부서 정보를 입력해주세요.</th>
					</tr>
					<tr>
						<td>
							<input type="text" name="deptNo" placeholder="부서번호">
						</td>
					</tr>
					<tr>
						<td>
							<input type="text" name="deptName" placeholder="부서이름">
						</td>
					</tr>
				</table>
						<%
			if (request.getParameter("msg") != null) {
		%>
			<div><%=request.getParameter("msg") %></div>
		<%	
				
			}
		%>
				<div class="d-grid" id="button">
					<button type="submit" class="btn btn-outline-secondary btn-block">추가</button>
				</div>
			</form>
			<br>
		</div>
	</body>
</html>