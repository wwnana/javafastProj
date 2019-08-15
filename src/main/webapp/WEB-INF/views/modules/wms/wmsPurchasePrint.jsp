<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>采购单打印</title>
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
	<form:form id="inputForm" modelAttribute="wmsPurchase" action="${ctx}/wms/wmsPurchase/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		
	<div class="row">
			<div class="col-sm-12">
				<div class="text-center p-lg">
	            	<h2>采购单</h2>
	            </div>
			</div>
		</div>
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
				
	</form:form>
</div></div></div>
</body>
</html>