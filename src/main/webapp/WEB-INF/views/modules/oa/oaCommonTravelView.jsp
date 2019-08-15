<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>差旅单查看</title>
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
	<form:form id="inputForm" modelAttribute="oaCommonTravel" action="${ctx}/oa/oaCommonTravel/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<table class="table table-bordered table-condensed dataTables-example dataTable no-footer">
		<tbody>
			<tr>
				<td class="width-15 active"><label class="pull-right">出发地：</label></td>
				<td class="width-35">
					${oaCommonTravel.startAddress}
				</td>
				<td class="width-15 active"><label class="pull-right">出差城市：</label></td>
				<td class="width-35">
					${oaCommonTravel.destAddress}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">开始时间：</label></td>
				<td class="width-35">
					<fmt:formatDate value="${oaCommonTravel.startTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<td class="width-15 active"><label class="pull-right">结束时间：</label></td>
				<td class="width-35">
					<fmt:formatDate value="${oaCommonTravel.endTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">预算金额：</label></td>
				<td class="width-35">
					${oaCommonTravel.budgetAmt}
				</td>
				<td class="width-15 active"><label class="pull-right">预支金额：</label></td>
				<td class="width-35">
					${oaCommonTravel.advanceAmt}
				</td>
			</tr>
			<tr>
			</tr>
		</tbody>
		</table>
	</form:form>
</body>
</html>