<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>下次联系提醒设置</title>
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
	
		<form:form id="inputForm" modelAttribute="crmContactRecord" action="${ctx}/crm/crmContactRecord/nextContactSave" method="post" class="form-horizontal">
			<form:hidden path="id"/>
			<form:hidden path="targetId"/>
			<sys:message content="${message}"/>	
			
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 下次联系时间</label>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<div class="col-sm-8">
							<div class="input-group date datepicker">
			                	<input id="contactDate" name="contactDate" type="text" readonly="readonly" class="form-control required" value="<fmt:formatDate value="${crmContactRecord.contactDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                	<span class="input-group-addon"><span class="fa fa-calendar"></span></span>
			                </div>
			                <label id="contactDate-error" class="error" for="contactDate" style="display: none;">必填</label>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 下次联系内容</label>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<div class="col-sm-8">
							<form:textarea path="content" htmlEscape="false" rows="4" maxlength="50" class="form-control required"/>
						</div>
					</div>
				</div>
			</div>
			
				
			
			</form:form>
		</div>
</body>
</html>