<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>开票信息查看</title>
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
	<form:form id="inputForm" modelAttribute="crmInvoice" action="${ctx}/crm/crmInvoice/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>	
		
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
		<tbody>
			<tr>
				<td class="width-15 active" width="10%"><label class="pull-right">客户：</label></td>
				<td class="width-35" width="40%">
					${crmInvoice.customer.name}
				</td>
				<td class="width-15 active" width="10%"><label class="pull-right">发票类型：</label></td>
				<td class="width-35" width="40%">
					${fns:getDictLabel(crmInvoice.invoiceType, 'invoice_type', '')}
				</td>
			</tr>
			<tr>	
				<td class="width-15 active"><label class="pull-right">发票抬头：</label></td>
				<td class="width-35">
					${crmInvoice.regName}
				</td>
				<td class="width-15 active"><label class="pull-right">税务登记号：</label></td>
				<td class="width-35">
					${crmInvoice.taxNo}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">单位地址：</label></td>
				<td class="width-35">
					${crmInvoice.regAddress}
				</td>
				<td class="width-15 active"><label class="pull-right">单位电话：</label></td>
				<td class="width-35">
					${crmInvoice.regPhone}
				</td>
			</tr>
			<tr>
				
				<td class="width-15 active"><label class="pull-right">开户行：</label></td>
				<td class="width-35">
					${crmInvoice.bankName}
				</td>
				<td class="width-15 active"><label class="pull-right">基本户账号：</label></td>
				<td class="width-35">
					${crmInvoice.bankNo}
				</td>
			</tr>
		</tbody>
		</table>
		
	</form:form>
</body>
</html>