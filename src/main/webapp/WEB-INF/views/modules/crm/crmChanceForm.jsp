<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>商机管理</title>
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
<body class="">
<div class="">
	<div class="">
		
		<div class="ibox-content">
		<form:form id="inputForm" modelAttribute="crmChance" action="${ctx}/crm/crmChance/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<form:hidden path="periodType"/>
		<sys:message content="${message}"/>	
			<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 商机名称</label>
						<div class="col-sm-8">
							<form:input path="name" htmlEscape="false" maxlength="50" class="form-control required"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 客户</label>
						<div class="col-sm-8">
							<sys:tableselect id="customer" name="customer.id" value="${crmChance.customer.id}" labelName="customer.name" labelValue="${crmChance.customer.name}" 
								title="客户" url="${ctx}/crm/crmCustomer/selectList" cssClass="form-control required" dataMsgRequired="必选"  allowClear="false" allowInput="false"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 销售金额(元)</label>
						<div class="col-sm-8">
							<form:input path="saleAmount" htmlEscape="false" maxlength="12" class="form-control digits"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 赢单率</label>
						<div class="col-sm-8">
							<form:select path="probability" cssClass="form-control">
								<form:options items="${fns:getDictList('probability_type')}" itemLabel="label" itemValue="value" htmlEscape="false" />
							</form:select>
						</div>
					</div>
				</div>
			</div>
			<%-- 
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 商机类型</label>
						<div class="col-sm-8">
							<form:select path="changeType" cssClass="form-control">
								<form:options items="${fns:getDictList('change_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 商机来源</label>
						<div class="col-sm-8">
							<form:select path="sourType" cssClass="form-control">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('sour_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
			</div>
			--%>
			<div class="row">
				
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 负责人</label>
						<div class="col-sm-8">
							<sys:treeselect id="ownBy" name="ownBy.id" value="${crmChance.ownBy.id}" labelName="ownBy.name" labelValue="${crmChance.ownBy.name}"
								title="用户" url="/sys/office/treeData?type=3" cssClass="form-control" allowClear="true" notAllowSelectParent="true"/>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">下次联系提醒</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">联系时间</label>
						<div class="col-sm-8">
							<div class="input-group date datepicker">
								<input name="nextcontactDate" type="text" readonly="readonly" class="form-control" value="<fmt:formatDate value="${crmChance.nextcontactDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
	                     		<span class="input-group-addon">
	                             	<span class="fa fa-calendar"></span>
	                     		</span>
                     		</div>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">联系内容</label>
						<div class="col-sm-8">
							<form:input path="nextcontactNote" htmlEscape="false" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">其他信息</h4>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label">商机描述</label>
						<div class="col-sm-10">
							<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="200" class="form-control"/>
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