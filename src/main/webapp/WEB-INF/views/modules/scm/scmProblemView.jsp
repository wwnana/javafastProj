<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>常见问题查看</title>
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
<body class="">
<div class="">
<div class="">
	<div class="row dashboard-header gray-bg">
		<h5>常见问题查看</h5>
		<div class="pull-right">
			<input id="btnCancel" class="btn btn-white btn-sm" type="button" value="返 回" onclick="history.go(-1)"/>
					<c:if test="${fns:getUser().id == scmProblem.createBy.id}">
            					
								<shiro:hasPermission name="scm:scmProblem:edit">
			    					<a href="${ctx}/scm/scmProblem/form?id=${scmProblem.id}" class="btn btn-white btn-sm" title="修改"><span class="hidden-xs">修改</span></a>
								</shiro:hasPermission>
								
								<shiro:hasPermission name="scm:scmProblem:del">
									<a href="${ctx}/scm/scmProblem/delete?id=${scmProblem.id}" onclick="return confirmx('确认要删除该常见问题吗？', this.href)" class="btn  btn-white btn-sm" title="删除"><span class="hidden-xs">删除</span></a> 
								</shiro:hasPermission>
					</c:if>			
                    
		</div>
	</div>
	<div class="ibox-content">
		<sys:message content="${message}"/>
	
		<form:form id="inputForm" modelAttribute="scmProblem" action="${ctx}/scm/scmProblem/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>	
			<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"><font color="red">*</font> 问题分类：</label>
						<div class="col-sm-10">
							<p class="form-control-static">
								${scmProblem.scmProblemType.name}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"><font color="red">*</font> 问题名称：</label>
						<div class="col-sm-10">
							<p class="form-control-static">${scmProblem.name}</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">创建人：</label>
						<div class="col-sm-8">
							<p class="form-control-static">${scmProblem.createBy.name}</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">创建时间：</label>
						<div class="col-sm-8">
							<p class="form-control-static"><fmt:formatDate value="${scmProblem.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/></p>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">详细内容</h4>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-1 control-label"></label>
						<div class="col-sm-10">
							<p class="form-control-static">${scmProblem.content}</p>
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