<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>入职页面</title>
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
		<h5>员工入职</h5>
	</div>
	<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="hrEmployee" action="${ctx}/hr/hrEmployee/saveEntry" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<form:hidden path="hrResume.id"/>
		<form:hidden path="status"/>
		<form:hidden path="graduateSchool"/>
		<form:hidden path="specialty"/>
		<form:hidden path="lastCompany"/>
		<form:hidden path="lastPosition"/>
		<form:hidden path="recruitSource"/>
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
						<label class="col-sm-4 control-label"><font color="red">*</font> 联系手机：</label>
						<div class="col-sm-8">
							<form:input path="mobile" htmlEscape="false" maxlength="20" class="form-control required"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 个人邮箱：</label>
						<div class="col-sm-8">
							<form:input path="email" htmlEscape="false" maxlength="50" class="form-control required"/>
						</div>
					</div>
				</div>
			</div>
			
			<h4 class="page-header">岗位信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 工号：</label>
						<div class="col-sm-8">
							<form:input path="user.no" htmlEscape="false" maxlength="20" class="form-control required"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 部门：</label>
						<div class="col-sm-8">
							<sys:treeselect id="office" name="office.id" value="${hrEmployee.office.id}" labelName="office.name" labelValue="${hrEmployee.office.name}"
							title="部门" url="/sys/office/treeData?type=2" cssClass="form-control required" notAllowSelectParent="true"/>
						</div>
					</div>
				</div>
			</div>
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
						<label class="col-sm-4 control-label"> 工作地点：</label>
						<div class="col-sm-8">
							<form:input path="workAddress" htmlEscape="false" maxlength="50" class="form-control"/>
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
							<form:input path="probationSalaryBase" htmlEscape="false" class="form-control number" min="0.01" max="10000000000"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 转正工资(元)：</label>
						<div class="col-sm-8">
							<form:input path="formalSalaryBase" htmlEscape="false" class="form-control number" min="0.01" max="10000000000"/>
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
			
			<h4 class="page-header">其他设置</h4>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						
						<div class="col-sm-10">
							<input type="checkbox" id="isSmsMsg" name="isSmsMsg" value="1" class="i-checks" checked="checked"> 发送短信通知
							<input type="checkbox" id="isEidt" name="isEidt" value="1" class="i-checks" checked="checked"> 允许员工编辑信息
						</div>
					</div>
				</div>
			</div>
		
			<div class="hr-line-dashed"></div>
			<div class="form-actions">
				<shiro:hasPermission name="hr:hrEmployee:edit">
					<button id="btnSubmit" class="btn btn-success" type="submit">确认入职</button>&nbsp;
				</shiro:hasPermission>
				<button id="btnCancel" class="btn btn-white" type="button" onclick="history.go(-1)">返回</button>
			</div>
		</form:form>
	</div>
</div>
</div>
</body>
</html>