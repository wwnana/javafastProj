<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>菜单管理</title>
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
			$("#name").focus();
			validateForm = $("#inputForm").validate({
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
			<h5>菜单${not empty menu.id?'修改':'添加'}</h5>
		</div>
		<div class="ibox-content">
			<sys:message content="${message}"/>
			
			
			<form:form id="inputForm" modelAttribute="menu" action="${ctx}/sys/menu/save" method="post" class="form-horizontal">
				<form:hidden path="id"/>
				<h4 class="page-header">基本信息</h4>
				<div class="row">
					<div class="col-sm-6">
						<div class="form-group">
			            	<label class="col-sm-4 control-label">上级菜单</label>
			            	 <div class="col-sm-8">
			                 	<sys:treeselect id="menu" name="parent.id" value="${menu.parent.id}" labelName="parent.name" labelValue="${menu.parent.name}"
									title="菜单" url="/sys/menu/treeData" extId="${menu.id}" cssClass="form-control required"/>
			                 </div>
			            </div>
		            </div>
		            <div class="col-sm-6">
						<div class="form-group">
			            	<label class="col-sm-4 control-label"><font color="red">*</font>菜单名称</label>
			            	 <div class="col-sm-8">
			                      <form:input path="name" htmlEscape="false" maxlength="50" class="required form-control "/>
			                 </div>
			            </div>
		            </div>
		        </div>
		        <div class="row">
					<div class="col-sm-6">
						<div class="form-group">
			            	<label class="col-sm-4 control-label">菜单链接</label>
			            	 <div class="col-sm-8">
			                 	<form:input path="href" htmlEscape="false" maxlength="2000" class="form-control "/>
								<span class="help-inline">点击菜单跳转的页面</span>
			                 </div>
			            </div>
		            </div>
		            <div class="col-sm-6">
						<div class="form-group">
			            	<label class="col-sm-4 control-label">菜单目标</label>
			            	 <div class="col-sm-8">
			                      <form:input path="target" htmlEscape="false" maxlength="10" class="form-control "/>
								  <span class="help-inline">链接打开的目标窗口，默认：mainFrame</span>
			                 </div>
			            </div>
		            </div>
		        </div>
		        <div class="row">
					<div class="col-sm-6">
						<div class="form-group">
			            	<label class="col-sm-4 control-label">菜单图标</label>
			            	 <div class="col-sm-8">
			                 	<sys:iconselect id="icon" name="icon" value="${menu.icon}"/>
			                 </div>
			            </div>
		            </div>
		            <div class="col-sm-6">
						<div class="form-group">
			            	<label class="col-sm-4 control-label">排序</label>
			            	 <div class="col-sm-8">
			                    <form:input path="sort" htmlEscape="false" maxlength="11" class="required digits form-control"/>
								<span class="help-inline">排列顺序，升序。</span>
			                 </div>
			            </div>
		            </div>
		        </div>
		        <div class="row">
					<div class="col-sm-6">
						<div class="form-group">
			            	<label class="col-sm-4 control-label">可见</label>
			            	 <div class="col-sm-8" style="margin-top: 5px;">
			                 	<form:radiobuttons path="isShow" items="${fns:getDictList('show_hide')}" itemLabel="label" itemValue="value" htmlEscape="false" class="required i-checks "/>
								<span class="help-inline">该菜单或操作是否显示到系统菜单中</span>
			                 </div>
			            </div>
		            </div>
		            <div class="col-sm-6">
						<div class="form-group">
			            	<label class="col-sm-4 control-label">权限标识</label>
			            	 <div class="col-sm-8">
			                    <form:input path="permission" htmlEscape="false" maxlength="100" class="form-control "/>
								<span class="help-inline">控制器中定义的权限标识，如：@RequiresPermissions("权限标识")，多个请用英文“,”隔开</span>
			                 </div>
			            </div>
		            </div>
		        </div>
		        <h4 class="page-header">其他信息</h4>
		        <div class="row">
					<div class="col-sm-12">
						<div class="form-group">
			            	<label class="col-sm-2 control-label">备注</label>
			            	 <div class="col-sm-10">
			                 	<form:textarea path="remarks" htmlEscape="false" rows="3" maxlength="200" class="form-control "/>
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