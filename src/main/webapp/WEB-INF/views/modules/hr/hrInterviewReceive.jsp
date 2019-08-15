<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>面试通知反馈</title>
	<meta name="decorator" content="default"/>
	<style type="text/css">
	.ibox-content{ 
		width: 500px;	
		height:350px;
		margin: 10% auto 0 auto;
	}
	.text-center{
		text-align:center;
		margin-top: 20%;
	}
	</style>
</head>
<body class="gray-bg">
<div class="wrapper-content">
<div class="">
	<div class="ibox-content">
		<div class="text-center">
			<c:if test="${status == 2}">
				<button class="btn btn-success btn-circle btn-lg" type="button">
					<i class="fa fa-check"></i>
	            </button>
	            <br><br>
	            <h3>您已接受面试</h3>
            </c:if>
            <c:if test="${status == 3}">
				<button class="btn btn-danger btn-circle btn-lg" type="button">
					<i class="fa fa-check"></i>
	            </button>
	            <br><br>
	            <h3>您已拒绝面试</h3>
            </c:if>
        </div>
	</div>
</div>
</div>
</body>
</html>