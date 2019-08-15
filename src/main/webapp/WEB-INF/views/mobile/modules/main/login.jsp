<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
    <meta name="decorator" content="default"/>
	<title>${fns:getConfig('productName')} 登录</title>

	<!-- Pixel Admin's css -->
	<link href="${ctxStatic}/assets/css/bootstrap.min.css" rel="stylesheet" type="text/css">
	<link href="${ctxStatic}/assets/css/pixel-admin.min.css" rel="stylesheet" type="text/css">
	<link href="${ctxStatic}/assets/css/pages.min.css" rel="stylesheet" type="text/css">
	<link href="${ctxStatic}/assets/css/rtl.min.css" rel="stylesheet" type="text/css">
	<link href="${ctxStatic}/assets/css/themes.min.css" rel="stylesheet" type="text/css">
	
	<!--[if lt IE 9]>
		<script src="${ctxStatic}/assets/js/ie.min.js"></script>
	<![endif]-->


<!-- $DEMO =========================================================================================

	Remove this section on production
-->
	<style>
		#signin-demo {
			position: fixed;
			right: 0;
			bottom: 0;
			z-index: 10000;
			background: rgba(0,0,0,.6);
			padding: 6px;
			border-radius: 3px;
		}
		#signin-demo img { cursor: pointer; height: 40px; }
		#signin-demo img:hover { opacity: .5; }
		#signin-demo div {
			color: #fff;
			font-size: 10px;
			font-weight: 600;
			padding-bottom: 6px;
		}
		.page-signin .form-group.w-icon .signin-form-icon {
    		height: 27px;
    	}
	</style>
<!-- / $DEMO -->

</head>


<!-- 1. $BODY ======================================================================================
	
	Body

	Classes:
	* 'theme-{THEME NAME}'
	* 'right-to-left'     - Sets text direction to right-to-left
-->
<body class="theme-default page-signin">

<script type="text/javascript">
	var init = [];
	init.push(function () {
		var $div = $('<div id="signin-demo" class="hidden-xs"><div>页面背景</div></div>'),
		    bgs  = [ '${ctxStatic}/assets/demo/signin-bg-1.jpg', '${ctxStatic}/assets/demo/signin-bg-2.jpg', '${ctxStatic}/assets/demo/signin-bg-3.jpg',
		    		 '${ctxStatic}/assets/demo/signin-bg-4.jpg', '${ctxStatic}/assets/demo/signin-bg-5.jpg', '${ctxStatic}/assets/demo/signin-bg-6.jpg',
					 '${ctxStatic}/assets/demo/signin-bg-7.jpg', '${ctxStatic}/assets/demo/signin-bg-8.jpg', '${ctxStatic}/assets/demo/signin-bg-9.jpg' ];
		for (var i=0, l=bgs.length; i < l; i++) $div.append($('<img src="' + bgs[i] + '">'));
		$div.find('img').click(function () {
			var img = new Image();
			img.onload = function () {
				$('#page-signin-bg > img').attr('src', img.src);
				$(window).resize();
			}
			img.src = $(this).attr('src');
		});
		$('body').append($div);
	});

	
  	if (window.top !== window.self) {
		window.top.location = window.location;
	}
  	$(document).ready(function() {
		$("#loginForm").validate({
			rules: {
				validateCode: {remote: "${pageContext.request.contextPath}/servlet/validateCodeServlet"}
			},
			messages: {
				username: {required: "请填写用户名."},password: {required: "请填写密码."},
				validateCode: {remote: "验证码不正确.", required: "请填写验证码."}
			},
			errorLabelContainer: "#messageBox",
			errorPlacement: function(error, element) {
				error.appendTo($("#loginError").parent());
			} 
		});
	});
	// 如果在框架或在对话框中，则弹出提示并跳转到首页
	if(self.frameElement && self.frameElement.tagName == "IFRAME" || $('#left').length > 0 || $('.jbox').length > 0){
		alert('未登录或登录超时。请重新登录，谢谢！');
		top.location = "${ctx}";
	}
</script>
	
	<script>var _urlPath = "${ctxStatic}/";</script>
