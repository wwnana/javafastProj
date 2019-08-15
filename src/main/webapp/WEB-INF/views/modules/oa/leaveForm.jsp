<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>请假管理</title>
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
				<h5>请假管理 </h5>
			</div>
			<div class="ibox-content">
				<div class="row">
					<div class="col-sm-12">
					
					<ul class="nav nav-tabs">
						<li><a href="${ctx}/oa/leave/">待办任务</a></li>
						<li><a href="${ctx}/oa/leave/list">所有任务</a></li>
						<shiro:hasPermission name="oa:leave:edit"><li class="active"><a href="${ctx}/oa/leave/form">请假申请</a></li></shiro:hasPermission>
					</ul>
					<br>
					<form:form id="inputForm" modelAttribute="leave" action="${ctx}/oa/leave/save" method="post" class="form-horizontal">
						<form:hidden path="id"/>
						<sys:message content="${message}"/>
						<div class="control-group">
							<label class="control-label">请假类型：</label>
							<div class="controls">
								<form:select path="leaveType" cssClass="form-control input-xlarge">
									<form:options items="${fns:getDictList('oa_leave_type')}" itemLabel="label" itemValue="value" htmlEscape="false" />
								</form:select>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label">开始时间：</label>
							<div class="controls">
								<input id="startTime" name="startTime" type="text" readonly="readonly" maxlength="20" class="form-control input-xlarge Wdate required"
									onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label">结束时间：</label>
							<div class="controls">
								<input id="endTime" name="endTime" type="text" readonly="readonly" maxlength="20" class="form-control input-xlarge Wdate required"
									onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label">请假原因：</label>
							<div class="controls">
								<form:textarea path="reason" class="required" rows="5" maxlength="20" cssClass="form-control input-xlarge"/>
							</div>
						</div>
						<div class="form-actions">
							<shiro:hasPermission name="oa:leave:edit"><input id="btnSubmit" class="btn btn-success" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
							<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
						</div>
					</form:form>
				<br/>
			</div>
		</div>
	</div>
</body>
</html>