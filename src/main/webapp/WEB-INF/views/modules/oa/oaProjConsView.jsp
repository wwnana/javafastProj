<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>项目咨询流程表查看</title>
	<meta name="decorator" content="default"/>
</head>
<body class="gray-bg">
<div class="wrapper-content">
<div class="ibox">
	<div class="ibox-title">
		<h5>项目咨询流程表查看</h5>
	</div>
	<div class="ibox-content">
	<form:form class="form-horizontal">
		<sys:message content="${message}"/>
			<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">流程实例ID：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${oaProjCons.procInsId}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">项目名称：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${oaProjCons.project.name}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
			<div class="col-sm-6">
				<div class="view-group">
					<label class="col-sm-4 control-label">申请用户：</label>
					<div class="col-sm-8">
						<p class="form-control-static">
						${oaProjCons.user.name}
						</p>
					</div>
				</div>
			</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">附件：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								<%-- <form:hidden id="files" path="files" htmlEscape="false" maxlength="2000" />
								<sys:ckfinder readonly="true" input="files" type="files" uploadPath="/file" selectMultiple="true"/>
							 --%> </p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">审批人：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${oaProjCons.audit.name}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">审批意见：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${oaProjCons.auditText}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">更新者：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${oaProjCons.updateBy.id}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">更新时间：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							<fmt:formatDate value="${oaProjCons.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">备注信息：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${oaProjCons.remarks}
							</p>
						</div>
					</div>
				</div>
			</div>
			<act:histoicFlow procInsId="${oaProjCons.act.procInsId}" />
			<div class="form-actions">
				<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
			</div>
		</form:form>
			</div>
		</div>
	</div>
</body>
</html>