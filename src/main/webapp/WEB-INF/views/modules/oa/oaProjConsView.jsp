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
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="oaProjCons" action="${ctx}/oa/oaProjCons/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
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
						<label class="col-sm-4 control-label">申请用户名称：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${oaProjCons.userName}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">申请用户部门：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${oaProjCons.officeName}
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
							<form:hidden id="files" path="files" htmlEscape="false" maxlength="2000" />
							<sys:ckfinder readonly="true" input="files" type="files" 
									uploadPath="/file" selectMultiple="true"/>
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">审批人：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${oaProjCons.auditName}
							</p>
						</div>
					</div>
				</div>
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
			</div>
			
			<div class="row">
				<div class="col-sm-6">
						<div class="view-group">
							<label class="col-sm-4 control-label">创建者：</label>
							<div class="col-sm-8">
								<p class="form-control-static">
								${oaProjCons.createByName}
								</p>
							</div>
						</div>
					</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">更新者：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${oaProjCons.updateByName}
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
			
			<div class="hr-line-dashed"></div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<div class="col-sm-offset-2 col-sm-10">
							<%-- <shiro:hasPermission name="oa:oaProjCons:edit">
						    	<a href="${ctx}/oa/oaProjCons/form?id=${oaProjCons.id}" class="btn btn-success" title="修改">修改</a>
							</shiro:hasPermission> --%>
							<shiro:hasPermission name="oa:oaProjCons:del">
								<a href="${ctx}/oa/oaProjCons/delete?id=${oaProjCons.id}" onclick="return confirmx('确认要删除该项目实施流程表吗？', this.href)" class="btn btn-danger" title="删除">删除</a> 
							</shiro:hasPermission>
							<a id="btnCancel" class="btn btn-white" onclick="history.go(-1)">返回</a>
						</div>
					</div>
				</div>
			</div>
			
			<act:histoicFlow procInsId="${oaProjCons.procInsId}"/>
		</form:form>
	</div>
</div>
</div>
</body>
</html>