<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<title>报价单</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta name="decorator" content="default"/>
	<style type="text/css">
	.table-bordered {
	    border: 1px solid #000000;
	}
	.hr-border {
	    border-color: #000000;
	}
	.table > thead > tr > th, .table > tbody > tr > th, .table > tfoot > tr > th, .table > thead > tr > td, .table > tbody > tr > td, .table > tfoot > tr > td {
	    border-top: 1px solid #000000;
	    line-height: 1.42857;
	    padding: 8px;
	    vertical-align: middle;
	}
	.table-bordered > thead > tr > th, .table-bordered > tbody > tr > th, .table-bordered > tfoot > tr > th, .table-bordered > thead > tr > td, .table-bordered > tbody > tr > td, .table-bordered > tfoot > tr > td {
	    border: 1px solid #000000;
	        border-top-width: 1px;
	        border-top-style: solid;
	        border-top-color: rgb(231, 231, 231);
	        border-top-color:#000000;
	}
	</style>
</head>
<body class="">
<div class="wrapper">
	<div class="">
		
		<div class="">
		
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
		<hr class="hr-border">
		<div class="row">
			<div class="col-sm-12">
	            <div class="col-sm-6 pull-left">
	            	地址：${fns:getSysAccount().address}<br>
	            	邮箱：${fns:getSysAccount().email}
	            </div>
	            <div class="col-sm-6 pull-right text-right">
	            	电话：${fns:getSysAccount().phone}<br>
	            	传真：${fns:getSysAccount().fax}
	            </div>	            
	            
			</div>
		</div>
		<hr class="hr-border">
		<div class="row">
			<div class="col-sm-12">
	            <div class="col-sm-6 pull-left">
	            	To：${crmQuote.customer.name}<br>
	            	Att：${crmQuote.contacter.name}<br>
	            	Tel：${crmQuote.contacter.mobile}
	            </div>
	            <div class="col-sm-6 pull-right text-right">
	            	From：${fns:getUser().name}<br>
	            	Date：<fmt:formatDate value="${crmQuote.startdate}" pattern="yyyy-MM-dd"/><br>
	            	Tel：${fns:getUser().mobile}
	            </div>	            
	            
			</div>
		</div>
		<div class="row">
			<div class="col-sm-12">
				<div class="text-center">
	            	<h2>报价单</h2>
	            	<br>
	            </div>
			</div>
		</div>
	 
		<!-- 明细 -->
		<div class="row">
			<div class="col-sm-12">
					<table id="contentTable" class="table table-bordered">
						<tbody>
							<tr>
								<td>序号</td>
								<td>产品名称</td>
								<td>规格</td>
								<td>单位</td>
								<td>数量</td>
								<td>单价(元)</td>								
								<td>金额(元)</td>
								<td>备注</td>
							</tr>
							<c:forEach items="${crmQuote.crmQuoteDetailList}" var="crmQuoteDetail" varStatus="sta">
								<tr>
											<td>${sta.index + 1}</td>
											<td>
												${crmQuoteDetail.product.name}
											</td>
											<td>
												${crmQuoteDetail.product.spec}
											</td>
											<td>
												${crmQuoteDetail.unitType}
											</td>
											<td>
												${crmQuoteDetail.num}
											</td>
											<td>
												${crmQuoteDetail.price}
											</td>
											<td>
												${crmQuoteDetail.amt}
											</td>
											<td>
												${crmQuoteDetail.remarks}
											</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
					<div class="pull-right">
						合计金额（元）：${crmQuote.amount} ，大写：（人民币）${fns:number2CNMontrayUnit(crmQuote.amount)}<br>
					</div>	
				</div>				
		</div>			
		<br>
		<div class="row">
			<div class="col-sm-12">
				${crmQuote.notes}
			</div>
		</div>
		<br>
		<hr>
		<div class="row">
			<div class="col-sm-12">
	            <div class="col-sm-6 pull-left">
	            	${fns:getSysAccount().neturl}
	            </div>
	            <div class="col-sm-6 pull-right text-right">
	            	${fns:getSysAccount().name}
	            </div>
			</div>
		</div>
					
</div></div></div>
	<script type="text/javascript">
        window.print();
    </script>
</body>
</html>