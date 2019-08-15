<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="org.apache.shiro.web.filter.authc.FormAuthenticationFilter"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<meta name="decorator" content="default"/>
	<meta name="description" content="User login page" />
	<title>忘记密码 - ${fns:getConfig('productName')}</title>
  	<style type="text/css">
  		input,button{
  			height: 34px !important;
  		}
  	</style>
  	<script type="text/javascript">
  	$(document).ready(function() {
  		$("#resetForm").validate({
			rules: {
			mobile: {remote: "${ctx}/sys/user/validateMobileExist"}
		},
			messages: {
				mobile:{remote: "此手机号未注册!", required: "手机号不能为空."}
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
  		$('#sendPassBtn').click(function () { 
			if($("#mobile").val()=="" || $("#mobile-error").text()!=""){
				top.layer.alert("请输入有效的注册手机号码！", {icon: 0});
				return;
			}
			$("#sendPassBtn").attr("disabled", true); 
			$.get("${ctx}/sys/user/resetPassword?mobile="+$("#mobile").val(),function(data){
					if(data.success == false){
						layer.alert(data.msg, {icon: 0});
						$("#sendPassBtn").html("重新发送").removeAttr("disabled"); 
						clearInterval(countdown); 
					}
			});
			var count = 60; 
			var countdown = setInterval(CountDown, 1000); 
			function CountDown() { 
				$("#sendPassBtn").attr("disabled", true); 
				$("#sendPassBtn").html("等待 " + count + "秒!"); 
				if (count == 0) { 
					$("#sendPassBtn").html("重新发送").removeAttr("disabled"); 
					clearInterval(countdown); 
				} 
				count--; 
			}
		}) ;
  	});
  	</script>
</head>
<body class="gray-bg">

    <div class="middle-box loginscreen animated fadeInDown">
        <div>
            <div class="text-center">
                <h1 class="logo-name">JF</h1>
                <h3>找回密码</h3>
            </div>
            
            <p>请输入您的注册手机号，您将会收到新的密码。</p>
            <form id="resetForm" method="post" class="form-horizontal">
                <div class="form-group">
                    <input type="text" id="mobile" name="mobile" class="form-control required isMobile" maxlength="11" placeholder="请输入手机号">
                </div>
                
                <div class="form-group">
                	<button id="sendPassBtn" type="button" class="btn btn-success block full-width m-b">发送!</button>
				</div>
                <p class="text-muted text-center"><a href="${ctx}">返回登录</a>
                </p>

            </form>
        </div>
    </div>
</body>
</html>