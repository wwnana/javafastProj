<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>话题编辑</title>
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
		<h5>话题${not empty oaTopic.id?'修改':'添加'}</h5>
	</div>
	<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="oaTopic" action="${ctx}/oa/oaTopic/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
			<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"><font color="red">*</font> 标题：</label>
						<div class="col-sm-10">
							<form:input path="title" htmlEscape="false" maxlength="50" class="form-control required"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"><font color="red">*</font> 内容：</label>
						<div class="col-sm-10">
							<form:textarea id="content" path="content" htmlEscape="false" rows="8" maxlength="10000" class="form-control " style="width:100%;height:400px;"/>
							<sys:umeditor replace="content" uploadPath="/image" maxlength="10000"/>
						</div>
					</div>
				</div>
			</div>
			
			<div class="hr-line-dashed"></div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<div class="col-sm-offset-2 col-sm-10">
							<button id="btnSubmit" class="btn btn-success" type="submit">保存</button>&nbsp;
							<button id="btnCancel" class="btn btn-white" type="button" onclick="history.go(-1)">返回</button>
						</div>
					</div>
				</div>
			</div>

		</form:form>
	</div>
</div>
</div>
</body>
</html>