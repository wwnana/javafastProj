<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>期权编辑</title>
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
<div class="ibox float-e-margins">				
                <div class="panel-body">
                    <div class="row">
						<div class="col-sm-2 text-center">
							<button class="btn btn-success btn-circle btn-lg pull-right" style="width: 100px;height: 100px;border-radius: 50px;font-size: 50px;" type="button">
								${fn:substring(hrOption.hrEmployee.name, 0, 1)}
                            </button>
                    	</div>
						<div class="col-sm-9">
							<div class="form-horizontal">
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">姓名：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrOption.hrEmployee.name}
												</p>
											</div>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">性别：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${fns:getDictLabel(hrOption.hrEmployee.sex, 'sex', '')}
												</p>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">手机号：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrOption.hrEmployee.mobile}
												</p>
											</div>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">邮箱：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrOption.hrEmployee.email}
												</p>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">当前职位：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${hrOption.hrEmployee.position}
												</p>
											</div>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">员工状态：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${fns:getDictLabel(hrOption.hrEmployee.status, 'employ_status', '')}
												</p>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="col-sm-1 pull-right">
						</div>	
                    </div>
                </div>
			</div>
			
<div class="ibox">
	<div class="ibox-title">
		<h5>期权${not empty hrOption.id?'修改':'添加'}</h5>
	</div>
	<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="hrOption" action="${ctx}/hr/hrOption/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<form:hidden path="hrEmployee.id"/>
			<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 授予日期：</label>
						<div class="col-sm-8">
							<div class="input-group date datepicker">
				                 <input name="grantDate" type="text" readonly="readonly" class="form-control required" 
				                 value="<fmt:formatDate value="${hrOption.grantDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
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
						<label class="col-sm-4 control-label"><font color="red">*</font> 授予数量：</label>
						<div class="col-sm-8">
							<form:input path="grantNum" htmlEscape="false" maxlength="11" class="form-control required digits" min="1" placeholder="大于0的整数"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 比例：</label>
						<div class="col-sm-8">
							<form:input path="proportion" htmlEscape="false" class="form-control" min="0.01" max="100" placeholder="0-100的数值，小数点后最多2位"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 轮次：</label>
						<div class="col-sm-8">
							<form:input path="roundNum" htmlEscape="false" maxlength="20" class="form-control" placeholder="不超过10个字符"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 锁定期：</label>
						<div class="col-sm-8">
							<form:input path="lockPeriod" htmlEscape="false" class="form-control" min="0.01" maxlength="11" placeholder="大于0的数值"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 已成熟数量：</label>
						<div class="col-sm-8">
							<form:input path="matureNum" htmlEscape="false" maxlength="11" class="form-control digits" min="1" placeholder="大于0的整数"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 期权合同：</label>
						<div class="col-sm-8">
							<form:hidden id="optionFile" path="optionFile" htmlEscape="false" maxlength="255" />
							<sys:ckfinder input="optionFile" type="files" uploadPath="/file" selectMultiple="false"/>
						</div>
					</div>
				</div>
			</div>
			
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 备注信息：</label>
						<div class="col-sm-8">
							<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="50" class="form-control " placeholder="1-100个字符"/>
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