<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>UI标签查看</title>
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
		<h5>UI标签查看</h5>
	</div>
	<div class="ibox-content">
	<sys:message content="${message}"/>
	<div class="row">
		<div class="col-sm-12">
			<div class="text-center p-lg">
            	<h2>UI标签</h2>
            </div>
		</div>
	</div>
	<form:form id="inputForm" modelAttribute="testUielement" action="${ctx}/test/ui/testUielement/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<table class="table table-bordered table-condensed dataTables-example dataTable no-footer">
		<tbody>
			<tr>
				<td class="width-15 active"><label class="pull-right">列表选择器：</label></td>
				<td class="width-35" width="40%">
					${testUielement.product.name}
				</td>
				<td class="width-15 active"><label class="pull-right">树形选择器：</label></td>
				<td class="width-35" width="40%">
					${testUielement.productType.name}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">数据字典radio：</label></td>
				<td class="width-35">
					${fns:getDictLabel(testUielement.sex, 'sex', '')}
				</td>
				<td class="width-15 active"><label class="pull-right">数据字典select：</label></td>
				<td class="width-35">
					${fns:getDictLabel(testUielement.sex2, 'sex', '')}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">多选下拉标签：</label></td>
				<td class="width-35">
					${fns:getDictLabels(testUielement.tags, 'color', '')}
				</td>
				<td class="width-15 active"><label class="pull-right">数据字典checkbox：</label></td>
				<td class="width-35">
					${fns:getDictLabels(testUielement.tags2, 'color', '')}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">人员选择：</label></td>
				<td class="width-35">
					${testUielement.user.name}
				</td>
				<td class="width-15 active"><label class="pull-right">部门选择：</label></td>
				<td class="width-35">
					${testUielement.office.name}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">单图片上传：</label></td>
				<td class="width-35">
					<form:hidden id="image" path="image" htmlEscape="false" maxlength="1000" class="input-xlarge"/>
					<sys:ckfinder input="image" type="images" uploadPath="/test" selectMultiple="false" readonly="true"/>
				</td>
				<td class="width-15 active"><label class="pull-right">多图片上传：</label></td>
				<td class="width-35">
					<form:hidden id="image2" path="image2" htmlEscape="false" maxlength="1000" class="input-xlarge"/>
					<sys:ckfinder input="image2" type="images" uploadPath="/test" selectMultiple="true" readonly="true"/>
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">单文件上传：</label></td>
				<td class="width-35">
					<form:hidden id="file" path="file" htmlEscape="false" maxlength="1000" class="input-xlarge"/>
					<sys:ckfinder input="file" type="files" uploadPath="/test" selectMultiple="false" readonly="true"/>
				</td>
				<td class="width-15 active"><label class="pull-right">多文件上传：</label></td>
				<td class="width-35">
					<form:hidden id="file2" path="file2" htmlEscape="false" maxlength="1000" class="input-xlarge"/>
					<sys:ckfinder input="file2" type="files" uploadPath="/test" selectMultiple="true" readonly="true"/>
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">富文本编辑器：</label></td>
				<td class="width-35">
					${testUielement.content}
				</td>
			</tr>
		</tbody>
		</table>
		<br>
			<div class="form-actions">
				<shiro:hasPermission name="test:ui:testUielement:edit">
			    	<a href="${ctx}/test/ui/testUielement/form?id=${testUielement.id}" class="btn btn-success" title="修改"><i class="fa fa-edit"></i><span class="hidden-xs">修改</span></a>
				</shiro:hasPermission>
				<shiro:hasPermission name="test:ui:testUielement:del">
					<a href="${ctx}/test/ui/testUielement/delete?id=${testUielement.id}" onclick="return confirmx('确认要删除该UI标签吗？', this.href)" class="btn  btn-danger" title="删除"><i class="fa fa-trash"></i><span class="hidden-xs">删除</span></a> 
				</shiro:hasPermission>
				<input id="btnCancel" class="btn btn-white" type="button" value="返 回" onclick="history.go(-1)"/>
			</div>
		<br>
	</form:form>
	</div>
</div>
</div>
</body>
</html>