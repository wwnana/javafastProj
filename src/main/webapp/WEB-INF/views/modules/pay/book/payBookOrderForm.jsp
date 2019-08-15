<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>JavaFast购买在线下单</title>
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
		
		function searchE(){
			var productId = $("#productId").val();
			
			if(productId == 0){
				$("#amount").val(20000);
			}
			if(productId == 1){
				$("#amount").val(50000);
			}
		}
	</script>
</head>
<body class="gray-bg">
<div class="wrapper-content">
	<div class="" style="width: 600px; margin-left: auto;margin-right: auto;">
			
			<div class="ibox-content">
				<sys:message content="${message}"/>
				<form:form id="inputForm" modelAttribute="payBookOrder" action="${ctx}/pay/payBookOrder/saveOrder" method="post" class="form-horizontal">
				<form:hidden path="id"/>
				<form:hidden path="no"/>
					<h4 class="page-header">请选择您需要的版本</h4>
					<div class="row">
						<div class="col-sm-10">
							<div class="form-group"> 
								<label class="col-sm-4 control-label"><font color="red">*</font> 选择产品：</label>
								<div class="col-sm-8">
									<select id="productId" name="productId" class="form-control required" onchange="searchE()">
										<option value="0" <c:if test='${payBookOrder.productId == 0}'>selected="selected"</c:if>>JavaFast企业标准版2.0</option>
										<option value="1" <c:if test='${payBookOrder.productId == 1}'>selected="selected"</c:if>>JavaFast企业高级版2.0</option>
									</select>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-10">
							<div class="form-group">
								<label class="col-sm-4 control-label"><font color="red">*</font> 订单金额：</label>
								<div class="col-sm-8">
									<form:input path="amount" htmlEscape="false" class="form-control required" readonly="true"/>
								</div>
							</div>
						</div>
					</div>
					<h4 class="page-header">请正确填写您的联系方式</h4>
					<div class="row">
						<div class="col-sm-10">
							<div class="form-group">
								<label class="col-sm-4 control-label"><font color="red">*</font> 手机号码：</label>
								<div class="col-sm-8">
									<form:input path="mobile" htmlEscape="false" maxlength="30" class="form-control required isMobile"/>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-10">
							<div class="form-group">
								<label class="col-sm-4 control-label"><font color="red">*</font> 姓名：</label>
								<div class="col-sm-8">
									<form:input path="name" htmlEscape="false" maxlength="30" class="form-control required"/>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-10">
							<div class="form-group">
								<label class="col-sm-4 control-label"><font color="red">*</font> 公司名称：</label>
								<div class="col-sm-8">
									<form:input path="company" htmlEscape="false" maxlength="50" class="form-control required"/>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-10">
							<div class="form-group">
								<label class="col-sm-4 control-label"><font color="red">*</font> 公司规模：</label>
								<div class="col-sm-8">
									<form:select path="scaleType" cssClass="form-control required">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('scale_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-10">
							<div class="form-group">
								<label class="col-sm-4 control-label"> 电子邮箱：</label>
								<div class="col-sm-8">
									<form:input path="email" htmlEscape="false" maxlength="50" class="form-control email"/>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-10">
							<div class="form-group">
								<label class="col-sm-4 control-label"> QQ：</label>
								<div class="col-sm-8">
									<form:input path="qq" htmlEscape="false" maxlength="50" class="form-control digits"/>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-10">
							<div class="form-group">
								<label class="col-sm-4 control-label"> 留言：</label>
								<div class="col-sm-8">
									<form:textarea path="notes" htmlEscape="false" rows="4" maxlength="50" class="form-control "/>
								</div>
							</div>
						</div>
					</div>
					
				
					<div class="hr-line-dashed"></div>
					<div class="row">
						<div class="col-sm-12">
							<div class="form-group">
								<div class="col-sm-offset-2 col-sm-10">
									<button id="btnSubmit" class="btn btn-success" type="submit">确认提交</button>&nbsp;
									<a href="#" class="btn btn-white" onclick="top.location.href='http://www.javafast.cn'" >返回官网</a>
								</div>
							</div>
							<br>
							<p>
								<span class="help-inline">提示：
								<br>下单成功后，平台客服会与您联系并提供合同；
								<br>签约完成后，平台会安排技术人员交付产品以及技术支持服务；
								<br>纸质合同以及发票会邮寄给您。</span>
								<br>公司上班时间为周一至周五9:00~18:00，节假日下单的会有所延后，如有疑问请咨询在线客服。</span>
							</p>
							
						</div>
					</div>
				</form:form>
			</div>
		</div>			

</div>
</body>
</html>