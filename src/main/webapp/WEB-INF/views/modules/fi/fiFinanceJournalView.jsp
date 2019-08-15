<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>资金流水查看</title>
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
	<form:form id="inputForm" modelAttribute="fiFinanceJournal" action="${ctx}/fi/fiFinanceJournal/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>	
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
		<tbody>
			<tr>
				<td class="width-15 active"><label class="pull-right">结算账户：</label></td>
				<td class="width-35">
					${fiFinanceJournal.fiaccount.id}
				</td>
				<td class="width-15 active"><label class="pull-right">交易类别：</label></td>
				<td class="width-35">
					${fns:getDictLabel(fiFinanceJournal.dealType, 'deal_type', '')}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">业务日期：</label></td>
				<td class="width-35">
					<fmt:formatDate value="${fiFinanceJournal.dealDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<td class="width-15 active"><label class="pull-right">资金类别：</label></td>
				<td class="width-35">
					${fns:getDictLabel(fiFinanceJournal.moneyType, 'money_type', '')}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">交易金额：</label></td>
				<td class="width-35">
					${fiFinanceJournal.money}
				</td>
				<td class="width-15 active"><label class="pull-right">摘要：</label></td>
				<td class="width-35">
					${fiFinanceJournal.notes}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">当前余额：</label></td>
				<td class="width-35">
					${fiFinanceJournal.balance}
				</td>
			</tr>
		</tbody>
		</table>
	</form:form>
</body>
</html>