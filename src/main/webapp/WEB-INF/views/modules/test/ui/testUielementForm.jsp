<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>UI标签编辑</title>
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
<body class="gray-bg">
<div class="wrapper-content">
<div class="ibox">
	<div class="ibox-title">
		<h5>UI标签${not empty testUielement.id?'修改':'添加'}</h5>
	</div>
	<div class="ibox-content">
	<sys:message content="${message}"/>
	
	<form:form id="inputForm" modelAttribute="testUielement" action="${ctx}/test/ui/testUielement/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>			
			<h4 class="page-header">选择器</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 列表选择器：</label>
						<div class="col-sm-8">
							<sys:tableselect id="product" name="product.id" value="${testUielement.product.id}" labelName="product.name" labelValue="${testUielement.product.name}" 
								title="商品" url="${ctx}/test/one/testOne/selectList" cssClass="form-control required" dataMsgRequired="必选"  allowClear="false" allowInput="false"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 树形选择器：</label>
						<div class="col-sm-8">
							<sys:treeselect id="productType" name="productType.id" value="${testUielement.productType.id}" labelName="productType.name" labelValue="${testUielement.productType.name}"
						title="商品分类" url="/test/tree/testTree/treeData" extId="${testUielement.productType.id}" cssClass="form-control required" allowClear="true"/>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">绑定数据字典</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">数据字典radio：</label>
						<div class="col-sm-8">
							<form:radiobuttons path="sex" items="${fns:getDictList('sex')}" itemLabel="label" itemValue="value" htmlEscape="false" class="i-checks"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">数据字典select：</label>
						<div class="col-sm-8">
							<form:select path="sex2" cssClass="form-control">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('sex')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">多选下拉标签：</label>
						<div class="col-sm-8">
							<form:select path="tags" cssClass="form-control" multiple="multiple">
								<form:options items="${fns:getDictList('color')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">数据字典checkbox：</label>
						<div class="col-sm-8">
							<form:checkboxes path="tags2" items="${fns:getDictList('color')}" itemLabel="label" itemValue="value" htmlEscape="false" class="i-checks"/>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">人员、部门选择</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">人员选择：</label>
						<div class="col-sm-8">
							<sys:treeselect id="user" name="user.id" value="${testUielement.user.id}" labelName="user.name" labelValue="${testUielement.user.name}"
								title="用户" url="/sys/office/treeData?type=3" cssClass="form-control " allowClear="true" notAllowSelectParent="true"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">部门选择：</label>
						<div class="col-sm-8">
							<sys:treeselect id="office" name="office.id" value="${testUielement.office.id}" labelName="office.name" labelValue="${testUielement.office.name}"
						title="部门" url="/sys/office/treeData?type=2" cssClass="form-control " allowClear="true" notAllowSelectParent="true"/>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">图片、文件上传</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">单图片上传：</label>
						<div class="col-sm-8">
							<form:hidden id="image" path="image" htmlEscape="false" maxlength="1000" class="input-xlarge"/>
					<sys:ckfinder input="image" type="images" uploadPath="/test" selectMultiple="false"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">多图片上传：</label>
						<div class="col-sm-8">
							<form:hidden id="image2" path="image2" htmlEscape="false" maxlength="1000" class="input-xlarge"/>
					<sys:ckfinder input="image2" type="images" uploadPath="/test" selectMultiple="true"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">单文件上传：</label>
						<div class="col-sm-8">
							<form:hidden id="file" path="file" htmlEscape="false" maxlength="1000" class="input-xlarge"/>
							<sys:ckfinder input="file" type="files" uploadPath="/test" selectMultiple="false"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">多文件上传：</label>
						<div class="col-sm-8">
							<form:hidden id="file2" path="file2" htmlEscape="false" maxlength="1000" class="input-xlarge"/>
							<sys:ckfinder input="file2" type="files" uploadPath="/test" selectMultiple="true"/>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">富文本编辑器</h4>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label">富文本编辑器：</label>
						<div class="col-sm-10">
							<form:textarea id="content" path="content" htmlEscape="false" rows="4" maxlength="10000" class="form-control " style="width:50%;height:100px;"/>
							<sys:umeditor replace="content" uploadPath="/test" maxlength="10000"/>
						</div>
					</div>
				</div>
			</div>
			
		
		<br>
			<div class="form-actions">
				<shiro:hasPermission name="test:ui:testUielement:edit"><input id="btnSubmit" class="btn btn-success" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
				<input id="btnCancel" class="btn btn-white" type="button" value="返 回" onclick="history.go(-1)"/>
			</div>
		<br>
	</form:form>
	</div>
</div>
</div>
</body>
</html>