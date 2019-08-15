<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>收款单管理</title>
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
	<form:form id="inputForm" modelAttribute="fiReceiveBill" action="${ctx}/fi/fiReceiveBill/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<form:hidden path="isInvoice"/>
		<sys:message content="${message}"/>	
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 收款单号：</label>
						<div class="col-sm-8">
							<form:input path="no" htmlEscape="false" maxlength="30" class="form-control required"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 所属应收款：</label>
						<div class="col-sm-8">
							<sys:tableselect id="fiReceiveAble" name="fiReceiveAble.id" value="${fiReceiveBill.fiReceiveAble.id}" labelName="fiReceiveAble.name" labelValue="${fiReceiveBill.fiReceiveAble.name}" 
								title="应收款" url="${ctx}/fi/fiReceiveAble/selectList" cssClass="form-control gray-bg required" dataMsgRequired="必选"  allowClear="false" allowInput="false" />
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 客户：</label>
						<div class="col-sm-8">
							<sys:tableselect id="customer" name="customer.id" value="${fiReceiveBill.customer.id}" labelName="customer.name" labelValue="${fiReceiveBill.customer.name}" 
								title="客户" url="${ctx}/crm/crmCustomer/selectList" cssClass="form-control gray-bg" dataMsgRequired=""  allowClear="true" allowInput="false" />
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 收款金额：</label>
						<div class="col-sm-8">
							<form:input path="amount" htmlEscape="false" class="form-control required number" min="0.01" max="10000000000"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 收款账户：</label>
						<div class="col-sm-8">
							<sys:spinnerselect id="fiAccount" name="fiAccount.id" value="${fiReceiveBill.fiAccount.id}" labelName="fiaccount.name" labelValue="${fiReceiveBill.fiAccount.name}" 
						title="结算账户" url="${ctx}/fi/fiFinanceAccount/getSelectData" cssClass="form-control required" allowEmpty="false"></sys:spinnerselect>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 收款人：</label>
						<div class="col-sm-8">
							<sys:treeselect id="ownBy" name="ownBy.id" value="${fiReceiveBill.ownBy.id}" labelName="ownBy.name" labelValue="${fiReceiveBill.ownBy.name}"
								title="用户" url="/sys/office/treeData?type=3" cssClass="form-control required" allowClear="true" notAllowSelectParent="true"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 收款时间：</label>
						<div class="col-sm-8">
							<div class="input-group date datepicker">
								<input name="dealDate" type="text" readonly="readonly" class="form-control required" value="<fmt:formatDate value="${fiReceiveBill.dealDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
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
						<label class="col-sm-4 control-label">开票金额：</label>
						<div class="col-sm-8">
							<form:input path="invoiceAmt" htmlEscape="false" class="form-control number" min="0.01"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">备注：</label>
						<div class="col-sm-8">
							<form:textarea path="remarks" htmlEscape="false" rows="2" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
	
			
	</form:form>
</div>
</body>
</html>