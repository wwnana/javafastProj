<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>面试邀请预览</title>
	<meta name="decorator" content="default"/>
	<link rel="stylesheet" href="${ctxStatic}/common/timeline.css" />
	<style type="text/css">
	#readDiv{ 
		
		border: 100px solid #E8E9F7; 
		background-color: white; 
		
		overflow: auto;
		width: auto;	
		height: auto; 	
	}
	</style>
	<script type="text/javascript">
		var validateForm;
		function doSubmit(){//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
		  if(validateForm.form()){
			  $("#inputForm").submit();
			  return true;
		  }
	
		  return false;
		}
		$(document).ready(function() {
			
			//$("#name").focus();
			validateForm=$("#inputForm").validate({
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
		});
	</script>
</head>
<body class="gray-bg">
<form:form id="inputForm" modelAttribute="hrInterview" action="${ctx}/hr/hrInterview/savePreview" method="post">
		<form:hidden path="id"/>
		<form:hidden path="hrResume.id"/>
		<form:hidden path="position"/>
		<input id="interviewDate" name="interviewDate" type="hidden" readonly="readonly" class="form-control required" value="<fmt:formatDate value="${hrInterview.interviewDate}" pattern="yyyy-MM-dd HH:mm"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm',isShowClear:true});" >
		<form:hidden path="interviewBy.id"/>
		<form:hidden path="linkMan"/>
		<form:hidden path="linkPhone"/>
		<form:hidden path="address"/>
		<form:hidden path="company"/>
		<form:hidden path="isSmsMsg"/>
		<form:hidden path="isEmailMsg"/>
		<form:hidden path="content"/>
		
<div class=" pb60">
<div class="ibox">
	<div class="ibox-title">
		<h5>面试通知预览</h5>
	</div>
	<div class="ibox-content" style="min-height: 600px">
		<sys:message content="${message}"/>
		<div class="row">
		<div class="col-sm-12">
			<div class="box-timeline">
				<ul class="text-center" style="width: 800px;" >
					<li>
						填写信息
						<div class="box-num1">
							1
						</div>
					</li>
					<li class="ml45">
						预览邮件
						<div class="box-outside1 outside2ab" id="outside1abs">
							<div class="box-num1 num1ab">
							  2
						    </div>
						</div>
					</li>
					<li class="ml45">
						完成
						<div class="box-outside2 outside2a" id="outside2as">
							<div class="box-num3 num3a" >
							 3
						   </div>
						</div>
					</li>
				</ul>
			</div>
		</div>
		</div>
		<br>
		
		<div id="readDiv" class="gray-bg">
				<div style="border: 2px dashed #39f;">
					<div style="margin: 50px;">
						<p>${hrInterview.content}</p>
					</div>
				</div>
		</div>
</div>
</div>
<div class="row dashboard-footer white-bg">
	         <div class="col-sm-12">
	        	<div class="text-center">
	        		<button id="btnRead" class="btn btn-success" type="submit">发送</button>
					<button id="btnCancel" class="btn btn-white" type="button" onclick="history.go(-1)">返回</button>
	        	</div>
	        </div>
</div>
</form:form>
</body>
</html>