<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>产品管理</title>
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
			$("#extendInfo").hide();
			
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
<body class="gray-bg">
<div class="">
	<div class="">
		<div class="">
			
		<div class="ibox-content">
	
			<form:form id="inputForm" modelAttribute="wmsProduct" action="${ctx}/wms/wmsProduct/save" method="post" class="form-horizontal">
			<form:hidden path="id"/>
			<sys:message content="${message}"/>	
				<h4 class="page-header">基本信息</h4>
				
				<div class="row">
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label"><font color="red">*</font> 产品名称</label>
							<div class="col-sm-8">
								<form:input path="name" htmlEscape="false" maxlength="50" class="form-control required"/>
							</div>
						</div>
					</div>
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label"><font color="red">*</font> 产品分类</label>
							<div class="col-sm-8">
								<sys:treeselect id="productType" name="productType.id" value="${wmsProduct.productType.id}" labelName="productType.name" labelValue="${wmsProduct.productType.name}"
								title="产品分类" url="/wms/wmsProductType/treeData" extId="${wmsProduct.productType.id}" cssClass="form-control required" allowClear="true"/>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label"><font color="red">*</font> 产品编号</label>
							<div class="col-sm-8">
								<form:input path="no" htmlEscape="false" maxlength="30" class="form-control required"/>
							</div>
						</div>
					</div>
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">产品条码</label>
							<div class="col-sm-8">
								<form:input path="code" htmlEscape="false" maxlength="50" class="form-control "/>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label"><font color="red">*</font> 基本单位</label>
							<div class="col-sm-8">
								<form:select path="unitType" class="form-control required">
									<form:options items="${fns:getDictList('unit_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
								</form:select>
							</div>
						</div>
					</div>
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">产品规格</label>
							<div class="col-sm-8">
								<form:input path="spec" htmlEscape="false" maxlength="30" class="form-control "/>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">标准价格</label>
							<div class="col-sm-8">
								<form:input path="salePrice" htmlEscape="false" class="form-control number" min="0.01"/>
							</div>
						</div>
					</div>
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">最低售价</label>
							<div class="col-sm-8">
								<form:input path="minPrice" htmlEscape="false" class="form-control number" min="0.01"/>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">状态</label>
							<div class="col-sm-8">
								<form:select path="status" class="form-control required">
									<form:options items="${fns:getDictList('use_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
								</form:select>
							</div>
						</div>
					</div>
				</div>
				
				<h4 class="page-header hide">扩展信息<span id="extendBtn" class="pull-right" onclick="javascript:$('#extendInfo').toggle();su.autoHeight();"><i class="fa fa-angle-double-down"></i> 展开</span></h4>
				<div id="extendInfo">
				<div class="row">
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">颜色</label>
							<div class="col-sm-8">
								<form:input path="color" htmlEscape="false" maxlength="30" class="form-control "/>
							</div>
						</div>
					</div>
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">尺寸</label>
							<div class="col-sm-8">
								<form:input path="size" htmlEscape="false" maxlength="30" class="form-control "/>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">批发价</label>
							<div class="col-sm-8">
								<form:input path="batchPrice" htmlEscape="false" class="form-control number" min="0.01"/>
							</div>
						</div>
					</div>
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">参考成本价</label>
							<div class="col-sm-8">
								<form:input path="costPrice" htmlEscape="false" class="form-control number" min="0.01"/>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">自定义属性1</label>
							<div class="col-sm-8">
								<form:input path="customField1" htmlEscape="false" maxlength="30" class="form-control "/>
							</div>
						</div>
					</div>
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">自定义属性2</label>
							<div class="col-sm-8">
								<form:input path="customField2" htmlEscape="false" maxlength="30" class="form-control "/>
							</div>
						</div>
					</div>
				</div>
				
				
				</div>
				
				<h4 class="page-header">产品介绍</h4>
				<div class="row">
					<div class="col-sm-12">
						<div class="form-group">
							<label class="col-sm-2 control-label">产品图片</label>
							<div class="col-sm-10">
								<form:hidden id="productImg" path="productImg" htmlEscape="false" maxlength="255" class=""/>
								<sys:ckfinder input="productImg" type="images" uploadPath="/photo" selectMultiple="false" maxWidth="100" maxHeight="100"/>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-sm-12">
						<div class="form-group">
							<label class="col-sm-2 control-label">产品详情</label>
							<div class="col-sm-10">
								<form:textarea id="content" path="wmsProductData.content" htmlEscape="false" rows="4" class="form-control " style="width:100%;height:200px;"/>
								<sys:umeditor replace="content" uploadPath="/image" maxlength="10000"/>
							</div>
						</div>
					</div>
				</div>
				
				<c:if test="${empty wmsProduct.id}">
				<h4 class="page-header">期初设置</h4>
				<div class="row">
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label"><font color="red">*</font> 期初库存</label>
							<div class="col-sm-8">
								<form:input path="initStock" htmlEscape="false" maxlength="10" class="form-control required digits" min="0"/>
							</div>
						</div>
					</div>
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label"><font color="red">*</font> 存入仓库</label>
							<div class="col-sm-8">		
								<sys:spinnerselect id="initWarehouse" name="initWarehouse.id" value="${wmsProduct.initWarehouse.id}" labelName="initWarehouse.name" labelValue="${wmsProduct.initWarehouse.name}" 
									title="仓库" url="${ctx}/wms/wmsWarehouse/getSelectData" cssClass="form-control required" allowEmpty="false"></sys:spinnerselect>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">最低库存量</label>
							<div class="col-sm-8">
								<form:input path="minStock" htmlEscape="false" maxlength="11" class="form-control digits" min="0"/>
							</div>
						</div>
					</div>
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">最高库存量</label>
							<div class="col-sm-8">
								<form:input path="maxStock" htmlEscape="false" maxlength="11" class="form-control digits" min="0"/>
							</div>
						</div>
					</div>
				</div>
				</c:if>
				
				
		</form:form>
		</div>
</div>
</div>
</div>
</body>
</html>