<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>业务数据编辑</title>
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
	<form:form id="inputForm" modelAttribute="testData" action="${ctx}/test/grid/testData/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>	
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
		<tbody>
			<tr>
				<td class="width-15 active"><label class="pull-right"><font color="red">*</font> 姓名：</label></td>
				<td class="width-35">
					<form:input path="name" htmlEscape="false" class="form-control input-xlarge required" maxlength="20"  minlength="2"/>
				</td>
				<td class="width-15 active"><label class="pull-right"><font color="red">*</font> 性别：</label></td>
				<td class="width-35">
					<form:radiobuttons path="sex" items="${fns:getDictList('sex')}" itemLabel="label" itemValue="value" htmlEscape="false" class="i-checks required"/>
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right"><font color="red">*</font> 年龄：</label></td>
				<td class="width-35">
					<form:input path="age" htmlEscape="false" maxlength="3" class="form-control input-xlarge required digits" min="1" max="100"/>
				</td>
				<td class="width-15 active"><label class="pull-right"><font color="red">*</font> 手机号码：</label></td>
				<td class="width-35">
					<form:input path="mobile" htmlEscape="false" maxlength="11" minlength="11" class="form-control input-xlarge required digits"/>
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">电子邮箱：</label></td>
				<td class="width-35">
					<form:input path="email" htmlEscape="false" maxlength="50" class="form-control input-xlarge email"/>
				</td>
				<td class="width-15 active"><label class="pull-right">联系地址：</label></td>
				<td class="width-35">
					<form:input path="address" htmlEscape="false" maxlength="50" class="form-control input-xlarge"/>
				</td>
			</tr>
			<tr>
				
				<td class="width-15 active"><label class="pull-right">备注：</label></td>
				<td class="width-35" colspan="3">
					<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="50" class="form-control input-xxlarge"/>
				</td>
			</tr>
			<tr>
			</tr>
		</tbody>
		</table>
	</form:form>
</body>
</html>