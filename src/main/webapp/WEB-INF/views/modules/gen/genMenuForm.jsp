<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>菜单管理</title>
<meta name="decorator" content="default" />
<script type="text/javascript">
	var validateForm;
	function doSubmit() {//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
		if (validateForm.form()) {
			$("#inputForm").submit();
			return true;
		}

		return false;
	}
	$(document).ready(
			function() {
				$("#name").focus();
				validateForm = $("#inputForm")
						.validate(
								{
									submitHandler : function(form) {
										loading('正在提交，请稍等...');
										form.submit();
									},
									errorContainer : "#messageBox",
									errorPlacement : function(error, element) {
										$("#messageBox").text("输入有误，请先更正。");
										if (element.is(":checkbox")
												|| element.is(":radio")
												|| element.parent().is(
														".input-append")) {
											error.appendTo(element.parent()
													.parent());
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
		
		<div class="ibox-content">
			<sys:message content="${message}"/>
			<form:form id="inputForm" modelAttribute="menu" action="${ctx}/gen/genTable/createMenu" method="post" class="form-horizontal">
				<form:hidden path="id" />
				<input type="hidden" value="${genTableId }" name="genTableId">
				
				<div class="row">
					<div class="col-sm-6">
						<div class="form-group">
			            	<label class="col-sm-3 control-label">上级菜单</label>
			            	 <div class="col-sm-8">
			                 	<sys:treeselect id="parent" name="parent.id" value="${menu.parent.id}" labelName="parent.name" labelValue="${menu.parent.name}"
									title="菜单" url="/sys/menu/treeData" extId="${menu.id}" cssClass="form-control required"/>
			                 </div>
			            </div>
		            </div>
		            <div class="col-sm-6">
						<div class="form-group">
			            	<label class="col-sm-3 control-label"><font color="red">*</font>菜单名称</label>
			            	 <div class="col-sm-8">
			                      <form:input path="name" htmlEscape="false" maxlength="50" class="required form-control "/>
			                 </div>
			            </div>
		            </div>
		        </div>
		        <div class="row">
					<div class="col-sm-6">
						<div class="form-group">
			            	<label class="col-sm-3 control-label">菜单图标</label>
			            	 <div class="col-sm-8">
			                 	<sys:iconselect id="icon" name="icon" value="${menu.icon}"/>
			                 </div>
			            </div>
		            </div>
		            <div class="col-sm-6">
						<div class="form-group">
			            	<label class="col-sm-3 control-label">排序</label>
			            	 <div class="col-sm-8">
			                    <form:input path="sort" htmlEscape="false" maxlength="11" class="required digits form-control"/>
								<span class="help-inline">排列顺序，升序。</span>
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