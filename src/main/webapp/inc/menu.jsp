<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
	.nav-link:hover, .nav-link:active {
		text-decoration: underline;
	}
	
	
	.nav-link:link, .nav-link:visited {
  		color: #5D5D5D;
		}
    
</style>
<!--  partilal jsp 페이지 사용할 코드 -->


<ul class="nav justify-content-center">
  <li class="nav-item">
    <a class="nav-link" href="<%=request.getContextPath()%>/index.jsp">홈으로</a>
  </li>
  <li class="nav-item">
    <a class="nav-link" href="<%=request.getContextPath()%>/dept/deptList.jsp">부서관리</a>
  </li>
  <li class="nav-item">
    <a class="nav-link" href="<%=request.getContextPath()%>/emp/emplist.jsp">사원관리</a>
  </li>
  <li class="nav-item">
    <a class="nav-link" href="<%=request.getContextPath()%>/">연봉관리</a>
  </li>
</ul>