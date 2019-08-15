<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>预定订单查看</title>
	<meta name="decorator" content="default"/>
</head>
<body class="gray-bg">
<div class="wrapper-content">
<div class="ibox">
	<div class="ibox-title">
		<h5>预定订单查看</h5>
	</div>
	<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="payBookOrder" action="${ctx}/pay/payBookOrder/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
			<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">订单编号：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${payBookOrder.no}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
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
				<div class="col-sm-6">
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
				<div class="col-sm-6">
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
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">姓名：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${payBookOrder.name}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
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
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">企业规模：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${fns:getDictLabel(payBookOrder.scaleType, 'scale_type', '')}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
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
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">QQ：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${payBookOrder.qq}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
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
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">支付状态：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${fns:getDictLabel(payBookOrder.status, 'pay_status', '')}
							</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-4 control-label">支付类型：</label>
						<div class="col-sm-8">
							<p class="form-control-static">
							${fns:getDictLabel(payBookOrder.payType, 'pay_type', '')}
							</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
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
			
			<div class="hr-line-dashed"></div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<div class="col-sm-offset-2 col-sm-10">
							<shiro:hasPermission name="pay:payBookOrder:edit">
						    	<a href="${ctx}/pay/payBookOrder/form?id=${payBookOrder.id}" class="btn btn-success" title="修改">修改</a>
							</shiro:hasPermission>
							<shiro:hasPermission name="pay:payBookOrder:del">
								<a href="${ctx}/pay/payBookOrder/delete?id=${payBookOrder.id}" onclick="return confirmx('确认要删除该预定订单吗？', this.href)" class="btn btn-danger" title="删除">删除</a> 
							</shiro:hasPermission>
							<a id="btnCancel" class="btn btn-white" onclick="history.go(-1)">返回</a>
						</div>
					</div>
				</div>
			</div>
		</form:form>
	</div>
</div>
</div>
</body>
</html>