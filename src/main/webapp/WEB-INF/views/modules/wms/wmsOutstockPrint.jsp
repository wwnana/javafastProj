<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>出库单打印</title>
	<meta name="decorator" content="default"/>
	<style type="text/css">
	.table-bordered {
	    border: 1px solid #aaa;
	}
	.hr-border {
	    border-color: #aaa;
	}
	.table > thead > tr > th, .table > tbody > tr > th, .table > tfoot > tr > th, .table > thead > tr > td, .table > tbody > tr > td, .table > tfoot > tr > td {
	    border-top: 1px solid #aaa;
	    line-height: 1.42857;
	    padding: 8px;
	    vertical-align: middle;
	}
	.table-bordered > thead > tr > th, .table-bordered > tbody > tr > th, .table-bordered > tfoot > tr > th, .table-bordered > thead > tr > td, .table-bordered > tbody > tr > td, .table-bordered > tfoot > tr > td {
	    border: 1px solid #aaa;
	        border-top-width: 1px;
	        border-top-style: solid;
	        border-top-color: rgb(231, 231, 231);
	        border-top-color:#aaa;
	}
	</style>
	<script type="text/javascript">
        window.print();
    </script>
</head>
<body class="">
<div class="">
	<div class="">
		
		<div class="ibox-content">
		
		<div class="row">
			<div class="col-sm-12">
				 <div class="col-sm-6 pull-left">
				 	<img alt="" src="${fns:getSysAccount().logo}">
				</div>
				 <div class="col-sm-6 pull-right text-right">
	            	<h2>${fns:getSysAccount().name}</h2>
	            	<p>${fns:getSysAccount().enname}</p>            	
	            </div>	            
			</div>
		</div>
		<hr>
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
		<div class="">
					<table id="contentTable" class="table table-bordered">
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
		<br>
		
		
	<br>
</div></div></div>
</body>
</html>