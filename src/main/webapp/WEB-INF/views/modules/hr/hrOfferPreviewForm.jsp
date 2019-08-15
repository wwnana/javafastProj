<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>OFFER预览</title>
	<meta name="decorator" content="default"/>
	<style type="text/css">
	#readDiv{ 
		border: 100px solid #E8E9F7; 
		background-color: white; 
		overflow: auto;
		width: auto;	
		height: auto; 	
	}
	</style>
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
		<h5>OFFER预览</h5>
	</div>
	<div class="ibox-content" style="min-height: 600px">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="hrOffer" action="${ctx}/hr/hrOffer/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<form:hidden path="hrResume.id"/>
		<form:hidden path="validityPeriod"/>
		<input id="reportDate" name="reportDate" type="hidden" readonly="readonly" class="form-control required" value="<fmt:formatDate value="${hrOffer.reportDate}" pattern="yyyy-MM-dd HH:mm"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm',isShowClear:true});" >
		<form:hidden path="probationPeriod"/>
		<form:hidden path="position"/>
		<form:hidden path="department"/>
		<form:hidden path="address"/>
		<form:hidden path="linkMan"/>
		<form:hidden path="linkPhone"/>
		<form:hidden path="company"/>
		<form:hidden path="probationSalaryBase"/>
		<form:hidden path="formalSalaryBase"/>
		<form:hidden path="salaryRemarks"/>
		<form:hidden path="offerFile"/>
		<form:hidden path="isSmsMsg"/>
		<form:hidden path="isEmailMsg"/>
		<form:hidden path="content"/>
		
			<div id="readDiv" class="gray-bg">
				<div class="row">
					<div style="margin: 50px;">
						<p>${hrOffer.content}</p>
					</div>
				</div>
			</div>	
		
			<div class="hr-line-dashed"></div>
			<div class="form-actions">
				<button id="btnSubmit" class="btn btn-success" type="submit">发送</button>
				<button id="btnCancel" class="btn btn-white" type="button" onclick="history.go(-1)">上一步</button>
			</div>
		</form:form>
	</div>
</div>
</div>
</body>
</html>