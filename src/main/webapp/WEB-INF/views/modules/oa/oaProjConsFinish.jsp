<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>项目咨询流程表编辑</title>
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
		<h5>项目咨询流程表${not empty oaProjCons.id?'修改':'添加'}</h5>
	</div>
	<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="oaProjCons" action="${ctx}/oa/oaProjCons/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<form:hidden path="act.taskId"/>
		<form:hidden path="act.taskName"/>
		<form:hidden path="act.taskDefKey"/>
		<form:hidden path="act.procInsId"/>
		<form:hidden path="act.procDefId"/>
		<form:hidden id="flag" path="act.flag"/>
		<form:hidden path="project.id"/>
		<form:hidden path="user.id"/>
		<form:hidden path="userName"/>
		<form:hidden path="office.id"/>
		<form:hidden path="officeName"/>
		<form:hidden path="procInsId"/>
		<form:hidden path="status"/>
		<form:hidden path="createByName"/>
		<form:hidden path="updateByName"/>
		
			<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 申请姓名：</label>
						<div class="col-sm-8">
							<%-- <sys:treeselect id="user" name="user.id" value="${oaProjectCon.user.id}" labelName="user.name" labelValue="${oaProjectCon.user.name}"
								title="用户" url="/sys/office/treeData?type=3" cssClass="form-control required recipient" allowClear="true" notAllowSelectParent="true"/> --%>
							${oaProjCons.userName}
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 归属部门：</label>
						<div class="col-sm-8">
							<%-- <sys:treeselect id="office" name="office.id" value="${oaProjectCon.office.id}" labelName="office.name" labelValue="${oaProjectCon.office.name}"
								title="部门" url="/sys/office/treeData?type=2" cssClass="form-control required recipient" allowClear="true" notAllowSelectParent="true"/> --%>
							${oaProjCons.officeName }
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 所属项目：</label>
						<div class="col-sm-8">
							${oaProjCons.project.name}
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 备注信息：</label>
						<div class="col-sm-8">
							<%-- <form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="form-control "/>
							 --%><textarea rows="4" cols="20" name="remarks" class="form-control"></textarea>
						</div>
					</div>
				</div>
			</div>
		
			<div class="hr-line-dashed"></div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<div class="col-sm-offset-2 col-sm-10">
							<button id="btnSubmit" class="btn btn-primary" type="submit">保存</button>&nbsp;
							<button id="btnCancel" class="btn btn-white" type="button" onclick="history.go(-1)">返回</button>
						</div>
					</div>
				</div>
			</div>
			<act:histoicFlow procInsId="${oaProjCons.procInsId}"/>
		</form:form>
	</div>
</div>
</div>
</body>
</html>