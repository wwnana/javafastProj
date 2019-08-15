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
		<h5>企业微信打卡、审批Secret配置</h5>
	</div>
	<div class="ibox-content">
		<div class="alert alert-info alert-dismissable">
	    	<button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
	        	提示和建议：<br>
	        	1、打卡应用的Secret：企业微信在管理后台->“企业应用”->“打卡”->“API”点击进入，即可看到。<br>
	        	2、审批应用的Secret：企业微信在管理后台->“企业应用”->“审批”->“API”点击进入，即可看到。<br>
	        	3、考勤数据来源于企业微信，请开启企业微信考勤并设置考勤规则<a class="alert-link" href="https://work.weixin.qq.com/wework_admin/frame#attendance/chart">了解更多</a>.
	     </div>

		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="sysConfig" action="${ctx}/sys/sysConfig/saveSecret" method="post" class="form-horizontal">
		<form:hidden path="id"/>
			<h4 class="page-header">企业微信配置</h4>
			
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 企业微信CorpID：</label>
						<div class="col-sm-8">
							<form:input path="wxCorpid" htmlEscape="false" maxlength="50" class="form-control required" readonly="true"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 打卡应用的Secret：</label>
						<div class="col-sm-8">
							<form:input path="checkinSecret" htmlEscape="false" maxlength="50" class="form-control required"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 审批应用的Secret：</label>
						<div class="col-sm-8">
							<form:input path="approvalSecret" htmlEscape="false" maxlength="50" class="form-control required"/>
						</div>
					</div>
				</div>
			</div>
		
			<div class="hr-line-dashed"></div>
			<div class="form-actions">
				<shiro:hasPermission name="sys:sysConfig:list">
					<button id="btnSubmit" class="btn btn-success" type="submit"><i class="fa fa-check"></i> 保存</button>&nbsp;
				</shiro:hasPermission>
				<button id="btnCancel" class="btn btn-white" type="button" onclick="history.go(-1)"><i class="fa fa-reply"></i> 返回</button>
			</div>
		</form:form>
	</div>
</div>
</div>
</body>
</html>