<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>客户管理</title>
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
			$("#extendInfo").hide();
			
			//展开、收缩
			var checkIndex = 1;
			$("#extendBtn").click(function(){
				checkIndex++;
				if((checkIndex%2 ==0)){
					$("#extendBtn").html('<i class="fa fa-angle-double-up"></i> 收缩');
				}else{
					$("#extendBtn").html('<i class="fa fa-angle-double-down"></i> 展开');
				}
			});
			
			//表单校验客户名称是否重名
			validateForm=$("#inputForm").validate({
				rules: {
					name: {
						remote:{
						   url:"${ctx}/crm/crmCustomer/validateCustomerName",
						   data:{
						       id:function(){
						          return $("#id").val();
						       }
				           } 
						}
					}
				},
				messages: {
					name:{remote: "系统中已经存在该客户名称，有可能撞单!", required: "客户名称不能为空."}
				},
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
<body class="white-bg">
<div class="">
	<div class="">
		<div class="ibox-title hide">
			<h5>客户${not empty crmCustomer.id?'修改':'添加'}</h5>
		</div>
		<div class="ibox-content">
	
		<form:form id="inputForm" modelAttribute="crmCustomer" action="${ctx}/crm/crmCustomer/save" method="post" class="form-horizontal">
			<form:hidden path="id"/>
			<form:hidden path="crmClueId"/>
			<sys:message content="${message}"/>	
			<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 客户名称</label>
						<div class="col-sm-8">
							<form:input path="name" htmlEscape="false" maxlength="50" class="form-control required"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 客户分类</label>
						<div class="col-sm-8">
							<form:select path="customerType" class="form-control">
								<form:options items="${fns:getDictList('customer_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 客户级别</label>
						<div class="col-sm-8">
							<form:select path="customerLevel" class="form-control">
								<form:options items="${fns:getDictList('customer_level')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 客户状态</label>
						<div class="col-sm-8">
							<form:select path="customerStatus" class="form-control">
								<form:options items="${fns:getDictList('customer_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">负责人</label>
						<div class="col-sm-8">
							<sys:treeselect id="ownBy" name="ownBy.id" value="${crmCustomer.ownBy.id}" labelName="ownBy.name" labelValue="${crmCustomer.ownBy.name}"
							title="用户" url="/sys/office/treeData?type=3" cssClass="form-control" allowClear="true" notAllowSelectParent="true"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">客户标签</label>
						<div class="col-sm-8">
							<div class="input-group date datepicker">
								<sys:tagselect id="tags" name="tags" value="${crmCustomer.tags}" labelName="crmCustomer.tags" labelValue="${crmCustomer.tags}" 
									title="客户标签" url="${ctx}/crm/crmTag/getSelectData" cssClass="form-control"></sys:tagselect>
									
			                	<a href="${ctx}/crm/crmTag/" class="input-group-addon" title="标签维护"><span class="fa fa-tag"></span></a>
			                </div>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">下次联系时间</label>
						<div class="col-sm-8">
							<div class="input-group date datepicker">
			                	<input name="nextcontactDate" type="text" readonly="readonly" class="form-control" value="<fmt:formatDate value="${crmCustomer.nextcontactDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                	<span class="input-group-addon"><span class="fa fa-calendar"></span></span>
			                </div>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">下次联系内容</label>
						<div class="col-sm-8">
							<form:input path="nextcontactNote" htmlEscape="false" maxlength="50" class="form-control "/>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">更多信息<a href="#"><span id="extendBtn" class="pull-right" onclick="javascript:$('#extendInfo').toggle();su.autoHeight();"><i class="fa fa-angle-double-down"></i> 展开</span></a></h4>
			<div id="extendInfo">
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">客户行业</label>
						<div class="col-sm-8">
							<form:select path="industryType" cssClass="form-control">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('industry_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">客户来源</label>
						<div class="col-sm-8">
							<form:select path="sourType" cssClass="form-control">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('sour_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">公司性质</label>
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
						<label class="col-sm-4 control-label">企业规模</label>
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
						<label class="col-sm-4 control-label">客户电话</label>
						<div class="col-sm-8">
							<form:input path="phone" htmlEscape="false" maxlength="20" class="form-control"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">客户传真</label>
						<div class="col-sm-8">
							<form:input path="fax" htmlEscape="false" maxlength="20" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">客户地址</label>
						<div class="col-sm-8">
							<form:select path="province" id="province" class="form-control input-mini"></form:select>
							<form:select path="city" id="city" class="form-control input-mini"></form:select>
							<form:select path="dict" id="dict" class="form-control input-mini"></form:select>
							<script type="text/javascript">
								addressInit('province', 'city', 'dict' , '${crmCustomer.province}', '${crmCustomer.city}', '${crmCustomer.dict}');
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
			</div>
			
			
			<h4 class="page-header">其他信息</h4>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label">客户描述</label>
						<div class="col-sm-10">
							<form:textarea path="remarks" htmlEscape="false" rows="3" maxlength="200" class="form-control "/>
						</div>
					</div>
				</div>
			</div>	

			<c:if test="${empty crmCustomer.id}">
			<h4 class="page-header">首要联系人</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 姓名</label>
						<div class="col-sm-8">
							<form:input path="crmContacter.name" htmlEscape="false" maxlength="30" class="form-control required"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">职务</label>
						<div class="col-sm-8">
							<form:input path="crmContacter.jobType" htmlEscape="false" maxlength="30" class="form-control "/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">手机</label>
						<div class="col-sm-8">
							<form:input path="crmContacter.mobile" htmlEscape="false" maxlength="20" class="form-control "/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">邮箱</label>
						<div class="col-sm-8">
							<form:input path="crmContacter.email" htmlEscape="false" maxlength="50" class="form-control email"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">QQ</label>
						<div class="col-sm-8">
							<form:input path="crmContacter.qq" htmlEscape="false" maxlength="20" class="form-control "/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">微信</label>
						<div class="col-sm-8">
							<form:input path="crmContacter.wx" htmlEscape="false" maxlength="20" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			</c:if>
				
			
			
					
			</form:form>
		</div>
		</div>
		</div>
</body>
</html>