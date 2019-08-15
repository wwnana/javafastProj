<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>入库单打印</title>
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
						${wmsInstock.realNum}
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
					<td class="width-15 active"><label class="pull-right">备注：</label></td>
					<td class="width-35" colspan="3">
						${wmsInstock.remarks}
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
	<br>
				
	</form:form>
</div></div></div>
</body>
</html>