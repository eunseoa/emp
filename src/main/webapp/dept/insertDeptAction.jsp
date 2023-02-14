<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.URLEncoder"%>
<% 
	//요청 분석
	request.setCharacterEncoding("utf-8");
	String deptNo = request.getParameter("deptNo");
	String deptName = request.getParameter("deptName");

	if (deptNo == null || deptName == null || deptNo.equals("") || deptName.equals("")) {
		String msg = URLEncoder.encode("부서번호와 부서이름을 입력하세요.", "utf-8"); // get방식 주소창에 문자열 인코딩
		response.sendRedirect(request.getContextPath()+"/dept/insertDeptForm.jsp?msg="+msg);
		return;
	} // 바르지않은 경로로 들어왔을시에 처음으로 돌려줌

	// 2
	// 이미 존재하는 key(dept_no, dept_name)값 동일한 값이 입력되면 예외발생 -> 동일한 값이 입력되었을때 예외방지 
	// 업무처리
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	
	//2-1 dept_no 중복검사
	String sql1 = "SELECT * FROM departments WHERE dept_no = ? OR dept_name = ?"; // 입력하기전 같은 dept_no가 존재하는지 묻는 쿼리문
	PreparedStatement stmt1 = conn.prepareStatement(sql1);
	stmt1.setString(1, deptNo);
	stmt1.setString(2, deptName);
	ResultSet rs = stmt1.executeQuery();
	if (rs.next()) { // 결과물 있다 -> 같은 dept_no가 이미 존재한다.
		String msg = URLEncoder.encode("부서번호 또는 부서이름이 중복됩니다.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/dept/insertDeptForm.jsp?msg="+msg);
		return;
	}
	
	// 2-2 입력
	// 부서이름을 새로받을 쿼리문
	String sql2 = "INSERT into departments(dept_no, dept_name) values(?, ?)";
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, deptNo);
	stmt2.setString(2, deptName);
	
	
	int row = stmt2.executeUpdate();
	
	if (row == 1) {
		System.out.println("입력성공");
	} else {
		System.out.println("입력실패");
	} // 디버깅
	
	// 입력받은 값을 list에 추가하고 출력
	response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
%>