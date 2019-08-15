<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>订单信息选择器</title>
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
						<form:form id="searchForm" modelAttribute="testDataMain" action="${ctx}/test/onetomany/testDataMain/selectList" method="post" class="form-inline">
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
								<div class="form-group"><span>经办人：</span>
									<sys:treeselect id="dealBy" name="dealBy.id" value="${testDataMain.dealBy.id}" labelName="dealBy.name" labelValue="${testDataMain.dealBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-medium" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>业务日期：</span>
									<input name="beginDealDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${testDataMain.beginDealDate}" pattern="yyyy-MM-dd"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/> - 
									<input name="endDealDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${testDataMain.endDealDate}" pattern="yyyy-MM-dd"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
								</div>
								<div class="form-group"><span>审核状态：</span>
									<form:select path="status" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('audit_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
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
				<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable">
					<thead>
						<tr>
							<th><input type="checkbox" class="i-checks"></th>
							<th class="sort-column no">单号</th>
							<th class="sort-column sale_type">销售类型</th>
							<th class="sort-column amount">订单总额(元)</th>
							<th class="sort-column invoice_amt">开票金额(元)</th>
							<th class="sort-column deal_by">经办人</th>
							<th class="sort-column deal_date">业务日期</th>
							<th class="sort-column audit_by">审核人</th>
							<th class="sort-column audit_date">审核时间</th>
							<th class="sort-column status">审核状态</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="testDataMain">
						<tr>
							<td><input type="checkbox" id="${testDataMain.id}" class="i-checks"></td>
							<td>${testDataMain.no}</td>
							<td class="codelabel">${fns:getDictLabel(testDataMain.saleType, 'sale_type', '')}</td>
							<td>${testDataMain.amount}</td>
							<td>${testDataMain.invoiceAmt}</td>
							<td>${testDataMain.dealBy.name}</td>
							<td><fmt:formatDate value="${testDataMain.dealDate}" pattern="yyyy-MM-dd"/></td>
							<td>${testDataMain.auditBy.id}</td>
							<td><fmt:formatDate value="${testDataMain.auditDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
							<td>${fns:getDictLabel(testDataMain.status, 'audit_status', '')}</td>
							<td>
								<shiro:hasPermission name="test:onetomany:testDataMain:view">
									<a href="${ctx}/test/onetomany/testDataMain/view?id=${testDataMain.id}" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
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