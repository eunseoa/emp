<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <title>Bootstrap Example</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
  <script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.slim.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<nav class="navbar navbar-expand-sm bg-dark navbar-dark">
	<div class="container-fluid">
		<ul class="navbar-nav">
			<li class="nav-item">
				<a class="nav-link active" href="<%=request.getContextPath()%>/index.jsp">INDEX</a>
			</li>
			<li class="nav-item">
        		<a class="nav-link" href="<%=request.getContextPath()%>/dept/deptList.jsp">부서</a>
      		</li>
      		<li class="nav-item">
       			<a class="nav-link" href="<%=request.getContextPath()%>/board/boardList.jsp">게시판</a>      
     	 	</li>
      		<li class="nav-item">
        		<a class="nav-link" href="<%=request.getContextPath() %>/salary/salaryMapList.jsp">연봉</a>
      		</li>
      		<li class="nav-item dropdown">
	  			<a class="nav-link dropdown-toggle"role="button" data-bs-toggle="dropdown">사원</a>
	 			 <ul class="dropdown-menu">
	    			<li><a class="dropdown-item" href="<%=request.getContextPath()%>/emp/empList.jsp">사원 관리</a></li>
	    			<li><a class="dropdown-item" href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp">부서별 사원</a></li>
	  			</ul>
			</li>
    	</ul>
  	</div>
</nav>
<br>
