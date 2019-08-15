<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>附件编辑</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		var validateForm;
		function doSubmit(){//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
		  
		  if($("#content").val() == null || $("#content").val().length == 0){
			  
			  layer.alert("请上传文件!");
			  return false;
		  }
		  
		  if($("#name").val() == null || $("#name").val().length == 0){
			  var contentPreview = $("#contentPreview li a").html();
			  $("#name").val(contentPreview);
		  }
		  
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
<body>
	<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="crmDocument" action="${ctx}/crm/crmDocument/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<form:hidden path="customer.id"/>
			
			<c:if test="${empty crmDocument.id}">
				<form:hidden path="name"/>
			</c:if>
			<c:if test="${not empty crmDocument.id}">
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 附件名称：</label>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<div class="col-sm-8">
							<form:input path="name" htmlEscape="false" maxlength="50" class="form-control required"/>
						</div>
					</div>
				</div>
			</div>
			</c:if>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 附件：</label>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<div class="col-sm-8">
							<form:hidden id="content" path="content" htmlEscape="false" maxlength="255" />
							<sys:ckfinder input="content" type="files" uploadPath="/file" selectMultiple="false" />
						</div>
					</div>
				</div>
			</div>
		
		</form:form>
	</div>
</body>
</html>