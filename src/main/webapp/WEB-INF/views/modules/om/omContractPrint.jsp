<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>合同</title>
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
	<script type="text/javascript">
        window.print();
    </script>
</head>
<body class="">
<div class="wrapper">
	<div class="">
		
		<div class="">
		<div class="row hide">
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
		
		<div class="row">
			<div class="col-sm-12">
				<div class="text-center">
	            	<h2>销售合同书</h2>
	            	<br>
	            </div>
			</div>
		</div>
		<table class="table" style="border: 0;">
			<tbody>
				<tr>
					<td width="50%">
						<p>合同编号：${omContract.no}</p>
						<p>供方：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${fns:getSysAccount().name}</p>
						<p>联系人：&nbsp;&nbsp;&nbsp;${omContract.ownBy.name}</p>
						<p>电话：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${omContract.ownBy.mobile}</p>
					</td>
					<td width="50%">						
						<p>签订日期：<fmt:formatDate value="${omContract.dealDate}" pattern="yyyy-MM-dd"/></p>
						<p>需方：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${omContract.customer.name}</p>
						<p>联系人：&nbsp;&nbsp;&nbsp;${omContract.customer.contacterName}</p>
						<p>电话：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${omContract.customer.mobile}</p>
					</td>
				</tr>
			</tbody>
		</table>		
		
		<div class="row">
			<div class="col-sm-12">
				第一条 供货清单与合同金额
			</div>
		</div>
		<br>
		<div class="row">
			<div class="col-sm-12">
		<!-- 明细 -->
		
					<table id="contentTable" class="table table-bordered">
						<tbody>
							<tr>
								<th>序号</th>
								<td>产品名称</td>
								<th>规格</th>
								<td>单位</td>
								<td>单价(元)</td>
								<td>数量</td>
								<td>金额(元)</td>
								
								<td>备注</td>
							</tr>
							<c:forEach items="${omContract.omOrderDetailList}" var="omOrderDetail" varStatus="sta">
								<tr>
											<td>${sta.index + 1}</td>
											<td>
												${omOrderDetail.product.name}
											</td>
											<td>
												${omOrderDetail.product.spec}
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
							<tr>
								<td>合计</td>
								<td colspan="5">
								
								</td>
								<td>${omContract.order.totalAmt}</td>
								<td></td>
							</tr>
						</tbody>
					</table>
					
					<div class="hide">
						总数量：${omContract.order.num}， 
						合计金额：${omContract.order.totalAmt}， 
						其他费用：${omContract.order.otherAmt}，
						总金额：${omContract.order.amount}
					
					</div>				
			</div>
		</div>		
	<br>
					<div>
						合同金额（元）：${omContract.order.amount}，大写：（人民币）${fns:number2CNMontrayUnit(omContract.order.amount)}
					</div>	
	<br>
		<div class="row">
			<div class="col-sm-12">
				${omContract.notes}
			</div>
		</div>
		<br>
		<table id="contentTable" class="table table-bordered">
			<tbody>
				<tr>
					<td align="center" width="50%">需方</td>
					<td align="center" width="50%">供方</td>
				</tr>
				<tr>
					<td>
						<p>公司名称：${omContract.customer.name}</p>
						<p>地址：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${omContract.customer.address}</p>
						<p>传真：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${omContract.customer.fax}</p>
						<p>开户银行：${omContract.customer.bankaccountname}</p>
						<p>开户帐号：${omContract.customer.bankaccountno}</p>
						<p>(签字)盖章：</p>
						<p>日期：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<fmt:formatDate value="${omContract.dealDate}" pattern="yyyy-MM-dd"/></p>
					</td>
					<td>						
						<p>公司名称：${fns:getSysAccount().name}</p>
						<p>地址：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${fns:getSysAccount().address}</p>
						<p>传真：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${fns:getSysAccount().fax}</p>
						<p>开户银行：${fns:getSysAccount().bankaccountname}</p>
						<p>开户帐号：${fns:getSysAccount().bankaccountno}</p>
						<p>(签字)盖章：</p>
						<p>日期：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<fmt:formatDate value="${omContract.dealDate}" pattern="yyyy-MM-dd"/></p>
					</td>
				</tr>
			</tbody>
		</table>		
	</div>
</div>
</div>
</body>
</html>