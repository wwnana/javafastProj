<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>付款单查看</title>
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
	<form:form id="inputForm" modelAttribute="fiPaymentBill" action="${ctx}/fi/fiPaymentBill/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>	
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
		<tbody>
			<tr>
				<td class="width-15 active"><label class="pull-right">所属应付款：</label></td>
				<td class="width-35">
					${fiPaymentBill.fiPaymentAble.no}
				</td>
				<td class="width-15 active"><label class="pull-right">单号：</label></td>
				<td class="width-35">
					${fiPaymentBill.no}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">往来单位：</label></td>
				<td class="width-35">
								<c:if test="${not empty fiPaymentBill.supplier.id}">
									[供应商] ${fiPaymentBill.supplier.name}
								</c:if>
								<c:if test="${not empty fiPaymentBill.customer.id}">
									[客户] ${fiPaymentBill.customer.name}
								</c:if>
				</td>
				<td class="width-15 active"><label class="pull-right">付款金额：</label></td>
				<td class="width-35">
					${fiPaymentBill.amount}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">付款时间：</label></td>
				<td class="width-35">
					<fmt:formatDate value="${fiPaymentBill.dealDate}" pattern="yyyy-MM-dd"/>
				</td>
				<td class="width-15 active"><label class="pull-right">付款账户：</label></td>
				<td class="width-35">
					${fiPaymentBill.fiAccount.name}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">负责人：</label></td>
				<td class="width-35">
					${fiPaymentBill.ownBy.name}
				</td>
				<td class="width-15 active"><label class="pull-right">状态：</label></td>
				<td class="width-35">
					${fns:getDictLabel(fiPaymentBill.status, 'audit_status', '')}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">备注：</label></td>
				<td class="width-35" colspan="3">
					${fiPaymentBill.remarks}
				</td>
			</tr>
		</tbody>
		</table>
	</form:form>
</body>
</html>