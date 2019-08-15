<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>销售订单查看</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">		
	</script>
</head>
<body class="gray-bg">
<div class="wrapper-content">
	<div class="ibox">
		<div class="ibox-title">
			<h5>销售订单查看</h5>
		</div>
		<div class="ibox-content">
		<sys:message content="${message}"/>	
	<form:form id="inputForm" modelAttribute="omOrder" action="${ctx}/om/omOrder/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		
	 <table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
		<tbody>
			<tr>
					<td class="width-15 active" width="10%"><label class="pull-right">单号：</label></td>
					<td class="width-35" width="40%">
						${omOrder.no}
					</td>
					<td class="width-15 active" width="10%"><label class="pull-right">销售类型：</label></td>
					<td class="width-35" width="40%">
						${fns:getDictLabel(omOrder.saleType, 'sale_type', '')}
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">客户：</label></td>
					<td class="width-35">
						<a href="${ctx}/crm/crmCustomer/index?id=${omOrder.customer.id}">${omOrder.customer.name}</a>
					</td>
					<td class="width-15 active"><label class="pull-right">内容：</label></td>
					<td class="width-35">
						${omOrder.content}
					</td>
				</tr>
			
				<tr> 
					<td class="width-15 active"><label class="pull-right">总计金额：</label></td>
					<td class="width-35">
						${omOrder.amount}
					</td>
					<td class="width-15 active"><label class="pull-right">结算账户：</label></td>
					<td class="width-35">
						${omOrder.fiAccount.name}
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">订金：</label></td>
					<td class="width-35">
						${omOrder.bookAmt}
					</td>
					<td class="width-15 active"><label class="pull-right">回款金额：</label></td>
					<td class="width-35">
						${omOrder.receiveAmt}
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">是否开票：</label></td>
					<td class="width-35">
						${fns:getDictLabel(omOrder.isInvoice, 'yes_no', '')}
					</td>
					<td class="width-15 active"><label class="pull-right">开票金额：</label></td>
					<td class="width-35">
						${omOrder.invoiceAmt}
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">毛利润：</label></td>
					<td class="width-35">
						${omOrder.profitAmt}
					</td>
					<td class="width-15 active"><label class="pull-right">审核状态：</label></td>
					<td class="width-35">
						${fns:getDictLabel(omOrder.status, 'audit_status', '')}
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">经办人：</label></td>
					<td class="width-35">
						${omOrder.dealBy.name}
					</td>
					<td class="width-15 active"><label class="pull-right">业务日期：</label></td>
					<td class="width-35">
						<fmt:formatDate value="${omOrder.dealDate}" pattern="yyyy-MM-dd"/>
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">创建人：</label></td>
					<td class="width-35">
						${omOrder.createBy.name}
					</td>
					<td class="width-15 active"><label class="pull-right">创建时间：</label></td>
					<td class="width-35">
						<fmt:formatDate value="${omOrder.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">审核人：</label></td>
					<td class="width-35">
						${omOrder.auditBy.name}
					</td>
					<td class="width-15 active"><label class="pull-right">审核时间：</label></td>
					<td class="width-35">
						<fmt:formatDate value="${omOrder.auditDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">备注：</label></td>
					<td class="width-35" colspan="3">
						${omOrder.remarks}
					</td>
				</tr>
			</tbody>
		</table>
		<!-- 明细 -->
		<div class="tabs-container">
	    	<ul class="nav nav-tabs">
				<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">销售订单明细</a></li>
	    	</ul>
          	<div class="tab-content">
          	   	<div class="panel-body">
					<div id="tab-1" class="tab-pane table-responsive active">
					<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed">
						<thead>
							<tr>
								<th>产品编号</th>
								<th>产品名称</th>
								<th>规格</th>
								<th>单位</th>
								<th>单价(元)</th>
								<th>数量</th>
								<th>金额(元)</th>
								<th>备注</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${omOrder.omOrderDetailList}" var="omOrderDetail">
								<tr>
											<td>
												${omOrderDetail.product.no}
											</td>
											<td>
												${omOrderDetail.product.name}
											</td>
											<td>
												${omOrderDetail.product.spec}
											</td>
											<td>
												${omOrderDetail.unitType}
											</td>
											<td>
												${omOrderDetail.price}
											</td>
											<td>
												${omOrderDetail.num}
											</td>
											<td>
												${omOrderDetail.amount}
											</td>
										
											<td>
												${omOrderDetail.remarks}
											</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
					<div class="pull-right">
						总数量：${omOrder.num}&nbsp;&nbsp;
						总计：${omOrder.totalAmt}&nbsp;&nbsp;
						其他费用：${omOrder.otherAmt}&nbsp;&nbsp;
						总金额：${omOrder.amount}&nbsp;&nbsp;
					</div>					
					</div>
				</div>
			</div>
		</div>
		
	<br>
				<div class="form-actions">
					<c:if test="${omOrder.status == 0}">
						<shiro:hasPermission name="om:omOrder:edit">
	    					<a href="${ctx}/om/omOrder/form?id=${omOrder.id}" class="btn btn-success" title="修改"><span class="hidden-xs">修改</span></a>
						</shiro:hasPermission>
						<shiro:hasPermission name="om:omOrder:del">
							<a href="${ctx}/om/omOrder/delete?id=${omOrder.id}" onclick="return confirmx('确认要删除该销售订单吗？', this.href)" class="btn  btn-danger" title="删除"><span class="hidden-xs">删除</span></a> 
						</shiro:hasPermission>
						</c:if>
						<c:if test="${omOrder.status == 1}">
						<shiro:hasPermission name="om:omReturnorder:edit">
	    					<a href="${ctx}/om/omReturnorder/form?order.id=${omOrder.id}" class="btn btn-success" title="退货"><span class="hidden-xs">退货</span></a>
						</shiro:hasPermission>
					</c:if>
					
					<a href="${ctx}/om/omOrder/print?id=${omOrder.id}" class="btn btn-white" title="打印" target="_blank"><span class="hidden-xs">打印</span></a>
					
					<input id="btnCancel" class="btn btn-white" type="button" value="返 回" onclick="history.go(-1)"/>
				</div>
			<br>
	</form:form>
</div></div></div>
</body>
</html>