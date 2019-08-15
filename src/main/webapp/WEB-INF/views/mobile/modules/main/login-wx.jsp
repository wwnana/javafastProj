<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="org.apache.shiro.web.filter.authc.FormAuthenticationFilter"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<meta name="decorator" content="default"/>
	<title>${fns:getConfig('productName')} 登录</title>
	<style type="text/css">
		.panel-body{
			text-align: center;
		}
  	</style>
  	<script type="text/javascript">
	  	$(document).ready(function() {
			//window.location.href = "${ctx}/wechat/login/qrcode";
	  	});
  	</script>
</head>
<body>
<div class="signinpanel">
	 <div class="row">
		 <div class="tabs-container">
		 	<ul class="nav nav-tabs">
		 		<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">普通用户登录</a></li>
		 		<li class="pull-right"><a data-toggle="tab" href="#tab-2" aria-expanded="false">管理员登录</a></li>
		 	</ul>
		 	<div class="tab-content">
		 		<div id="tab-1" class="tab-pane active">
		 			<div class="panel-body">
		 				<br><br><br><br>
		 				<p class="login-box-msg">点击后打开"微信"扫码登录</p>
		 				<br><br>
		 				<a href="${ctx}/wechat/login/qrcode?userType=member">
					    	<img src="//rescdn.qqmail.com/node/wwopen/wwopenmng/style/images/independent/brand/300x40_blue$cecbbc4e.png" srcset="//rescdn.qqmail.com/node/wwopen/wwopenmng/style/images/independent/brand/300x40_blue_2x$c22687e4.png 2x" alt="企业微信登录">
					    </a>
					    <br><br>
		 			</div>
		 		</div>
		 		<div id="tab-2" class="tab-pane">
		 			<div class="panel-body">
		 				<br><br><br><br>
		 				<p class="login-box-msg">点击后打开"微信"扫码登录</p>
		 				<br><br>
		 				<a href="${ctx}/wechat/login/qrcode?userType=admin">
					    	<img src="//rescdn.qqmail.com/node/wwopen/wwopenmng/style/images/independent/brand/300x40_blue$cecbbc4e.png" srcset="//rescdn.qqmail.com/node/wwopen/wwopenmng/style/images/independent/brand/300x40_blue_2x$c22687e4.png 2x" alt="企业微信登录">
					    </a>
					    <br><br>
		 			</div>
		 		</div>
		 	</div>
		 </div>
	 </div>
</div>
    
</body>
</html>