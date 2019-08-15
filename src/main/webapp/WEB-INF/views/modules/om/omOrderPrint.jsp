<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>销售订单打印</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
        window.print();
    </script>
</head>
<body class="">
<div class="">
	<div class="">
		
		<div class="">
		<sys:message content="${message}"/>	
	<form:form id="inputForm" modelAttribute="omOrder" action="${ctx}/om/omOrder/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<div class="row">
			<div class="col-sm-12">
				<div class="text-center p-lg">
	            	<h2>销售订单</h2>
	            </div>
			</div>
		</div>
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
						${omOrder.customer.name}
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
					<td class="width-15 active"><label class="pull-right">备注：</label></td>
					<td class="width-35">
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
								<th>产品编码</th>
								<th>产品名称</th>
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
	</form:form>
</div></div></div>
</body>
</html>