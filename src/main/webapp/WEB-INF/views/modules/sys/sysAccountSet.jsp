<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>企业帐户管理</title>
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
		<div class="row">
			<div class="col-sm-12">
				<div class="ibox">
					<div class="ibox-content">
						<div class="row row-sm text-center">
							<div class="col-xs-3">
                                <div class="panel padder-v item ">
                                    <div class="h3 text-primary font-thin h1">${sysAccount.name }</div>
                                    <span class="text-xs">帐户类型: 正式</span>
                                </div>
                            </div>
                            <div class="col-xs-3">
                                <div class="panel padder-v item ">
                                    <div class="h3 text-info font-thin h1">企业版</div>
                                    <span class="text-xs">当前版本</span>
                                </div>
                            </div>
                            <div class="col-xs-3">
                                <div class="panel padder-v item ">
                                    <div class="h3 text-info font-thin h1">${sysAccount.nowUserNum }</div>
                                    <span class="text-xs">你的企业现拥有的帐号数</span>
                                </div>
                            </div>
                            <div class="col-xs-3">
                                <div class="panel padder-v item">
                                    <div class="h3 text-info font-thin h1">
                                    	<c:if test="${sysAccount.payStatus == 0}">正常</c:if>
                                    	<c:if test="${sysAccount.payStatus == 1}">欠费</c:if>
                                    </div>
                                    <span class="text-xs">状态</span>
                                </div>
                            </div>
                            
                        </div>
					</div>
				</div>
			</div>
		</div>
		<div class="ibox">
			<div class="ibox-title">
				<h5>系统设置</h5>
			</div>
			<div class="ibox-content">
				<form:form id="inputForm" modelAttribute="sysAccount" action="${ctx}/sys/sysAccount/saveSet" method="post" class="form-horizontal">
				<form:hidden path="id"/>
				<sys:message content="${message}"/>	
				<h4 class="page-header">基本信息</h4>
				<div class="row">
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label"><font color="red">*</font> 系统名称：</label>
							<div class="col-sm-8">
								<form:input path="systemName" htmlEscape="false" maxlength="20" class="form-control required"/>
							</div>
						</div>
					</div>
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label"><font color="red">*</font> 公司名称：</label>
							<div class="col-sm-8">
								<form:input path="name" htmlEscape="false" maxlength="20" class="form-control required"/>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label"><font color="red">*</font> 注册手机：</label>
							<div class="col-sm-8">
								<form:input path="mobile" htmlEscape="false" maxlength="11" class="form-control required" readonly="true"/>
							</div>
						</div>
					</div>
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label"> 公司英文名：</label>
							<div class="col-sm-8">
								<form:input path="enname" htmlEscape="false" maxlength="50" class="form-control "/>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">电话：</label>
							<div class="col-sm-8">
								<form:input path="phone" htmlEscape="false" maxlength="20" class="form-control "/>
							</div>
						</div>
					</div>
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label"> 邮箱：</label>
							<div class="col-sm-8">
								<form:input path="email" htmlEscape="false" maxlength="30" class="form-control email"/>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">传真：</label>
							<div class="col-sm-8">
								<form:input path="fax" htmlEscape="false" maxlength="20" class="form-control "/>
							</div>
						</div>
					</div>
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label"> 地址：</label>
							<div class="col-sm-8">
								<form:input path="address" htmlEscape="false" maxlength="50" class="form-control "/>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">开户银行：</label>
							<div class="col-sm-8">
								<form:input path="bankaccountname" htmlEscape="false" maxlength="20" class="form-control "/>
							</div>
						</div>
					</div>
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label"> 开户帐号：</label>
							<div class="col-sm-8">
								<form:input path="bankaccountno" htmlEscape="false" maxlength="50" class="form-control "/>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">公司LOGO：</label>
							<div class="col-sm-8">
								<form:hidden id="logo" path="logo" htmlEscape="false" maxlength="255" class=""/>
								<sys:ckfinder input="logo" type="images" uploadPath="/image" selectMultiple="false" maxWidth="100" maxHeight="100"/>
								<span class="help-inline">(建议尺寸：160*160)</span>
							</div>
						</div>
					</div>
					
				</div>
				<h4 class="page-header">其他设置</h4>
				<div class="row">
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">开通短信服务：</label>
							<div class="col-sm-8">
								<form:select path="smsStatus" cssClass="form-control">
									<form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
								</form:select>
								<span class="help-inline">短信提醒、问候短信、营销短信等</span>
							</div>
						</div>
					</div>
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">独立域名：</label>
							<div class="col-sm-8">
								<form:input path="neturl" htmlEscape="false" maxlength="50" class="form-control url"/>
								<span class="help-inline">设置您的个性域名，平台审核后生效</span>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">客户回收周期(天)：</label>
							<div class="col-sm-8">
								<form:input path="crmRetrievePeriod" htmlEscape="false" maxlength="50" class="form-control required digits" min="5" max="300"/>
								<span class="help-inline">超期未联系的客户自动转入公海</span>
							</div>
						</div>
					</div>
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">客户联系提醒周期(天)：</label>
							<div class="col-sm-8">
								<form:input path="crmContactRemindPeriod" htmlEscape="false" maxlength="50" class="form-control required digits" min="5" max="300"/>
								<span class="help-inline">超期未联系的客户系统自动提醒</span>
							</div>
						</div>
					</div>
				</div>
				<div class="hr-line-dashed"></div>
				<div class="form-actions">
					<input id="btnSubmit" class="btn btn-success" type="submit" value="保 存"/>&nbsp;
					<input id="btnCancel" class="btn btn-white" type="button" value="返 回" onclick="history.go(-1)"/>
				</div>
				
				<h4 class="page-header">授权信息</h4>
				<div class="row">
					<div class="col-sm-6">
						<div class="view-group">
							<label class="col-sm-4 control-label">管理员账号：</label>
							<div class="col-sm-8">
								<p class="form-control-static">${sysAccount.adminUserId }</p>
							</div>
						</div>
					</div>
					<div class="col-sm-6">
						<div class="view-group">
							<label class="col-sm-4 control-label"> 授权用户数：</label>
							<div class="col-sm-8">
								<p class="form-control-static">${sysAccount.maxUserNum }</p>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-sm-6">
						<div class="view-group">
							<label class="col-sm-4 control-label">当前用户数：</label>
							<div class="col-sm-8">
								<p class="form-control-static">${sysAccount.nowUserNum }</p>
							</div>
						</div>
					</div>
					<div class="col-sm-6">
						<div class="view-group">
							<label class="col-sm-4 control-label"> 状态：</label>
							<div class="col-sm-8">
								<p class="form-control-static">
								<c:if test="${sysAccount.status == 1}">冻结</c:if>
								<c:if test="${sysAccount.status == 0}">激活</c:if>
								</p>
							</div>
						</div>
					</div>
				</div>
				<%-- 
				<div class="row">
					<div class="col-sm-6">
						<div class="view-group">
							<label class="col-sm-4 control-label">API接口权限：</label>
							<div class="col-sm-8">
								<p class="form-control-static">
								<c:if test="${not empty sysAccount.apiSecret }">已获得</c:if>
								<c:if test="${empty sysAccount.apiSecret }">未获得，请联系平台方授权</c:if>
								</p>
							</div>
						</div>
					</div>
					<div class="col-sm-6">
						<div class="view-group">
							<label class="col-sm-4 control-label"> API接口 Key Secret：</label>
							<div class="col-sm-8">
								<p class="form-control-static">${sysAccount.apiSecret }</p>
							</div>
						</div>
					</div>
				</div>
				--%>
				
				
		
				</form:form>
				
			</div>
		</div>
		<div class="alert alert-info alert-dismissable">
	    	<button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
	        	提示和建议：<br>
	        	
	        	1、开通短信服务，请保证账户余额300元以上，短信费用5元/100条.<br>
	        	2、如果需要授权更多用户数，请联系在线客服.<br>
	        	3、请填写详细的企业信息，方便平台联系到您.<br>
	     </div>
	</div>
</body>
</html>