<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>离职编辑</title>
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
		<h5>员工离职</h5>
	</div>
	<div class="ibox-content">
		<div class="alert alert-warning">
			此操作将使员工离职，员工账号将不能再登录，且此操作不可撤销；离职后社保、公积金将无法更改，请您认真核对。
        </div>
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="hrQuit" action="${ctx}/hr/hrQuit/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<form:hidden path="hrEmployee.id"/>
			<div class="row">
	            <div class="col-sm-6">
					<div class="col-sm-4 text-center">
						<button class="btn btn-success btn-circle btn-lg pull-right" style="width: 100px;height: 100px;border-radius: 50px;font-size: 50px;" type="button">
							${fn:substring(hrQuit.hrEmployee.name, 0, 1)}
	                          </button>
	                  	</div>
					<div class="col-sm-8">
						<div class="form-horizontal">
							<div class="row">
								<div class="col-sm-12">
									<div class="view-group">
										<p class="form-control-static">姓名：${hrQuit.hrEmployee.name}</p>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-sm-12">
									<div class="view-group">
										<p class="form-control-static">手机：${hrQuit.hrEmployee.mobile}</p>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-sm-12">
									<div class="view-group">
										<p class="form-control-static">部门：${hrQuit.hrEmployee.office.name}</p>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
            </div>
            
			<h4 class="page-header">离职信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 离职类型：</label>
						<div class="col-sm-8">
							<form:select path="quitType" cssClass="form-control required">
								<form:options items="${fns:getDictList('quit_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 离职时间：</label>
						<div class="col-sm-8">
							<div class="input-group date datepicker">
				                 <input name="quitDate" type="text" readonly="readonly" class="form-control required" 
				                 value="<fmt:formatDate value="${hrQuit.quitDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
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
						<label class="col-sm-4 control-label"> 离职原因：</label>
						<div class="col-sm-8">
							<form:input path="quitCause" htmlEscape="false" maxlength="200" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 申请离职原因：</label>
						<div class="col-sm-8">
							<form:textarea path="applyQuitCause" htmlEscape="false" rows="2" maxlength="200" class="form-control "/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 补偿金：</label>
						<div class="col-sm-8">
							<form:input path="compensation" htmlEscape="false" class="form-control" min="0.01" maxlength="10"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 社保减员月：</label>
						<div class="col-sm-8">
							<form:select path="socialOverMonth" cssClass="form-control required">
								<form:options items="${fns:getDictList('over_month_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 公积金减员月：</label>
						<div class="col-sm-8">
							<form:select path="fundOverMonth" cssClass="form-control required">
								<form:options items="${fns:getDictList('over_month_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 剩余年假：</label>
						<div class="col-sm-8">
							<form:input path="annualLeave" htmlEscape="false" maxlength="3" class="form-control digits"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 剩余调休：</label>
						<div class="col-sm-8">
							<form:input path="restLeave" htmlEscape="false" maxlength="3" class="form-control digits"/>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">工作交接</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 工作交接内容：</label>
						<div class="col-sm-8">
							<form:textarea path="workContent" htmlEscape="false" rows="4" maxlength="300" class="form-control "/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 工作交接给：</label>
						<div class="col-sm-8">
							<sys:treeselect id="workBy" name="workBy.id" value="${hrQuit.workBy.id}" labelName="workBy.name" labelValue="${hrQuit.workBy.name}"
								title="用户" url="/sys/office/treeData?type=3" cssClass="form-control required" allowClear="true" notAllowSelectParent="true"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 工作交接完成情况：</label>
						<div class="col-sm-8">
							<form:select path="workStatus" cssClass="form-control required">
								<form:options items="${fns:getDictList('finish_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 备注信息：</label>
						<div class="col-sm-8">
							<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="50" class="form-control "/>
						</div>
					</div>
				</div>
			</div>
		
			<div class="hr-line-dashed"></div>
			<div class="form-actions">
				<shiro:hasPermission name="hr:hrEmployee:edit">
					<button id="btnSubmit" class="btn btn-success" type="submit">提交</button>&nbsp;
				</shiro:hasPermission>
				<button id="btnCancel" class="btn btn-white" type="button" onclick="history.go(-1)">返回</button>
			</div>
		</form:form>
	</div>
</div>
</div>
</body>
</html>