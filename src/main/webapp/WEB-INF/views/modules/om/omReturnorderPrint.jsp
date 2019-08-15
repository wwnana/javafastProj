<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>销售退单打印</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
        window.print();
    </script>
</head>
<body class="">
<div class="">
	<div class="">
		
		<div class="ibox-content">
		<sys:message content="${message}"/>	
	<form:form id="inputForm" modelAttribute="omReturnorder" action="${ctx}/om/omReturnorder/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<div class="row">
			<div class="col-sm-12">
				<div class="text-center p-lg">
	            	<h2>退货单</h2>
	            </div>
			</div>
		</div>
	 <table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
		<tbody>
			<tr>
					<td class="width-15 active"><label class="pull-right">单号：</label></td>
					<td class="width-35">
						${omReturnorder.no}
					</td>
					<td class="width-15 active"><label class="pull-right">销售类型：</label></td>
					<td class="width-35">
						${fns:getDictLabel(omReturnorder.saleType, 'sale_type', '')}
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">客户：</label></td>
					<td class="width-35">
						${omReturnorder.customer.name}
					</td>
					<td class="width-15 active"><label class="pull-right">关联销售订单：</label></td>
					<td class="width-35">
						${omReturnorder.order.no}
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">经办人：</label></td>
					<td class="width-35">
						${omReturnorder.dealBy.name}
					</td>
					<td class="width-15 active"><label class="pull-right">业务日期：</label></td>
					<td class="width-35">
						<fmt:formatDate value="${omReturnorder.dealDate}" pattern="yyyy-MM-dd"/>
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">实退数量：</label></td>
					<td class="width-35">
						${omReturnorder.num}
					</td>
					<td class="width-15 active"><label class="pull-right">退入仓库：</label></td>
					<td class="width-35">
						${omReturnorder.warehouse.name}
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">结算账户：</label></td>
					<td class="width-35">
						${omReturnorder.fiAccount.name}
					</td>
					<td class="width-15 active"><label class="pull-right">实退金额：</label></td>
					<td class="width-35">
						${omReturnorder.actualAmt}
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">备注：</label></td>
					<td class="width-35">
						${omReturnorder.remarks}
					</td>
				</tr>
				
			</tbody>
		</table>
		<!-- 明细 -->
		<div class="tabs-container">
	    	<ul class="nav nav-tabs">
				<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">退货单明细</a></li>
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
								<th>退货数量</th>
								<th>金额(元)</th>
								<th>备注</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${omReturnorder.omReturnorderDetailList}" var="omReturnorderDetail">
								<tr>
											<td>
												${omReturnorderDetail.product.no}
											</td>
											<td>
												${omReturnorderDetail.product.name}
											</td>
											<td>
												${omReturnorderDetail.unitType}
											</td>
											<td>
												${omReturnorderDetail.price}
											</td>
											<td>
												${omReturnorderDetail.num}
											</td>
											<td>
												${omReturnorderDetail.amount}
											</td>
											<td>
												${omReturnorderDetail.remarks}
											</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
					<div class="pull-right">
						总退货数量：${omReturnorder.num}&nbsp;&nbsp;
						总计：${omReturnorder.totalAmt}&nbsp;&nbsp;
						其他费用：${omReturnorder.otherAmt}&nbsp;&nbsp;
						总金额：${omReturnorder.amount}&nbsp;&nbsp;
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