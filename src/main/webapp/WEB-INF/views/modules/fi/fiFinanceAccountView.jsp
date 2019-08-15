<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>结算账户查看</title>
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
	<form:form id="inputForm" modelAttribute="fiFinanceAccount" action="${ctx}/fi/fiFinanceAccount/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>	
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
		<tbody>
			<tr>
				<td class="width-15 active"><label class="pull-right">账户名称：</label></td>
				<td class="width-35">
					${fiFinanceAccount.name}
				</td>
				<td class="width-15 active"><label class="pull-right">银行名称：</label></td>
				<td class="width-35">
					${fiFinanceAccount.bankName}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">银行账号：</label></td>
				<td class="width-35">
					${fiFinanceAccount.bankcardNo}
				</td>
				<td class="width-15 active"><label class="pull-right">余额：</label></td>
				<td class="width-35">
					${fiFinanceAccount.balance}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">状态：</label></td>
				<td class="width-35">
					${fns:getDictLabel(fiFinanceAccount.status, 'use_status', '')}
				</td>
				<td class="width-15 active"><label class="pull-right">备注：</label></td>
				<td class="width-35">
					${fiFinanceAccount.remarks}
				</td>
			</tr>
			<tr>
			</tr>
		</tbody>
		</table>
	</form:form>
</body>
</html>