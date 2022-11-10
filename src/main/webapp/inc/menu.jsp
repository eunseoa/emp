<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<nav class="navbar bg-light fixed-top">
  <div class="container-fluid">
    <span>INDEX</span>
    <button class="navbar-toggler" type="button" data-bs-toggle="offcanvas" data-bs-target="#offcanvasNavbar" aria-controls="offcanvasNavbar">
    <span class="navbar-toggler-icon"></span>
    </button>
    <div class="offcanvas offcanvas-end" tabindex="-1" id="offcanvasNavbar" aria-labelledby="offcanvasNavbarLabel">
      <div class="offcanvas-header">
        <h5 class="offcanvas-title" id="offcanvasNavbarLabel">INDEX</h5>
        <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
      </div>
      <div class="offcanvas-body">
        <ul class="navbar-nav justify-content-end flex-grow-1">
          <li class="nav-item">
            <a class="nav-link active" href="<%=request.getContextPath()%>/index.jsp">Home</a>
            <a class="nav-link active" href="<%=request.getContextPath()%>/dept/deptList.jsp">부서관리</a>
            <a class="nav-link active" href="<%=request.getContextPath()%>/emp/empList.jsp">사원관리</a>
            <a class="nav-link active" href="<%=request.getContextPath()%>/">연봉관리</a>
          </li>
		</ul>
      </div>
    </div>
  </div>
</nav>