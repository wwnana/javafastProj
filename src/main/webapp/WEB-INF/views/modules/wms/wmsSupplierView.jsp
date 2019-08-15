<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>供应商查看</title>
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
	<form:form id="inputForm" modelAttribute="wmsSupplier" action="${ctx}/wms/wmsSupplier/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>	
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
		<tbody>
			<tr>
				<td class="width-15 active" width="10%"><label class="pull-right">编号：</label></td>
				<td class="width-35"  colspan="3">
					${wmsSupplier.no}
				</td>
			</tr>
			<tr>
				<td class="width-15 active" width="10%"><label class="pull-right">名称：</label></td>
				<td class="width-35"  colspan="3">
					${wmsSupplier.name}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">供应商分类：</label></td>
				<td class="width-35" colspan="3">
					${wmsSupplier.supplierType.name}
				</td>
				
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">联系人：</label></td>
				<td class="width-35" width="40%">
					${wmsSupplier.contactName}
				</td>
				<td class="width-15 active"><label class="pull-right">联系电话：</label></td>
				<td class="width-35" width="40%">
					${wmsSupplier.phone}
				</td>
				
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">邮箱：</label></td>
				<td class="width-35">
					${wmsSupplier.email}
				</td>
				<td class="width-15 active"><label class="pull-right">QQ：</label></td>
				<td class="width-35">
					${wmsSupplier.qq}
				</td>
				
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">传真：</label></td>
				<td class="width-35">
					${wmsSupplier.fax}
				</td>
				<td class="width-15 active"><label class="pull-right">邮编：</label></td>
				<td class="width-35">
					${wmsSupplier.zipcode}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">联系地址：</label></td>
				<td class="width-35" colspan="3">
					${wmsSupplier.address}
				</td>
			</tr>
			<tr>
				
				<td class="width-15 active"><label class="pull-right">状态：</label></td>
				<td class="width-35" colspan="3">
					${fns:getDictLabel(wmsSupplier.status, 'use_status', '')}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">备注：</label></td>
				<td class="width-35" colspan="3">
					${wmsSupplier.remarks}
				</td>
			</tr>
		</tbody>
		</table>
	</form:form>
</body>
</html>