<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="org.apache.shiro.web.filter.authc.FormAuthenticationFilter"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html class="gt-ie8 gt-ie9 not-ie">
<head>
	<meta name="decorator" content="default"/>
	<title>用户注册 - ${fns:getConfig('productName')}</title>

	<!-- Pixel Admin's css -->
	<link href="${ctxStatic}/assets/css/bootstrap.min.css" rel="stylesheet" type="text/css">
	<link href="${ctxStatic}/assets/css/pixel-admin.min.css" rel="stylesheet" type="text/css">
	<link href="${ctxStatic}/assets/css/pages.min.css" rel="stylesheet" type="text/css">
	<link href="${ctxStatic}/assets/css/rtl.min.css" rel="stylesheet" type="text/css">
	<link href="${ctxStatic}/assets/css/themes.min.css" rel="stylesheet" type="text/css">
	
	<!--[if lt IE 9]>
		<script src="${ctxStatic}/assets/js/ie.min.js"></script>
	<![endif]-->

	<style>
		#signup-demo {
			position: fixed;
			right: 0;
			bottom: 0;
			z-index: 10000;
			background: rgba(0,0,0,.6);
			padding: 6px;
			border-radius: 3px;
		}
		#signup-demo img { cursor: pointer; height: 40px; }
		#signup-demo img:hover { opacity: .5; }
		#signup-demo div {
			color: #fff;
			font-size: 10px;
			font-weight: 600;
			padding-bottom: 6px;
		}
		.page-signup .form-group.w-icon .signup-form-icon {
    		height: 27px;
    	}
	</style>

</head>

<body class="theme-default page-signup">

