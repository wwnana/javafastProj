<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>打卡规则表编辑</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		var validateForm;
		function doSubmit(){//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
		  if(validateForm.form()){
			  $("#inputForm").submit();
			  return true;
		  }
	
		  return false;
		}
		$(document).ready(function() {
			//$("#name").focus();
			validateForm=$("#inputForm").validate({
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
		<h5>打卡规则表${not empty hrCheckRule.id?'修改':'添加'}</h5>
	</div>
	<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="hrCheckRule" action="${ctx}/hr/hrCheckRule/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
			<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 打卡规则类型。1：固定时间上下班；2：按班次上下班；3：自由上下班：</label>
						<div class="col-sm-8">
							<form:radiobuttons path="groupType" items="${fns:getDictList('')}" itemLabel="label" itemValue="value" htmlEscape="false" class="i-checks"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 打卡规则id：</label>
						<div class="col-sm-8">
							<form:input path="groupId" htmlEscape="false" maxlength="64" class="form-control required"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 打卡名称：</label>
						<div class="col-sm-8">
							<form:input path="groupname" htmlEscape="false" maxlength="64" class="form-control required"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 打卡日期：</label>
						<div class="col-sm-8">
							<form:checkboxes path="workdays" items="${fns:getDictList('')}" itemLabel="label" itemValue="value" htmlEscape="false" class="i-checks "/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 弹性时间：</label>
						<div class="col-sm-8">
							<form:input path="flexTime" htmlEscape="false" maxlength="11" class="form-control digits"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 下班不需要打卡：</label>
						<div class="col-sm-8">
							<form:input path="noneedOffwork" htmlEscape="false" maxlength="11" class="form-control digits"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 打卡时间限制：</label>
						<div class="col-sm-8">
							<form:input path="limitAheadtime" htmlEscape="false" maxlength="11" class="form-control digits"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 打卡时间：</label>
						<div class="col-sm-8">
							<form:input path="checkintime" htmlEscape="false" maxlength="400" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 不需要打卡的时间Json：</label>
						<div class="col-sm-8">
							<form:input path="speOffdays" htmlEscape="false" maxlength="400" class="form-control"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 同步节假日：</label>
						<div class="col-sm-8">
							<form:input path="syncHolidays" htmlEscape="false" maxlength="2" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 拍照打卡：</label>
						<div class="col-sm-8">
							<form:input path="needPhoto" htmlEscape="false" maxlength="2" class="form-control"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> wifi信息：</label>
						<div class="col-sm-8">
							<form:input path="wifimacInfos" htmlEscape="false" maxlength="400" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 是否备注时允许上传本地图片：</label>
						<div class="col-sm-8">
							<form:input path="noteCanUseLocalPic" htmlEscape="false" maxlength="2" class="form-control"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 是否非工作日允许打卡：</label>
						<div class="col-sm-8">
							<form:input path="allowCheckinOffworkday" htmlEscape="false" maxlength="2" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 补卡申请：</label>
						<div class="col-sm-8">
							<form:input path="allowApplyOffworkday" htmlEscape="false" maxlength="2" class="form-control"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 位置打卡地点信息json：</label>
						<div class="col-sm-8">
							<form:input path="locInfos" htmlEscape="false" maxlength="400" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
		
			<div class="hr-line-dashed"></div>
			<div class="form-actions">
				<shiro:hasPermission name="hr:hrCheckReport:edit">
					<button id="btnSubmit" class="btn btn-success" type="submit"><i class="fa fa-check"></i> 保存</button>&nbsp;
				</shiro:hasPermission>
				<button id="btnCancel" class="btn btn-white" type="button" onclick="history.go(-1)"><i class="fa fa-reply"></i> 返回</button>
			</div>
		</form:form>
	</div>
</div>
</div>
</body>
</html>