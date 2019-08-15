<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>产品查看</title>
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
<body class="">
<div class="" >
		<div class="row">
			
			<div class="">
	
	<div class="ibox-content">
	<form:form id="inputForm" modelAttribute="wmsProduct" action="${ctx}/wms/wmsProduct/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>	
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
		<tbody>
			<tr>
				<td class="width-15 active"><label class="pull-right">产品名称：</label></td>
				<td class="width-35" colspan="3">
					${wmsProduct.name}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">产品分类：</label></td>
				<td class="width-35" colspan="3">
					${wmsProduct.productType.name}
				</td>
			</tr>
			<tr>
				<td class="width-15 active" width="10%"><label class="pull-right">产品编号：</label></td>
				<td class="width-35" width="40%">
					${wmsProduct.no}
				</td>
				<td class="width-15 active" width="10%"><label class="pull-right">产品条码：</label></td>
				<td class="width-35" width="40%">
					${wmsProduct.code}
				</td>
			</tr>
			
			<tr>
				<td class="width-15 active"><label class="pull-right">基本单位：</label></td>
				<td class="width-35">
					${fns:getDictLabel(wmsProduct.unitType, 'unit_type', '')}
				</td>
				<td class="width-15 active"><label class="pull-right">规格：</label></td>
				<td class="width-35">
					${wmsProduct.spec}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">颜色：</label></td>
				<td class="width-35">
					${wmsProduct.color}
				</td>
				<td class="width-15 active"><label class="pull-right">尺寸：</label></td>
				<td class="width-35">
					${wmsProduct.size}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">自定义属性1：</label></td>
				<td class="width-35">
					${wmsProduct.customField1}
				</td>
				<td class="width-15 active"><label class="pull-right">自定义属性2：</label></td>
				<td class="width-35">
					${wmsProduct.customField2}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">标准价格：</label></td>
				<td class="width-35">
					${wmsProduct.salePrice}
				</td>
				<td class="width-15 active"><label class="pull-right">批发价：</label></td>
				<td class="width-35">
					${wmsProduct.batchPrice}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">最低售价：</label></td>
				<td class="width-35">
					${wmsProduct.minPrice}
				</td>
				<td class="width-15 active"><label class="pull-right">参考成本价：</label></td>
				<td class="width-35">
					${wmsProduct.costPrice}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">最低库存量：</label></td>
				<td class="width-35">
					${wmsProduct.minStock}
				</td>
				<td class="width-15 active"><label class="pull-right">最高库存量：</label></td>
				<td class="width-35">
					${wmsProduct.maxStock}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">状态：</label></td>
				<td class="width-35">
					${fns:getDictLabel(wmsProduct.status, 'use_status', '')}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">产品图片：</label></td>
				<td class="width-35" colspan="3">
					<form:hidden id="productImg" path="productImg" htmlEscape="false" maxlength="255" class="input-xlarge"/>
					<sys:ckfinder input="productImg" type="images" uploadPath="/image" selectMultiple="false" maxWidth="100" maxHeight="100" readonly="true"/>
					
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">备注：</label></td>
				<td class="width-35" colspan="3">
					${wmsProduct.remarks}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">创建人：</label></td>
				<td class="width-35">
					${wmsProduct.createBy.name}
				</td>
				<td class="width-15 active"><label class="pull-right">创建时间：</label></td>
				<td class="width-35">
					<fmt:formatDate value="${wmsProduct.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
			</tr>
		</tbody>
		</table>
		
	</form:form>
	</div></div></div></div>
</body>
</html>