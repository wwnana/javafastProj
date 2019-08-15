<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>系统配置编辑</title>
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
<div class="ibox">
	<div class="ibox-title">
		<h5>系统配置${not empty sysConfig.id?'修改':'添加'}</h5>
	</div>
	<div class="ibox-content">
		<div class="alert alert-info alert-dismissable">
	    	<button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
	        	提示和建议：<br>
	        	1、请在企业微信在管理后台->“企业应用”->“自建应用”创建应用，在工作台应用主页设置访问网址：${fns:getConfig('productName')}。<br>
	        	2、企业微信CorpID：每个企业都拥有唯一的corpid，获取此信息可在管理后台“我的企业”－“企业信息”下查看（需要有管理员权限）。<br>
	        	3、企业微信secret：secret是企业应用里面用于保障数据安全的“钥匙”，每一个应用都有一个独立的访问密钥，为了保证数据的安全，secret务必不能泄漏。<br>
	        	4、企业微信AgentId：每个应用都有唯一的agentid。在管理后台->“企业应用”->点进应用，即可看到agentid。<br>
	     </div>
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="sysConfig" action="${ctx}/sys/sysConfig/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
			<%-- 
			<h4 class="page-header">邮箱配置</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 邮箱服务器地址：</label>
						<div class="col-sm-8">
							<form:input path="mailSmtp" htmlEscape="false" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 邮箱服务器端口：</label>
						<div class="col-sm-8">
							<form:input path="mailPort" htmlEscape="false" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 系统邮箱地址：</label>
						<div class="col-sm-8">
							<form:input path="mailName" htmlEscape="false" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 系统邮箱密码：</label>
						<div class="col-sm-8">
							<form:input path="mailPassword" htmlEscape="false" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<c:if test="${not empty sysConfig.id}">
			<div class="hr-line-dashed"></div>
			<div class="form-actions">
				<shiro:hasPermission name="sys:sysConfig:list">
					<a class="btn btn-white" href="#" onclick="openDialog('测试邮箱', '${ctx}/sys/sysConfig/testMailForm','800px', '500px')"><i class="fa fa-reply"></i>测试邮箱</a>
				</shiro:hasPermission>
			</div>
			</c:if>
			--%>
			<%-- 
			<h4 class="page-header">短信配置</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 短信用户名：</label>
						<div class="col-sm-8">
							<form:input path="smsName" htmlEscape="false" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 短信密码：</label>
						<div class="col-sm-8">
							<form:input path="smsPassword" htmlEscape="false" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			--%>
			<h4 class="page-header">企业微信配置</h4>
			
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 企业微信CorpID：</label>
						<div class="col-sm-8">
							<form:input path="wxCorpid" htmlEscape="false" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 企业微信secret：</label>
						<div class="col-sm-8">
							<form:input path="wxCorpsecret" htmlEscape="false" maxlength="50" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 企业微信AgentId：</label>
						<div class="col-sm-8">
							<form:input path="wxAgentid" htmlEscape="false" maxlength="30" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<c:if test="${sysConfig.wxStatus == 1}">
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 企业微信凭证：</label>
						<div class="col-sm-8">
							<form:input path="wxAccessToken" htmlEscape="false" maxlength="512" class="form-control" readonly="true"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 凭证有效时间（秒）：</label>
						<div class="col-sm-8">
							<form:input path="wxExpiresIn" htmlEscape="false" maxlength="50" class="form-control digits" readonly="true"/>
						</div>
					</div>
				</div>
			</div>
			</c:if>	
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 企业微信连接测试：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								<c:if test="${sysConfig.wxStatus == 1}">成功</c:if>
								<c:if test="${sysConfig.wxStatus == 0}">失败</c:if>
							</p>
						</div>
					</div>
				</div>
			</div>
			
		
			<div class="hr-line-dashed"></div>
			<div class="form-actions">
				<shiro:hasPermission name="sys:sysConfig:list">
					<button id="btnSubmit" class="btn btn-success" type="submit">保存</button>&nbsp;
				</shiro:hasPermission>
				<button id="btnCancel" class="btn btn-white" type="button" onclick="history.go(-1)">返回</button>
			</div>
		</form:form>
	</div>
</div>
</div>
</body>
</html>