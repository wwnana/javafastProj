<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>产品库存查看</title>
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
	<form:form id="inputForm" modelAttribute="wmsStock" action="${ctx}/wms/wmsStock/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>	
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
		<tbody>
			<tr>
				<td class="width-15 active" width="10%"><label class="pull-right">产品编号：</label></td>
				<td class="width-35" width="40%">
					${wmsStock.product.no}
				</td>
				<td class="width-15 active" width="10%"><label class="pull-right">产品名称：</label></td>
				<td class="width-35" width="40%">
					${wmsStock.product.name}
				</td>
			</tr>
			<tr>
				<td class="width-15 active" width="10%"><label class="pull-right">单位：</label></td>
				<td class="width-35" width="40%">
					${fns:getDictLabel(wmsStock.product.unitType, 'unit_type', '')}
				</td>
				<td class="width-15 active" width="10%"><label class="pull-right">仓库：</label></td>
				<td class="width-35" width="40%">
					${wmsStock.warehouse.name}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">库存数：</label></td>
				<td class="width-35">
					${wmsStock.stockNum}
				</td>
				<td class="width-15 active"><label class="pull-right">预警数：</label></td>
				<td class="width-35">
					${wmsStock.warnNum}
				</td>
			</tr>
			<tr>
			</tr>
		</tbody>
		</table>
	</form:form>
</body>
</html>