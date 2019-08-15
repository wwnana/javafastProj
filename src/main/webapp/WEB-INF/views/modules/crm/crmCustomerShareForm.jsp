<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>客户指派</title>
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
<body class="white-bg">

		<div class="ibox-content">
	
		<form:form id="inputForm" modelAttribute="crmCustomer" action="${ctx}/crm/crmCustomer/saveShare" method="post" class="form-horizontal">
			<form:hidden path="id"/>
			<sys:message content="${message}"/>	
			
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 将客户指派给：</label>
						<div class="col-sm-8">
							<sys:treeselect id="ownBy" name="ownBy.id" value="" labelName="ownBy.name" labelValue=""
								title="用户" url="/sys/office/treeData?type=3" cssClass="form-control required" dataMsgRequired="必选" allowClear="true" notAllowSelectParent="true"/>
						</div>
					</div>
				</div>
			</div>
		
				
			
			</form:form>
		</div>
</body>


</html>