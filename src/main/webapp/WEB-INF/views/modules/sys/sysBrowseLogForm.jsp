<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>足迹管理</title>
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
	<form:form id="inputForm" modelAttribute="sysBrowseLog" action="${ctx}/sys/sysBrowseLog/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>	
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
		<tbody>
		<tr>
			</tr><tr>
				<td class="width-15 active"><label class="pull-right">目标类型：</label></td>
				<td class="width-35">
				<form:select path="targetType" cssClass="form-control input-xlarge">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('target_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</td>
			
				<td class="width-15 active"><label class="pull-right">目标ID：</label></td>
				<td class="width-35">
				<form:input path="targetId" htmlEscape="false" maxlength="30" class="form-control input-xlarge"/>
			</td>
			</tr><tr>
				<td class="width-15 active"><label class="pull-right">目标名称：</label></td>
				<td class="width-35">
				<form:input path="targetName" htmlEscape="false" maxlength="50" class="form-control input-xlarge"/>
			</td>
			
				<td class="width-15 active"><label class="pull-right">浏览者：</label></td>
				<td class="width-35">
				<form:input path="userId" htmlEscape="false" maxlength="30" class="form-control input-xlarge required"/>
				<span class="help-inline"><font color="red">*</font> </span>
			</td>
			</tr><tr>
				<td class="width-15 active"><label class="pull-right">最新浏览时间：</label></td>
				<td class="width-35">
				<input name="browseDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control layer-date input-xlarge required"
					value="<fmt:formatDate value="${sysBrowseLog.browseDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
				<span class="help-inline"><font color="red">*</font> </span>
			</td>
			
	</form:form>
</body>
</html>