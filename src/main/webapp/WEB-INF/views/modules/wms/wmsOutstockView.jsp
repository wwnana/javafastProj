<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>出库单查看</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		
	</script>
</head>
<body class="gray-bg">
<div class="wrapper-content">
	<div class="ibox">
		<div class="ibox-title">
			<h5>出库单查看</h5>
		</div>
		<div class="ibox-content">
		<sys:message content="${message}"/>	
	<form:form id="inputForm" modelAttribute="wmsOutstock" action="${ctx}/wms/wmsOutstock/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
	<div class="row">
			<div class="col-sm-12">
				<div class="text-center p-lg">
	            	<h2>出库单</h2>
	            </div>
			</div>
		</div>	
	 <table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
		<tbody>
			   <tr>
					<td class="width-15 active" width="10%"><label class="pull-right">出库单号：</label></td>
					<td class="width-35" width="40%">
						${wmsOutstock.no}
					</td>
					<td class="width-15 active"><label class="pull-right">审核状态：</label></td>
					<td class="width-35">
						${fns:getDictLabel(wmsOutstock.status, 'audit_status', '')}
					</td>
				</tr>
				<tr> 
					<td class="width-15 active" width="10%"><label class="pull-right">出库类型：</label></td>
					<td class="width-35" width="40%">
						${fns:getDictLabel(wmsOutstock.outstockType, 'outstock_type', '')}
					</td>
					
					<c:if test="${wmsOutstock.outstockType == 0}">
						<td class="width-15 active"><label class="pull-right">关联订单号：</label></td>
						<td class="width-35">
								${wmsOutstock.order.no}
						</td>
					</c:if>
					<c:if test="${wmsOutstock.outstockType == 1}">
						<td class="width-15 active"><label class="pull-right">供应商：</label></td>
						<td class="width-35">
							${wmsOutstock.supplier.name}
						</td>
					</c:if>
					<c:if test="${wmsOutstock.outstockType == 2}">
						<td class="width-15 active"><label class="pull-right"></label></td>
						<td class="width-35">
							
						</td>
					</c:if>
					
					
				</tr>
				
				<tr> 
					<td class="width-15 active"><label class="pull-right">出库仓库：</label></td>
					<td class="width-35" colspan="3">
						${wmsOutstock.warehouse.name}
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">经办人：</label></td>
					<td class="width-35">
						${wmsOutstock.dealBy.name}
					</td>
					<td class="width-15 active"><label class="pull-right">业务日期：</label></td>
					<td class="width-35">
						<fmt:formatDate value="${wmsOutstock.dealDate}" pattern="yyyy-MM-dd"/>
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">审核人：</label></td>
					<td class="width-35">
						${wmsOutstock.auditBy.name}
					</td>
					<td class="width-15 active"><label class="pull-right">审核时间：</label></td>
					<td class="width-35">
						<fmt:formatDate value="${wmsOutstock.auditDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">备注：</label></td>
					<td class="width-35" colspan="3">
						${wmsOutstock.remarks}
					</td>
				</tr>
			</tbody>
		</table>
		<!-- 明细 -->
		<div class="tabs-container">
	    	<ul class="nav nav-tabs">
				<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">出库单明细</a></li>
	    	</ul>
          	<div class="tab-content">
          	   	<div class="panel-body">
					<div id="tab-1" class="tab-pane table-responsive active">
					<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed">
						<thead>
							<tr>
								<th>产品编码</th>
								<th>产品名称</th>
								<th>规格</th>
								<th>单位</th>
								<th>数量</th>
								<th>已出库数量</th>
								<th>未出库数量</th>
								<th>备注</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${wmsOutstock.wmsOutstockDetailList}" var="wmsOutstockDetail">
								<tr>
											<td>
												${wmsOutstockDetail.product.no}
											</td>
											<td>
												${wmsOutstockDetail.product.name}
											</td>
											<td>
												${wmsOutstockDetail.product.spec}
											</td>
											<td>
												${wmsOutstockDetail.unitType}
											</td>
											<td>
												${wmsOutstockDetail.num}
											</td>
											<td>
												${wmsOutstockDetail.outstockNum}
											</td>
											<td>
												${wmsOutstockDetail.diffNum}
											</td>
											<td>
												${wmsInstockDetail.remarks}
											</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
					<div class="pull-right">
						总数量：${wmsOutstock.num }，&nbsp;&nbsp;
						已出库数：${wmsOutstock.realNum }，&nbsp;&nbsp;
						剩余：${wmsOutstock.num - wmsOutstock.realNum}&nbsp;&nbsp;
					</div>						
					</div>
				</div>
			</div>
		</div>
	<br>
				<div class="form-actions">
					<c:if test="${wmsOutstock.status == 0}">
						<shiro:hasPermission name="wms:wmsOutstock:edit">
	    					<a href="${ctx}/wms/wmsOutstock/form?id=${wmsOutstock.id}" class="btn btn-success" title="出库"><i class="fa fa-edit"></i>
								<span class="hidden-xs">出库</span></a>
						</shiro:hasPermission>
						<c:if test="${wmsOutstock.num == wmsOutstock.realNum}">
							<shiro:hasPermission name="wms:wmsOutstock:audit">
								<a href="${ctx}/wms/wmsOutstock/audit?id=${wmsOutstock.id}" onclick="return confirmx('确认要审核该出库单吗？', this.href)" class="btn btn-success" title="审核"><i class="fa fa-check"></i>
									<span class="hidden-xs">审核</span></a> 
							</shiro:hasPermission>
						</c:if>
					</c:if>
					<a href="${ctx}/wms/wmsOutstock/print?id=${wmsOutstock.id}" class="btn btn-white" title="打印" target="_blank"><i class="fa fa-print"></i> <span class="hidden-xs">打印</span></a>
					<input id="btnCancel" class="btn btn-white" type="button" value="返 回" onclick="history.go(-1)"/>
				</div>
			<br>
	</form:form>
</div></div></div>
</body>
</html>