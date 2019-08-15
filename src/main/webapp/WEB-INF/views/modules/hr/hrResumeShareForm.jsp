<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>简历推荐/共享</title>
	<meta name="decorator" content="default"/>
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
<body class="hideScroll">
	<div class="ibox-content">
		<form:form id="inputForm" modelAttribute="hrResumeRecord" action="${ctx}/hr/hrResume/saveShare" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<form:hidden path="hrResume.id"/>
		<sys:message content="${message}"/>
			
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
                    </div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
							<button class="btn btn-success btn-circle btn-lg" type="button">
								${fn:substring(hrResumeRecord.hrResume.name, 0, 1)}
                            </button>&nbsp;&nbsp;
                            ${hrResumeRecord.hrResume.name } / ${hrResumeRecord.hrResume.position }
                    </div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label">共享给：</label>
						<div class="col-sm-8">
							<sys:treeselect id="user" name="user.id" value="" labelName="user.name" labelValue=""
								title="用户" url="/sys/office/treeData?type=3" cssClass="form-control required" dataMsgRequired="必选" allowClear="true" notAllowSelectParent="true" />
						</div>
					</div>
				</div>
			</div>
			
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label">通&nbsp;&nbsp;&nbsp;&nbsp;知：</label>
						<div class="col-sm-10">
						<p class="form-control-static">
							<input type="checkbox" id="isMsg" name="isMsg" value="1" class="i-checks"> 企业微信通知 					
							<input type="checkbox" id="isSmsMsg" name="isSmsMsg" value="1" class="i-checks"> 手机短信通知
						</p>
						</div>
					</div>
				</div>
			</div>
		</form:form>
	</div>
</body>
</html>