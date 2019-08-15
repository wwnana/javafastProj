<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>客户投诉查看</title>
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
		<h5>客户投诉查看</h5>
	</div>
	<div class="ibox-content">
	<sys:message content="${message}"/>
	
	<form:form id="inputForm" modelAttribute="scmComplaint" action="${ctx}/scm/scmComplaint/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<table class="table table-bordered table-condensed dataTables-example dataTable no-footer">
		<tbody>
			<tr>
				<td class="width-15 active"><label class="pull-right">主题：</label></td>
				<td class="width-35">
					${scmComplaint.name}
				</td>
				<td class="width-15 active"><label class="pull-right">订单合同：</label></td>
				<td class="width-35">
					${scmComplaint.omContract.name}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">客户：</label></td>
				<td class="width-35">
					${scmComplaint.customer.name}
				</td>
				<td class="width-15 active"><label class="pull-right">负责人：</label></td>
				<td class="width-35">
					${scmComplaint.ownBy.name}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">优先级：</label></td>
				<td class="width-35">
					${fns:getDictLabel(scmComplaint.levelType, 'level_type', '')}
				</td>
				<td class="width-15 active"><label class="pull-right">截止日期：</label></td>
				<td class="width-35">
					<fmt:formatDate value="${scmComplaint.endDate}" pattern="yyyy-MM-dd"/>
				</td>
			</tr>
			<tr>
				
				<td class="width-15 active"><label class="pull-right">投诉内容：</label></td>
				<td class="width-35" colspan="3">
					${scmComplaint.content}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">期望结果：</label></td>
				<td class="width-35" colspan="3">
					${scmComplaint.expecte}
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">状态：</label></td>
				<td class="width-35">
								<span class="<c:if test='${scmComplaint.status == 0}'>text-danger</c:if>">
									${fns:getDictLabel(scmComplaint.status, 'audit_status', '')}
								</span>
				</td>
				<td class="width-15 active"><label class="pull-right">处理日期：</label></td>
				<td class="width-35">
					<fmt:formatDate value="${scmComplaint.dealDate}" pattern="yyyy-MM-dd"/>
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">满意度：</label></td>
				<td class="width-35">
					${fns:getDictLabel(scmComplaint.satisfyType, 'satisfy_type', '')}
				</td>
				
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">审核人：</label></td>
				<td class="width-35">
					${scmComplaint.auditBy.name}
				</td>
				<td class="width-15 active"><label class="pull-right">审核日期：</label></td>
				<td class="width-35">
					<fmt:formatDate value="${scmComplaint.auditDate}" pattern="yyyy-MM-dd"/>
				</td>
				
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">创建人：</label></td>
				<td class="width-35">
					${scmComplaint.createBy.name}
				</td>
				<td class="width-15 active"><label class="pull-right">创建时间：</label></td>
				<td class="width-35">
					<fmt:formatDate value="${scmComplaint.createDate}" pattern="yyyy-MM-dd"/>
				</td>
			</tr>
			<tr>
				<td class="width-15 active"><label class="pull-right">备注信息：</label></td>
				<td class="width-35" colspan="3">
					${scmComplaint.remarks}
				</td>
			</tr>
			<tr>
			</tr>
		</tbody>
		</table>
		<br>
			<div class="form-actions">
				
				<c:if test="${scmComplaint.status == 0}">
					<shiro:hasPermission name="scm:scmComplaint:audit">
    					<a href="${ctx}/scm/scmComplaint/auditForm?id=${scmComplaint.id}" class="btn btn-success" title="审核"><i class="fa fa-check"></i><span class="hidden-xs">审核</span></a>
					</shiro:hasPermission>
				
								
				<shiro:hasPermission name="scm:scmComplaint:edit">
			    	<a href="${ctx}/scm/scmComplaint/form?id=${scmComplaint.id}" class="btn btn-success" title="修改"><i class="fa fa-edit"></i><span class="hidden-xs">修改</span></a>
				</shiro:hasPermission>
				
				<shiro:hasPermission name="scm:scmComplaint:del">
					<a href="${ctx}/scm/scmComplaint/delete?id=${scmComplaint.id}" onclick="return confirmx('确认要删除该客户投诉吗？', this.href)" class="btn  btn-danger" title="删除"><i class="fa fa-trash"></i><span class="hidden-xs">删除</span></a> 
				</shiro:hasPermission>
				</c:if>
				
				<input id="btnCancel" class="btn btn-white" type="button" value="返 回" onclick="history.go(-1)"/>
			</div>
		<br>
	</form:form>
	</div>
</div>
</div>
</body>
</html>