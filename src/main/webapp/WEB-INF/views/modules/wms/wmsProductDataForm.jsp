<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>产品详情表编辑</title>
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
		<h5>产品详情表${not empty wmsProductData.id?'修改':'添加'}</h5>
	</div>
	<div class="ibox-content">
	<sys:message content="${message}"/>
	<div class="row">
		<div class="col-sm-12">
			<div class="text-center p-lg">
            	<h2>产品详情表</h2>
            </div>
		</div>
	</div>
	<form:form id="inputForm" modelAttribute="wmsProductData" action="${ctx}/wms/wmsProductData/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>			
		<table class="table table-bordered table-condensed dataTables-example dataTable no-footer">
		<tbody>
			<tr>
				<td class="width-15 active"><label class="pull-right">产品详情：</label></td>
				<td class="width-35">
					<form:textarea id="content" path="content" htmlEscape="false" rows="4" class="form-control " style="width:50%;height:200px;"/>
					<sys:umeditor replace="content" uploadPath="/image" maxlength="0"/>
				</td>
			</tr>
		</tbody>
		</table>
		
		<br>
			<div class="form-actions">
				<shiro:hasPermission name="wms:wmsProductData:edit"><input id="btnSubmit" class="btn btn-success" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
				<input id="btnCancel" class="btn btn-white" type="button" value="返 回" onclick="history.go(-1)"/>
			</div>
		<br>
	</form:form>
	</div>
</div>
</div>
</body>
</html>