<!-- Demo script --> <script src="${ctxStatic}/assets/demo/demo2.js"></script> <!-- / Demo script -->

	<!-- Page background -->
	<div id="page-signin-bg">
		<!-- Background overlay -->
		<div class="overlay"></div>
		<!-- Replace this with your bg image -->
		<img src="${ctxStatic}/assets/demo/signin-bg-1.jpg" alt="">
	</div>
	<!-- / Page background -->

	<!-- Container -->
	<div class="signin-container">

		<!-- Left side -->
		<div class="signin-info">
			<a href="#" class="logo">
				${fns:getConfig('productName')}
			</a> <!-- / .logo -->
			<div class="slogan">
				
			</div> <!-- / .slogan -->
			<ul>
				<li><i class="fa fa-sitemap signin-icon"></i> 快速高效</li>
				<li><i class="fa fa-server signin-icon"></i> 安全稳定</li>
				<li><i class="fa fa-bar-chart signin-icon"></i> 完美兼容</li>
				<li><i class="fa fa-tv signin-icon"></i> 支持SAAS</li>
			</ul> <!-- / Info list -->
		</div>
		<!-- / Left side -->

		<!-- Right side -->
		<div class="signin-form">

			<!-- Form <form action="index.html" id="signin-form_id">-->
			<form id="loginForm" class="form-signin" action="${ctx}/login" method="post">
			
				<div class="signin-text">
					<span>登录到您的帐户</span>
				</div> <!-- / .signin-text -->
				
				<sys:message content="${message}"/>
				
				<div class="form-group w-icon">
					<input type="text" id="username" name="username" class="form-control input-lg required" placeholder="用户名" value="">
					<span class="fa fa-user signin-form-icon"></span>
				</div>

				<div class="form-group w-icon">
					<input type="password" id="password" name="password" class="form-control input-lg required" placeholder="密码" value="">
					<span class="fa fa-lock signin-form-icon"></span>
				</div>
				
				<c:if test="${isValidateCodeLogin}">
                   	<div class="form-group">
                   		验证码：<sys:validateCode name="validateCode" inputCssStyle="height:40px;width: 100px;border: 1px solid #d6d6d6;"/>
                   	</div>
                </c:if>
                    
				<div class="form-group">
                    <input type="checkbox" id="rememberMe" name="rememberMe" checked="checked" class="i-checks"> 下次自动登录 
                </div>
                    
				<div class="form-actions">
					<button type="submit" class="signin-btn bg-primary">登录</button>
					<%-- 
					<a href="#" class="forgot-password" id="forgot-password-link">忘记密码?</a>
					--%>
				</div> <!-- / .form-actions -->
			</form>
			<!-- / Form -->

			<!-- "Sign In with" block -->
			<div class="signin-with">
				<!-- Facebook -->
				<a href="${ctx}/codeLogin" class="signin-with-btn" style="background:#4f6faa;background:rgba(79, 111, 170, .8);">短信验证码<span>登录</span></a>
			</div>
			<!-- / "Sign In with" block -->

			<!-- Password reset form -->
			<div class="password-reset-form" id="password-reset-form">
				<div class="header">
					<div class="signin-text">
						<span>Password reset</span>
						<div class="close">&times;</div>
					</div> <!-- / .signin-text -->
				</div> <!-- / .header -->
				
				<!-- Form -->
				<form action="index.html" id="password-reset-form_id">
					<div class="form-group w-icon">
						<input type="text" name="password_reset_email" id="p_email_id" class="form-control input-lg" placeholder="Enter your email">
						<span class="fa fa-envelope signin-form-icon"></span>
					</div> <!-- / Email -->

					<div class="form-actions">
						<input type="submit" value="SEND PASSWORD RESET LINK" class="signin-btn bg-primary">
					</div> <!-- / .form-actions -->
				</form>
				<!-- / Form -->
			</div>
			<!-- / Password reset form -->
		</div>
		<!-- Right side -->
	</div>
	<!-- / Container -->
	<!--
	<div class="not-a-member">
		还没有账号? <a href="${ctx}/sys/register">立即注册</a>
	</div>
	-->

<!-- Pixel Admin's js -->
<script src="${ctxStatic}/assets/js/pixel-admin.min.js"></script>

<script type="text/javascript">
	// Resize BG
	init.push(function () {
		var $ph  = $('#page-signin-bg'),
		    $img = $ph.find('> img');

		$(window).on('resize', function () {
			$img.attr('style', '');
			if ($img.height() < $ph.height()) {
				$img.css({
					height: '100%',
					width: 'auto'
				});
			}
		});
	});

	// Show/Hide password reset form on click
	init.push(function () {
		$('#forgot-password-link').click(function () {
			$('#password-reset-form').fadeIn(400);
			return false;
		});
		$('#password-reset-form .close').click(function () {
			$('#password-reset-form').fadeOut(400);
			return false;
		});
	});

	

	// Setup Password Reset form validation
	init.push(function () {
		$("#password-reset-form_id").validate({ focusInvalid: true, errorPlacement: function () {} });
		
		// Validate email
		$("#p_email_id").rules("add", {
			required: true,
			email: true
		});
	});

	window.PixelAdmin.start(init);
</script>

</body>
</html>
