<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>在线用户查看</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		
	</script>
</head>
<body class="gray-bg">
<div class="wrapper-content">
	<div class="ibox">
		<div class="ibox-title">
			<h5>当前在线用户(${fn:length(onlineUserList)})</h5>
		</div>
		<div class="ibox-content">
			<div class="table-responsive">
	            <table class="table table-striped table-hover">
	                <tbody>
	                	<c:forEach items="${onlineUserList }" var="user">
	                    <tr>
	                        <td class="client-avatar"><img alt="image" src="${user.photo }"> </td>
	                        <td><a href="#" class="client-link">${user.name }</a>
	                        </td>
							<td>${user.mobile}</td>
							<td>${user.phone}</td>
							<td>${user.company.name}</td>
							<td>${user.office.name}</td>
	                        <td class="client-status"><span class="label label-primary">在线</span>
	                        </td>
	                    </tr>
	                    </c:forEach>
	               	</tbody>
	            </table>
	         </div>
		</div>
	</div>
</div>
</body>
</html>