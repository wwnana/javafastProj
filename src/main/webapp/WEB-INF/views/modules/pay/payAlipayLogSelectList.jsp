<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>支付宝支付通知列表选择器</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
	    	$('#contentTable thead tr th input.i-checks').on('ifChecked', function(event){ //ifCreated 事件应该在插件初始化之前绑定 
	    		$('#contentTable tbody tr td input.i-checks').iCheck('check');
	    	});
	    	$('#contentTable thead tr th input.i-checks').on('ifUnchecked', function(event){ //ifCreated 事件应该在插件初始化之前绑定 
	    		$('#contentTable tbody tr td input.i-checks').iCheck('uncheck');
	    	});
		});		
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#searchForm").submit();
        	return false;
        }		
		function getSelectedItem(){
			var size = $("#contentTable tbody tr td input.i-checks:checked").size();
			if(size == 0 ){
				top.layer.alert('请至少选择一条数据!', {icon: 0, title:'警告'});
				return "-1";
			}

			if(size > 1 ){
				top.layer.alert('只能选择一条数据!', {icon: 0, title:'警告'});
				return "-1";
			}
			var id =  $("#contentTable tbody tr td input.i-checks:checkbox:checked").attr("id");
			var label = $("#contentTable tbody tr td input.i-checks:checkbox:checked").parent().parent().parent().find(".codelabel").html();
			return id+"_item_"+label;
		}
	</script>
</head>
<body class="gray-bg">
	<div class="wrapper-content">
		<div class="ibox">
			
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="payAlipayLog" action="${ctx}/pay/payAlipayLog/selectList" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
								<div class="form-group"><span>支付宝交易号：</span>
									<form:input path="tradeNo" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>商户订单号：</span>
									<form:input path="outTradeNo" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>交易状态：</span>
									<form:input path="tradeStatus" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>支付宝支付账号：</span>
									<form:input path="buyerId" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>状态：</span>
									<form:select path="status" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('paylog_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>创建时间：</span>
									<input name="beginCreateDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${payAlipayLog.beginCreateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/> - 
									<input name="endCreateDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${payAlipayLog.endCreateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
								</div>
						</form:form>
						<br>
					</div>
				</div>
				<!-- 工具栏 -->
				<div class="row">
					<div class="col-sm-12 m-b-sm">
						<div class="pull-left">
					       <button class="btn btn-white btn-sm " data-toggle="tooltip" data-placement="left" onclick="sortOrRefresh()" title="刷新"><i class="glyphicon glyphicon-repeat"></i> 刷新</button>
						</div>
						<div class="pull-right">
							<button  class="btn btn-success btn-rounded btn-outline btn-sm " onclick="search()" ><i class="fa fa-search"></i> 查询</button>
							<button  class="btn btn-success btn-rounded btn-outline btn-sm " onclick="resetSearch()" ><i class="fa fa-refresh"></i> 重置</button>
						</div>
					</div>
				</div>
					
				<!-- 表格 -->
				<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable">
					<thead>
						<tr>
							<th><input type="checkbox" class="i-checks"></th>
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
							<td class="codelabel">${payAlipayLog.appid}</td>
							<td>${payAlipayLog.sellerId}</td>
							<td>${payAlipayLog.tradeNo}</td>
							<td>${payAlipayLog.outTradeNo}</td>
							<td>${payAlipayLog.tradeStatus}</td>
							<td>${payAlipayLog.totalAmount}</td>
							<td>${payAlipayLog.buyerPayAmount}</td>
							<td>${payAlipayLog.receiptAmount}</td>
							<td>${payAlipayLog.gmtPayment}</td>
							<td>${payAlipayLog.buyerId}</td>
							<td>${payAlipayLog.outBizNo}</td>
							<td>${payAlipayLog.refundFee}</td>
							<td>${payAlipayLog.gmtRefund}</td>
							<td>${fns:getDictLabel(payAlipayLog.status, 'paylog_status', '')}</td>
							<td><fmt:formatDate value="${payAlipayLog.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
							<td>
								<shiro:hasPermission name="pay:payAlipayLog:view">
									<a href="#" onclick="openDialogView('查看支付宝支付通知', '${ctx}/pay/payAlipayLog/view?id=${payAlipayLog.id}','800px', '500px')" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
								</shiro:hasPermission>
							</td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
				<table:page page="${page}"></table:page>
				<br/>
			</div>
		</div>
	</div>
</body>
</html>