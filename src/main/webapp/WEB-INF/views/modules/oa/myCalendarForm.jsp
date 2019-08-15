<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>日程管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		var validateForm;
		function doSubmit(){//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
		  if(validateForm.form()){
			  
			  $("#adllDay").val("1");
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
<body class="">
<div class="">
	<div class="">
		<div class="ibox-content">
		<form:form id="inputForm" modelAttribute="myCalendar" action="${ctx}/iim/myCalendar/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<form:hidden path="adllDay"/>
		<sys:message content="${message}"/>	
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"><font color="red">*</font> 提醒内容</label>
					</div>
					<div class="form-group">
						<div class="col-sm-10">
							<form:textarea path="title" htmlEscape="false" rows="2" maxlength="50" class="form-control required"/>
						</div>
					</div>
				</div>
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"><font color="red">*</font> 提醒时间</label>
					</div>
					<div class="form-group">
						<div class="col-sm-10">
							<div class="input-group date datepicker">
								<input name="start" type="text" readonly="readonly" class="form-control required" value="<fmt:formatDate value="${myCalendar.start}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
	                     		<span class="input-group-addon">
	                             	<span class="fa fa-calendar"></span>
	                     		</span>
                     		</div>
                     		<label id="start-error" class="error" for="start" style="display: none;">必填</label>
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