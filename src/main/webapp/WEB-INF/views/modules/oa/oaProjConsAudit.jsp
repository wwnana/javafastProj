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
					
				
				<form:form id="inputForm" modelAttribute="oaProjCons" action="${ctx}/oa/oaProjCons/saveAudit" method="post" class="form-horizontal">
					<form:hidden path="id"/>
					<form:hidden path="act.taskId"/>
					<form:hidden path="act.taskName"/>
					<form:hidden path="act.taskDefKey"/>
					<form:hidden path="act.procInsId"/>
					<form:hidden path="act.procDefId"/>
					<form:hidden id="flag" path="act.flag"/>
					<form:hidden path="project.id"/>
					<form:hidden path="audit.id"/>
					<sys:message content="${message}"/>
					<h4 class="page-header">申请信息</h4>
						<div class="row">
							<div class="col-sm-6">
								<div class="view-group">
									<label class="col-sm-4 control-label">姓名：</label>
									<div class="col-sm-8">
										<p class="form-control-static">
											${oaProjCons.user.name }
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
											${oaProjCons.office.name }
										</p>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-6">
								<div class="view-group">
								
									<label class="col-sm-4 control-label">所属项目：</label>
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
									<label class="col-sm-4 control-label">备注：</label>
									<div class="col-sm-8">
										<p class="form-control-static">
										${oaProjCons.remarks}
										</p>
									</div>
								</div>
							</div>
						</div>

						<div class="row">
							<div class="col-sm-6">
								<div class="view-group">
									<label class="col-sm-4 control-label">附件:</label>
									<div class="col-sm-8">
										<form:hidden id="files" path="files" htmlEscape="false"
											maxlength="2000" />
										<sys:ckfinder input="files" type="files" uploadPath="/file"
											selectMultiple="true" readonly="true"/>
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
						<shiro:hasPermission name="oa:oaProjCons:edit">
							<c:if test="${oaProjCons.act.taskDefKey eq 'apply_end'}">
								<input id="btnSubmit" class="btn btn-success" type="submit" value="兑 现" onclick="$('#flag').val('yes')"/>&nbsp;
							</c:if>
							<c:if test="${oaProjCons.act.taskDefKey ne 'apply_end'}">
								<input id="btnSubmit" class="btn btn-success" type="submit" value="同 意" onclick="$('#flag').val('yes')"/>&nbsp;
								<input id="btnSubmit" class="btn btn-inverse" type="submit" value="驳 回" onclick="$('#flag').val('no')"/>&nbsp;
							</c:if>
						</shiro:hasPermission>
						<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
					</div>
					<act:histoicFlow procInsId="${oaProjCons.act.procInsId}"/>
				</form:form>
				<br/>
			</div>
		</div>
	</div>
</body>
</html>
