<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	// 1. 요청분석
	request.setCharacterEncoding("utf-8");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Insert title here</title>
	</head>
	<body>
		<div>
			<form method="post" action="<%=request.getContextPath()%>/board/deleteCommnetAction.jsp">
				<table>
					<tr>
						<th>비밀번호를 입력해주세요</th>
					</tr>
					<tr>
						<td><input type="hidden" name="boardNo" value="<%=boardNo %>"></td>
					</tr>
					<tr>
						<td><input type="hidden" name="commentNo" value="<%=commentNo%>"></td>
					</tr>
					<tr>
						<td><input type="password" name="commnetPw" placeholder="비밀번호"></td>
					</tr>
				</table>
				<%
					if (msg != null) {
				%>
					<div><%=msg %></div>
				<%
					}
				%>
				<br>
				<div class="d-grid" id="button">
					<button type="submit" class="btn btn-outline-secondary btn-block">삭제</button>
				</div>
			</form>
		</div>
	</body>
</html>