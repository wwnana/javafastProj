<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>修改个人信息</title>
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
			$("#name").focus();
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
<body>
<div class="ibox-content">
	<form:form id="inputForm" modelAttribute="user" action="${ctx}/sys/user/saveUserInfo" method="post" class="form-horizontal">
	<div class="row">
		<div class="col-sm-6">
			<div class="form-group">
				<label class="col-sm-3 control-label"><font color="red">*</font> 姓名:</label>
				<div class="col-sm-8">
					<form:input path="name" htmlEscape="false" maxlength="30"  class="form-control required" />
				</div>
			</div>
		</div>
		<div class="col-sm-6">
			<div class="form-group">
				<label class="col-sm-3 control-label"><font color="red">*</font> 手机:</label>
				<div class="col-sm-8">
					<form:input path="mobile" class="form-control required" htmlEscape="false" maxlength="20"/>
				</div>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-sm-6">
			<div class="form-group">
				<label class="col-sm-3 control-label">邮箱:</label>
				<div class="col-sm-8">
					<form:input path="email" htmlEscape="false" maxlength="50" class="form-control email"/>
				</div>
			</div>
		</div>
		<div class="col-sm-6">
			<div class="form-group">
				<label class="col-sm-3 control-label">电话:</label>
				<div class="col-sm-8">
					<form:input path="phone" htmlEscape="false" class="form-control " maxlength="30"/>
				</div>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-sm-6">
			<div class="form-group">
				<label class="col-sm-3 control-label">备注:</label>
				<div class="col-sm-8">
					<form:textarea path="remarks" htmlEscape="false" rows="3" maxlength="50" class="form-control "/>
				</div>
			</div>
		</div>
	</div>
	</form:form>
</div>
</body>
</html>