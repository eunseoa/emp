<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	// 1. 요청분석 (Controller)
	// 할 것 없음
	
	// 2. 업무 처리(Model) -> 모델데이터(단일값 or 자료구조형태(배열, 리스트, ...))
	
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("드라이버로딩 성공"); // 디버깅

	// db에 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "dmstj1004");
	System.out.println(conn + " <-- conn"); // 디버깅
	
	// 접속한 db에 no, name select 쿼리를 만듦
	String sql = "SELECT dept_no deptNo, dept_name deptName FROM departments ORDER BY dept_no ASC"; // as 생략
	
	// 만든 쿼리를 실행
	PreparedStatement stmt = conn.prepareStatement(sql);
	ResultSet rs = stmt.executeQuery(); 
	// 모델데이터 ResultSet은 일반적인 타입X, 독립적인 타입X
	// ResultSet rs라는 모델자료구조를 좀 더 일반적이고 독립적인 자료구조로 변경
	ArrayList<Department> list = new ArrayList<Department>();
	while(rs.next()) { // ResultSet의 API(사용방법)을 모른다면 사용할 수 없는 반복문
		Department d = new Department();
		d.deptNo = rs.getString("deptNo");
		d.deptName = rs.getString("deptName");
		list.add(d);
	}
	
	// 3. 출력(View) -> 모델데이터를 고객이 원하는 형태로 출력 -> 뷰(리포트)
	
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
     	<title>DEPT LIST</title>
      	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet">
      	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"></script>
      	<style>
      		body {
      			background: #f8f9fa
      		}
      	
			#header {
            	text-align: center;
            	margin-top: 100px; 
         	}
         
         	tr, td {
            	height: 50px;
         	}
         
         	a:link, a:visited {
         		color: gray;
         		text-decoration: none;
         	}
         	
         	a:hover, a:active {
         		text-decoration: underline;
         	}
        
      	</style>
	</head>
   	<body>
 		<div>
			<jsp:include page="/inc/menu.jsp"></jsp:include>
   		</div>
		<div class="container" id="header">
			<div>
           	<h1>DEPT LIST</h1>
        </div>
        <div>
        	<ul class="nav justify-content-end">
            	<li class="nav-item">
                	<a class="nav-link" href="<%=request.getContextPath()%>/dept/insertDeptForm.jsp">부서 추가</a>
              	</li>
          	</ul>
		</div>
        <div> 
        	<form action="<%=request.getContextPath() %>/dept/deleteDept.jsp" method="post">
            	<!-- 부서목록출력(부서번호 내림차순으로 출력) -->
            <table class="table">
             	<thead>
					<th>부서 번호</th>
                  	<th>부서 이름</th>
                  	<th>수정</th>
                  	<th>삭제</th>
               	</thead>
             	<tbody>
         <%
                  for (Department d : list) { // 자바문법에서 제공하는 foreach문
         %>         
					<tr>
                    	<td><%=d.deptNo %></td>
                     	<td><%=d.deptName %></td>
                     	<td><a href="<%=request.getContextPath() %>/dept/updateDeptForm.jsp?deptNo=<%=d.deptNo %>">수정</a></td>
                     	<td><a href="<%=request.getContextPath() %>/dept/deleteDept.jsp?deptNo=<%=d.deptNo %>">삭제</a></td>
                  	</tr>
         <%      
                  }
         
         %>
				</tbody>
			</table>
          	</form>
		</div>
		</div>
	</body>
</html>