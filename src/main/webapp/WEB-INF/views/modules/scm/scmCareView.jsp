<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>客户关怀查看</title>
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
	<form:form id="inputForm" modelAttribute="scmCare" action="${ctx}/scm/scmCare/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<table class="table table-bordered table-condensed dataTables-example dataTable no-footer">
		<tbody>
			<tr>
				<td class="width-15 active"><label class="pull-right">主题：</label></td>
				<td class="width-35"">
					${scmCare.name}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">客户：</label></td>
				<td class="width-35">
					${scmCare.customer.name}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">联系人：</label></td>
				<td class="width-35">
					${scmCare.contacterName}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">关怀类型：</label></td>
				<td class="width-35">
					${fns:getDictLabel(scmCare.careType, 'care_type', '')}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">关怀日期：</label></td>
				<td class="width-35">
					<fmt:formatDate value="${scmCare.careDate}" pattern="yyyy-MM-dd"/>
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">关怀内容：</label></td>
				<td class="width-35">
					${scmCare.careNote}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">负责人：</label></td>
				<td class="width-35" >
					${scmCare.ownBy.name}
				</td>
				
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">创建者：</label></td>
				<td class="width-35">
					${scmCare.createBy.name}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">创建时间：</label></td>
				<td class="width-35">
					<fmt:formatDate value="${scmCare.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">备注信息：</label></td>
				<td class="width-35">
					${scmCare.remarks}
				</td>
			</tr>
			<tr>
			</tr>
		</tbody>
		</table>
	</form:form>
</body>
</html>