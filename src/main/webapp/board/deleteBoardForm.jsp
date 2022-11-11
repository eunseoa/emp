<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	// 1. 요청분석
	request.setCharacterEncoding("utf-8");

	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String msg = request.getParameter("msg"); // 수정 실패시 리다이렉트

		
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Insert title here</title>
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"></script>
	</head>
	<body>
		<div>
		<%
			if (msg != null) {
		%>
			<div><%=msg %></div>
		<%
			}
		%>
			<form action="<%=request.getContextPath() %>/board/deleteBoardAction.jsp" method="post">
				<table class="table table-borderless">
					<div>
						비밀번호를 입력해주세요
					</div>
					<tr>
						<td><input type="hidden" name="boardNo" value="<%=boardNo %>"></td>
					</tr>
					<tr>
						<td>비밀번호</td>
						<td><input type="password" name="boardPw"></td>
					</tr>
				</table>
			
			</form>
		</div>
	</body>
</html>