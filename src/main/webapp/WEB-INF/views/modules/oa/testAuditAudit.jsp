<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>审批管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#name").focus();
			$("#inputForm").validate({
				submitHandler: function(form){
					loading('正在提交，请稍等...');
					form.submit();
				},
				errorContainer: "#messageBox",
				errorPlacement: function(error, element) {
					$("#messageBox").text("输入有误，请先更正。");
					if (element.is(":checkbox")||element.is(":radio")||element.parent().is(".input-append")){
						error.appendTo(element.parent().parent());
					} else {
						error.insertAfter(element);
					}
				}
			});
		});
	</script>
</head>
<body class="gray-bg">
<div class="wrapper-content">
		<div class="ibox">
			<div class="ibox-title">
				<h5>审批流程 </h5>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
					
				
				<form:form id="inputForm" modelAttribute="testAudit" action="${ctx}/oa/testAudit/saveAudit" method="post" class="form-horizontal">
					<form:hidden path="id"/>
					<form:hidden path="act.taskId"/>
					<form:hidden path="act.taskName"/>
					<form:hidden path="act.taskDefKey"/>
					<form:hidden path="act.procInsId"/>
					<form:hidden path="act.procDefId"/>
					<form:hidden id="flag" path="act.flag"/>
					<sys:message content="${message}"/>
					<h4 class="page-header">申请信息</h4>
						<div class="row">
							<div class="col-sm-6">
								<div class="view-group">
									<label class="col-sm-4 control-label">姓名：</label>
									<div class="col-sm-8">
										<p class="form-control-static">
										${testAudit.user.name}
										</p>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-6">
								<div class="view-group">
									<label class="col-sm-4 control-label">部门：</label>
									<div class="col-sm-8">
										<p class="form-control-static">
										${testAudit.office.name}
										</p>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-6">
								<div class="view-group">
									<label class="col-sm-4 control-label">岗位：</label>
									<div class="col-sm-8">
										<p class="form-control-static">
										${testAudit.post}
										</p>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-6">
								<div class="view-group">
									<label class="col-sm-4 control-label">申请事由：</label>
									<div class="col-sm-8">
										<p class="form-control-static">
										${testAudit.content}
										</p>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-6">
								<div class="view-group">
									<label class="col-sm-4 control-label"><font color="red">*</font> 您的意见：</label>
									<div class="col-sm-8">
										<p class="form-control-static">
										<form:textarea path="act.comment" class="form-control required" rows="5" maxlength="20" cssClass="form-control"/>
										</p>
									</div>
								</div>
							</div>
						</div>
						
						
						<div class="hr-line-dashed"></div>
					<div class="form-actions">
						<shiro:hasPermission name="oa:testAudit:edit">
							<c:if test="${testAudit.act.taskDefKey eq 'apply_end'}">
								<input id="btnSubmit" class="btn btn-success" type="submit" value="兑 现" onclick="$('#flag').val('yes')"/>&nbsp;
							</c:if>
							<c:if test="${testAudit.act.taskDefKey ne 'apply_end'}">
								<input id="btnSubmit" class="btn btn-success" type="submit" value="同 意" onclick="$('#flag').val('yes')"/>&nbsp;
								<input id="btnSubmit" class="btn btn-inverse" type="submit" value="驳 回" onclick="$('#flag').val('no')"/>&nbsp;
							</c:if>
						</shiro:hasPermission>
						<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
					</div>
					<act:histoicFlow procInsId="${testAudit.act.procInsId}"/>
				</form:form>
				<br/>
			</div>
		</div>
	</div>
</body>
</html>
