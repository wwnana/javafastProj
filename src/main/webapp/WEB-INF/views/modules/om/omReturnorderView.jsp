<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>销售退单查看</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		
	</script>
</head>
<body class="gray-bg">
<div class="wrapper-content">
	<div class="ibox">
		<div class="ibox-title">
			<h5>退货单查看</h5>
		</div>
		<div class="ibox-content">
		<sys:message content="${message}"/>	
	<form:form id="inputForm" modelAttribute="omReturnorder" action="${ctx}/om/omReturnorder/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		
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
					<td class="width-15 active"><label class="pull-right">创建人：</label></td>
					<td class="width-35">
						${omReturnorder.createBy.name}
					</td>
					<td class="width-15 active"><label class="pull-right">创建时间：</label></td>
					<td class="width-35">
						<fmt:formatDate value="${omReturnorder.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">审核状态：</label></td>
					<td class="width-35">
						${fns:getDictLabel(omReturnorder.status, 'audit_status', '')}
					</td>
					
				</tr>
				<tr>
					<td class="width-15 active"><label class="pull-right">审核人：</label></td>
					<td class="width-35">
						${omReturnorder.auditBy.name}
					</td>
					<td class="width-15 active"><label class="pull-right">审核时间：</label></td>
					<td class="width-35">
						<fmt:formatDate value="${omReturnorder.auditDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">备注：</label></td>
					<td class="width-35" colspan="3">
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
				<div class="form-actions">
					<c:if test="${omReturnorder.status == 0}">
						<shiro:hasPermission name="om:omReturnorder:edit">
	    					<a href="${ctx}/om/omReturnorder/form?id=${omReturnorder.id}" class="btn btn-success" title="修改"><span class="hidden-xs">修改</span></a>
						</shiro:hasPermission>
						<shiro:hasPermission name="om:omReturnorder:del">
							<a href="${ctx}/om/omReturnorder/delete?id=${omReturnorder.id}" onclick="return confirmx('确认要删除该销售退单吗？', this.href)" class="btn  btn-danger" title="删除"><span class="hidden-xs">删除</span></a> 
						</shiro:hasPermission>
						
						<shiro:hasPermission name="om:omReturnorder:audit">
							<a href="${ctx}/om/omReturnorder/audit?id=${omReturnorder.id}" onclick="return confirmx('确认要审核该销售退单吗？', this.href)" class="btn  btn-success" title="审核"><span class="hidden-xs">审核</span></a> 
						</shiro:hasPermission>
					</c:if>
					
					<a href="${ctx}/om/omReturnorder/print?id=${omReturnorder.id}" class="btn btn-white" title="打印" target="_blank"><span class="hidden-xs">打印</span></a>
					
					<input id="btnCancel" class="btn btn-white" type="button" value="返 回" onclick="history.go(-1)"/>
				</div>
			<br>
	</form:form>
	</div></div></div>
</body>
</html>