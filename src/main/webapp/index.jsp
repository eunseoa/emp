<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>DEPT</title>
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"></script>
		<style>
			 #header {
				text-align: center;
				margin-top:50px;
				box-shadow: 1px 1px 1px 1px gray;
				width: 600px;
				height: 400px;
				border-radius: 20px;
			}
			
			body {
				background: #f5f6f7;
			}
			
			.container {
				background: white;
			}
		</style>
	</head>
	<body>
		<div class="container" id="header">
		<button class="MuiButton-root MuiButton-contained MuiButton-containedPrimary MuiButton-sizeMedium MuiButton-containedSizeMedium MuiButton-fullWidth MuiButtonBase-root  css-in6sf" tabindex="0" type="button">Details<span class="MuiTouchRipple-root css-w0pj6f"></span></button>
			<div>
				<ul class="nav flex-column">
  					<li class="nav-item">
					    <a class="nav-link" href="<%=request.getContextPath()%>/dept/deptList.jsp">부서 관리</a>
					    <a class="nav-link" href="<%=request.getContextPath()%>/emp/empList.jsp">사원 관리</a>
					    <a class="nav-link" href="<%=request.getContextPath()%>/board/boardList.jsp">게시판 관리</a>
					    <a class="nav-link" href="<%=request.getContextPath() %>/salary/salaryMapList.jsp">연봉 관리</a>
					</li>
				</ul>
			</div>
		</div>
	</body>
</html>