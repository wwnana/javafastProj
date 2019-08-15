<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>联系人查看</title>
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
	<form:form id="inputForm" modelAttribute="crmContacter" action="${ctx}/crm/crmContacter/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>	
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
		<tbody>
			<tr>
				<td class="width-15 active" width="10%"><label class="pull-right">所属客户：</label></td>
				<td class="width-35" width="40%">
					${crmContacter.customer.name}
				</td>
				<td class="width-15 active" width="10%"><label class="pull-right">姓名：</label></td>
				<td class="width-35" width="40%">
					${crmContacter.name}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">性别：</label></td>
				<td class="width-35">
					${fns:getDictLabel(crmContacter.sex, 'sex', '')}
				</td>
				<td class="width-15 active"><label class="pull-right">生日：</label></td>
				<td class="width-35">
					<fmt:formatDate value="${crmContacter.birthday}" pattern="yyyy-MM-dd"/>
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">职务：</label></td>
				<td class="width-35">
					${crmContacter.jobType}
				</td>
				<td class="width-15 active"><label class="pull-right">手机：</label></td>
				<td class="width-35">
					${crmContacter.mobile}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">电话：</label></td>
				<td class="width-35">
					${crmContacter.tel}
				</td>
				<td class="width-15 active"><label class="pull-right">邮箱：</label></td>
				<td class="width-35">
					${crmContacter.email}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">微信：</label></td>
				<td class="width-35">
					${crmContacter.wx}
				</td>
				<td class="width-15 active"><label class="pull-right">QQ：</label></td>
				<td class="width-35">
					${crmContacter.qq}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">备注：</label></td>
				<td class="width-35" colspan="3">
					${crmContacter.remarks}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">创建人：</label></td>
				<td class="width-35">
					${crmContacter.createBy.name}
				</td>
				<td class="width-15 active"><label class="pull-right">创建时间：</label></td>
				<td class="width-35">
					<fmt:formatDate value="${crmContacter.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
			</tr>
		</tbody>
		</table>
	</form:form>
</body>
</html>