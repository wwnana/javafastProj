<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>员工信息编辑</title>
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
		function comWorkAge(){			
            var firstWorkDate = $("#firstWorkDate").val();
            if(firstWorkDate != null && firstWorkDate != ""){
            	var endTime = new Date(firstWorkDate).getTime();    
                var startTime = new Date().getTime();
                var dates = Math.abs((startTime - endTime))/(1000*60*60*24*365); 
                $("#workAge").val(dates.toFixed(2));
            }            
		}
	</script>
</head>
<body class="gray-bg">
<div class="wrapper-content">
<div class="ibox">
	<div class="ibox-title">
		<h5>员工信息${not empty hrEmployee.id?'修改':'添加'}</h5>
	</div>
	<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="hrEmployee" action="${ctx}/hr/hrEmployee/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
			<h4 class="page-header">基本信息</h4>
			
			<div class="row">	
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 姓名：</label>
						<div class="col-sm-8">
							<form:input path="name" htmlEscape="false" maxlength="50" class="form-control required"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 英文名：</label>
						<div class="col-sm-8">
							<form:input path="enName" htmlEscape="false" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 性别：</label>
						<div class="col-sm-8">
							<form:select path="sex" cssClass="form-control">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('sex')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 出生日期：</label>
						<div class="col-sm-8">
							<div class="input-group date datepicker">
				                 <input name="birthDate" type="text" readonly="readonly" class="form-control" 
				                 value="<fmt:formatDate value="${hrEmployee.birthDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
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
						<label class="col-sm-4 control-label"> 身份证号：</label>
						<div class="col-sm-8">
							<form:input path="idCard" htmlEscape="false" maxlength="20" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"> 身份证照：</label>
						<div class="col-sm-10">
							<form:hidden id="idCardImg" path="idCardImg" htmlEscape="false" maxlength="255" />
							<sys:ckfinder input="idCardImg" type="images" uploadPath="/image" selectMultiple="true" fileNumLimit="2"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 籍贯：</label>
						<div class="col-sm-8">
							<form:input path="nativePlace" htmlEscape="false" maxlength="30" class="form-control"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 民族：</label>
						<div class="col-sm-8">
							<form:input path="nation" htmlEscape="false" maxlength="30" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 户籍所在地：</label>
						<div class="col-sm-8">
							<form:input path="registration" htmlEscape="false" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 政治面貌：</label>
						<div class="col-sm-8">
							<form:input path="political" htmlEscape="false" maxlength="20" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">				
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 生日：</label>
						<div class="col-sm-8">
							<form:input path="birthday" htmlEscape="false" maxlength="10" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 婚姻状况：</label>
						<div class="col-sm-8">
							<form:select path="maritalStatus" cssClass="form-control">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('marital_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 子女状态：</label>
						<div class="col-sm-8">
							<form:input path="children" htmlEscape="false" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">通讯信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 联系手机：</label>
						<div class="col-sm-8">
							<form:input path="mobile" htmlEscape="false" maxlength="20" class="form-control"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 个人邮箱：</label>
						<div class="col-sm-8">
							<form:input path="email" htmlEscape="false" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> QQ：</label>
						<div class="col-sm-8">
							<form:input path="qq" htmlEscape="false" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 微信：</label>
						<div class="col-sm-8">
							<form:input path="wx" htmlEscape="false" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 居住城市：</label>
						<div class="col-sm-8">
							<form:input path="city" htmlEscape="false" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 通讯地址：</label>
						<div class="col-sm-8">
							<form:input path="address" htmlEscape="false" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 紧急联系人：</label>
						<div class="col-sm-8">
							<form:input path="contactPeople" htmlEscape="false" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 紧急联系电话：</label>
						<div class="col-sm-8">
							<form:input path="contactPhone" htmlEscape="false" maxlength="20" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">账号信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 社保电脑号：</label>
						<div class="col-sm-8">
							<form:input path="socialSecurityNo" htmlEscape="false" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 公积金账号：</label>
						<div class="col-sm-8">
							<form:input path="accumulationNo" htmlEscape="false" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 银行卡号：</label>
						<div class="col-sm-8">
							<form:input path="bankCardNo" htmlEscape="false" maxlength="30" class="form-control"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 开户行：</label>
						<div class="col-sm-8">
							<form:input path="bankCardName" htmlEscape="false" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">教育信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 毕业学校：</label>
						<div class="col-sm-8">
							<form:input path="graduateSchool" htmlEscape="false" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 专业：</label>
						<div class="col-sm-8">
							<form:input path="specialty" htmlEscape="false" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 入学时间：</label>
						<div class="col-sm-8">
							<div class="input-group date datepicker">
				                 <input name="schoolStart" type="text" readonly="readonly" class="form-control" 
				                 value="<fmt:formatDate value="${hrEmployee.schoolStart}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                 <span class="input-group-addon">
				                      <span class="fa fa-calendar"></span>
				                 </span>
							</div>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 毕业时间：</label>
						<div class="col-sm-8">
							<div class="input-group date datepicker">
				                 <input name="schoolEnd" type="text" readonly="readonly" class="form-control" 
				                 value="<fmt:formatDate value="${hrEmployee.schoolEnd}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
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
						<label class="col-sm-4 control-label"> 最高学历：</label>
						<div class="col-sm-8">
							<form:select path="educationType" cssClass="form-control">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('education_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 毕业证书：</label>
						<div class="col-sm-8">
							<form:hidden id="certificateImg" path="certificateImg" htmlEscape="false" maxlength="255" />
							<sys:ckfinder input="certificateImg" type="images" uploadPath="/image" selectMultiple="false"/>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">从业信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 上家公司：</label>
						<div class="col-sm-8">
							<form:input path="lastCompany" htmlEscape="false" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 上家公司职位：</label>
						<div class="col-sm-8">
							<form:input path="lastPosition" htmlEscape="false" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"> 前公司离职证明：</label>
						<div class="col-sm-10">
							<form:hidden id="leavingCertify" path="leavingCertify" htmlEscape="false" maxlength="255" />
							<sys:ckfinder input="leavingCertify" type="images" uploadPath="/image" selectMultiple="false"/>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">岗位信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 职位：</label>
						<div class="col-sm-8">
							<form:input path="position" htmlEscape="false" maxlength="50" class="form-control required"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 聘用形式：</label>
						<div class="col-sm-8">
							<form:select path="employType" cssClass="form-control">
								<form:options items="${fns:getDictList('employ_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
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
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 入职日期：</label>
						<div class="col-sm-8">
							<div class="input-group date datepicker">
				                 <input name="entryDate" type="text" readonly="readonly" class="form-control required" 
				                 value="<fmt:formatDate value="${hrEmployee.entryDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
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
						<label class="col-sm-4 control-label"> 转正日期：</label>
						<div class="col-sm-8">
							<div class="input-group date datepicker">
				                 <input name="regularDate" type="text" readonly="readonly" class="form-control" 
				                 value="<fmt:formatDate value="${hrEmployee.regularDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                 <span class="input-group-addon">
				                      <span class="fa fa-calendar"></span>
				                 </span>
							</div>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 转正状态：</label>
						<div class="col-sm-8">
							<form:select path="regularStatus" cssClass="form-control">
								<form:options items="${fns:getDictList('regular_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
				
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 员工状态：</label>
						<div class="col-sm-8">
							<form:select path="status" cssClass="form-control">
								<form:options items="${fns:getDictList('employ_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 工作地点：</label>
						<div class="col-sm-8">
							<form:input path="workAddress" htmlEscape="false" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 首次参加工作时间：</label>
						<div class="col-sm-8">
							<div class="input-group date datepicker">
				                 <input id="firstWorkDate" name="firstWorkDate" type="text" readonly="readonly" class="form-control" 
				                 value="<fmt:formatDate value="${hrEmployee.firstWorkDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" onchange="comWorkAge()">
				                 <span class="input-group-addon">
				                      <span class="fa fa-calendar"></span>
				                 </span>
							</div>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 工龄：</label>
						<div class="col-sm-8">
							<input type="text" id="workAge" name="workAge" class="form-control" readonly="readonly">
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">合同信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 现合同开始时间：</label>
						<div class="col-sm-8">
							<div class="input-group date datepicker">
				                 <input name="contractStartDate" type="text" readonly="readonly" class="form-control" 
				                 value="<fmt:formatDate value="${hrEmployee.contractStartDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                 <span class="input-group-addon">
				                      <span class="fa fa-calendar"></span>
				                 </span>
							</div>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 现合同结束时间：</label>
						<div class="col-sm-8">
							<div class="input-group date datepicker">
				                 <input name="contractEndDate" type="text" readonly="readonly" class="form-control" 
				                 value="<fmt:formatDate value="${hrEmployee.contractEndDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                 <span class="input-group-addon">
				                      <span class="fa fa-calendar"></span>
				                 </span>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"> 合同文件：</label>
						<div class="col-sm-10">
							<form:hidden id="contractFile" path="contractFile" htmlEscape="false" maxlength="255" />
							<sys:ckfinder input="contractFile" type="files" uploadPath="/file" selectMultiple="false"/>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">工资信息</h4>			
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 试用期工资(元)：</label>
						<div class="col-sm-8">
							<form:input path="probationSalaryBase" htmlEscape="false" class="form-control"/>
						</div>
					</div>
				</div>
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
			<h4 class="page-header">招聘信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 招聘渠道：</label>
						<div class="col-sm-8">
							<form:select path="recruitSource" cssClass="form-control">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('resume_source')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 推荐企业/人：</label>
						<div class="col-sm-8">
							<form:input path="recommend" htmlEscape="false" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">备注信息</h4>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"> 备注：</label>
						<div class="col-sm-10">
							<form:textarea path="remarks" htmlEscape="false" rows="2" maxlength="200" class="form-control "/>
						</div>
					</div>
				</div>
			</div>
		
			<div class="hr-line-dashed"></div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<div class="col-sm-offset-2 col-sm-10">
							<button id="btnSubmit" class="btn btn-success" type="submit">保存</button>&nbsp;
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