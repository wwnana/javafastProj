<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>系统短信管理</title>
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
<body class="hideScroll">
	<form:form id="inputForm" modelAttribute="sysSms" action="${ctx}/sys/sysSms/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>	
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
		<tbody>
		<tr>
			</tr><tr>
				<td class="width-15 active"><label class="pull-right">短信类型：</label></td>
				<td class="width-35">
					<form:select path="smsType" cssClass="form-control input-xlarge required">
						<form:option value="" label=""/>
						<form:options items="${fns:getDictList('sms_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
					<span class="help-inline"><font color="red">*</font> </span>
				</td>
				<td class="width-15 active"><label class="pull-right">手机号码：</label></td>
				<td class="width-35">
					<form:input path="mobile" htmlEscape="false" maxlength="11" class="form-control input-xlarge required"/>
					<span class="help-inline"><font color="red">*</font> </span>
				</td>
				
			</td>
			</tr><tr>
				<td class="width-15 active"><label class="pull-right">短信内容：</label></td>
				<td class="width-35">
					<form:textarea path="content" htmlEscape="false" rows="4" maxlength="100" class="form-control input-xlarge required"/>
					<span class="help-inline"><font color="red">*</font> </span>
				</td>
			
				<td class="width-15 active"><label class="pull-right">客户端IP：</label></td>
				<td class="width-35">
					<form:input path="ip" htmlEscape="false" maxlength="20" class="form-control input-xlarge"/>
				</td>
			</tr><tr>
				<td class="width-15 active"><label class="pull-right">成功状态：</label></td>
				<td class="width-35">
				<form:select path="status" cssClass="form-control input-xlarge required">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</td>
			
			
	</form:form>
</body>
</html>