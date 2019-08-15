<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>简历导入</title>
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
			
			$("#hrRecruitId").change(function(){
				var positionName =  $("#hrRecruitId").find("option:selected").text();
				$("#position").val(positionName);
			});
			
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
		<h5>上传简历</h5>
	</div>
	<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="hrResume" action="${ctx}/hr/hrResume/saveUpload" method="post" class="form-horizontal">
		<form:hidden path="id"/>
			<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 招聘任务：</label>
						<div class="col-sm-8">
							<sys:spinnerselect id="hrRecruit" name="hrRecruit.id" value="${hrResume.hrRecruit.id}" labelName="hrRecruit.name" labelValue="${hrResume.hrRecruit.name}" 
								title="招聘任务" url="${ctx}/hr/hrRecruit/getSelectData" cssClass="form-control" allowEmpty="true"></sys:spinnerselect>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 应聘岗位：</label>
						<div class="col-sm-8">
							<form:input path="position" htmlEscape="false" maxlength="50" class="form-control required"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 简历来源：</label>
						<div class="col-sm-8">
							<form:select path="resumeSource" cssClass="form-control required">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('resume_source')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 简历文件：</label>
						<div class="col-sm-8">
							<form:hidden id="resumeFile" path="resumeFile" htmlEscape="false" maxlength="255" cssClass="required"/>
							<sys:ckfinder input="resumeFile" type="files" uploadPath="/file" selectMultiple="false"/>
							<span class="help-inline">支持DOX、DOCX格式的简历,一次最多上传1个,一个简历不超过5M</span>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">招聘环节：</label>
						<div class="col-sm-8">
							<form:select path="currentNode" cssClass="form-control required">
								<form:options items="${fns:getDictList('resume_current_node')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
			</div>
		
			<div class="hr-line-dashed"></div>
			<div class="form-actions">
				<shiro:hasPermission name="hr:hrResume:edit">
					<button id="btnSubmit" class="btn btn-success" type="submit">提交</button>&nbsp;
				</shiro:hasPermission>
				<button id="btnCancel" class="btn btn-white" type="button" onclick="history.go(-1)">返回</button>
			</div>
		</form:form>
	</div>
</div>
</div>
</body>
</html>