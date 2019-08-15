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
				<h5>审批${not empty testAudit.id?'修改':'申请'}流程 </h5>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
					
	
					<form:form id="inputForm" modelAttribute="testAudit" action="${ctx}/oa/testAudit/save" method="post" class="form-horizontal">
						<form:hidden path="id"/>
						<form:hidden path="act.taskId"/>
						<form:hidden path="act.taskName"/>
						<form:hidden path="act.taskDefKey"/>
						<form:hidden path="act.procInsId"/>
						<form:hidden path="act.procDefId"/>
						<form:hidden id="flag" path="act.flag"/>
						<sys:message content="${message}"/>
						
							<h4 class="page-header">审批申请</h4>
							<div class="row">
								<div class="col-sm-6">
									<div class="form-group">
										<label class="col-sm-4 control-label"><font color="red">*</font> 姓名：</label>
										<div class="col-sm-8">
											<sys:treeselect id="user" name="user.id" value="${testAudit.user.id}" labelName="user.name" labelValue="${testAudit.user.name}" 
												title="用户" url="/sys/office/treeData?type=3" cssClass="form-control required recipient"  
												allowClear="true" notAllowSelectParent="true" smallBtn="false"/>
										</div>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-sm-6">
									<div class="form-group">
										<label class="col-sm-4 control-label"><font color="red">*</font> 部门：</label>
										<div class="col-sm-8">
											<sys:treeselect id="office" name="office.id" value="${testAudit.office.id}" labelName="office.name" labelValue="${testAudit.office.name}" 
											title="用户" url="/sys/office/treeData?type=2" cssClass="form-control required recipient"  
											allowClear="true" notAllowSelectParent="true" smallBtn="false"/>
										</div>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-sm-6">
									<div class="form-group">
										<label class="col-sm-4 control-label"> 岗位：</label>
										<div class="col-sm-8">
											<form:input path="post" htmlEscape="false" maxlength="50" cssClass="form-control"/>
										</div>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-sm-6">
									<div class="form-group">
										<label class="col-sm-4 control-label"><font color="red">*</font> 申请事由：</label>
										<div class="col-sm-8">
											<form:textarea path="content" class="form-control required" rows="4" maxlength="200"/>
										</div>
									</div>
								</div>
							</div>
							
			
						<div class="form-actions">
							<shiro:hasPermission name="oa:testAudit:edit">
								<input id="btnSubmit" class="btn btn-success" type="submit" value="提交申请" onclick="$('#flag').val('yes')"/>&nbsp;
								<c:if test="${not empty testAudit.id}">
									<input id="btnSubmit2" class="btn btn-inverse" type="submit" value="销毁申请" onclick="$('#flag').val('no')"/>&nbsp;
								</c:if>
							</shiro:hasPermission>
							<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
						</div>
						<c:if test="${not empty testAudit.id}">
							<act:histoicFlow procInsId="${testAudit.act.procInsId}" />
						</c:if>
					</form:form>
				<br/>
			</div>
		</div>
	</div>
</body>
</html>