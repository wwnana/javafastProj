<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>入库单查看</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		
	</script>
</head>
<body class="gray-bg">
<div class="wrapper-content">
	<div class="ibox">
		<div class="ibox-title">
			<h5>入库单查看</h5>
		</div>
		<div class="ibox-content">
		<sys:message content="${message}"/>	
	<form:form id="inputForm" modelAttribute="wmsInstock" action="${ctx}/wms/wmsInstock/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
	<div class="row">
			<div class="col-sm-12">
				<div class="text-center p-lg">
	            	<h2>入库单</h2>
	            </div>
			</div>
		</div>	
	 <table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
		<tbody>
			<tr>
					<td class="width-15 active" width="10%"><label class="pull-right">入库单号：</label></td>
					<td class="width-35" width="40%">
						${wmsInstock.no}
					</td>
					<td class="width-15 active" width="10%"><label class="pull-right">审核状态：</label></td>
					<td class="width-35" width="40%">
						${fns:getDictLabel(wmsInstock.status, 'audit_status', '')}
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">入库类型：</label></td>
					<td class="width-35" colspan="3">
							${fns:getDictLabel(wmsInstock.instockType, 'instock_type', '')}
					</td>	
				</tr>
				<c:if test="${wmsInstock.instockType == 0}">
				<tr> 				
					<td class="width-15 active"><label class="pull-right">采购单：</label></td>
					<td class="width-35">
						${wmsInstock.purchase.no}
					</td>
					<td class="width-15 active"><label class="pull-right">供应商：</label></td>
					<td class="width-35">
						${wmsInstock.supplier.name}
					</td>
				</tr>
				</c:if>
				<tr> 
					<td class="width-15 active"><label class="pull-right">入库仓库：</label></td>
					<td class="width-35">
						${wmsInstock.warehouse.name}
					</td>
					<td class="width-15 active"><label class="pull-right">入库数量：</label></td>
					<td class="width-35">
						${wmsInstock.num}
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">经办人：</label></td>
					<td class="width-35">
						${wmsInstock.dealBy.name}
					</td>
					<td class="width-15 active"><label class="pull-right">业务日期：</label></td>
					<td class="width-35">
						<fmt:formatDate value="${wmsInstock.dealDate}" pattern="yyyy-MM-dd"/>
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">审核人：</label></td>
					<td class="width-35">
						${wmsInstock.auditBy.name}
					</td>
					<td class="width-15 active"><label class="pull-right">审核时间：</label></td>
					<td class="width-35">
						<fmt:formatDate value="${wmsInstock.auditDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">备注：</label></td>
					<td class="width-35" colspan="3">
						${wmsInstock.remarks}
					</td>
				</tr>
			</tbody>
		</table>
		<!-- 明细 -->
		<div class="tabs-container">
	    	<ul class="nav nav-tabs">
				<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">入库单明细</a></li>
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
								<th>已入库数量</th>
								<th>未入库数量</th>
								<th>备注</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${wmsInstock.wmsInstockDetailList}" var="wmsInstockDetail">
								<tr>
											<td>
												${wmsInstockDetail.product.no}
											</td>
											<td>
												${wmsInstockDetail.product.name}
											</td>
											<td>
												${wmsInstockDetail.product.spec}
											</td>
											<td>
												${wmsInstockDetail.unitType}
											</td>
											<td>
												${wmsInstockDetail.num}
											</td>
											<td>
												${wmsInstockDetail.instockNum}
											</td>
											<td>
												${wmsInstockDetail.diffNum}
											</td>
											<td>
												${wmsInstockDetail.remarks}
											</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>	
					<div class="pull-right">
						总数量：${wmsInstock.num }，&nbsp;&nbsp;
						已入库数：${wmsInstock.realNum }，&nbsp;&nbsp;
						剩余：${wmsInstock.num - wmsInstock.realNum}&nbsp;&nbsp;
					</div>				
					</div>
				</div>
			</div>
		</div>
	<br>
				<div class="form-actions">
					<c:if test="${wmsInstock.status == 0}">
						<shiro:hasPermission name="wms:wmsInstock:edit">
    						<a href="${ctx}/wms/wmsInstock/form?id=${wmsInstock.id}" class="btn btn-success" title="入库"><i class="fa fa-edit"></i>
							<span class="hidden-xs">入库</span></a>
						</shiro:hasPermission>	
						<c:if test="${wmsInstock.num == wmsInstock.realNum}">
							<shiro:hasPermission name="wms:wmsInstock:audit">	
								<a href="${ctx}/wms/wmsInstock/audit?id=${wmsInstock.id}" onclick="return confirmx('确认要审核该入库单吗？', this.href)" class="btn  btn-success" title="审核"><i class="fa fa-check"></i>
									<span class="hidden-xs">审核</span></a>
							</shiro:hasPermission>
						</c:if>
					</c:if>
					<a href="${ctx}/wms/wmsInstock/print?id=${wmsInstock.id}" class="btn btn-white" title="打印" target="_blank"><i class="fa fa-print"></i> <span class="hidden-xs">打印</span></a>
					<input id="btnCancel" class="btn btn-white" type="button" value="返 回" onclick="history.go(-1)"/>
				</div>
			<br>
	</form:form>
</div></div></div>
</body>
</html>