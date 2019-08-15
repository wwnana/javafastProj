<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>销售线索编辑</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript" src="${ctxStatic}/address/jsAddress.js"></script>
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
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="crmClue" action="${ctx}/crm/crmClue/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
			<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 公司：</label>
						<div class="col-sm-8">
							<form:input path="name" htmlEscape="false" maxlength="50" class="form-control required"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 所有者：</label>
						<div class="col-sm-8">
							<sys:treeselect id="ownBy" name="ownBy.id" value="${crmClue.ownBy.id}" labelName="ownBy.name" labelValue="${crmClue.ownBy.name}"
								title="用户" url="/sys/office/treeData?type=3" cssClass="form-control" allowClear="true" notAllowSelectParent="true"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 姓名：</label>
						<div class="col-sm-8">
							<form:input path="contacterName" htmlEscape="false" maxlength="30" class="form-control required"/>
						</div>
					</div>
				</div>
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
				
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 职务：</label>
						<div class="col-sm-8">
							<form:input path="jobType" htmlEscape="false" maxlength="20" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 手机：</label>
						<div class="col-sm-8">
							<form:input path="mobile" htmlEscape="false" maxlength="20" class="form-control"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 邮箱：</label>
						<div class="col-sm-8">
							<form:input path="email" htmlEscape="false" maxlength="50" class="form-control email"/>
						</div>
					</div>
				</div>
				
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 线索来源：</label>
						<div class="col-sm-8">
							<form:select path="sourType" cssClass="form-control">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('sour_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 所属行业：</label>
						<div class="col-sm-8">
							<form:select path="industryType" cssClass="form-control">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('industry_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 企业性质：</label>
						<div class="col-sm-8">
							<form:select path="natureType" cssClass="form-control">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('nature_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 企业规模：</label>
						<div class="col-sm-8">
							<form:select path="scaleType" cssClass="form-control">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('scale_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">联系地址</label>
						<div class="col-sm-8">
							<form:select path="province" id="province" class="form-control input-mini"></form:select>
							<form:select path="city" id="city" class="form-control input-mini"></form:select>
							<form:select path="dict" id="dict" class="form-control input-mini"></form:select>
							<script type="text/javascript">
								addressInit('province', 'city', 'dict' , '${crmClue.province}', '${crmClue.city}', '${crmClue.dict}');
							</script>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">详细地址</label>
						<div class="col-sm-8">
							<form:input path="address" htmlEscape="false" maxlength="50" class="form-control" placeholder=""/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">市场活动</label>
						<div class="col-sm-8">
							<sys:tableselect id="crmMarket" name="crmMarket.id" value="${crmClue.crmMarket.id}" labelName="crmMarket.name" labelValue="${crmClue.crmMarket.name}" 
								title="市场活动" url="${ctx}/crm/crmMarket/selectList" cssClass="form-control"  allowClear="true" allowInput="false"/>
						</div>
					</div>
				</div>
			</div>
			
			<h4 class="page-header">下次联系</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 下次联系时间：</label>
						<div class="col-sm-8">
							<div class="input-group date datepicker">
				                 <input name="nextcontactDate" type="text" readonly="readonly" class="form-control" 
				                 value="<fmt:formatDate value="${crmClue.nextcontactDate}" pattern="yyyy-MM-dd HH:mm:ss"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:true});" >
				                 <span class="input-group-addon">
				                      <span class="fa fa-calendar"></span>
				                 </span>
							</div>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 下次联系内容：</label>
						<div class="col-sm-8">
							<form:input path="nextcontactNote" htmlEscape="false" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			
			<h4 class="page-header">备注信息</h4>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"> 备注：</label>
						<div class="col-sm-8">
							<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="200" class="form-control "/>
						</div>
					</div>
				</div>
			</div>
			<div class="hr-line-dashed"></div>
			
		</form:form>
	</div>
</div>
</div>
</body>
</html>