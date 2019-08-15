<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>仓库管理</title>
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
	<form:form id="inputForm" modelAttribute="wmsWarehouse" action="${ctx}/wms/wmsWarehouse/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>	
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
		<tbody>
		<tr>
			</tr><tr>
				<td class="width-15 active"><label class="pull-right"><font color="red">*</font> 仓库编号：</label></td>
				<td class="width-35">
				<form:input path="no" htmlEscape="false" maxlength="30" class="form-control input-xlarge required"/>
			</td>
			
				<td class="width-15 active"><label class="pull-right"><font color="red">*</font> 仓库名称：</label></td>
				<td class="width-35">
				<form:input path="name" htmlEscape="false" maxlength="50" class="form-control input-xlarge required"/>
			</td>
			</tr><tr>
				<td class="width-15 active"><label class="pull-right">是否默认：</label></td>
				<td class="width-35">
				<form:select path="isDefault" class="input-xlarge ">
					<form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</td>
			
				<td class="width-15 active"><label class="pull-right">联系人：</label></td>
				<td class="width-35">
				<form:input path="contactName" htmlEscape="false" maxlength="30" class="form-control input-xlarge "/>
			</td>
			</tr><tr>
				<td class="width-15 active"><label class="pull-right">联系电话：</label></td>
				<td class="width-35">
				<form:input path="phone" htmlEscape="false" maxlength="20" class="form-control input-xlarge "/>
			</td>
			
				<td class="width-15 active"><label class="pull-right">联系手机：</label></td>
				<td class="width-35">
				<form:input path="mobile" htmlEscape="false" maxlength="20" class="form-control input-xlarge "/>
			</td>
			</tr><tr>
				<td class="width-15 active"><label class="pull-right">联系邮箱：</label></td>
				<td class="width-35">
				<form:input path="email" htmlEscape="false" maxlength="50" class="form-control input-xlarge "/>
			</td>
			
				<td class="width-15 active"><label class="pull-right">联系地址：</label></td>
				<td class="width-35">
				<form:input path="address" htmlEscape="false" maxlength="50" class="form-control input-xlarge "/>
			</td>
			</tr><tr>
				<td class="width-15 active"><label class="pull-right">状态：</label></td>
				<td class="width-35">
				<form:select path="status" class="input-xlarge ">
					<form:options items="${fns:getDictList('use_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</td>
			
			
			
			
			
				<td class="width-15 active"><label class="pull-right">备注：</label></td>
				<td class="width-35">
				<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="50" class="form-control "/>
			</td>
			</tr><tr>
			</tr><tr>
			</tr><tr>
	</form:form>
</body>
</html>