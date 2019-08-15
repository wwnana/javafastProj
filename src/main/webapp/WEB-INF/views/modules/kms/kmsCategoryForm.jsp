<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>栏目编辑</title>
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
			validateForm =$("#inputForm").validate({
				submitHandler: function(form){
					loading('正在提交，请稍等...');
					form.submit();
				},
				errorContainer: "#messageBox",
				errorPlacement: function(error, element) {
					$("#messageBox").text("输入有误，请先更正。");
					if (element.is(":checkbox") || element.is(":radio") || element.parent().is(".input-append")){
						error.appendTo(element.parent().parent());
					} else {
						error.insertAfter(element);
					}
				}
			});
			
		});
	</script>
</head>
<body class="">
<div class="wrapper-content">
	<div class="">
		<form:form id="inputForm" modelAttribute="kmsCategory" action="${ctx}/kms/kmsCategory/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
			<sys:message content="${message}"/>
	
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">上级分类</label>
						<div class="col-sm-8">
							<sys:treeselect id="parent" name="parent.id" value="${kmsCategory.parent.id}" labelName="parent.name" labelValue="${kmsCategory.parent.name}"
								title="上级分类" url="/kms/kmsCategory/treeData" extId="${kmsCategory.id}" cssClass="form-control " allowClear="true"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 栏目名称</label>
						<div class="col-sm-8">
							<form:input path="name" htmlEscape="false" maxlength="50" class="form-control required"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">排序</label>
						<div class="col-sm-8">
							<form:input path="sort" htmlEscape="false" maxlength="11" class="form-control required digits"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">是否显示</label>
						<div class="col-sm-8">
							<form:select path="inMenu" class="form-control   ">
								<form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
			</div>
			
	</form:form>
	</div>
</div>
</body>
</html>