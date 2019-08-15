<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>工资明细编辑</title>
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
		<h5>工资明细${not empty hrSalaryDetail.id?'修改':'添加'}</h5>
	</div>
	<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="hrSalaryDetail" action="${ctx}/hr/hrSalaryDetail/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
			<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 归属工资表：</label>
						<div class="col-sm-8">
							<form:input path="hrSalaryId" htmlEscape="false" maxlength="64" class="form-control"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 员工：</label>
						<div class="col-sm-8">
							<form:input path="hrEmployeeId" htmlEscape="false" maxlength="30" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 姓名：</label>
						<div class="col-sm-8">
							<form:input path="name" htmlEscape="false" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 应出勤天数：</label>
						<div class="col-sm-8">
							<form:input path="mustWorkDays" htmlEscape="false" maxlength="10" class="form-control digits"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 实际出勤天数：</label>
						<div class="col-sm-8">
							<form:input path="realWorkDays" htmlEscape="false" maxlength="10" class="form-control digits"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 加班天数：</label>
						<div class="col-sm-8">
							<form:input path="extraWorkDays" htmlEscape="false" maxlength="10" class="form-control digits"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 请假天数：</label>
						<div class="col-sm-8">
							<form:input path="leaveDays" htmlEscape="false" maxlength="10" class="form-control digits"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 旷工天数：</label>
						<div class="col-sm-8">
							<form:input path="absentDays" htmlEscape="false" maxlength="10" class="form-control digits"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 基本工资：</label>
						<div class="col-sm-8">
							<form:input path="baseSalary" htmlEscape="false" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 岗位工资：</label>
						<div class="col-sm-8">
							<form:input path="postSalary" htmlEscape="false" class="form-control"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 奖金：</label>
						<div class="col-sm-8">
							<form:input path="bonusSalary" htmlEscape="false" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 加班费：</label>
						<div class="col-sm-8">
							<form:input path="overtimeSalary" htmlEscape="false" class="form-control"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 应发合计：</label>
						<div class="col-sm-8">
							<form:input path="shouldAmt" htmlEscape="false" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 社保：</label>
						<div class="col-sm-8">
							<form:input path="socialAmt" htmlEscape="false" class="form-control"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 公积金：</label>
						<div class="col-sm-8">
							<form:input path="fundAmt" htmlEscape="false" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 个税：</label>
						<div class="col-sm-8">
							<form:input path="taxAmt" htmlEscape="false" class="form-control"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 应扣工资：</label>
						<div class="col-sm-8">
							<form:input path="seductSalary" htmlEscape="false" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 实发工资：</label>
						<div class="col-sm-8">
							<form:input path="realAmt" htmlEscape="false" class="form-control"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 状态：</label>
						<div class="col-sm-8">
							<form:input path="status" htmlEscape="false" maxlength="1" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 备注：</label>
						<div class="col-sm-8">
							<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="50" class="form-control "/>
						</div>
					</div>
				</div>
			</div>
		
			<div class="hr-line-dashed"></div>
			<div class="form-actions">
				<shiro:hasPermission name="hr:hrSalaryDetail:edit">
					<button id="btnSubmit" class="btn btn-success" type="submit"><i class="fa fa-check"></i> 保存</button>&nbsp;
				</shiro:hasPermission>
				<button id="btnCancel" class="btn btn-white" type="button" onclick="history.go(-1)"><i class="fa fa-reply"></i> 返回</button>
			</div>
		</form:form>
	</div>
</div>
</div>
</body>
</html>