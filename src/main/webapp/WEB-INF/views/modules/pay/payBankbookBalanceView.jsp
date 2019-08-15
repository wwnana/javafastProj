<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>电子钱包余额查看</title>
	<meta name="decorator" content="default"/>
</head>
<body class="hideScroll">
	<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="payBankbookBalance" action="${ctx}/pay/payBankbookBalance/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
			<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">余额：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${payBankbookBalance.balance}
							</p>
						</div>
					</div>
				</div>
			</div>
			
		</form:form>
	</div>
</body>
</html>