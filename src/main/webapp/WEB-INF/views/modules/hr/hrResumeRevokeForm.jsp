<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>简历放弃</title>
	<meta name="decorator" content="default"/>
	<style type="text/css">
		label {
		    display: inline-block;
		    max-width: 100%;
		    margin-bottom: 5px;
		    font-weight: 400 !important;
		    margin-right: 50px !important;
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
<body class="hideScroll">
	<div class="ibox-content">
		<form:form id="inputForm" modelAttribute="hrResume" action="${ctx}/hr/hrResume/saveRevoke" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						
						<div class="col-sm-12">
							<h5>${hrResume.name }</h5>
							<small>${hrResume.position } ${hrResume.mobile } ${hrResume.mail }</small>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header"></h4>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<div class="col-sm-12 "> 把简历移到简历库：</div>
					</div>
				</div>
			</div>
			<br>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<div class="col-sm-12">
							<form:radiobuttons path="reserveStatus" items="${fns:getDictList('reserve_status')}" itemLabel="label" itemValue="value" htmlEscape="false" class="i-checks"/>
						</div>
					</div>
				</div>
			</div>
			<br><br>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<div class="col-sm-12 "> 放弃原因：</div>
					</div>
				</div>
			</div>
			<br>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<div class="col-sm-12">
							<form:radiobuttons path="reserveCause" items="${fns:getDictList('reserve_cause')}" itemLabel="label" itemValue="value" htmlEscape="false" class="i-checks"/>
						</div>
					</div>
				</div>
			</div>
			
		</form:form>
	</div>
</body>
</html>