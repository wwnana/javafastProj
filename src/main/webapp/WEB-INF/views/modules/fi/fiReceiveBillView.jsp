<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>收款单查看</title>
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
	<form:form id="inputForm" modelAttribute="fiReceiveBill" action="${ctx}/fi/fiReceiveBill/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>	
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
		<tbody>
			<tr>
				<td class="width-15 active"><label class="pull-right">单号：</label></td>
				<td class="width-35">
					${fiReceiveBill.no}
				</td>
				<td class="width-15 active"><label class="pull-right">所属应收款：</label></td>
				<td class="width-35">
					${fiReceiveBill.fiReceiveAble.no}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">客户：</label></td>
				<td class="width-35">
					${fiReceiveBill.customer.name}
				</td>
				<td class="width-15 active"><label class="pull-right">收款金额：</label></td>
				<td class="width-35">
					${fiReceiveBill.amount}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">收款时间：</label></td>
				<td class="width-35">
					<fmt:formatDate value="${fiReceiveBill.dealDate}" pattern="yyyy-MM-dd"/>
				</td>
				<td class="width-15 active"><label class="pull-right">收款账户：</label></td>
				<td class="width-35">
					${fiReceiveBill.fiAccount.name}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">收款人：</label></td>
				<td class="width-35">
					${fiReceiveBill.ownBy.name}
				</td>
				<td class="width-15 active"><label class="pull-right">状态：</label></td>
				<td class="width-35">
					${fns:getDictLabel(fiReceiveBill.status, 'audit_status', '')}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">是否开票：</label></td>
				<td class="width-35">
					${fns:getDictLabel(fiReceiveBill.isInvoice, 'yes_no', '')}
				</td>
				<td class="width-15 active"><label class="pull-right">开票金额：</label></td>
				<td class="width-35">
					${fiReceiveBill.invoiceAmt}
				</td>
				
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">备注：</label></td>
				<td class="width-35" colspan="3">
					${fiReceiveBill.remarks}
				</td>
			</tr>
		</tbody>
		</table>
	</form:form>
</body>
</html>