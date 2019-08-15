<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>客户投诉编辑</title>
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
<body class="gray-bg">
<div class="wrapper-content">
<div class="ibox">
	<div class="ibox-title">
		<h5>客户投诉${not empty scmComplaint.id?'修改':'添加'}</h5>
	</div>
	<div class="ibox-content">
	<sys:message content="${message}"/>
	
	<form:form id="inputForm" modelAttribute="scmComplaint" action="${ctx}/scm/scmComplaint/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>	
			<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 主题</label>
						<div class="col-sm-8">
							<form:input path="name" htmlEscape="false" maxlength="50" class="form-control required"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 客户</label>
						<div class="col-sm-8">
							<div class="input-group">
								<input id="customerId" name="customer.id" type="hidden" value="${scmComplaint.customer.id}"/>
								<input type="text" id="customerName" name="customer.name" readonly="readonly" value="${scmComplaint.customer.name}" class="form-control required">
								<span class="input-group-addon" id="customerButton"><i class="fa fa-search"></i></span>
							</div>
							<label id="customerName-error" class="error" for="customerName" style="display:none"></label>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">订单合同</label>
						<div class="col-sm-8">
							<div class="input-group">
								<input id="omContractId" name="omContract.id" type="hidden" value="${scmComplaint.omContract.id}"/>
								<input type="text" id="omContractName" name="omContract.name" readonly="readonly" value="${scmComplaint.omContract.name}" class="form-control">
								<span class="input-group-addon" id="customerButton"><i class="fa fa-search"></i></span>
							</div>
						</div>
					</div>
				</div>
				
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 负责人</label>
						<div class="col-sm-8">
							<sys:treeselect id="ownBy" name="ownBy.id" value="${scmComplaint.ownBy.id}" labelName="ownBy.name" labelValue="${scmComplaint.ownBy.name}"
						title="用户" url="/sys/office/treeData?type=3" cssClass="form-control required" dataMsgRequired="必选" allowClear="true" notAllowSelectParent="true"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label">优先级</label>
						<div class="col-sm-8">
							<form:select path="levelType" cssClass="form-control ">
								<form:options items="${fns:getDictList('level_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 截止日期</label>
						<div class="col-sm-8">
							<div class="input-group date datepicker">
								<input name="endDate" type="text" readonly="readonly" class="form-control required" value="<fmt:formatDate value="${scmComplaint.endDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
		                   		<span class="input-group-addon">
		                           	<span class="fa fa-calendar"></span>
		                   		</span>
		                   	</div>
						</div>
					</div>
				</div>
			</div>
			
			<h4 class="page-header">投诉详情</h4>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label">投诉内容</label>
						<div class="col-sm-10">
							<form:textarea path="content" htmlEscape="false" rows="4" maxlength="10000" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label">期望结果</label>
						<div class="col-sm-10">
							<form:textarea path="expecte" htmlEscape="false" rows="4" maxlength="200" class="form-control"/>
						</div>
					</div>
				</div>
			</div>
			
		</tbody>
		</table>
		
		<div class="hr-line-dashed"></div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<div class="col-sm-offset-2 col-sm-10">
							<button id="btnSubmit" class="btn btn-success" type="submit">保存</button>&nbsp;
							<button id="btnCancel" class="btn btn-white" type="button" onclick="history.go(-1)">返回</button>
						</div>
					</div>
				</div>
			</div>
	</form:form>
	</div>
</div>
</div>
<script type="text/javascript">
				$("#customerButton, #customerName").click(function(){
					// 是否限制选择，如果限制，设置为disabled
					if ($("#${id}Button").hasClass("disabled")){
						return true;
					}
					
					var width = '1000px';
					var height = '500px';
					if(navigator.userAgent.match(/(iPhone|iPod|Android|ios)/i)){//如果是移动端，就使用自适应大小弹窗
						width='100%';
						height='100%';
					}
					var oldCustomerId = $("#customerId").val();
					
					var url="${ctx}/crm/crmCustomer/selectList";
					top.layer.open({
					    type: 2,  
					    area: [width, height],
					    title:"客户列表（单选）",
					    maxmin: true, //开启最大化最小化按钮
					    name:'friend',
					    content: url,
					    btn: ['确定', '关闭'],
					    yes: function(index, layero){
					    	 var iframeWin = layero.find('iframe')[0].contentWindow; //得到iframe页的窗口对象，执行iframe页的方法：iframeWin.method();
					    	 var item = iframeWin.getSelectedItem();
			
					    	 if(item == "-1"){
						    	 return;
					    	 }
					    	
					    	 $("#customerId").val(item.split('_item_')[0]);
					    	 $("#customerName").val(item.split('_item_')[1]);
					    	 if(oldCustomerId != null && oldCustomerId != "" && oldCustomerId != item.split('_item_')[0]){
					    		 $("#omContractId").val("");
						    	 $("#omContractName").val("");
							 }
							 top.layer.close(index);//关闭对话框。
						  },
						  cancel: function(index){ 
					       }
					}); 
				});
				$("#omContractButton, #omContractName").click(function(){
					// 是否限制选择，如果限制，设置为disabled
					if ($("#${id}Button").hasClass("disabled")){
						return true;
					}
					
					var width = '1000px';
					var height = '500px';
					if(navigator.userAgent.match(/(iPhone|iPod|Android|ios)/i)){//如果是移动端，就使用自适应大小弹窗
						width='100%';
						height='100%';
					}
					var customerId = $("#customerId").val();
					if(customerId == null || customerId == ""){
						top.layer.alert('请先选择客户!', {icon: 0, title:'警告'});
						return true;
					}
					var url="${ctx}/om/omContract/selectList?customer.id="+customerId;
					top.layer.open({
					    type: 2,  
					    area: [width, height],
					    title:"联系人列表（单选）",
					    maxmin: true, //开启最大化最小化按钮
					    name:'friend',
					    content: url,
					    btn: ['确定', '关闭'],
					    yes: function(index, layero){
					    	 var iframeWin = layero.find('iframe')[0].contentWindow; //得到iframe页的窗口对象，执行iframe页的方法：iframeWin.method();
					    	 var item = iframeWin.getSelectedItem();
			
					    	 if(item == "-1"){
						    	 return;
					    	 }
					    	
					    	 $("#omContractId").val(item.split('_item_')[0]);
					    	 $("#omContractName").val(item.split('_item_')[1]);
							 top.layer.close(index);//关闭对话框。
						  },
						  cancel: function(index){ 
					       }
					}); 
				});
				
			</script>
</body>
</html>