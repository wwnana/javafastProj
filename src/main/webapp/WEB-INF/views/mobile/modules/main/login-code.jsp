<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="org.apache.shiro.web.filter.authc.FormAuthenticationFilter"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<meta name="decorator" content="default"/>
	<title>${fns:getConfig('productName')} 登录</title>
  	<style type="text/css">
  		input,button{
  			height: 34px !important;
  		}
  	</style>
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
				
				if($("#mobile").val()=="" || $("#tel-error").text()!=""){
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
</head>
<body class="signin">
	 
    <div class="signinpanel">
    	<div class="login-logo">
		     ${fns:getConfig('productName')}
		</div>
		<sys:message content="${message}"/>	
        <div class="row">
            <div class="col-sm-12">
                <form id="loginForm" class="form-signin" action="${ctx}/codeLogin/doLogin" method="post">
                   
                    <p class="login-box-msg">使用手机短信验证码进行登录</p>
                    
                    <div class="form-group">
                   		<input type="text" id="mobile" name="mobile" class="form-control required isMobile" maxlength="11" placeholder="请输入手机号">
                   		<label id="tel-error" class="error" for="mobile" style="display:none"></label>
	                </div>
	                <div class="form-group">
	                	<div class="input-group">
	                    	<input id="randomCode" name="randomCode" type="text" class="form-control required" maxlength="6" placeholder="验证码"/>
	                    	<span class="input-group-btn">
	                    		<button id="sendCodeBtn" type="button" class="btn btn-success">点击获取验证码 </button>
	                    	</span>
	                    </div>
						<label id="tel-error" class="error" for="code" style="display:none"></label>                	
	                </div>
                	
                    <div class="form-group">
                    	<input type="checkbox" id="rememberMe" name="rememberMe" checked="checked" class="i-checks"> 下次自动登录 
                    </div>
                    <div class="form-group">
                   		<button type="submit" class="btn btn-success btn-block">登录</button>
                    </div>
                    <div class="form-group hide">
                    	<p class="text-muted text-center"> <a href="${ctx}">账号密码登录</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<a href="${ctx}/sys/register">注册一个新账号</a>
                    </div>
                    
                </form>
            </div>
        </div>
        
        <div class="signup-footer">
            <div class="">
                &copy; copyright ${fns:getConfig('copyrightYear')} ${fns:getConfig('productName')} 
            </div>
            <br>
        </div>
    </div>
</body>
</html>