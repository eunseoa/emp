<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*" %>
<%@ page import = "java.net.URLEncoder"%>
<%
	// 수정 요청 분석
	request.setCharacterEncoding("utf-8");
	String deptNo = request.getParameter("deptNo");
	String deptName = request.getParameter("deptName");
	
	if (deptNo == null || deptName == null || deptNo.equals("") || deptName.equals("")) {
		response.sendRedirect(request.getContextPath()+"/dept/updateDeptForm.jsp");
		return;
	} // 바르지않은 경로로 들어왔을시에 처음으로 돌려줌
	
	
	Department dept = new Department();
	dept.deptNo = deptNo;
	dept.deptName = deptName;
	
	// 업무처리
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	
	// dept_name 중복검사
	String sql1 = "SELECT dept_name FROM departments WHERE dept_name = ?"; // 입력하기전 같은 dept_name이 존재하는지 묻는 쿼리문
	PreparedStatement stmt1 = conn.prepareStatement(sql1);
	stmt1.setString(1, deptNo);
	stmt1.setString(2, deptName);
	ResultSet rs = stmt1.executeQuery();
	if (rs.next()) { // 결과물 있다 -> 같은 dept_name이 이미 존재한다.
		String msg = URLEncoder.encode(deptName+"는 사용할 수 없습니다.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/dept/updateDeptForm.jsp?msg="+msg);
		return;
	}
	
	// 부서이름 수정할 쿼리문
	String sql2 = "UPDATE departments SET dept_name=? WHERE dept_no=?";
	PreparedStatement stmt2 = conn.prepareStatement(sql2);

	// 수정할 이름을 받음
	stmt2.setString(1, deptName);
	stmt2.setString(2, deptNo);
	System.out.println(deptNo); // 디버깅
	System.out.println(deptName); // 디버깅
	
	int row = stmt2.executeUpdate();
	
	// 디버깅

	if (row == 1) {
		System.out.println("수정성공");
	} else {
		System.out.println("수정실패");

	}
	// 수정하고 list로 돌아감
	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
	
%>