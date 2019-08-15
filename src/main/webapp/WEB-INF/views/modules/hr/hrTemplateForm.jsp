<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>模板编辑</title>
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
		<h5>模板${not empty hrTemplate.id?'修改':'添加'}</h5>
	</div>
	<div class="ibox-content">
		<div class="alert alert-warning">
             	系统模板不可编辑
        </div>
        <!-- 工具栏 -->
		<div class="row">
			<div class="col-sm-12">
				<div class="pull-right">
					<div class="btn-group">
						
					</div>
				</div>
				<div class="pull-left">
					<shiro:hasPermission name="hr:hrResume:add">
						<table:addRow url="${ctx}/hr/hrTemplate/form" title="模板" pageModel="page" label="新增模板"></table:addRow><!-- 增加按钮 -->
					</shiro:hasPermission>
				</div>
			</div>
		</div>			
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="hrTemplate" action="${ctx}/hr/hrTemplate/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
			<h4 class="page-header">模板配置</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 模板分类：</label>
						<div class="col-sm-8">
							<form:select path="type" cssClass="form-control required">
								<form:options items="${fns:getDictList('hr_template_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 模板名称：</label>
						<div class="col-sm-8">
							<form:input path="name" htmlEscape="false" maxlength="50" class="form-control required"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 标题：</label>
						<div class="col-sm-8">
							<form:input path="title" htmlEscape="false" maxlength="50" class="form-control required"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"> 模板内容：</label>
						<div class="col-sm-10">
							<form:textarea id="content" path="content" htmlEscape="false" rows="4" maxlength="10000" class="form-control " style="width:80%;height:300px;"/>
							<sys:umeditor replace="content" uploadPath="/file" maxlength="10000"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 是否默认：</label>
						<div class="col-sm-8">
							<form:select path="isDefault" cssClass="form-control">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
			</div>
		
			<div class="hr-line-dashed"></div>
			<div class="form-actions">
				<c:if test="${not empty hrTemplate.id}">
				<c:if test="${hrTemplate.accountId eq fns:getSysAccount().id}">
				<shiro:hasPermission name="hr:hrResume:edit">
					<button id="btnSubmit" class="btn btn-success" type="submit">保存</button>&nbsp;
				</shiro:hasPermission>
				</c:if>
				</c:if>
				<c:if test="${empty hrTemplate.id}">
				<shiro:hasPermission name="hr:hrResume:edit">
					<button id="btnSubmit" class="btn btn-success" type="submit">保存</button>&nbsp;
				</shiro:hasPermission>
				</c:if>
				<button id="btnCancel" class="btn btn-white" type="button" onclick="history.go(-1)">返回</button>
			</div>
		</form:form>
	</div>
</div>
</div>
</body>
</html>