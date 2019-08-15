<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>动态管理</title>
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
	<form:form id="inputForm" modelAttribute="sysDynamic" action="${ctx}/sys/sysDynamic/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>	
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
		<tbody>
		<tr>
			</tr><tr>
				<td class="width-15 active"><label class="pull-right">对象类型：</label></td>
				<td class="width-35">
				<form:select path="objectType" cssClass="form-control input-xlarge">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('object_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</td>
			
				<td class="width-15 active"><label class="pull-right">动作类型：</label></td>
				<td class="width-35">
				<form:select path="actionType" cssClass="form-control input-xlarge">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('action_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</td>
			</tr><tr>
				<td class="width-15 active"><label class="pull-right">对象ID：</label></td>
				<td class="width-35">
				<form:input path="targetId" htmlEscape="false" maxlength="30" class="form-control input-xlarge"/>
			</td>
			
				<td class="width-15 active"><label class="pull-right">对象名称：</label></td>
				<td class="width-35">
				<form:input path="targetName" htmlEscape="false" maxlength="50" class="form-control input-xlarge"/>
			</td>
			</tr><tr>
			</tr><tr>
			</tr><tr>
				<td class="width-15 active"><label class="pull-right">关联客户：</label></td>
				<td class="width-35">
				<form:input path="customerId" htmlEscape="false" maxlength="30" class="form-control input-xlarge"/>
			</td>
			
			
	</form:form>
</body>
</html>