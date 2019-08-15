<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>供应商管理</title>
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
		<div class="row dashboard-header gray-bg">
				<h5>供应商${not empty wmsSupplier.id?'修改':'添加'}</h5>
		</div>
		<div class="ibox-content" id="ibox-content">		
			<form:form id="inputForm" modelAttribute="wmsSupplier" action="${ctx}/wms/wmsSupplier/save" method="post" class="form-horizontal">
			<form:hidden path="id"/>
			<sys:message content="${message}"/>	
				<h4 class="page-header">基本信息</h4>
				<div class="row">
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label"><font color="red">*</font> 编号</label>
							<div class="col-sm-8">
								<form:input path="no" htmlEscape="false" maxlength="30" class="form-control required"/>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label"><font color="red">*</font> 名称</label>
							<div class="col-sm-8">
								<form:input path="name" htmlEscape="false" maxlength="50" class="form-control required"/>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label"><font color="red">*</font> 分类</label>
							<div class="col-sm-8">
								<sys:treeselect id="supplierType" name="supplierType.id" value="${wmsSupplier.supplierType.id}" labelName="supplierType.name" labelValue="${wmsSupplier.supplierType.name}"
								title="供应商分类" url="/wms/wmsSupplierType/treeData" extId="${wmsSupplier.supplierType.id}" cssClass="form-control required" allowClear="true"/>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">状态</label>
							<div class="col-sm-8">
								<form:select path="status" class="form-control ">
									<form:options items="${fns:getDictList('use_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
								</form:select>
							</div>
						</div>
					</div>
				</div>
				<h4 class="page-header">联系信息</h4>
				<div class="row">
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">联系人</label>
							<div class="col-sm-8">
								<form:input path="contactName" htmlEscape="false" maxlength="30" class="form-control "/>
							</div>
						</div>
					</div>
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">联系电话</label>
							<div class="col-sm-8">
								<form:input path="phone" htmlEscape="false" maxlength="20" class="form-control "/>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">联系邮箱</label>
							<div class="col-sm-8">
								<form:input path="email" htmlEscape="false" maxlength="50" class="form-control email"/>
							</div>
						</div>
					</div>
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">联系QQ</label>
							<div class="col-sm-8">
								<form:input path="qq" htmlEscape="false" maxlength="30" class="form-control"/>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">传真</label>
							<div class="col-sm-8">
								<form:input path="fax" htmlEscape="false" maxlength="30" class="form-control "/>
							</div>
						</div>
					</div>
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">邮编</label>
							<div class="col-sm-8">
								<form:input path="zipcode" htmlEscape="false" maxlength="10" class="form-control  digits"/>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">联系地址</label>
							<div class="col-sm-8">
								<form:input path="address" htmlEscape="false" maxlength="50" class="form-control "/>
							</div>
						</div>
					</div>
				</div>
				<h4 class="page-header">备注信息</h4>
				<div class="row">
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">备注</label>
							<div class="col-sm-8">
								<form:textarea path="remarks" htmlEscape="false" rows="2" maxlength="50" class="form-control "/>
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
</body>
</html>