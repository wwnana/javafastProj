<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>知识编辑</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		var validateForm;
		function doSubmit(){//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
		  if(validateForm.form()){
			  $("#status").val("1");
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
		function doSave(){
			if(validateForm.form()){
				$("#status").val("0");
			  	$("#inputForm").submit();
			  	return true;
		  	}
	
		  	return false;
		}
	</script>
</head>
<body class="gray-bg">
<div class="">
<div class="">
	<div class="ibox-title">
		<h5>知识${not empty kmsArticle.id?'修改':'添加'}</h5>
	</div>
	<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="kmsArticle" action="${ctx}/kms/kmsArticle/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<form:hidden path="status"/>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"><font color="red">*</font> 分类：</label>
						<div class="col-sm-10">
							<sys:treeselect id="kmsCategory" name="kmsCategory.id" value="${kmsArticle.kmsCategory.id}" labelName="kmsCategory.name" labelValue="${kmsArticle.kmsCategory.name}"
						title="栏目" url="/kms/kmsCategory/treeData" extId="${kmsArticle.kmsCategory.id}" cssClass="form-control required" allowClear="true"/>		
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"><font color="red">*</font> 标题：</label>
						<div class="col-sm-10">
							<form:input path="title" htmlEscape="false" maxlength="50" class="form-control required"/>
						</div>
					</div>
				</div>
			</div>
			
			
			
			
			<%-- 
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"><font color="red">*</font> 摘要：</label>
						<div class="col-sm-10">
							<form:textarea path="description" htmlEscape="false" rows="4" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label">外部链接：</label>
						<div class="col-sm-10">
							<form:input path="link" htmlEscape="false" maxlength="250" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label">缩略图：</label>
						<div class="col-sm-10">
							<form:hidden id="image" path="image" htmlEscape="false" maxlength="250" class="width100"/>
							<sys:ckfinder input="image" type="files" uploadPath="/image" selectMultiple="true"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label">关键字：</label>
						<div class="col-sm-10">
							<form:input path="keywords" htmlEscape="false" maxlength="50" class="form-control"/>
							<span class="help-inline">多个关键字请用英文","隔开</span>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label">排序：</label>
						<div class="col-sm-10">
							<form:input path="sort" htmlEscape="false" maxlength="11" class="form-control digits"/>
							<span class="help-inline">降序，越大越靠前</span>
						</div>
					</div>
				</div>
			</div>
			--%>
			
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label">正文：</label>
						<div class="col-sm-10">
							<form:textarea id="content" htmlEscape="true" path="articleData.content" rows="4" maxlength="10000" style="width:100%;height:500px;"/>
							<sys:umeditor replace="content" uploadPath="/image" height="100px" maxlength="10000"/>
						</div>
					</div>
				</div>
			</div>
			
			
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label">附件：</label>
						<div class="col-sm-10">
							<form:hidden id="files" path="articleData.files" htmlEscape="false" maxlength="1000" class="form-control"/>
							<sys:ckfinder input="files" type="files" uploadPath="/file" selectMultiple="true" fileNumLimit="2"/>
						</div>
					</div>
				</div>
			</div>
			
			<div class="hr-line-dashed"></div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<div class="col-sm-offset-2 col-sm-10">
							<button id="btnSubmit" class="btn btn-success" type="button" onclick="doSubmit()">保存并发布</button>&nbsp;
							<button id="btnSave" class="btn btn-white" type="button" onclick="doSave()">保存</button>&nbsp;
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