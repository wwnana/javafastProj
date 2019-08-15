<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>结算账户管理</title>
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
	<div class="ibox-content">
		<form:form id="inputForm" modelAttribute="fiFinanceAccount" action="${ctx}/fi/fiFinanceAccount/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 账户名称：</label>
						<div class="col-sm-8">
							<form:input path="name" htmlEscape="false" maxlength="50" class="form-control required"/>
						</div>
					</div>
				</div>
			</div>
			<c:if test="${empty fiFinanceAccount.id}">
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 初始余额：</label>
						<div class="col-sm-8">
							<form:input path="balance" htmlEscape="false" class="form-control required number" min="0.01" max="1000000000"/>
						</div>
					</div>
				</div>
			</div>
			</c:if>
			<c:if test="${not empty fiFinanceAccount.id}">
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 当前余额：</label>
						<div class="col-sm-8">
							<form:input path="balance" htmlEscape="false" class="form-control " readonly="true"/>
						</div>
					</div>
				</div>
			</div>
			</c:if>
			
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 开户银行：</label>
						<div class="col-sm-8">
							<form:input path="bankName" htmlEscape="false" maxlength="50" class="form-control "/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 开户账号：</label>
						<div class="col-sm-8">
							<form:input path="bankcardNo" htmlEscape="false" maxlength="20" class="form-control "/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 是否默认：</label>
						<div class="col-sm-8">
							<form:select path="isDefault" cssClass="form-control ">
								<form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 状态：</label>
						<div class="col-sm-8">
							<form:select path="status" cssClass="form-control ">
								<form:options items="${fns:getDictList('use_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 备注：</label>
						<div class="col-sm-8">
							<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="50" class="form-control "/>
						</div>
					</div>
				</div>
			</div>
		</form:form>	
			
	</div>
</body>
</html>