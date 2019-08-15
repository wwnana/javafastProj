<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>联系人管理</title>
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
<body class="white-bg">
<div class="">
	<div class="">
		
		<div class="ibox-content">
			<form:form id="inputForm" modelAttribute="crmContacter" action="${ctx}/crm/crmContacter/save" method="post" class="form-horizontal">
			<form:hidden path="id"/>
			<sys:message content="${message}"/>	
			
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 姓名</label>
						<div class="col-sm-8">
							<form:input path="name" htmlEscape="false" maxlength="30" class="form-control required"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 所属客户</label>
						<div class="col-sm-8">
							<sys:tableselect id="customer" name="customer.id" value="${crmContacter.customer.id}" labelName="customer.name" labelValue="${crmContacter.customer.name}" 
								title="客户" url="${ctx}/crm/crmCustomer/selectList" cssClass="form-control required" dataMsgRequired="必选"  allowClear="false" allowInput="false"/>
						</div>
					</div>
				</div>
			</div>
			
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 角色</label>
						<div class="col-sm-8">
							<form:select path="roleType" class="form-control">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('role_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">职务</label>
						<div class="col-sm-8">
							<form:input path="jobType" htmlEscape="false" maxlength="20" class="form-control "/>
						</div>
					</div>
				</div>
				
			</div>
			
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">手机</label>
						<div class="col-sm-8">
							<form:input path="mobile" htmlEscape="false" maxlength="20" class="form-control "/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">电话</label>
						<div class="col-sm-8">
							<form:input path="tel" htmlEscape="false" maxlength="20" class="form-control "/>
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
						<label class="col-sm-4 control-label">QQ</label>
						<div class="col-sm-8">
							<form:input path="qq" htmlEscape="false" maxlength="20" class="form-control "/>
						</div>
					</div>
				</div>
				<%-- 
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">微信</label>
						<div class="col-sm-8">
							<form:input path="wx" htmlEscape="false" maxlength="20" class="form-control "/>
						</div>
					</div>
				</div>
				--%>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">性别</label>
						<div class="col-sm-8">
							<form:radiobuttons path="sex" items="${fns:getDictList('sex')}" itemLabel="label" itemValue="value" htmlEscape="false" class="i-checks"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">生日</label>
						<div class="col-sm-8">
							<div class="input-group date datepicker">
								<input name="birthday" type="text" readonly="readonly" class="form-control" value="<fmt:formatDate value="${crmContacter.birthday}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
	                     		<span class="input-group-addon">
	                             	<span class="fa fa-calendar"></span>
	                     		</span>
                     		</div>
						</div>
					</div>
				</div>
			</div>
			
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label">备注</label>
						<div class="col-sm-10">
							<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="50" class="form-control"/>
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