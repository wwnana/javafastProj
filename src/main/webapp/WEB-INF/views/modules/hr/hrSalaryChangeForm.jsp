<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>调薪编辑</title>
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
			
			//计算调薪幅度
			$("#baseSalary").change(function(){   
				var oldBaseSalary = $("#oldBaseSalary").val();
				var baseSalary = $("#baseSalary").val();
				if(oldBaseSalary != null && oldBaseSalary != "" && baseSalary != null && baseSalary != ""){
					$("#changeRange").val(((baseSalary-oldBaseSalary)/oldBaseSalary).toFixed(2)*100);
				}
		    });
			
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
		<h5>调薪</h5>
	</div>
	<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="hrSalaryChange" action="${ctx}/hr/hrSalaryChange/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<form:hidden path="hrEmployee.id"/>
			
			<div class="row">
	            <div class="col-sm-6">
					<div class="col-sm-4 text-center">
						<button class="btn btn-success btn-circle btn-lg pull-right" style="width: 100px;height: 100px;border-radius: 50px;font-size: 50px;" type="button">
							${fn:substring(hrSalaryChange.hrEmployee.name, 0, 1)}
	                          </button>
	                  	</div>
					<div class="col-sm-8">
						<div class="form-horizontal">
							<div class="row">
								<div class="col-sm-12">
									<div class="view-group">
										<p class="form-control-static">姓名：${hrSalaryChange.hrEmployee.name}</p>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-sm-12">
									<div class="view-group">
										<p class="form-control-static">手机：${hrSalaryChange.hrEmployee.mobile}</p>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-sm-12">
									<div class="view-group">
										<p class="form-control-static">部门：${hrSalaryChange.hrEmployee.office.name}</p>
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
						<label class="col-sm-4 control-label"><font color="red">*</font> 调薪前基本工资：</label>
						<div class="col-sm-8">
							<form:input path="oldBaseSalary" htmlEscape="false" class="form-control required number" min="0.01" max="1000000000"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 调薪后基本工资：</label>
						<div class="col-sm-8">
							<form:input path="baseSalary" htmlEscape="false" class="form-control required number" min="0.01" max="1000000000" />
						</div>
					</div>
				</div>
				
			</div>
			
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 调整幅度(%)：</label>
						<div class="col-sm-8">
							<form:input path="changeRange" htmlEscape="false" class="form-control" readonly="true"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 调薪生效时间：</label>
						<div class="col-sm-8">
							<div class="input-group date datepicker">
				                 <input name="effectDate" type="text" readonly="readonly" class="form-control required" 
				                 value="<fmt:formatDate value="${hrSalaryChange.effectDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
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
						<label class="col-sm-4 control-label"> 调薪原因：</label>
						<div class="col-sm-8">
							<form:textarea path="changeCause" htmlEscape="false" rows="4" maxlength="200" class="form-control "/>
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