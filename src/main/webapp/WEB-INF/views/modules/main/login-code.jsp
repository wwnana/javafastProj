<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html class="gt-ie8 gt-ie9 not-ie">
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

</script>
<script type="text/javascript">
	  	var validateForm;
		function doSubmit(){//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
		  if(validateForm.form()){
			  $("#loginForm").submit();
			  return true;
		  }
	
		  return false;
		}
	  	$(document).ready(function() {
			
	  		validateForm=$("#loginForm").validate({
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
	  		
			$('#sendCodeBtn').click(function () { 
				
				if($("#mobile").val()=="" || $("#mobile-error").text()!=""){
					top.layer.alert("请输入有效的注册手机号码！", {icon: 0});//讨厌的白色字体问题
					return;

				}
				$("#mobile").attr("readonly", true);
				$("#sendCodeBtn").attr("disabled", true);
				$.get("${ctx}/codeLogin/getLoginCode?mobile="+$("#mobile").val(),function(data){
						if(data.success == false){
							//top.layer.alert(data.msg, {icon: 0});
							layer.alert(data.msg);
							$("#sendCodeBtn").html("重新发送").removeAttr("disabled"); 
							clearInterval(countdown); 
						}
				});
				var count = 300; 
				var countdown = setInterval(CountDown, 1000); 
				function CountDown() { 
					$("#sendCodeBtn").attr("disabled", true); 
					$("#sendCodeBtn").html("等待 " + count + "秒!"); 
					if (count == 0) { 
						$("#sendCodeBtn").html("重新发送").removeAttr("disabled"); 
						clearInterval(countdown); 
					} 
					count--; 
				}
				
			});
			
		});
  	</script>
	
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
				<img src="${ctxStatic}/assets/demo/logo-big-jf.png" alt="" style="margin-top: -5px;width: 30px;border-radius: 3px;">&nbsp;
				JavaFast
			</a> <!-- / .logo -->
			<div class="slogan">
				让软件开发极限提速！
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

			<form id="loginForm" class="form-signin" action="${ctx}/codeLogin/doLogin" method="post">
			
				<div class="signin-text">
					<span>使用手机短信验证码进行登录</span>
				</div> <!-- / .signin-text -->
				
				<sys:message content="${message}"/>
				
				<div class="form-group w-icon">
					<input type="text" id="mobile" name="mobile" class="form-control input-lg required isMobile" placeholder="手机号码" >
					<span class="fa fa-phone signin-form-icon"></span>
					<label id="mobile-error" class="error" for="code" style="display:none"></label>   
				</div>
				
				
				<div class="form-group w-icon">
					<div class="input-group">
						<input type="text" id="randomCode" name="randomCode" class="form-control input-lg required" placeholder="验证码" >
						<span class="fa fa-envelope-o signin-form-icon"></span>
						<span class="input-group-btn">
                    		<button id="sendCodeBtn" type="button" class="btn btn-white" style="height: 45px;">点击获取验证码 </button>
                    	</span>
                    </div>
                   <label id="randomCode-error" class="error" for="randomCode" style="display:none"></label>                
				</div>
                    
				<div class="form-group">
                    <input type="checkbox" id="rememberMe" name="rememberMe" checked="checked" class="i-checks"> 下次自动登录 
                </div>
                    
				<div class="form-actions">
					<button type="submit" class="signin-btn bg-primary">登录</button>
					<%-- 
					<a href="#" class="forgot-password" id="forgot-password-link">忘记密码?</a>
					--%>
				</div>
			</form>
			<!-- / Form -->

			<div class="signin-with">
				<a href="${ctx}" class="signin-with-btn" style="background:#4f6faa;background:rgba(79, 111, 170, .8);">账号密码<span>登录</span></a>
			</div>
			

			
		</div>
		<!-- Right side -->
	</div>
	<!-- / Container -->

	<div class="not-a-member">
		还没有账号? <a href="${ctx}/sys/register">立即注册</a>
	</div>




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

	window.PixelAdmin.start(init);
</script>

</body>
</html>
