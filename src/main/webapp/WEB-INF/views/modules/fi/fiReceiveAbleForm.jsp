<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>应收款管理</title>
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
	<form:form id="inputForm" modelAttribute="fiReceiveAble" action="${ctx}/fi/fiReceiveAble/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>	
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 单号：</label>
						<div class="col-sm-8">
							<form:input path="no" htmlEscape="false" maxlength="50" class="form-control required" readonly="true" />
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 关联订单：</label>
						<div class="col-sm-8">
							<sys:tableselect id="order" name="order.id" value="${fiReceiveAble.order.id}" labelName="order.name" labelValue="${fiReceiveAble.order.name}" 
								title="订单" url="${ctx}/om/omOrder/selectList" cssClass="form-control required" dataMsgRequired=""  allowClear="false" allowInput="false"/>
						</div>
					</div>
				</div>
			</div>
			
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 应收金额：</label>
						<div class="col-sm-8">
							<form:input path="amount" htmlEscape="false" class="form-control required"/>
						</div>
					</div>
				</div>
			</div>
			
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"> 应收时间：</label>
						<div class="col-sm-8">
							<input name="ableDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control layer-date "
								value="<fmt:formatDate value="${fiReceiveAble.ableDate}" pattern="yyyy-MM-dd"/>"
								onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font>  负责人：</label>
						<div class="col-sm-8">
							<sys:treeselect id="ownBy" name="ownBy.id" value="${fiReceiveAble.ownBy.id}" labelName="ownBy.name" labelValue="${fiReceiveAble.ownBy.name}"
								title="用户" url="/sys/office/treeData?type=3" cssClass="form-control required" allowClear="false" notAllowSelectParent="true"/>
						</div>
					</div>
				</div>
			</div>
			
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">备注：</label>
						<div class="col-sm-8">
							<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="50" class="form-control "/>
						</div>
					</div>
				</div>
			</div>
			
	</form:form>
	</div>
</body>
</html>