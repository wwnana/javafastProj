<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>企业帐户管理</title>
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
<body class="hideScroll">
	<form:form id="inputForm" modelAttribute="sysAccount" action="${ctx}/sys/sysAccount/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>	
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
		<tbody>
		<tr>
			</tr><tr>
				<td class="width-15 active"><label class="pull-right">公司名称：</label></td>
				<td class="width-35">
				<form:input path="name" htmlEscape="false" maxlength="30" class="form-control input-xlarge"/>
			</td>
			
				<td class="width-15 active"><label class="pull-right">手机：</label></td>
				<td class="width-35">
				<form:input path="mobile" htmlEscape="false" maxlength="20" class="form-control input-xlarge"/>
			</td>
			</tr><tr>
				<td class="width-15 active"><label class="pull-right">电话：</label></td>
				<td class="width-35">
				<form:input path="phone" htmlEscape="false" maxlength="20" class="form-control input-xlarge"/>
			</td>
			
				<td class="width-15 active"><label class="pull-right">邮箱：</label></td>
				<td class="width-35">
				<form:input path="email" htmlEscape="false" maxlength="30" class="form-control input-xlarge"/>
			</td>
			</tr><tr>
				<td class="width-15 active"><label class="pull-right">管理员账号：</label></td>
				<td class="width-35">
				<form:input path="adminUserId" htmlEscape="false" maxlength="64" class="form-control input-xlarge"/>
			</td>
			
				
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">授权用户数：</label></td>
				<td class="width-35">
					<form:input path="maxUserNum" htmlEscape="false" maxlength="11" class="form-control input-xlarge digits"/>
				</td>
				<td class="width-15 active"><label class="pull-right">当前用户数：</label></td>
				<td class="width-35">
					<form:input path="nowUserNum" htmlEscape="false" maxlength="11" class="form-control input-xlarge digits"/>
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">可用状态：</label></td>
				<td class="width-35">
					<form:select path="status" cssClass="form-control input-xlarge">
						<form:option value="" label=""/>
						<form:options items="${fns:getDictList('use_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
				</td>
				<td class="width-15 active"><label class="pull-right">开通短信功能：</label></td>
				<td class="width-35">
					<form:select path="smsStatus" cssClass="form-control input-xlarge">
						<form:option value="" label=""/>
						<form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">备注：</label></td>
				<td class="width-35">
				<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="form-control "/>
			</td>
		</tr><tr>
				<td class="width-15 active"><label class="pull-right">应用名称：</label></td>
				<td class="width-35">
					${sysAccount.systemName }
			</td>
			
				<td class="width-15 active"><label class="pull-right">API Secret：</label></td>
				<td class="width-35">
					${sysAccount.apiSecret }
			</td>
		</tr>
		
			<tr>
				<td class="width-15 active"><label class="pull-right">授权方应用id：</label></td>
				<td class="width-35">
					<form:input path="agentid" htmlEscape="false" maxlength="50" class="form-control input-xlarge digits"/>
				</td>
			
				<td class="width-15 active"><label class="pull-right">授权管理员的userid：</label></td>
				<td class="width-35">
					<form:input path="userid" htmlEscape="false" maxlength="50" class="form-control input-xlarge"/>
				</td>
			
			</tr>
		</tbody>
	</table>	
	</form:form>
</body>
</html>