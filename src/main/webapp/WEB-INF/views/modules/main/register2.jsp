<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="org.apache.shiro.web.filter.authc.FormAuthenticationFilter"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<meta name="decorator" content="default"/>
	<meta name="description" content="User login page" />
	<title>用户注册 - ${fns:getConfig('productName')}</title>
  	<style type="text/css">
  		input,button{
  			height: 34px !important;
  		}
  	</style>
  	<script type="text/javascript">
  	$(document).ready(function() {
  		$("#regForm").validate({
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
				}
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
			if($("#mobile").val()=="" || $("#tel-error").text()!=""){
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
</head>
<body class="gray-bg">

    <div class="middle-box loginscreen animated fadeInDown">
        <div>
            <div class="text-center">
                <h1 class="logo-name">JF</h1>
                <h3>欢迎注册${fns:getConfig('productName')}</h3>
            </div>
            
            <p>创建一个新账户</p>
            <form id="regForm" action="${ctx}/sys/register/registerUser" method="post" class="form-horizontal">
            
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
					<label id="code-error" class="error" for="code" style="display:none"></label>                	
                </div>
                
                <div class="form-group">
                	<input id="companyName" name="companyName" type="text" maxlength="20" class="form-control required" placeholder="企业名称"/>
                </div>
                <div class="form-group">
                    <input id="loginPass" name="loginPass" type="password" class="form-control required" maxlength="30" minlength="3" placeholder="请输入密码">
                </div>
                <div class="form-group">
                    <input id="confirmNewPassword" name="confirmNewPassword" type="password" class="form-control required" placeholder="请再次输入密码">
                </div>
                <div class="form-group text-left">
                    <div class="checkbox i-checks">
                        <label class="no-padding">
                            <input type="checkbox" checked="checked" class="required"><i></i> <a href="${ctx}/sys/register/agree" target="_blank">我同意注册协议</a></label>
                    </div>
                </div>
                <div class="form-group">
                	<button type="submit" class="btn btn-success block full-width m-b">注 册</button>
				</div>
                <p class="text-muted text-center"><small>已经有账户了？</small><a href="${ctx}">点此登录</a>
                </p>

            </form>
        </div>
    </div>
</body>
</html>