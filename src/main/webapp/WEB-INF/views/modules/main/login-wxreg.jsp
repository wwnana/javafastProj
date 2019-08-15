<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="org.apache.shiro.web.filter.authc.FormAuthenticationFilter"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<meta name="decorator" content="default"/>
	<title>${fns:getConfig('productName')} 企业微信注册</title>
	<style type="text/css">
  	</style>
  	<script type="text/javascript">
	  	$(document).ready(function() {
			window.location.href = "${ctx}/wechat/auth/getAuthRegisterUrl";
	  	});
  	</script>
</head>
<body class="">
	<div class="signinpanel">
	 <div class="row">
	 	<a href="${ctx}/wechat/auth/getAuthRegisterUrl">
	    	<img src="${ctxStatic}/weui/demos/images/register_blue_big.png" alt="企业微信注册">
	    </a>
	 </div>
	 </div>
    
</body>
</html>