<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>服务工单编辑</title>
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
		<form:form id="inputForm" modelAttribute="crmService" action="${ctx}/crm/crmService/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<form:hidden path="no"/>
		<form:hidden path="customer.id"/>
			
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"><font color="red">*</font> 主题：</label>
						<div class="col-sm-10">
							<form:input path="name" htmlEscape="false" maxlength="50" class="form-control required"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"><font color="red">*</font> 类型：</label>
						<div class="col-sm-10">
							<form:select path="serviceType" cssClass="form-control">
								<form:options items="${fns:getDictList('service_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"><font color="red">*</font> 负责人：</label>
						<div class="col-sm-10">
							<sys:treeselect id="ownBy" name="ownBy.id" value="${crmService.ownBy.id}" labelName="ownBy.name" labelValue="${crmService.ownBy.name}"
								title="用户" url="/sys/office/treeData?type=3" cssClass="form-control required" allowClear="true" notAllowSelectParent="true"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"> 优先级：</label>
						<div class="col-sm-10">
							<form:select path="levelType" cssClass="form-control">
								<form:options items="${fns:getDictList('level_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
			</div>
			<div class="row">	
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"> 截止日期：</label>
						<div class="col-sm-10">
							<div class="input-group date datepicker">
				                 <input name="endDate" type="text" readonly="readonly" class="form-control" 
				                 value="<fmt:formatDate value="${crmService.endDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
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
						<label class="col-sm-2 control-label"><font color="red">*</font> 工单内容：</label>
						<div class="col-sm-10">
							<form:textarea path="content" htmlEscape="false" rows="4" maxlength="500" class="form-control required"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"> 期望结果：</label>
						<div class="col-sm-10">
							<form:textarea path="expecte" htmlEscape="false" rows="4" maxlength="200" class="form-control "/>
						</div>
					</div>
				</div>
			</div>
						
		
		</form:form>
	</div>
</body>
</html>