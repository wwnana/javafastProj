<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>审批记录编辑</title>
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
		<form:form id="inputForm" modelAttribute="hrApproval" action="${ctx}/hr/hrApproval/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
			<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 审批名称：</label>
						<div class="col-sm-8">
							<form:input path="name" htmlEscape="false" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 申请人姓名：</label>
						<div class="col-sm-8">
							<form:input path="applyName" htmlEscape="false" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 申请人部门：</label>
						<div class="col-sm-8">
							<form:input path="applyOrg" htmlEscape="false" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 审批人姓名：</label>
						<div class="col-sm-8">
							<form:input path="approvalName" htmlEscape="false" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 抄送人姓名：</label>
						<div class="col-sm-8">
							<form:input path="notifyName" htmlEscape="false" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 审批状态：</label>
						<div class="col-sm-8">
							<form:input path="spStatus" htmlEscape="false" maxlength="2" class="form-control digits"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 审批单号：</label>
						<div class="col-sm-8">
							<form:input path="spNum" htmlEscape="false" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 审批单提交时间：</label>
						<div class="col-sm-8">
							<div class="input-group date datepicker">
				                 <input name="applyTime" type="text" readonly="readonly" class="form-control" 
				                 value="<fmt:formatDate value="${hrApproval.applyTime}" pattern="yyyy-MM-dd HH:mm:ss"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:true});" >
				                 <span class="input-group-addon">
				                      <span class="fa fa-calendar"></span>
				                 </span>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 审批单提交者的userid：</label>
						<div class="col-sm-8">
							<form:input path="applyUserId" htmlEscape="false" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 审批类型：</label>
						<div class="col-sm-8">
							<form:select path="approvalType" cssClass="form-control">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('common_audit_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 报销类型：</label>
						<div class="col-sm-8">
							<form:input path="expenseType" htmlEscape="false" maxlength="1" class="form-control digits"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 报销事由：</label>
						<div class="col-sm-8">
							<form:input path="expenseReason" htmlEscape="false" maxlength="255" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 请假时间单位：0半天；1小时：</label>
						<div class="col-sm-8">
							<form:input path="leaveTimeunit" htmlEscape="false" maxlength="1" class="form-control digits"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 请假类型：</label>
						<div class="col-sm-8">
							<form:input path="leaveType" htmlEscape="false" maxlength="2" class="form-control digits"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 请假开始时间：</label>
						<div class="col-sm-8">
							<div class="input-group date datepicker">
				                 <input name="leaveStartTime" type="text" readonly="readonly" class="form-control" 
				                 value="<fmt:formatDate value="${hrApproval.leaveStartTime}" pattern="yyyy-MM-dd HH:mm:ss"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:true});" >
				                 <span class="input-group-addon">
				                      <span class="fa fa-calendar"></span>
				                 </span>
							</div>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 请假结束时间：</label>
						<div class="col-sm-8">
							<div class="input-group date datepicker">
				                 <input name="leaveEndTime" type="text" readonly="readonly" class="form-control" 
				                 value="<fmt:formatDate value="${hrApproval.leaveEndTime}" pattern="yyyy-MM-dd HH:mm:ss"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:true});" >
				                 <span class="input-group-addon">
				                      <span class="fa fa-calendar"></span>
				                 </span>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 请假时长，单位小时：</label>
						<div class="col-sm-8">
							<form:input path="leaveDuration" htmlEscape="false" maxlength="10" class="form-control digits"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 请假事由：</label>
						<div class="col-sm-8">
							<form:input path="leaveReason" htmlEscape="false" maxlength="255" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 申请单数据：</label>
						<div class="col-sm-8">
							<form:input path="applyData" htmlEscape="false" maxlength="1000" class="form-control"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 用户：</label>
						<div class="col-sm-8">
							<sys:treeselect id="user" name="user.id" value="${hrApproval.user.id}" labelName="user.name" labelValue="${hrApproval.user.name}"
								title="用户" url="/sys/office/treeData?type=3" cssClass="form-control" allowClear="true" notAllowSelectParent="true"/>
						</div>
					</div>
				</div>
			</div>
		
		</form:form>
	</div>
</body>
</html>