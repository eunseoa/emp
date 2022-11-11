<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
				width: 1000px;
				height:700px;
				border-radius: 20px;
			}
					
			input[type=text],  input:focus {
				width: 100%;
				border : hidden;
				outline: none;
			}
					
			#button, h3 {
				text-align: center;
				width: 90%;
				margin-left:auto; 
    			margin-right:auto;
			}
			
			textarea {
			    width: 100%;
			    height: 380px;
			    border: none;
			    resize: none;
			  }
		</style>
	</head>
	<body>
		<div>
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>
		<div class="container" id="header">
			<form action="<%=request.getContextPath() %>/board/insertBoardAction.jsp"> 
				<table class="table table-borderless">
					<tr>
						<th><h3><br>글쓰기</h3></th>
					</tr>
					<tr>
						<td>
							<input type="text" name="boardWrite" placeholder="작성자">
						</td>
					</tr>
					<tr>
						<td>
							<input type="text" name="boardPw" placeholder="비밀번호">
						</td>
					</tr>
					<tr>
						<td>
							<input type="text" name="boardTitle" placeholder="제목">
						</td>
					</tr>
					<tr>
						<td>
							<textarea cols="100" rows="15" name="boardContent"></textarea>
						</td>
					</tr>
				</table>
				<div class="d-grid" id="button">
					<button type="submit" class="btn btn-outline-secondary btn-block">작성</button>
				</div>
			</form>
		</div>
	</body>
</html>