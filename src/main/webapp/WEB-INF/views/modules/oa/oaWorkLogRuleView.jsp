<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>汇报规则查看</title>
	<meta name="decorator" content="default"/>
</head>
<body class="hideScroll">
	<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="oaWorkLogRule" action="${ctx}/oa/oaWorkLogRule/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
			<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">查阅人：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${oaWorkLogRule.user.name}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">排序：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${oaWorkLogRule.sort}
							</p>
						</div>
					</div>
				</div>
			</div>
			
		</form:form>
	</div>
</body>
</html>