<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>调岗编辑</title>
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
		<h5>调岗</h5>
	</div>
	<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="hrPositionChange" action="${ctx}/hr/hrPositionChange/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<form:hidden path="hrEmployee.id"/>
			<div class="row">
	            <div class="col-sm-6">
					<div class="col-sm-4 text-center">
						<button class="btn btn-success btn-circle btn-lg pull-right" style="width: 100px;height: 100px;border-radius: 50px;font-size: 50px;" type="button">
							${fn:substring(hrPositionChange.hrEmployee.name, 0, 1)}
	                          </button>
	                  	</div>
					<div class="col-sm-8">
						<div class="form-horizontal">
							<div class="row">
								<div class="col-sm-12">
									<div class="view-group">
										<p class="form-control-static">姓名：${hrPositionChange.hrEmployee.name}</p>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-sm-12">
									<div class="view-group">
										<p class="form-control-static">手机：${hrPositionChange.hrEmployee.mobile}</p>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-sm-12">
									<div class="view-group">
										<p class="form-control-static">部门：${hrPositionChange.hrEmployee.office.name}</p>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
            </div>
			<h4 class="page-header"></h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 调整前部门：</label>
						<div class="col-sm-8">
							<sys:treeselect id="oldOffice" name="oldOffice.id" value="${hrPositionChange.oldOffice.id}" labelName="oldOffice.name" labelValue="${hrPositionChange.oldOffice.name}"
								title="部门" url="/sys/office/treeData?type=2" cssClass="form-control" allowClear="true" notAllowSelectParent="true" disabled="disabled"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 调整后部门：</label>
						<div class="col-sm-8">
							<sys:treeselect id="office" name="office.id" value="${hrPositionChange.office.id}" labelName="office.name" labelValue="${hrPositionChange.office.name}"
								title="部门" url="/sys/office/treeData?type=2" cssClass="form-control" allowClear="true" notAllowSelectParent="true"/>
						</div>
					</div>
				</div>
				
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 调整前岗位：</label>
						<div class="col-sm-8">
							<form:input path="oldPosition" htmlEscape="false" maxlength="50" class="form-control" readonly="true"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 调整后岗位：</label>
						<div class="col-sm-8">
							<form:input path="position" htmlEscape="false" maxlength="50" class="form-control required"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 调整前职级：</label>
						<div class="col-sm-8">
							<form:input path="oldPositionLevel" htmlEscape="false" maxlength="50" class="form-control" readonly="true"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 调整后职级：</label>
						<div class="col-sm-8">
							<form:input path="positionLevel" htmlEscape="false" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 调岗时间：</label>
						<div class="col-sm-8">
							<div class="input-group date datepicker">
				                 <input name="changeDate" type="text" readonly="readonly" class="form-control required" 
				                 value="<fmt:formatDate value="${hrPositionChange.changeDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
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
						<label class="col-sm-4 control-label"> 调岗原因：</label>
						<div class="col-sm-8">
							<form:textarea path="changeCause" htmlEscape="false" rows="4" maxlength="50" class="form-control "/>
						</div>
					</div>
				</div>
			</div>
		
			<div class="hr-line-dashed"></div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<div class="col-sm-offset-2 col-sm-10">
							<button id="btnSubmit" class="btn btn-success" type="submit">提交</button>&nbsp;
							<button id="btnCancel" class="btn btn-white" type="button" onclick="history.go(-1)">返回</button>
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