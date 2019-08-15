<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>支付宝支付通知编辑</title>
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
	<form:form id="inputForm" modelAttribute="payAlipayLog" action="${ctx}/pay/payAlipayLog/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>			
		<table class="table table-bordered table-condensed dataTables-example dataTable no-footer">
		<tbody>
			<tr>
				<td class="width-15 active"><label class="pull-right">开发者应用ID：</label></td>
				<td class="width-35">
					<form:input path="appid" htmlEscape="false" maxlength="50" class="form-control input-xlarge"/>
				</td>
				<td class="width-15 active"><label class="pull-right">卖家支付宝用户号：</label></td>
				<td class="width-35">
					<form:input path="sellerId" htmlEscape="false" maxlength="50" class="form-control input-xlarge"/>
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">支付宝交易号：</label></td>
				<td class="width-35">
					<form:input path="tradeNo" htmlEscape="false" maxlength="50" class="form-control input-xlarge"/>
				</td>
				<td class="width-15 active"><label class="pull-right">商户订单号：</label></td>
				<td class="width-35">
					<form:input path="outTradeNo" htmlEscape="false" maxlength="50" class="form-control input-xlarge"/>
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">交易状态：</label></td>
				<td class="width-35">
					<form:input path="tradeStatus" htmlEscape="false" maxlength="50" class="form-control input-xlarge"/>
				</td>
				<td class="width-15 active"><label class="pull-right">签名：</label></td>
				<td class="width-35">
					<form:input path="sign" htmlEscape="false" maxlength="50" class="form-control input-xlarge"/>
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">签名类型：</label></td>
				<td class="width-35">
					<form:input path="signType" htmlEscape="false" maxlength="50" class="form-control input-xlarge"/>
				</td>
				<td class="width-15 active"><label class="pull-right">交易类型：</label></td>
				<td class="width-35">
					<form:input path="tradeType" htmlEscape="false" maxlength="30" class="form-control input-xlarge"/>
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">付款银行：</label></td>
				<td class="width-35">
					<form:input path="bankType" htmlEscape="false" maxlength="50" class="form-control input-xlarge"/>
				</td>
				<td class="width-15 active"><label class="pull-right">订单金额：</label></td>
				<td class="width-35">
					<form:input path="totalAmount" htmlEscape="false" class="form-control input-xlarge"/>
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">付款金额：</label></td>
				<td class="width-35">
					<form:input path="buyerPayAmount" htmlEscape="false" class="form-control input-xlarge"/>
				</td>
				<td class="width-15 active"><label class="pull-right">实收金额：</label></td>
				<td class="width-35">
					<form:input path="receiptAmount" htmlEscape="false" class="form-control input-xlarge"/>
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">交易付款时间：</label></td>
				<td class="width-35">
					<form:input path="gmtPayment" htmlEscape="false" maxlength="50" class="form-control input-xlarge"/>
				</td>
				<td class="width-15 active"><label class="pull-right">支付宝支付账号：</label></td>
				<td class="width-35">
					<form:input path="buyerId" htmlEscape="false" maxlength="50" class="form-control input-xlarge"/>
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">商户业务号：</label></td>
				<td class="width-35">
					<form:input path="outBizNo" htmlEscape="false" maxlength="50" class="form-control input-xlarge"/>
				</td>
				<td class="width-15 active"><label class="pull-right">退款金额：</label></td>
				<td class="width-35">
					<form:input path="refundFee" htmlEscape="false" class="form-control input-xlarge"/>
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">交易退款时间：</label></td>
				<td class="width-35">
					<form:input path="gmtRefund" htmlEscape="false" maxlength="50" class="form-control input-xlarge"/>
				</td>
				<td class="width-15 active"><label class="pull-right">状态：</label></td>
				<td class="width-35">
					<form:select path="status" cssClass="form-control input-xlarge">
						<form:option value="" label=""/>
						<form:options items="${fns:getDictList('paylog_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
				</td>
			</tr>
			<tr>
			</tr>
		</tbody>
		</table>
		
	</form:form>
</body>
</html>