<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>活动详情查看</title>
	<meta name="decorator" content="default"/>
</head>
<body class="gray-bg">
<div class="wrapper-content">
<div class="ibox">
	<div class="ibox-title">
		<h5>活动详情查看</h5>
	</div>
	<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="crmMarketData" action="${ctx}/crm/crmMarketData/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
			<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">展示标题：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${crmMarketData.title}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">封面图：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							<input type="hidden" id="coverImage" value="${crmMarketData.}"/>
							<sys:ckfinder id="coverImage" type="images" uploadPath="/crm" readonly="true"/>
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">活动内容：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${crmMarketData.content}
							</p>
						</div>
					</div>
				</div>
			</div>
			
			<div class="hr-line-dashed"></div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<div class="col-sm-offset-2 col-sm-10">
							<shiro:hasPermission name="crm:crmMarket:edit">
						    	<a href="${ctx}/crm/crmMarketData/form?id=${crmMarketData.id}" class="btn btn-success" title="修改">修改</a>
							</shiro:hasPermission>
							<shiro:hasPermission name="crm:crmMarket:del">
								<a href="${ctx}/crm/crmMarketData/delete?id=${crmMarketData.id}" onclick="return confirmx('确认要删除该活动详情吗？', this.href)" class="btn btn-danger" title="删除">删除</a> 
							</shiro:hasPermission>
							<a id="btnCancel" class="btn btn-white" onclick="history.go(-1)">返回</a>
						</div>
					</div>
				</div>
			</div>
		</form:form>
	</div>
</div>
</div>
</body>
</html>