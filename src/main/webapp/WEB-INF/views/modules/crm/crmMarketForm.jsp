<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>市场活动编辑</title>
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
		<form:form id="inputForm" modelAttribute="crmMarket" action="${ctx}/crm/crmMarket/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 活动名称：</label>
						<div class="col-sm-8">
							<form:input path="name" htmlEscape="false" maxlength="50" class="form-control required"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 开始日期：</label>
						<div class="col-sm-8">
							<div class="input-group date datepicker">
				                 <input name="startDate" type="text" readonly="readonly" class="form-control required" 
				                 value="<fmt:formatDate value="${crmMarket.startDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
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
						<label class="col-sm-4 control-label"><font color="red">*</font> 截止日期：</label>
						<div class="col-sm-8">
							<div class="input-group date datepicker">
				                 <input name="endDate" type="text" readonly="readonly" class="form-control required" 
				                 value="<fmt:formatDate value="${crmMarket.endDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                 <span class="input-group-addon">
				                      <span class="fa fa-calendar"></span>
				                 </span>
							</div>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 活动类型：</label>
						<div class="col-sm-8">
							<form:select path="marketType" cssClass="form-control">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('market_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
			</div>
			
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 预计成本：</label>
						<div class="col-sm-8">
							<form:input path="estimateCost" htmlEscape="false" class="form-control isDecimal"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 实际成本：</label>
						<div class="col-sm-8">
							<form:input path="actualCost" htmlEscape="false" class="form-control isDecimal"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 预计收入：</label>
						<div class="col-sm-8">
							<form:input path="estimateAmount" htmlEscape="false" class="form-control isDecimal"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 实际收入：</label>
						<div class="col-sm-8">
							<form:input path="actualAmount" htmlEscape="false" class="form-control isDecimal"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 邀请人数：</label>
						<div class="col-sm-8">
							<form:input path="inviteNum" htmlEscape="false" maxlength="11" class="form-control digits"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 实际人数：</label>
						<div class="col-sm-8">
							<form:input path="actualNum" htmlEscape="false" maxlength="11" class="form-control digits"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 活动地点：</label>
						<div class="col-sm-8">
							<form:input path="marketAddress" htmlEscape="false" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
			
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 负责人：</label>
						<div class="col-sm-8">
							<sys:treeselect id="ownBy" name="ownBy.id" value="${crmMarket.ownBy.id}" labelName="ownBy.name" labelValue="${crmMarket.ownBy.name}"
								title="用户" url="/sys/office/treeData?type=3" cssClass="form-control" allowClear="true" notAllowSelectParent="true"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 活动状态：</label>
						<div class="col-sm-8">
							<form:select path="status" cssClass="form-control">
								<form:options items="${fns:getDictList('market_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"> 活动描述：</label>
						<div class="col-sm-10">
							<form:textarea path="remarks" htmlEscape="false" rows="3" maxlength="255" class="form-control "/>
						</div>
					</div>
				</div>
			</div>
			
		
		</form:form>
	</div>
</body>
</html>