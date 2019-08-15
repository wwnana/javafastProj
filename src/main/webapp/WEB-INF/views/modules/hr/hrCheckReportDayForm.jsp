<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>每日打卡汇总编辑</title>
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
		<form:form id="inputForm" modelAttribute="hrCheckReportDay" action="${ctx}/hr/hrCheckReportDay/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
			<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 日期：</label>
						<div class="col-sm-8">
							<div class="input-group date datepicker">
				                 <input name="checkinDate" type="text" readonly="readonly" class="form-control" 
				                 value="<fmt:formatDate value="${hrCheckReportDay.checkinDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                 <span class="input-group-addon">
				                      <span class="fa fa-calendar"></span>
				                 </span>
							</div>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 姓名：</label>
						<div class="col-sm-8">
							<sys:treeselect id="user" name="user.id" value="${hrCheckReportDay.user.id}" labelName="user.name" labelValue="${hrCheckReportDay.user.name}"
								title="用户" url="/sys/office/treeData?type=3" cssClass="form-control" allowClear="true" notAllowSelectParent="true"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 部门：</label>
						<div class="col-sm-8">
							<sys:treeselect id="office" name="office.id" value="${hrCheckReportDay.office.id}" labelName="office.name" labelValue="${hrCheckReportDay.office.name}"
								title="部门" url="/sys/office/treeData?type=2" cssClass="form-control" allowClear="true" notAllowSelectParent="true"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 所属规则：</label>
						<div class="col-sm-8">
							<form:input path="groupname" htmlEscape="false" maxlength="50" class="form-control required"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 最早：</label>
						<div class="col-sm-8">
							<div class="input-group date datepicker">
				                 <input name="firstCheckinTime" type="text" readonly="readonly" class="form-control" 
				                 value="<fmt:formatDate value="${hrCheckReportDay.firstCheckinTime}" pattern="yyyy-MM-dd HH:mm:ss"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:true});" >
				                 <span class="input-group-addon">
				                      <span class="fa fa-calendar"></span>
				                 </span>
							</div>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 最晚：</label>
						<div class="col-sm-8">
							<div class="input-group date datepicker">
				                 <input name="lastCheckinTime" type="text" readonly="readonly" class="form-control" 
				                 value="<fmt:formatDate value="${hrCheckReportDay.lastCheckinTime}" pattern="yyyy-MM-dd HH:mm:ss"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:true});" >
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
						<label class="col-sm-4 control-label"> 次数：</label>
						<div class="col-sm-8">
							<form:input path="checkinNum" htmlEscape="false" maxlength="11" class="form-control digits"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 工作时长：</label>
						<div class="col-sm-8">
							<form:input path="workHours" htmlEscape="false" maxlength="10" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 审批单：</label>
						<div class="col-sm-8">
							<form:input path="hrApproval.id" htmlEscape="false" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 状态：</label>
						<div class="col-sm-8">
							<form:select path="checkinStatus" cssClass="form-control">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('checkin_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 校准状态：</label>
						<div class="col-sm-8">
							<form:input path="auditStatus" htmlEscape="false" maxlength="1" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
		
		</form:form>
	</div>
</body>
</html>