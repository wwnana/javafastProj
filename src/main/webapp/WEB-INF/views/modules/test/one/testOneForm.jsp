<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>商品信息(单表)编辑</title>
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
		<h5>商品信息(单表)${not empty testOne.id?'修改':'添加'}</h5>
	</div>
	<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="testOne" action="${ctx}/test/one/testOne/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
			<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 商品分类：</label>
						<div class="col-sm-8">
							<sys:treeselect id="testTree" name="testTree.id" value="${testOne.testTree.id}" labelName="testTree.name" labelValue="${testOne.testTree.name}"
								title="商品分类" url="/test/tree/testTree/treeData" cssClass="form-control required" allowClear="true" notAllowSelectParent="true"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 状态：</label>
						<div class="col-sm-8">
							<form:select path="status" cssClass="form-control">
								<form:options items="${fns:getDictList('use_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 商品名称：</label>
						<div class="col-sm-8">
							<form:input path="name" htmlEscape="false" maxlength="50" class="form-control required"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 商品编码：</label>
						<div class="col-sm-8">
							<form:input path="no" htmlEscape="false" maxlength="30" class="form-control required"/>
						</div>
					</div>
				</div>
			</div>
			
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 基本单位：</label>
						<div class="col-sm-8">
							<form:select path="unitType" cssClass="form-control">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('unit_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 规格：</label>
						<div class="col-sm-8">
							<form:input path="spec" htmlEscape="false" maxlength="30" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 颜色：</label>
						<div class="col-sm-8">
							<form:input path="color" htmlEscape="false" maxlength="30" class="form-control"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 尺寸：</label>
						<div class="col-sm-8">
							<form:input path="size" htmlEscape="false" maxlength="30" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 零售价：</label>
						<div class="col-sm-8">
							<form:input path="salePrice" htmlEscape="false" class="form-control" max="1000000000" min="0.01"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 批发价：</label>
						<div class="col-sm-8">
							<form:input path="batchPrice" htmlEscape="false" class="form-control" max="1000000000" min="0.01"/>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">图片信息</h4>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"> 商品图片：</label>
						<div class="col-sm-10">
							<form:hidden id="productImg" path="productImg" htmlEscape="false" maxlength="500" />
							<sys:ckfinder input="productImg" type="images" uploadPath="/test" selectMultiple="false"/>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">描述信息</h4>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"> 商品描述：</label>
						<div class="col-sm-10">
							<form:textarea id="content" path="content" htmlEscape="false" rows="4" maxlength="10000" class="form-control " style="width:90%;height:200px;"/>
							<sys:umeditor replace="content" uploadPath="/image" maxlength="10000"/>
						</div>
					</div>
				</div>
			</div>
		
			<div class="hr-line-dashed"></div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<div class="col-sm-offset-2 col-sm-10">
							<button id="btnSubmit" class="btn btn-success" type="submit">保存</button>&nbsp;
							<button id="btnCancel" class="btn btn-white" type="button" onclick="history.go(-1)">返回</button>
						</div>
					</div>
				</div>
			</div>
		</form:form>
	</div>
</div>
</div>
</body>
</html>