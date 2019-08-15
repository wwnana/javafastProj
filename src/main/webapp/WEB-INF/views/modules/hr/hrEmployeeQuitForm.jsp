<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>离职页面</title>
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
		function comWorkAge(){			
            var firstWorkDate = $("#firstWorkDate").val();
            if(firstWorkDate != null && firstWorkDate != ""){
            	var endTime = new Date(firstWorkDate).getTime();    
                var startTime = new Date().getTime();
                var dates = Math.abs((startTime - endTime))/(1000*60*60*24*365); 
                $("#workAge").val(dates.toFixed(2));
            }            
		}
	</script>
</head>
<body class="gray-bg">
<div class="wrapper-content">
<div class="ibox">
	<div class="ibox-title">
		<h5>员工离职</h5>
	</div>
	<div class="ibox-content">
		<div class="alert alert-warning">
			此操作将使员工离职，员工账号将不能再登录，且此操作不可撤销；离职后社保、公积金将无法更改，请您认真核对。
        </div>
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="hrEmployee" action="${ctx}/hr/hrEmployee/saveQuit" method="post" class="form-horizontal">
		<form:hidden path="id"/>
			<h4 class="page-header">基本信息</h4>
			
			<div class="row">	
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 离职类型：</label>
						<div class="col-sm-8">
							<form:select path="quitType" cssClass="form-control">
								<form:options items="${fns:getDictList('quit_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
			</div>
			<div class="row">	
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 离职日期：</label>
						<div class="col-sm-8">
							<div class="input-group date datepicker">
				                 <input name="quitDate" type="text" readonly="readonly" class="form-control" 
				                 value="<fmt:formatDate value="${hrEmployee.quitDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                 <span class="input-group-addon">
				                      <span class="fa fa-calendar"></span>
				                 </span>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 离职原因：</label>
						<div class="col-sm-8">
							<form:textarea path="quitCause" htmlEscape="false" rows="4" maxlength="200" class="form-control "/>
						</div>
					</div>
				</div>
			</div>
		
			<div class="hr-line-dashed"></div>
			<div class="form-actions">
				<shiro:hasPermission name="hr:hrEmployee:edit">
					<button id="btnSubmit" class="btn btn-success" type="submit">确认离职</button>&nbsp;
				</shiro:hasPermission>
				<button id="btnCancel" class="btn btn-white" type="button" onclick="history.go(-1)">返回</button>
			</div>
		</form:form>
	</div>
</div>
</div>
</body>
</html>