<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>OFFER编辑</title>
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
		<h5>发送offer</h5>
	</div>
	<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="hrOffer" action="${ctx}/hr/hrOffer/preview" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<form:hidden path="hrResume.id"/>
			<h4 class="page-header">简历信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label"> 姓名：</label>
						<div class="col-sm-8">
							<p class="form-control-static">${hrOffer.hrResume.name}</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label"> 手机：</label>
						<div class="col-sm-8">
							<p class="form-control-static">${hrOffer.hrResume.mobile}</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label"> 邮箱：</label>
						<div class="col-sm-8">
							<p class="form-control-static">${hrOffer.hrResume.mail}</p>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header"></h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 抄送邮箱：</label>
						<div class="col-sm-8">
							<form:input path="readEmail" htmlEscape="false" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 有效期(天)：</label>
						<div class="col-sm-8">
							<form:input path="validityPeriod" htmlEscape="false" maxlength="2" class="form-control digits required"/>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">offer信息</h4>
			<div class="row">	
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 报到时间：</label>
						<div class="col-sm-8">
							<div class="input-group date datepicker">
				                 <input id="reportDate" name="reportDate" type="text" readonly="readonly" class="form-control required" 
				                 value="<fmt:formatDate value="${hrOffer.reportDate}" pattern="yyyy-MM-dd HH:mm"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm',isShowClear:true});" >
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
						<label class="col-sm-4 control-label"><font color="red">*</font> 试用期(月)：</label>
						<div class="col-sm-8">
							<form:select path="probationPeriod" cssClass="form-control">
								<form:options items="${fns:getDictList('probation_period')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 入职岗位：</label>
						<div class="col-sm-8">
							<form:input path="position" htmlEscape="false" maxlength="50" class="form-control required"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 入职部门：</label>
						<div class="col-sm-8">
							<form:input path="department" htmlEscape="false" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 公司地址：</label>
						<div class="col-sm-8">
							<form:input path="address" htmlEscape="false" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 入职联系人：</label>
						<div class="col-sm-8">
							<form:input path="linkMan" htmlEscape="false" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 联系人电话：</label>
						<div class="col-sm-8">
							<form:input path="linkPhone" htmlEscape="false" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header"></h4>			
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 试用期工资(元)：</label>
						<div class="col-sm-8">
							<form:input path="probationSalaryBase" htmlEscape="false" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 转正工资(元)：</label>
						<div class="col-sm-8">
							<form:input path="formalSalaryBase" htmlEscape="false" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 薪酬备注：</label>
						<div class="col-sm-8">
							<form:textarea path="salaryRemarks" htmlEscape="false" rows="2" maxlength="200" class="form-control "/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 附件：</label>
						<div class="col-sm-8">
							<form:hidden id="offerFile" path="offerFile" htmlEscape="false" maxlength="255" />
							<sys:ckfinder input="offerFile" type="files" uploadPath="/file" selectMultiple="false"/>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">OFFER通知</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"></label>
						<div class="col-sm-8">
							<input type="checkbox" id="isSmsMsg" name="isSmsMsg" value="1" class="i-checks" checked="checked"> 向候选人发送短信通知 					
							<input type="checkbox" id="isEmailMsg" name="isEmailMsg" value="1" class="i-checks" checked="checked"> 向候选人发送邮件通知
						</div>
					</div>
				</div>
			</div>
			<div class="hr-line-dashed"></div>
			<div class="form-actions">
				<button id="btnSubmit" class="btn btn-success" type="submit">预览</button>
				<button id="btnCancel" class="btn btn-white" type="button" onclick="history.go(-1)">返回</button>
			</div>
		</form:form>
	</div>
</div>
</div>
</body>
</html>