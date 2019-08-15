<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>邀请您加入</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	$(document).ready(function() {
		$("#joinForm").validate({

			errorLabelContainer: "#messageBox",
			errorPlacement: function(error, element) {
				error.appendTo($("#loginError").parent());
			} 
		});
		
		$('#sendCodeBtn').click(function () { 
			if($("#mobile").val()=="" || $("#tel-error").text()!=""){
				alert("请输入有效的注册手机号码！");//讨厌的白色字体问题
				return;

			}
			$("#sendCodeBtn").attr("disabled", true); 
			$.get("${ctx}/sys/register/getRegisterCode?mobile="+$("#mobile").val(),function(data){
					if(data.success == false){
						
						alert(data.msg);
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
	<style type="text/css">
  		input,button{
  			height: 40px !important;
  		}
  	</style>
</head>
<body class="gray-bg">
<div class="wrapper-content">
<div class="">
	<div class="ibox-title">
		<h5>${user.name}邀请您加入</h5>
	</div>
	<div class="ibox-content">
		<sys:message content="${message}"/>
			<div class="row">
				<div class="pull-center">
					<h3>${sysAccount.name}</h3>
				</div>
			</div>
			<br>
		
		<c:if test="${empty result}">
		<form id="joinForm" class="form-horizontal" action="${ctx}/sys/register/doJoin" method="post">
		<input type="hidden" id="accountId" name="accountId" value="${sysAccount.id }">
		<input type="hidden" id="userId" name="userId" value="${user.id }">
		
			
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<div class="col-sm-8">
							<input type="text" id="mobile" name="mobile" class="form-control uname required isMobile" placeholder="手机号码" />
							<label id="tel-error" class="error" for="mobile" style="display:none"></label>         
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<div class="col-sm-8">
							<input type="text" id="randomCode" name="randomCode" class="form-control input-mini required " placeholder="验证码" />
							 <button id="sendCodeBtn" class="btn btn-default pull-right">点击获取验证码</button>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<div class="col-sm-8">
							<input type="text" id="name" name="name" class="form-control uname required" placeholder="真实姓名" />
						</div>
					</div>
				</div>
			</div>
			
		
			<div class="hr-line-dashed"></div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<div class="col-sm-offset-2 col-sm-10">
							<button id="btnSubmit" class="btn btn-success btn-rounded btn-block" type="submit">加入该组织</button>&nbsp;
						</div>
					</div>
				</div>
			</div>
		</form>
		</c:if>
		
		<c:if test="${not empty result}">
			
			<div class="row">
				<div class="pull-center">
					<h1>${msg }</h1>
				</div>
			</div>
			<br>
		</c:if>
	</div>
</div>
</div>
</body>
</html>