<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>付款单选择器</title>
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
						<form:form id="searchForm" modelAttribute="fiPaymentBill" action="${ctx}/fi/fiPaymentBill/selectList" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
								<div class="form-group"><span>单号：</span>
									<form:input path="no" htmlEscape="false" maxlength="30" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>供应商：</span>
									<sys:tableselect id="supplier" name="supplier.id" value="${fiPaymentBill.supplier.id}" labelName="supplier.name" labelValue="${fiPaymentBill.supplier.name}" 
										title="供应商" url="${ctx}/wms/wmsSupplier/selectList" cssClass="form-control input-xlarge" dataMsgRequired=""  allowClear="false" allowInput="false"/>
								</div>
								<div class="form-group"><span>付款时间：</span>
									<input name="beginDealDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${fiPaymentBill.beginDealDate}" pattern="yyyy-MM-dd"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/> - 
									<input name="endDealDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${fiPaymentBill.endDealDate}" pattern="yyyy-MM-dd"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
								</div>
								<div class="form-group"><span>付款账户：</span>
									<sys:tableselect id="fiAccount" name="fiAccount.id" value="${fiPaymentBill.fiAccount.id}" labelName="fiAccount.name" labelValue="${fiPaymentBill.fiAccount.name}" 
										title="结算账户" url="${ctx}/fi/fiFinanceAccount/selectList" cssClass="form-control input-xlarge" dataMsgRequired=""  allowClear="true" allowInput="false"/>
								</div>
								<div class="form-group"><span>负责人：</span>
									<sys:treeselect id="ownBy" name="ownBy.id" value="${fiPaymentBill.ownBy.id}" labelName="ownBy.name" labelValue="${fiPaymentBill.ownBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-medium" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>状态：</span>
									<form:select path="status" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('audit_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>创建人：</span>
									<sys:treeselect id="createBy" name="createBy.id" value="${fiPaymentBill.createBy.id}" labelName="createBy.name" labelValue="${fiPaymentBill.createBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-medium" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>创建时间：</span>
									<input name="beginCreateDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${fiPaymentBill.beginCreateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/> - 
									<input name="endCreateDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${fiPaymentBill.endCreateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
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
							<th class="sort-column no">单号</th>
							<th class="sort-column supplier_id">供应商</th>
							<th class="sort-column amount">付款金额</th>
							<th class="sort-column a.deal_date">付款时间</th>
							<th class="sort-column fi_account_id">付款账户</th>
							<th class="sort-column a.own_by">负责人</th>
							<th class="sort-column a.status">状态</th>
							<th class="sort-column a.create_by">创建人</th>
							<th class="sort-column a.create_date">创建时间</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="fiPaymentBill">
						<tr>
							<td><input type="checkbox" id="${fiPaymentBill.id}" class="i-checks"></td>
							<td>${fiPaymentBill.no}</td>
							<td class="codelabel">${fiPaymentBill.supplier.name}</td>
							<td>${fiPaymentBill.amount}</td>
							<td><fmt:formatDate value="${fiPaymentBill.dealDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
							<td>${fiPaymentBill.fiAccount.id}</td>
							<td>${fiPaymentBill.ownBy.name}</td>
							<td>${fns:getDictLabel(fiPaymentBill.status, 'audit_status', '')}</td>
							<td>${fiPaymentBill.createBy.name}</td>
							<td><fmt:formatDate value="${fiPaymentBill.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
							<td>
								<shiro:hasPermission name="fi:fiPaymentBill:view">
									<a href="#" onclick="openDialogView('查看付款单', '${ctx}/fi/fiPaymentBill/view?id=${fiPaymentBill.id}','800px', '500px')" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
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