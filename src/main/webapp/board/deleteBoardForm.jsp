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
				height:270px;
				border-radius: 20px;
			}
			
			input[type=password], input:focus{
				width:450px;
				border-right: hidden;
				border-left: hidden;
				border-top: hidden;
				font-align:center;
				outline: none;
			}
			
			table {
				 border-spacing: 10px;
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
		<div>
			<jsp:include page="/inc/menu.jsp"></jsp:include>
   		</div>
		<div class="container" id="header">
			<form action="<%=request.getContextPath() %>/board/deleteBoardAction.jsp" method="post">
				<table class="table table-borderless">
					<tr>
						<th>비밀번호를 입력해주세요</th>
					</tr>
					<tr>
						<td><input type="hidden" name="boardNo" value="<%=boardNo %>"></td>
					</tr>
					<tr>
						<td><input type="password" name="boardPw" placeholder="비밀번호"></td>
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