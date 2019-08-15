<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>业务数据查看</title>
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
	<form:form id="inputForm" modelAttribute="testData" action="${ctx}/test/grid/testData/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>	
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
		<tbody>
			<tr>
				<td class="width-15 active"><label class="pull-right">姓名：</label></td>
				<td class="width-35">
					${testData.name}
				</td>
				<td class="width-15 active"><label class="pull-right">性别：</label></td>
				<td class="width-35">
					${fns:getDictLabel(testData.sex, 'sex', '')}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">年龄：</label></td>
				<td class="width-35">
					${testData.age}
				</td>
				<td class="width-15 active"><label class="pull-right">手机号码：</label></td>
				<td class="width-35">
					${testData.mobile}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">电子邮箱：</label></td>
				<td class="width-35">
					${testData.email}
				</td>
				<td class="width-15 active"><label class="pull-right">联系地址：</label></td>
				<td class="width-35">
					${testData.address}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">备注：</label></td>
				<td class="width-35" colspan="3">
					${testData.remarks}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">创建者：</label></td>
				<td class="width-35">
					${testData.createBy.name}
				</td>
				<td class="width-15 active"><label class="pull-right">创建时间：</label></td>
				<td class="width-35">
					<fmt:formatDate value="${testData.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
			</tr><tr>
				<td class="width-15 active"><label class="pull-right">更新者：</label></td>
				<td class="width-35">
					${testData.updateBy.name}
				</td>
				<td class="width-15 active"><label class="pull-right">更新时间：</label></td>
				<td class="width-35">
					<fmt:formatDate value="${testData.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
			</tr>
			<tr>
			</tr>
		</tbody>
		</table>
	</form:form>
</body>
</html>