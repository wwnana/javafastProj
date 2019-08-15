<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>调拨单列表选择器</title>
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
						<form:form id="searchForm" modelAttribute="wmsAllot" action="${ctx}/wms/wmsAllot/selectList" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
								<div class="form-group"><span>单号：</span>
									<form:input path="no" htmlEscape="false" maxlength="30" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>审核状态：</span>
									<form:select path="status" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('audit_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>业务日期：</span>
									<input name="beginDealDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${wmsAllot.beginDealDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/> - 
									<input name="endDealDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${wmsAllot.endDealDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
								</div>
						</form:form>
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
				<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable">
					<thead>
						<tr>
							<th><input type="checkbox" class="i-checks"></th>
							<th class="sort-column a.no">单号</th>
							<th class="sort-column a.num">总数量</th>
							<th class="sort-column a.real_num">已完成数</th>
							<th class="sort-column a.out_warehouse_id">调出仓库</th>
							<th class="sort-column a.in_warehouse_id">调入出库</th>
							<th class="sort-column a.logistics_company">物流公司</th>
							<th class="sort-column a.logistics_no">物流单号</th>
							<th class="sort-column a.logistics_amount">运费</th>
							<th class="sort-column a.fi_account_id">支付账户</th>
							<th class="sort-column a.status">审核状态</th>
							<th class="sort-column a.deal_by">经办人</th>
							<th class="sort-column a.deal_date">业务日期</th>
							<th class="sort-column a.create_by">制单人</th>
							<th class="sort-column a.create_date">制单时间</th>
							<th class="sort-column a.audit_by">审核人</th>
							<th class="sort-column a.audit_date">审核时间</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="wmsAllot">
						<tr>
							<td><input type="checkbox" id="${wmsAllot.id}" class="i-checks"></td>
							<td class="codelabel">${wmsAllot.no}</td>
							<td>${wmsAllot.num}</td>
							<td>${wmsAllot.realNum}</td>
							<td>${wmsAllot.outWarehouse.id}</td>
							<td>${wmsAllot.inWarehouse.id}</td>
							<td>${wmsAllot.logisticsCompany}</td>
							<td>${wmsAllot.logisticsNo}</td>
							<td>${wmsAllot.logisticsAmount}</td>
							<td>${wmsAllot.fiAccount.id}</td>
							<td>${fns:getDictLabel(wmsAllot.status, 'audit_status', '')}</td>
							<td>${wmsAllot.dealBy.id}</td>
							<td><fmt:formatDate value="${wmsAllot.dealDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
							<td>${wmsAllot.createBy.id}</td>
							<td><fmt:formatDate value="${wmsAllot.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
							<td>${wmsAllot.auditBy.id}</td>
							<td><fmt:formatDate value="${wmsAllot.auditDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
							<td>
								<shiro:hasPermission name="wms:wmsAllot:view">
									<a href="#" onclick="openDialogView('查看调拨单', '${ctx}/wms/wmsAllot/view?id=${wmsAllot.id}','800px', '500px')" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
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