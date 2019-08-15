<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>库存流水管理</title>
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
	<form:form id="inputForm" modelAttribute="wmsStockJournal" action="${ctx}/wms/wmsStockJournal/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>	
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
		<tbody>
		<tr>
			</tr><tr>
				<td class="width-15 active"><label class="pull-right">产品：</label></td>
				<td class="width-35">
				<form:input path="product.name" htmlEscape="false" maxlength="30" class="form-control input-xlarge "/>
			</td>
			
				<td class="width-15 active"><label class="pull-right">操作类型：</label></td>
				<td class="width-35">
				<form:select path="dealType" class="input-xlarge ">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('deal_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</td>
			</tr><tr>
				<td class="width-15 active"><label class="pull-right">数量：</label></td>
				<td class="width-35">
				<form:input path="num" htmlEscape="false" maxlength="11" class="form-control input-xlarge  digits"/>
			</td>
			
				<td class="width-15 active"><label class="pull-right">摘要：</label></td>
				<td class="width-35">
				<form:input path="notes" htmlEscape="false" maxlength="50" class="form-control input-xlarge "/>
			</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">仓库：</label></td>
				<td class="width-35">
				<form:input path="warehouse.name" htmlEscape="false" maxlength="30" class="form-control input-xlarge "/>
				</td>
			
				<td class="width-15 active"><label class="pull-right">来源单号：</label></td>
				<td class="width-35">
				<form:input path="uniqueCode" htmlEscape="false" maxlength="50" class="form-control input-xlarge "/>
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">操作人：</label></td>
				<td class="width-35">
				<form:input path="createBy.name" htmlEscape="false" maxlength="30" class="form-control input-xlarge "/>
				</td>
			
				<td class="width-15 active"><label class="pull-right">操作时间：</label></td>
				<td class="width-35">
				<fmt:formatDate value="${wmsStockJournal.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
			</tr><tr>
			</tr><tr>
			</tr><tr>
			</tr><tr>
	</form:form>
</body>
</html>