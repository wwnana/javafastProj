<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>面板设置编辑</title>
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
<body>
	<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="sysPanel" action="${ctx}/sys/sysPanel/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
			<h4 class="page-header">办公管理</h4>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<c:forEach items="${sysPanelList}" var="sysPanel">
						<c:if test="${sysPanel.value < 10}">
						<div class="col-sm-3">
							<input name="panelId" type="checkbox" class="i-checks" value="${sysPanel.value}" checked="checked" required="required" > ${sysPanel.label}
						</div>
						</c:if>
						</c:forEach>						
					</div>
				</div>
			</div>
			<h4 class="page-header">项目管理</h4>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<c:forEach items="${sysPanelList}" var="sysPanel">
						<c:if test="${sysPanel.value >= 10 && sysPanel.value < 20}">
						<div class="col-sm-3">
							<input name="panelId" type="checkbox" class="i-checks" value="${sysPanel.value}"  <c:if test='${not empty sysPanel.panelId}'>checked="checked"</c:if> > ${sysPanel.label}
						</div>
						</c:if>
						</c:forEach>
					</div>
				</div>
			</div>
			<h4 class="page-header">客户管理</h4>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<c:forEach items="${sysPanelList}" var="sysPanel">
						<c:if test="${sysPanel.value >= 20 && sysPanel.value < 30}">
						<div class="col-sm-3">
							<input name="panelId" type="checkbox" class="i-checks" value="${sysPanel.value}"  <c:if test='${not empty sysPanel.panelId}'>checked="checked"</c:if> > ${sysPanel.label}
						</div>
						</c:if>
						</c:forEach>
					</div>
				</div>
			</div>
			<h4 class="page-header">进销存管理</h4>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<c:forEach items="${sysPanelList}" var="sysPanel">
						<c:if test="${sysPanel.value >= 30 && sysPanel.value < 40}">
						<div class="col-sm-3">
							<input name="panelId" type="checkbox" class="i-checks" value="${sysPanel.value}"  <c:if test='${not empty sysPanel.panelId}'>checked="checked"</c:if> > ${sysPanel.label}
						</div>
						</c:if>
						</c:forEach>
					</div>
				</div>
			</div>
			<h4 class="page-header">财务管理</h4>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<c:forEach items="${sysPanelList}" var="sysPanel">
						<c:if test="${sysPanel.value >= 40 && sysPanel.value < 50}">
						<div class="col-sm-3">
							<input name="panelId" type="checkbox" class="i-checks" value="${sysPanel.value}"  <c:if test='${not empty sysPanel.panelId}'>checked="checked"</c:if> > ${sysPanel.label}
						</div>
						</c:if>
						</c:forEach>
					</div>
				</div>
			</div>
			<%-- 
			<h4 class="page-header">人事管理</h4>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<c:forEach items="${sysPanelList}" var="sysPanel">
						<c:if test="${sysPanel.value >= 50 && sysPanel.value < 60}">
						<div class="col-sm-3">
							<input name="panelId" type="checkbox" class="i-checks" value="${sysPanel.value}"  <c:if test='${not empty sysPanel.panelId}'>checked="checked"</c:if> > ${sysPanel.label}
						</div>
						</c:if>
						</c:forEach>
					</div>
				</div>
			</div>
			--%>
			
		</form:form>
	</div>
</body>
</html>