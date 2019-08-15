<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>指令回调消息查看</title>
	<meta name="decorator" content="default"/>
</head>
<body class="gray-bg">
<div class="wrapper-content">
<div class="ibox">
	<div class="ibox-title">
		<h5>指令回调消息查看</h5>
	</div>
	<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="qwsSuiteNotice" action="${ctx}/qws/qwsSuiteNotice/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
			<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-12">
					<div class="view-group">
						<label class="col-sm-2 control-label">请求URL：</label>
						<div class="col-sm-10">
							<p class="form-control-static">
							${qwsSuiteNotice.requestUrl}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="view-group">
						<label class="col-sm-2 control-label">消息主体：</label>
						<div class="col-sm-10">
							<p class="form-control-static">
							${qwsSuiteNotice.requestBody}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">消息签名：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${qwsSuiteNotice.msgSignature}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">时间戳：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${qwsSuiteNotice.timestamp}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">随机数：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${qwsSuiteNotice.nonce}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">加密字符串：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${qwsSuiteNotice.echostr}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">第三方应用的SuiteId：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${qwsSuiteNotice.suiteId}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">消息类型：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${qwsSuiteNotice.infoType}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">suite_ticket：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${qwsSuiteNotice.suiteTicket}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">临时授权码：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${qwsSuiteNotice.authCode}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">授权方的corpid：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${qwsSuiteNotice.authCorpId}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">通讯录变更类型：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${qwsSuiteNotice.changeType}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">成员ID：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${qwsSuiteNotice.user.name}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">部门ID：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${qwsSuiteNotice.partyId}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">处理状态：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${fns:getDictLabel(qwsSuiteNotice.status, 'yes_no', '')}
							</p>
						</div>
					</div>
				</div>
			</div>
			
			<div class="hr-line-dashed"></div>
			<div class="form-actions">
				<shiro:hasPermission name="qws:qwsSuiteNotice:edit">
			    	<a href="${ctx}/qws/qwsSuiteNotice/form?id=${qwsSuiteNotice.id}" class="btn btn-success" title="修改"><i class="fa fa-pencil"></i> 修改</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="qws:qwsSuiteNotice:del">
					<a href="${ctx}/qws/qwsSuiteNotice/delete?id=${qwsSuiteNotice.id}" onclick="return confirmx('确认要删除该指令回调消息吗？', this.href)" class="btn btn-danger" title="删除"><i class="fa fa-trash"></i> 删除</a> 
				</shiro:hasPermission>
				<a id="btnCancel" class="btn btn-white" onclick="history.go(-1)"><i class="fa fa-reply"></i> 返回</a>
			</div>
		</form:form>
	</div>
</div>
</div>
</body>
</html>