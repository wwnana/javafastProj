<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>采购单查看</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		
	</script>
</head>
<body class="gray-bg">
<div class="wrapper-content">
	<div class="ibox">
		<div class="ibox-title">
			<h5>采购单查看</h5>
		</div>
		<div class="ibox-content">
		<sys:message content="${message}"/>	
	<form:form id="inputForm" modelAttribute="wmsPurchase" action="${ctx}/wms/wmsPurchase/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		
	
	 <table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
		<tbody>
			<tr>
					<td class="width-15 active" width="10%"><label class="pull-right">单号：</label></td>
					<td class="width-35" width="40%">
						${wmsPurchase.no}
					</td>
					<td class="width-15 active" width="10%"><label class="pull-right">供应商：</label></td>
					<td class="width-35" width="40%">
						${wmsPurchase.supplier.name}
					</td>
				</tr>				
				<tr> 
					<td class="width-15 active"><label class="pull-right">入库仓库：</label></td>
					<td class="width-35">
						
					</td>
					<td class="width-15 active"><label class="pull-right">审核状态：</label></td>
					<td class="width-35">
						${fns:getDictLabel(wmsPurchase.status, 'audit_status', '')}
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">经办人：</label></td>
					<td class="width-35">
						${wmsPurchase.dealBy.name}
					</td>
					<td class="width-15 active"><label class="pull-right">业务日期：</label></td>
					<td class="width-35">
						<fmt:formatDate value="${wmsPurchase.dealDate}" pattern="yyyy-MM-dd"/>
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">制单人：</label></td>
					<td class="width-35">
						${wmsPurchase.createBy.name}
					</td>
					<td class="width-15 active"><label class="pull-right">制单日期：</label></td>
					<td class="width-35">
						<fmt:formatDate value="${wmsPurchase.createDate}" pattern="yyyy-MM-dd"/>
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">审核人：</label></td>
					<td class="width-35">
						${wmsPurchase.auditBy.name}
					</td>
					<td class="width-15 active"><label class="pull-right">审核时间：</label></td>
					<td class="width-35">
						<fmt:formatDate value="${wmsPurchase.auditDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
					</td>
				</tr>
				<tr> 
					<td class="width-15 active"><label class="pull-right">备注：</label></td>
					<td class="width-35" colspan="3">
						${wmsPurchase.remarks}
					</td>
				</tr>
			</tbody>
		</table>
		
		<!-- 明细 -->
		<div class="tabs-container">
	    	<ul class="nav nav-tabs">
				<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">采购单明细</a></li>
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
								<th>单价(元)</th>
								<th>数量</th>
								<th>金额(元)</th>
								<th>税率(%)</th>
								<th>税额(元)</th>
								<th>备注</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${wmsPurchase.wmsPurchaseDetailList}" var="wmsPurchaseDetail">
								<tr>
											<td>
												${wmsPurchaseDetail.product.no}
											</td>
											<td>
												${wmsPurchaseDetail.product.name}
											</td>
											<td>
												${wmsPurchaseDetail.product.spec}
											</td>
											<td>
												${wmsPurchaseDetail.unitType}
											</td>
											<td>
												${wmsPurchaseDetail.price}
											</td>
											<td>
												${wmsPurchaseDetail.num}
											</td>
											<td>
												${wmsPurchaseDetail.amount}
											</td>
											<td>
												${wmsPurchaseDetail.taxRate}
											</td>
											<td>
												${wmsPurchaseDetail.taxAmt}
											</td>
											<td>
												${wmsPurchaseDetail.remarks}
											</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
					<div class="pull-right">
						总数量：<form:input path="num" htmlEscape="false" maxlength="11" class="form-control input-mini digits" readonly="true" style="border:0;"/>
						金额总计：<input type="text" id="totalAmt" name="totalAmt" value="${wmsPurchase.totalAmt}" htmlEscape="false" class="form-control input-mini" readonly="true" style="border:0;"/>
						税额：<input type="text" id="taxAmt" name="taxAmt" value="${wmsPurchase.taxAmt}" htmlEscape="false" class="form-control input-mini" readonly="true" style="border:0;"/>
						其他费用：<input type="text" id="otherAmt" name="otherAmt" value="${wmsPurchase.otherAmt}" htmlEscape="false" min="0" maxlength="10" class="form-control input-mini number" onkeyup="checkInputOtherAmt()"  style="border:0;"/>
						总金额：<input type="text" id="amount" name="amount" value="${wmsPurchase.amount}" htmlEscape="false" class="form-control input-mini" readonly="true" style="border:0;"/>
						
					</div>
					</div>
				</div>
			</div>
		</div>
	<br>
				<div class="form-actions">
					<c:if test="${wmsPurchase.status == 0}">
						<shiro:hasPermission name="wms:wmsPurchase:edit">
	    					<a href="${ctx}/wms/wmsPurchase/form?id=${wmsPurchase.id}" class="btn btn-success" title="修改"><i class="fa fa-edit"></i>
								<span class="hidden-xs">修改</span></a>
						</shiro:hasPermission>
						
						<shiro:hasPermission name="wms:wmsPurchase:audit">
							<a href="${ctx}/wms/wmsPurchase/audit?id=${wmsPurchase.id}" onclick="return confirmx('确认要审核该采购单吗？', this.href)" class="btn  btn-success" title="审核"><i class="fa fa-check"></i>
								<span class="hidden-xs">审核</span></a> 
						</shiro:hasPermission>
					</c:if>	
					
					<a href="${ctx}/wms/wmsPurchase/print?id=${wmsPurchase.id}" class="btn btn-white" title="打印" target="_blank"><i class="fa fa-print"></i> <span class="hidden-xs">打印</span></a>
					<input id="btnCancel" class="btn btn-white" type="button" value="返 回" onclick="history.go(-1)"/>
				</div>
			<br>
	</form:form>
</div></div></div>
</body>
</html>