<script type="text/javascript">
	var init = [];
	init.push(function () {
		var $div = $('<div id="signup-demo" class="hidden-xs"><div>网页背景</div></div>'),
		    bgs  = [ '${ctxStatic}/assets/demo/signin-bg-1.jpg', '${ctxStatic}/assets/demo/signin-bg-2.jpg', '${ctxStatic}/assets/demo/signin-bg-3.jpg',
		    		 '${ctxStatic}/assets/demo/signin-bg-4.jpg', '${ctxStatic}/assets/demo/signin-bg-5.jpg', '${ctxStatic}/assets/demo/signin-bg-6.jpg',
					 '${ctxStatic}/assets/demo/signin-bg-7.jpg', '${ctxStatic}/assets/demo/signin-bg-8.jpg', '${ctxStatic}/assets/demo/signin-bg-9.jpg' ];
		for (var i=0, l=bgs.length; i < l; i++) $div.append($('<img src="' + bgs[i] + '">'));
		$div.find('img').click(function () {
			var img = new Image();
			img.onload = function () {
				$('#page-signup-bg > img').attr('src', img.src);
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
		  $("#regForm").submit();
		  return true;
	  }
	  return false;
	}
	$(document).ready(function() {
		
		validateForm=$("#regForm").validate({
			rules: {
				mobile: {remote: "${ctx}/sys/user/validateMobile"},
				randomCode: {
					remote:{
					   url:"${ctx}/sys/register/validateMobileCode", 
					   data:{
				       mobile:function(){
				          return $("#mobile").val();
				          }
		          		} 
					}
				},
				confirmNewPassword: {equalTo:"#loginPass"}
			},
			messages: {
				loginPass: {required: "密码不能为空."},
				confirmNewPassword: {equalTo: "输入与上面相同的密码"},
				ck1: {required: "必须接受用户协议."},
				companyName: {required: "公司名称不能为空."},
				mobile:{remote: "此手机号已经被注册!", required: "手机号不能为空."},
				randomCode:{remote: "验证码不正确!", required: "验证码不能为空."}
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
  		
  		$('#sendCodeBtn').click(function () { 
  			
			if($("#mobile").val()=="" || $("#mobile-error").text()!=""){
				top.layer.alert("请输入有效的注册手机号码！", {icon: 0});//讨厌的白色字体问题
				return;
			}
			$("#sendCodeBtn").attr("disabled", true); 
			$.get("${ctx}/sys/register/getRegisterCode?mobile="+$("#mobile").val(),function(data){
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
	<div id="page-signup-bg">
		<!-- Background overlay -->
		<div class="overlay"></div>
		<!-- Replace this with your bg image -->
		<img src="${ctxStatic}/assets/demo/signin-bg-1.jpg" alt="">
	</div>
	<!-- / Page background -->

	<!-- Container -->
	<div class="signup-container">
		<!-- Header -->
		<div class="signup-header">
			<a href="index.html" class="logo">
				<img src="${ctxStatic}/assets/demo/logo-big-jf.png" alt="" style="margin-top: -5px;width: 30px;border-radius: 3px;">&nbsp;
				JavaFast
			</a> <!-- / .logo -->
			<div class="slogan">
				让软件开发极限提速！
			</div> <!-- / .slogan -->
		</div>
		<!-- / Header -->

		<!-- Form -->
		<div class="signup-form">
			<form id="regForm" action="${ctx}/sys/register/registerUser" method="post">
				
				<div class="signup-text">
					<span>创建帐户</span>
				</div>
				
				<sys:message content="${message}"/>	
				
				<div class="form-group w-icon">
					<input type="text" id="mobile" name="mobile" class="form-control input-lg required isMobile" maxlength="11" placeholder="手机号码">
					<span class="fa fa-phone signup-form-icon"></span>
					<label id="mobile-error" class="error" for="code" style="display:none"></label>   
				</div>
				
				
				<div class="form-group w-icon">
                	<div class="input-group">
                    	<input id="randomCode" name="randomCode" type="text" class="form-control input-lg required" maxlength="6" placeholder="验证码"/>
                    	<span class="fa fa-envelope-o signup-form-icon"></span>
                    	<span class="input-group-btn">
                    		<button id="sendCodeBtn" type="button" class="btn btn-white" style="height: 45px;">点击获取验证码 </button>
                    	</span>
                    </div>
					<label id="randomCode-error" class="error" for="randomCode" style="display:none"></label>                	
                </div>
				

				<div class="form-group w-icon">
					<input type="text" id="companyName" name="companyName" class="form-control input-lg required" placeholder="企业名称">
					<span class="fa fa-home signup-form-icon"></span>
					<label id="companyName-error" class="error" for="companyName" style="display:none"></label>    
				</div>

				<div class="form-group w-icon">
					<input type="password" id="loginPass" name="loginPass" type="password" class="form-control input-lg required" placeholder="密码">
					<span class="fa fa-lock signup-form-icon"></span>
				</div>
				
				<div class="form-group w-icon">
					<input type="password" id="confirmNewPassword" name="confirmNewPassword" type="password" class="form-control input-lg required" placeholder="确认密码">
					<span class="fa fa-lock signup-form-icon"></span>
				</div>

				<div class="form-group" style="margin-top: 20px;margin-bottom: 20px;">
					<label class="checkbox-inline">
						<input type="checkbox" checked="checked" class="px i-checks required">
						<span class="lbl">我同意 <a href="${ctx}/sys/register/agree" target="_blank">用户注册协议</a></span>
					</label>
				</div>

				<div class="form-actions">
					<button type="submit" class="signup-btn bg-primary">注册</button>
				</div>
			</form>
			<!-- / Form -->

			<!-- "Sign In with" block -->
			<div class="signup-with hide">
				<!-- Facebook -->
				<a href="${ctx}" class="signup-with-btn" style="background:#4f6faa;background:rgba(79, 111, 170, .8);">已有账号 <span>直接登录</span></a>
			</div>
			<!-- / "Sign In with" block -->
		</div>
		<!-- Right side -->
	</div>

		<div class="have-account">
		已有账号? <a href="${ctx}">直接登录</a>
	</div>


<script type="text/javascript">
	// Resize BG
	init.push(function () {
		var $ph  = $('#page-signup-bg'),
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
