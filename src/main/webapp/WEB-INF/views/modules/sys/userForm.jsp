<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>用户管理</title>
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
			$("#no").focus();
			validateForm = $("#inputForm").validate({
				rules: {
					loginName: {remote: "${ctx}/sys/user/checkLoginName?oldLoginName=" + encodeURIComponent('${user.loginName}')}, //设置了远程验证，在初始化时必须预先调用一次。
					mobile: {remote: "${ctx}/sys/user/checkMobile?oldMobile="+ encodeURIComponent('${user.mobile}')}
				},
				messages: {
					loginName: {remote: "用户登录名已存在"},
					mobile: {remote: "手机号码已被占用"},
					confirmNewPassword: {equalTo: "输入与上面相同的密码"}
				},
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

			//在ready函数中预先调用一次远程校验函数，是一个无奈的回避案。(刘高峰）
			//否则打开修改对话框，不做任何更改直接submit,这时再触发远程校验，耗时较长，
			//submit函数在等待远程校验结果然后再提交，而layer对话框不会阻塞会直接关闭同时会销毁表单，因此submit没有提交就被销毁了导致提交表单失败。
			$("#inputForm").validate().element($("#loginName"));
		});

	
	</script>
</head>

<body class="">
<div class="">
	<div class="">
		
		<div class="ibox-content">
			<sys:message content="${message}"/>
			<form:form id="inputForm" modelAttribute="user" action="${ctx}/sys/user/save" method="post" class="form-horizontal">
				<form:hidden path="id"/>
				<h4 class="page-header">基本信息</h4>
				<div class="row">
					<div class="col-sm-6">
						<div class="form-group">
			            	<label class="col-sm-4 control-label"><font color="red">*</font>归属公司</label>
			            	 <div class="col-sm-8">
			                       <sys:treeselect id="company" name="company.id" value="${user.company.id}" labelName="company.name" labelValue="${user.company.name}"
									title="公司" url="/sys/office/treeData?type=1" cssClass="form-control required"/>
			                 </div>
			            </div>
		            </div>
		            <div class="col-sm-6">
						<div class="form-group">
			            	<label class="col-sm-4 control-label"><font color="red">*</font>归属部门</label>
			            	 <div class="col-sm-8">
			                      <sys:treeselect id="office" name="office.id" value="${user.office.id}" labelName="office.name" labelValue="${user.office.name}"
							title="部门" url="/sys/office/treeData?type=2" cssClass="form-control required" notAllowSelectParent="true"/>
			                 </div>
			            </div>
		            </div>
		        </div>
		        <div class="row">
					<div class="col-sm-6">
						<div class="form-group">
			            	<label class="col-sm-4 control-label"><font color="red">*</font>工号</label>
							<div class="col-sm-8">
								<form:input path="no" htmlEscape="false" maxlength="50" class="form-control required"/>
							</div>
			            </div>
		            </div>
		            <div class="col-sm-6">
						<div class="form-group">
			            	<label class="col-sm-4 control-label"><font color="red">*</font>姓名</label>
			            	<div class="col-sm-8">
								<form:input path="name" htmlEscape="false" maxlength="30" class="form-control required"/>
							</div>
			            </div>
		            </div>
		        </div>
		        <div class="row">
					<div class="col-sm-6">
						<div class="form-group">
			            	<label class="col-sm-4 control-label">邮箱</label>
							<div class="col-sm-8">
								<form:input path="email" htmlEscape="false" maxlength="50" class="form-control email"/>
							</div>
			            </div>
		            </div>
		            <div class="col-sm-6">
						<div class="form-group">
			            	<label class="col-sm-4 control-label">电话</label>
			            	<div class="col-sm-8">
								<form:input path="phone" htmlEscape="false" maxlength="50" class="form-control"/>
							</div>
			            </div>
		            </div>
		        </div>
		        <h4 class="page-header">账号信息</h4>
				<div class="row">
					<div class="col-sm-6">
						<div class="form-group">
			            	<label class="col-sm-4 control-label"><font color="red">*</font>登录名</label>
							<div class="col-sm-8">
								<input id="oldLoginName" name="oldLoginName" type="hidden" value="${user.loginName}">
							 	<form:input path="loginName" htmlEscape="false" maxlength="30" class="form-control required"/>
							</div>
			            </div>
		            </div>
		            <div class="col-sm-6">
						<div class="form-group">
			            	<label class="col-sm-4 control-label"><font color="red">*</font>手机号</label>
			            	<div class="col-sm-8">
								<form:input path="mobile" htmlEscape="false" maxlength="11" class="form-control digits" minlength="11" />
							</div>
			            </div>
		            </div>
		        </div>
		        <div class="row">
					<div class="col-sm-6">
						<div class="form-group">
			            	<label class="col-sm-4 control-label"><c:if test="${empty user.id}"><font color="red">*</font></c:if>密码</label>
							<div class="col-sm-8">
								<input id="newPassword" name="newPassword" type="password" value="" maxlength="50" minlength="3" class="form-control ${empty user.id?'required':''}"/>
								<c:if test="${not empty user.id}"><span class="help-inline">若不修改密码，请留空。</span></c:if>
							</div>
			            </div>
		            </div>
		            <div class="col-sm-6">
						<div class="form-group">
			            	<label class="col-sm-4 control-label"><c:if test="${empty user.id}"><font color="red">*</font></c:if>确认密码</label>
			            	<div class="col-sm-8">
								<input id="confirmNewPassword" name="confirmNewPassword" type="password"  class="form-control ${empty user.id?'required':''}" value="" maxlength="50" minlength="3" equalTo="#newPassword"/>
							</div>
			            </div>
		            </div>
		        </div>
				
		        <div class="row">
					<div class="col-sm-6">
						<div class="form-group">
			            	<label class="col-sm-4 control-label">用户类型</label>
							<div class="col-sm-8">
								<form:select path="userType"  class="form-control">
									<form:options items="${fns:getDictList('sys_user_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
								</form:select>
							</div>
			            </div>
		            </div>
		            <div class="col-sm-6">
						<div class="form-group">
			            	<label class="col-sm-4 control-label">用户状态</label>
			            	<div class="col-sm-8">
								<form:select path="loginFlag"  class="form-control">
									<form:options items="${fns:getDictList('login_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
								</form:select>
							</div>
			            </div>
		            </div>
		        </div>
		        <h4 class="page-header">角色授权</h4>
		        <div class="row">
					<div class="col-sm-12">
						<div class="form-group">
			            	<label class="col-sm-2 control-label">可选角色</label>
							<div class="col-sm-10" style="margin-top: 5px;">
								<form:checkboxes path="roleIdList" items="${allRoles}" itemLabel="name" itemValue="id" htmlEscape="false" cssClass="i-checks required"/>
				         		<label id="roleIdList-error" class="error" for="roleIdList"></label>
							</div>
			            </div>
		            </div>
		        </div>
		        <h4 class="page-header">其他信息</h4>
		        <div class="row">
					<div class="col-sm-12">
						<div class="form-group">
			            	<label class="col-sm-2 control-label">头像</label>
							<div class="col-sm-10">
								<form:hidden id="nameImage" path="photo" htmlEscape="false" maxlength="255" class="input-xlarge"/>
								<sys:ckfinder input="nameImage" type="images" uploadPath="/image" selectMultiple="false" maxWidth="100" maxHeight="100"/>
							</div>
			            </div>
		            </div>
		        </div>
		        <div class="row">
					<div class="col-sm-12">
						<div class="form-group">
			            	<label class="col-sm-2 control-label">备注</label>
							<div class="col-sm-8">
								<form:textarea path="remarks" htmlEscape="false" rows="2" maxlength="200" class="form-control "/>
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