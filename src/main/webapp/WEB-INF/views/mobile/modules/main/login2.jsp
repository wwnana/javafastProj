<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<meta name="decorator" content="default"/>
	<title>${fns:getConfig('productName')} 微信登录</title>
  	<script type="text/javascript">
	  	$(document).ready(function() {
	  		//自动跳转到微信登录
			window.location.href = "http://crm.qikucrm.com/jf/wechat/login/app?appid=wwd61f16dcd63c4021";
	  	});
  	</script>
</head>
<body>
<div>
	 
</body>
</html>