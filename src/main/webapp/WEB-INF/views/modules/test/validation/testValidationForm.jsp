<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>校验测试表单编辑</title>
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
<body>
	<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="testValidation" action="${ctx}/test/validation/testValidation/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 非空：</label>
						<div class="col-sm-8">
							<form:input path="name" htmlEscape="false" maxlength="50" class="form-control required"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 金额：</label>
						<div class="col-sm-8">
							<form:input path="num" htmlEscape="false" class="form-control number" min="0.01" maxlength="12"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 整数：</label>
						<div class="col-sm-8">
							<form:input path="num2" htmlEscape="false" maxlength="11" class="form-control digits"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 日期：</label>
						<div class="col-sm-8">
							<div class="input-group date datepicker">
				                 <input name="newDate" type="text" readonly="readonly" class="form-control" 
				                 value="<fmt:formatDate value="${testValidation.newDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                 <span class="input-group-addon">
				                      <span class="fa fa-calendar"></span>
				                 </span>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 时间：</label>
						<div class="col-sm-8">
							<div class="input-group date datepicker">
				                 <input name="date2" type="text" readonly="readonly" class="form-control" 
				                 value="<fmt:formatDate value="${testValidation.date2}" pattern="yyyy-MM-dd HH:mm:ss"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:true});" >
				                 <span class="input-group-addon">
				                      <span class="fa fa-calendar"></span>
				                 </span>
							</div>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 手机号码：</label>
						<div class="col-sm-8">
							<form:input path="mobile" htmlEscape="false" maxlength="11" class="form-control isMobile"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 邮箱：</label>
						<div class="col-sm-8">
							<form:input path="email" htmlEscape="false" maxlength="50" class="form-control email"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 网址：</label>
						<div class="col-sm-8">
							<form:input path="url" htmlEscape="false" maxlength="64" class="form-control url"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 备注信息：</label>
						<div class="col-sm-8">
							<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="form-control "/>
						</div>
					</div>
				</div>
			</div>
		
		</form:form>
	</div>
</body>
</html>