<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>系统配置管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	$(document).ready(function(){

		$("#inputForm").validate({  
	        rules: {  
			mailName: {  
	    required: true,  
	    email: true  
	   }}});


	});
	function modifyMail(){
		if($("#inputForm").valid() == false){
			return;
		}
		$.ajax({
	        async: false,
	        url: "${ctx}/sys/systemConfig/save",
	        data:{"smtp":$("#smtp").val(),"port":$("#port").val(),"mailName":$("#mailName").val(),"mailPassword":$("#mailPassword").val()},
	        dataType: "json",
	        success: function (data) {
	    	    if(data.success){
	    	    	top.layer.alert("保存成功！");
	    	    }else{
	    	    	top.layer.alert("保存失败！");
	    	    }
	        }
		});
	}

	function modifySms(){
		$.ajax({
	        async: false,
	        url: "${ctx}/sys/systemConfig/save",
	        data:{"smsName":$("#smsName").val(),"smsPassword":$("#smsPassword").val()},
	        dataType: "json",
	        success: function (data) {
	    	    if(data.success){
	    	    	top.layer.alert("保存成功！");
	    	    }else{
	    	    	top.layer.alert("保存失败！");
	    	    }
	        }
		});
	}
	</script>
</head>
<body>
<div class="wrapper-content">
<div class="ibox">
	<div class="ibox-title">
		<h5>系统配置 </h5>
	</div>
	<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="systemConfig" action="${ctx}/sys/systemConfig/save" method="post" class="form-horizontal">
			<h4 class="page-header">邮箱设置 </h4>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"><font color="red">*</font> 邮箱服务器地址</label>
						<div class="col-sm-10">
							<form:input path="smtp" htmlEscape="false" maxlength="64" class="form-control "/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"><font color="red">*</font> 邮箱服务器端口</label>
						<div class="col-sm-10">
							<form:input path="port" htmlEscape="false" maxlength="64" class="form-control "/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"><font color="red">*</font> 系统邮箱地址</label>
						<div class="col-sm-10">
							<form:input path="mailName" htmlEscape="false" maxlength="64" class="form-control "/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"><font color="red">*</font> 系统邮箱密码</label>
						<div class="col-sm-10">
							<form:input path="mailPassword" htmlEscape="false" maxlength="64" class="form-control required"/>
						</div>
					</div>
				</div>
			</div>
			<div class="hr-line-dashed"></div>
			<div class="form-actions">
				<shiro:hasPermission name="sys:systemConfig:index">
					<button id="btnSubmit" class="btn btn-info" type="button" onclick="modifyMail()"><i class="fa fa-check"></i> 保存</button>&nbsp;
					<a class="btn btn-info" href="${ctx }/sys/systemConfig/testMail"><i class="fa fa-check"></i> 测试</a>&nbsp;
				</shiro:hasPermission>
				<button id="btnCancel" class="btn btn-white" type="button" onclick="history.go(-1)"><i class="fa fa-reply"></i> 返回</button>
			</div>
		</form:form>
	</div>
</div>
</div>
			
		<%-- 
		<div class="col-sm-5">
			<form:form id="inputForm1" modelAttribute="systemConfig" action="${ctx}/sys/systemConfig/save" method="post" class="form-horizontal">
					  <div class="panel panel-success">
			              <div class="panel-heading">
			                <i class="fa fa-comment"></i> 短信设置(<a href="http://www.cnsms.cn/" target="_blank"><font color="white">企信通</font></a>)
			              	<div class="pull-right">
									<a href="#" onclick="modifySms()" style="color:white">
										<i style="font-size: 20px" class="fa  fa-save"></i>
									</a>
								</div>
			              </div>
			              <div class="panel-body">
			                 <table class="table table-striped">
										<tr>
											<td class="width-15"><label class="pull-right">短信用户名：</label></td>
											<td class="width-35">
												<form:input path="smsName" htmlEscape="false" maxlength="64" class="form-control "/>
											</td>
										</tr>
										<tr>
											<td class="width-15"><label class="pull-right">短信密码：</label></td>
											<td class="width-35">
												<form:input path="smsPassword" htmlEscape="false" maxlength="64" class="form-control "/>
											</td>
										</tr>
								</table>
			                 </div>
			             </div>
			
				</form:form>
		</div>
		--%>
	</div>
</body>
</html>