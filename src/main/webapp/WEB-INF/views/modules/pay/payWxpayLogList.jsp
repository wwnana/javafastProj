<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>微信支付通知列表</title>
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
				<h5>微信支付通知列表 </h5>
				<div class="pull-right">
					<button id="searchBtn" class="btn btn-white btn-sm" title="搜索"><i class="fa fa-search"></i> 搜索</button>
					 <button class="btn btn-white btn-sm " data-toggle="tooltip" data-placement="left" onclick="sortOrRefresh()" title="刷新"><i class="glyphicon glyphicon-repeat"></i> 刷新</button>
					<shiro:hasPermission name="pay:payWxpayLog:export">
			       		<table:exportExcel url="${ctx}/pay/payWxpayLog/export"></table:exportExcel><!-- 导出按钮 -->
			       	</shiro:hasPermission>
				</div>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="payWxpayLog" action="${ctx}/pay/payWxpayLog/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow>
								<div class="form-group"><span>商户号：</span>
									<form:input path="mchId" htmlEscape="false" maxlength="50" class="form-control input-small"/>
								</div>
								<div class="form-group"><span>微信支付订单号：</span>
									<form:input path="transactionId" htmlEscape="false" maxlength="50" class="form-control input-small"/>
								</div>
								<div class="form-group"><span>商户订单号：</span>
									<form:input path="outTradeNo" htmlEscape="false" maxlength="50" class="form-control input-small"/>
								</div>
								<div class="form-group"><span>付款通知处理状态：</span>
									<form:select path="status" class="form-control input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('paylog_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>业务日期：</span>
									<div class="input-group date datepicker">
			                            <input name="beginCreateDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${payWxpayLog.beginCreateDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
			                         - 
			                        <div class="input-group" data-autoclose="true">
			                        	 <input name="endCreateDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${payWxpayLog.endCreateDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
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
							<th class="sort-column a.appid">公众账号</th>
							<th class="sort-column a.mch_id">商户号</th>
							<th class="sort-column a.result_code">业务结果</th>
							<th class="sort-column a.err_code">错误代码</th>
							<th class="sort-column a.trade_type">交易类型</th>
							<th class="sort-column a.bank_type">付款银行</th>
							<th class="sort-column a.openid">用户标识</th>
							<th class="sort-column a.total_fee">订单金额</th>
							<th class="sort-column a.cash_fee">现金支付金额</th>
							<th class="sort-column a.transaction_id">微信支付订单号</th>
							<th class="sort-column a.out_trade_no">商户订单号</th>
							<th class="sort-column a.time_end">支付完成时间</th>
							<th class="sort-column a.status">付款通知处理状态</th>
							<th class="sort-column a.create_date">创建时间</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="payWxpayLog">
						<tr>
							<td><input type="checkbox" id="${payWxpayLog.id}" class="i-checks"></td>
							<td>
								<a href="#" onclick="openDialogView('查看微信支付通知', '${ctx}/pay/payWxpayLog/view?id=${payWxpayLog.id}','800px', '500px')">
								${payWxpayLog.appid}
							</a></td>
							<td>
								${payWxpayLog.mchId}
							</td>
							<td>
								${payWxpayLog.resultCode}
							</td>
							<td>
								${payWxpayLog.errCode}
							</td>
							<td>
								${payWxpayLog.tradeType}
							</td>
							<td>
								${payWxpayLog.bankType}
							</td>
							<td>
								${payWxpayLog.openid}
							</td>
							<td>
								${payWxpayLog.totalFee}
							</td>
							<td>
								${payWxpayLog.cashFee}
							</td>
							<td>
								${payWxpayLog.transactionId}
							</td>
							<td>
								${payWxpayLog.outTradeNo}
							</td>
							<td>
								${payWxpayLog.timeEnd}
							</td>
							<td>
								${fns:getDictLabel(payWxpayLog.status, 'paylog_status', '')}
							</td>
							<td>
								<fmt:formatDate value="${payWxpayLog.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<td>
								<%-- 
								<shiro:hasPermission name="pay:payWxpayLog:view">
									<a href="#" onclick="openDialogView('查看微信支付通知', '${ctx}/pay/payWxpayLog/view?id=${payWxpayLog.id}','800px', '500px')" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
								</shiro:hasPermission>
								<shiro:hasPermission name="pay:payWxpayLog:edit">
			    					<a href="#" onclick="openDialog('修改微信支付通知', '${ctx}/pay/payWxpayLog/form?id=${payWxpayLog.id}','800px', '500px')" class="btn btn-success btn-xs" title="修改"><i class="fa fa-edit"></i><span class="hidden-xs">修改</span></a>
								</shiro:hasPermission>
								
								<shiro:hasPermission name="pay:payWxpayLog:del">
									<a href="${ctx}/pay/payWxpayLog/delete?id=${payWxpayLog.id}" onclick="return confirmx('确认要删除该微信支付通知吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i><span class="hidden-xs">删除</span></a> 
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