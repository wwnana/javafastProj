<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>支付宝支付通知列表</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
		});
	</script>
</head>
<body class="">
	<div class="">
		<div class="">
			<div class="row dashboard-header gray-bg">
				<h5>支付宝支付通知列表 </h5>
				<div class="pull-right">
					<button id="searchBtn" class="btn btn-white btn-sm" title="搜索"><i class="fa fa-search"></i> 搜索</button>
					<shiro:hasPermission name="pay:payAlipayLog:export">
			       		<table:exportExcel url="${ctx}/pay/payAlipayLog/export"></table:exportExcel><!-- 导出按钮 -->
			       	</shiro:hasPermission>
				</div>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="payAlipayLog" action="${ctx}/pay/payAlipayLog/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow>
								<div class="form-group"><span>支付宝交易号：</span>
									<form:input path="tradeNo" htmlEscape="false" maxlength="50" class="form-control input-small"/>
								</div>
								<div class="form-group"><span>商户订单号：</span>
									<form:input path="outTradeNo" htmlEscape="false" maxlength="50" class="form-control input-small"/>
								</div>
								
								<div class="form-group"><span>支付宝支付账号：</span>
									<form:input path="buyerId" htmlEscape="false" maxlength="50" class="form-control input-small"/>
								</div>
								<div class="form-group"><span>状态：</span>
									<form:select path="status" class="form-control input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('paylog_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>业务日期：</span>
									<div class="input-group date datepicker">
			                            <input name="beginCreateDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${payAlipayLog.beginCreateDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
			                         - 
			                        <div class="input-group" data-autoclose="true">
			                        	 <input name="endCreateDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${payAlipayLog.endCreateDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
								</div>
								<div class="form-group">
									<button class="btn btn-white btn-sm " onclick="search()"><i class="fa fa-search"></i> 查询</button>
									<button class="btn btn-white btn-sm " onclick="resetSearch()"><i class="fa fa-refresh"></i> 重置</button>
								</div>
						</form:form>
					</div>
				</div>
				
					
				<!-- 表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<th width="30px"><input type="checkbox" class="i-checks"></th>
							<th class="sort-column a.appid">开发者应用ID</th>
							<th class="sort-column a.seller_id">卖家支付宝用户号</th>
							<th class="sort-column a.trade_no">支付宝交易号</th>
							<th class="sort-column a.out_trade_no">商户订单号</th>
							<th class="sort-column a.trade_status">交易状态</th>
							<th class="sort-column a.total_amount">订单金额</th>
							<th class="sort-column a.buyer_pay_amount">付款金额</th>
							<th class="sort-column a.receipt_amount">实收金额</th>
							<th class="sort-column a.gmt_payment">交易付款时间</th>
							<th class="sort-column a.buyer_id">支付宝支付账号</th>
							<th class="sort-column a.out_biz_no">商户业务号</th>
							<th class="sort-column a.refund_fee">退款金额</th>
							<th class="sort-column a.gmt_refund">交易退款时间</th>
							<th class="sort-column a.status">状态</th>
							<th class="sort-column a.create_date">创建时间</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="payAlipayLog">
						<tr>
							<td><input type="checkbox" id="${payAlipayLog.id}" class="i-checks"></td>
							<td>
								<a href="#" onclick="openDialogView('查看支付宝支付通知', '${ctx}/pay/payAlipayLog/view?id=${payAlipayLog.id}','800px', '500px')">
								${payAlipayLog.appid}
							</a></td>
							<td>
								${payAlipayLog.sellerId}
							</td>
							<td>
								${payAlipayLog.tradeNo}
							</td>
							<td>
								${payAlipayLog.outTradeNo}
							</td>
							<td>
								${payAlipayLog.tradeStatus}
							</td>
							<td>
								${payAlipayLog.totalAmount}
							</td>
							<td>
								${payAlipayLog.buyerPayAmount}
							</td>
							<td>
								${payAlipayLog.receiptAmount}
							</td>
							<td>
								${payAlipayLog.gmtPayment}
							</td>
							<td>
								${payAlipayLog.buyerId}
							</td>
							<td>
								${payAlipayLog.outBizNo}
							</td>
							<td>
								${payAlipayLog.refundFee}
							</td>
							<td>
								${payAlipayLog.gmtRefund}
							</td>
							<td>
								${fns:getDictLabel(payAlipayLog.status, 'paylog_status', '')}
							</td>
							<td>
								<fmt:formatDate value="${payAlipayLog.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<td>
								<%-- 
								<shiro:hasPermission name="pay:payAlipayLog:view">
									<a href="#" onclick="openDialogView('查看支付宝支付通知', '${ctx}/pay/payAlipayLog/view?id=${payAlipayLog.id}','800px', '500px')" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
								</shiro:hasPermission>
								<shiro:hasPermission name="pay:payAlipayLog:edit">
			    					<a href="#" onclick="openDialog('修改支付宝支付通知', '${ctx}/pay/payAlipayLog/form?id=${payAlipayLog.id}','800px', '500px')" class="btn btn-success btn-xs" title="修改"><i class="fa fa-edit"></i><span class="hidden-xs">修改</span></a>
								</shiro:hasPermission>
								
								<shiro:hasPermission name="pay:payAlipayLog:del">
									<a href="${ctx}/pay/payAlipayLog/delete?id=${payAlipayLog.id}" onclick="return confirmx('确认要删除该支付宝支付通知吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i><span class="hidden-xs">删除</span></a> 
								</shiro:hasPermission>
								--%>
							</td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
				<table:page page="${page}"></table:page>
				</div>
			</div>
		</div>
	</div>
</body>
</html>