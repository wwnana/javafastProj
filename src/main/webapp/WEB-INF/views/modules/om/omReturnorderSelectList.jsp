<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>销售退单选择器</title>
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
						<form:form id="searchForm" modelAttribute="omReturnorder" action="${ctx}/om/omReturnorder/selectList" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
								<div class="form-group"><span>单号：</span>
									<form:input path="no" htmlEscape="false" maxlength="30" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>销售类型：</span>
									<form:select path="saleType" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('sale_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>客户：</span>
									<sys:tableselect id="customer" name="customer.id" value="${omReturnorder.customer.id}" labelName="customer.name" labelValue="${omReturnorder.customer.name}" 
										title="客户" url="${ctx}/crm/crmCustomer/selectList" cssClass="form-control input-medium" dataMsgRequired=""  allowClear="false" allowInput="false"/>
								</div>
								<div class="form-group"><span>关联销售订单：</span>
									<sys:tableselect id="order" name="order.id" value="${omReturnorder.order.id}" labelName="order.name" labelValue="${omReturnorder.order.name}" 
										title="订单" url="${ctx}/om/omOrder/selectList" cssClass="form-control input-medium" dataMsgRequired=""  allowClear="true" allowInput="false"/>
									
								</div>
								<div class="form-group"><span>入库仓库：</span>
									<sys:tableselect id="warehouse" name="warehouse.id" value="${omReturnorder.warehouse.id}" labelName="warehouse.name" labelValue="${omReturnorder.warehouse.name}" 
										title="入库仓库" url="${ctx}/wms/wmsWarehouse/selectList" cssClass="form-control input-medium" dataMsgRequired=""  allowClear="false" allowInput="false"/>
								</div>
								<div class="form-group"><span>结算账户：</span>
									<sys:tableselect id="fiAccount" name="fiAccount.id" value="${omReturnorder.fiAccount.id}" labelName="fiAccount.name" labelValue="${omReturnorder.fiAccount.name}" 
										title="结算账户" url="${ctx}/fi/fiFinanceAccount/selectList" cssClass="form-control input-medium" dataMsgRequired=""  allowClear="true" allowInput="false"/>
									
								</div>
								<div class="form-group"><span>审核状态：</span>
									<form:select path="status" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('audit_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>经办人：</span>
									<sys:treeselect id="dealBy" name="dealBy.id" value="${omReturnorder.dealBy.id}" labelName="dealBy.name" labelValue="${omReturnorder.dealBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-medium" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>业务日期：</span>
									<input name="beginDealDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${omReturnorder.beginDealDate}" pattern="yyyy-MM-dd"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/> - 
									<input name="endDealDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${omReturnorder.endDealDate}" pattern="yyyy-MM-dd"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
								</div>
						</form:form>
						<br>
					</div>
				</div>
				<!-- 工具栏 -->
				<div class="row">
					<div class="col-sm-12">
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
				<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed">
					<thead>
						<tr>
							<th><input type="checkbox" class="i-checks"></th>
							<th class="sort-column no">单号</th>
							<th class="sort-column sale_type">销售类型</th>
							<th class="sort-column customer_id">客户</th>
							<th class="sort-column order_id">关联销售订单</th>
							<th class="sort-column warehouse_id">入库仓库</th>
							<th class="sort-column content">内容</th>
							<th class="sort-column num">数量</th>
							<th class="sort-column total_amt">合计</th>
							<th class="sort-column other_amt">其他费用</th>
							<th class="sort-column amount">总计金额</th>
							<th class="sort-column actual_amt">实退金额</th>
							<th class="sort-column fi_account_id">结算账户</th>
							<th class="sort-column status">审核状态</th>
							<th class="sort-column deal_by">经办人</th>
							<th class="sort-column deal_date">业务日期</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="omReturnorder">
						<tr>
							<td><input type="checkbox" id="${omReturnorder.id}" class="i-checks"></td>
							<td><a href="#" onclick="openDialogView('查看销售退单', '${ctx}/om/omReturnorder/form?id=${omReturnorder.id}','800px', '500px')">${omReturnorder.no}</a></td>
							<td class="codelabel">${fns:getDictLabel(omReturnorder.saleType, 'sale_type', '')}</td>
							<td>${omReturnorder.customer.id}</td>
							<td>${omReturnorder.order.id}</td>
							<td>${omReturnorder.warehouse.id}</td>
							<td>${omReturnorder.content}</td>
							<td>${omReturnorder.num}</td>
							<td>${omReturnorder.totalAmt}</td>
							<td>${omReturnorder.otherAmt}</td>
							<td>${omReturnorder.amount}</td>
							<td>${omReturnorder.actualAmt}</td>
							<td>${omReturnorder.fiAccount.id}</td>
							<td>${fns:getDictLabel(omReturnorder.status, 'audit_status', '')}</td>
							<td>${omReturnorder.dealBy.name}</td>
							<td><fmt:formatDate value="${omReturnorder.dealDate}" pattern="yyyy-MM-dd"/></td>
							<td>
								<shiro:hasPermission name="om:omReturnorder:view">
									<a href="#" onclick="openDialogView('查看销售退单', '${ctx}/om/omReturnorder/form?id=${omReturnorder.id}','800px', '500px')" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
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