<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>订单查看</title>
	<meta name="decorator" content="default"/>
</head>
<body class="gray-bg">
<div class="wrapper-content">
<div class="" style="width: 600px; margin-left: auto;margin-right: auto;">
	<div class="ibox-title">
		<h5>订单查看</h5>
	</div>
	<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="payBookOrder" action="${ctx}/pay/payBookOrder/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
			<h4 class="page-header">订单信息</h4>
			<div class="row">
				<div class="col-sm-10">
					<div class="view-group">
						<label class="col-sm-4 control-label">订单编号：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${payBookOrder.no}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-10">
					<div class="view-group">
						<label class="col-sm-4 control-label">订单金额：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${payBookOrder.amount}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-10">
					<div class="view-group">
						<label class="col-sm-4 control-label">产品名称：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
								<c:if test="${payBookOrder.productId == 0}">JavaFast企业标准版2.0</c:if>
								<c:if test="${payBookOrder.productId == 1}">JavaFast企业高级版2.0</c:if>
							</p>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">联系信息</h4>
			<div class="row">
				<div class="col-sm-10">
					<div class="view-group">
						<label class="col-sm-4 control-label">手机号码：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${payBookOrder.mobile}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-10">
					<div class="view-group">
						<label class="col-sm-4 control-label">姓名：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${payBookOrder.name}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-10">
					<div class="view-group">
						<label class="col-sm-4 control-label">公司名称：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${payBookOrder.company}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-10">
					<div class="view-group">
						<label class="col-sm-4 control-label">企业规模：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${fns:getDictLabel(payBookOrder.scaleType, 'scale_type', '')}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-10">
					<div class="view-group">
						<label class="col-sm-4 control-label">电子邮箱：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${payBookOrder.email}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-10">
					<div class="view-group">
						<label class="col-sm-4 control-label">QQ：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${payBookOrder.qq}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-10">
					<div class="view-group">
						<label class="col-sm-4 control-label">留言：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${payBookOrder.notes}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-10">
					<div class="view-group">
						<label class="col-sm-4 control-label">下单时间：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							<fmt:formatDate value="${payBookOrder.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-10">
					<div class="view-group">
						<label class="col-sm-4 control-label">支付状态：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${fns:getDictLabel(payBookOrder.status, 'pay_status', '')}
							</p>
						</div>
					</div>
				</div>
			</div>
			
			
			<div class="hr-line-dashed"></div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<div class="col-sm-offset-2 col-sm-10">
							<a href="#" class="btn btn-white" onclick="top.location.href='http://www.javafast.cn'" >返回官网</a>
						</div>
					</div>
					<br>
					<p>
						<span class="help-inline">提示：公司上班时间为周一至周五9:00~18:00，节假日下单的会有所延后</span>
					</p>
				</div>
			</div>
		</form:form>
	</div>
</div>
</div>
</body>
</html>