<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>客户关怀编辑</title>
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
<body class="hideScroll">
	<div class="ibox-content">
		<form:form id="inputForm" modelAttribute="scmCare" action="${ctx}/scm/scmCare/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>	
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"><font color="red">*</font> 主题</label>
						<div class="col-sm-10">
							<form:input path="name" htmlEscape="false" maxlength="50" class="form-control required"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"><font color="red">*</font> 客户</label>
						<div class="col-sm-10">
							<sys:tableselect id="customer" name="customer.id" value="${scmCare.customer.id}" labelName="customer.name" labelValue="${scmCare.customer.name}" 
						title="客户" url="${ctx}/crm/crmCustomer/selectList" cssClass="form-control required" dataMsgRequired="必选"  allowClear="false" allowInput="false"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label">联系人</label>
						<div class="col-sm-10">
							<form:input path="contacterName" htmlEscape="false" maxlength="30" class="form-control "/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label">关怀类型</label>
						<div class="col-sm-10">
							<form:select path="careType" cssClass="form-control ">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('care_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"><font color="red">*</font> 关怀日期</label>
						<div class="col-sm-10">
							<div class="input-group date datepicker">
								<input name="careDate" type="text" readonly="readonly" class="form-control required" value="<fmt:formatDate value="${scmCare.careDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
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
						<label class="col-sm-2 control-label"><font color="red">*</font> 负责人</label>
						<div class="col-sm-10">
							<sys:treeselect id="ownBy" name="ownBy.id" value="${scmCare.ownBy.id}" labelName="ownBy.name" labelValue="${scmCare.ownBy.name}"
							title="用户" url="/sys/office/treeData?type=3" cssClass="form-control required" dataMsgRequired="必选" allowClear="true" notAllowSelectParent="true"/>
						</div>
					</div>
				</div>
				
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label">关怀内容</label>
						<div class="col-sm-10">
							<form:textarea path="careNote" htmlEscape="false" rows="4" maxlength="200" class="form-control "/>
						</div>
					</div>
				</div>
			</div>
			
			
			
			
		
		</form:form>
	</
</body>
</html>