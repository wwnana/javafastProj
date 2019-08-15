<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>客户服务审核</title>
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
		<h5>客户服务审核</h5>
	</div>
	<div class="ibox-content">
	<sys:message content="${message}"/>
	
	<form:form id="inputForm" modelAttribute="scmSuppot" action="${ctx}/scm/scmSuppot/auditSave" method="post" class="form-horizontal">
		<form:hidden path="id"/>			
		<table class="table table-bordered table-condensed dataTables-example dataTable no-footer">
		<tbody>
			
			<tr>
				<td class="width-15 active"><label class="pull-right">主题：</label></td>
				<td class="width-35">
					${scmSuppot.name}
				</td>
				<td class="width-15 active"><label class="pull-right">订单合同：</label></td>
				<td class="width-35">
					${scmSuppot.omContract.name}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">客户：</label></td>
				<td class="width-35">
					${scmSuppot.customer.name}
				</td>
				<td class="width-15 active"><label class="pull-right">负责人：</label></td>
				<td class="width-35">
					${scmSuppot.ownBy.name}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">优先级：</label></td>
				<td class="width-35">
					${fns:getDictLabel(scmSuppot.levelType, 'level_type', '')}
				</td>
				<td class="width-15 active"><label class="pull-right">截止日期：</label></td>
				<td class="width-35">
					<fmt:formatDate value="${scmSuppot.endDate}" pattern="yyyy-MM-dd"/>
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">服务内容：</label></td>
				<td class="width-35">
					${scmSuppot.content}
				</td>
				<td class="width-15 active"><label class="pull-right">期望结果：</label></td>
				<td class="width-35">
					${scmSuppot.expecte}
				</td>
				
			</tr>
			<tr>				
				<td class="width-15 active"><label class="pull-right"><font color="red">*</font> 处理日期：</label></td>
				<td class="width-35">
					<div class="input-group date datepicker input-xlarge">
						<input name="dealDate" type="text" readonly="readonly" class="form-control required" value="<fmt:formatDate value="${scmSuppot.dealDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
                   		<span class="input-group-addon">
                           	<span class="fa fa-calendar"></span>
                   		</span>
                   	</div>
				</td>
				<td class="width-15 active"><label class="pull-right"><font color="red">*</font> 满意度：</label></td>
				<td class="width-35">
					<form:select path="satisfyType" cssClass="form-control input-xlarge required">
						<form:options items="${fns:getDictList('satisfy_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">备注信息：</label></td>
				<td class="width-35" colspan="3">
					<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="50" class="form-control"/>
				</td>
			</tr>
			
		</tbody>
		</table>
		
		<br>
			<div class="form-actions">
				<shiro:hasPermission name="scm:scmSuppot:edit"><input id="btnSubmit" class="btn btn-success" type="submit" value="审 核"/>&nbsp;</shiro:hasPermission>
				<input id="btnCancel" class="btn btn-white" type="button" value="返 回" onclick="history.go(-1)"/>
			</div>
		<br>
	</form:form>
	</div>
</div>
</div>
</body>
</html>