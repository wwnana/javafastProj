<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>收款单选择器</title>
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
						<form:form id="searchForm" modelAttribute="fiReceiveBill" action="${ctx}/fi/fiReceiveBill/selectList" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
								<div class="form-group"><span>单号：</span>
									<form:input path="no" htmlEscape="false" maxlength="30" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>应收款：</span>
									<form:input path="fiReceiveAble.id" htmlEscape="false" maxlength="30" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>客户：</span>
									<sys:tableselect id="customer" name="customer.id" value="${fiReceiveBill.customer.id}" labelName="customer.name" labelValue="${fiReceiveBill.customer.name}" 
										title="客户" url="${ctx}/crm/crmCustomer/selectList" cssClass="form-control input-medium" dataMsgRequired=""  allowClear="true" allowInput="false"/>
								</div>
								<div class="form-group"><span>收款账户：</span>
									<sys:tableselect id="fiAccount" name="fiAccount.id" value="${fiReceiveBill.fiAccount.id}" labelName="fiAccount.name" labelValue="${fiReceiveBill.fiAccount.name}" 
										title="结算账户" url="${ctx}/fi/fiFinanceAccount/selectList" cssClass="form-control input-medium" dataMsgRequired=""  allowClear="true" allowInput="false"/>
									
								</div>
									<div class="form-group"><span>收款时间：</span>
									<input name="beginDealDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${fiReceiveBill.beginDealDate}" pattern="yyyy-MM-dd"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/> - 
									<input name="endDealDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${fiReceiveBill.endDealDate}" pattern="yyyy-MM-dd"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
								</div>
								<div class="form-group"><span>收款账户：</span>
									<form:input path="fiAccount.id" htmlEscape="false" maxlength="30" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>收款人：</span>
									<sys:treeselect id="ownBy" name="ownBy.id" value="${fiReceiveBill.ownBy.id}" labelName="ownBy.name" labelValue="${fiReceiveBill.ownBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-medium" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>是否开票：</span>
									<form:select path="isInvoice" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>状态：</span>
									<form:select path="status" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('audit_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>创建人：</span>
									<form:input path="createBy.id" htmlEscape="false" maxlength="30" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>创建时间：</span>
									<input name="beginCreateDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${fiReceiveBill.beginCreateDate}" pattern="yyyy-MM-dd"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/> - 
									<input name="endCreateDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${fiReceiveBill.endCreateDate}" pattern="yyyy-MM-dd"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
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
				<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed">
					<thead>
						<tr>
							<th><input type="checkbox" class="i-checks"></th>
							<th class="sort-column no">单号</th>
							<th class="sort-column fi_receive_able_id">应收款</th>
							<th class="sort-column customer_id">客户</th>
							<th class="sort-column amount">收款金额</th>
							<th class="sort-column deal_date">收款时间</th>
							<th class="sort-column fi_account_id">收款账户</th>
							<th class="sort-column own_by">收款人</th>
							<th class="sort-column is_invoice">是否开票</th>
							<th class="sort-column invoice_amt">开票金额</th>
							<th class="sort-column status">状态</th>
							<th class="sort-column create_by">创建人</th>
							<th class="sort-column create_date">创建时间</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="fiReceiveBill">
						<tr>
							<td><input type="checkbox" id="${fiReceiveBill.id}" class="i-checks"></td>
							<td><a href="#" onclick="openDialogView('查看收款单', '${ctx}/fi/fiReceiveBill/view?id=${fiReceiveBill.id}','800px', '500px')">${fiReceiveBill.no}</a></td>
							<td class="codelabel">${fiReceiveBill.fiReceiveAble.id}</td>
							<td>${fiReceiveBill.customer.id}</td>
							<td>${fiReceiveBill.amount}</td>
							<td><fmt:formatDate value="${fiReceiveBill.dealDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
							<td>${fiReceiveBill.fiAccount.id}</td>
							<td>${fiReceiveBill.ownBy.name}</td>
							<td>${fns:getDictLabel(fiReceiveBill.isInvoice, 'yes_no', '')}</td>
							<td>${fiReceiveBill.invoiceAmt}</td>
							<td>${fns:getDictLabel(fiReceiveBill.status, 'audit_status', '')}</td>
							<td>${fiReceiveBill.createBy.id}</td>
							<td><fmt:formatDate value="${fiReceiveBill.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
							<td>
								<shiro:hasPermission name="fi:fiReceiveBill:view">
									<a href="#" onclick="openDialogView('查看收款单', '${ctx}/fi/fiReceiveBill/view?id=${fiReceiveBill.id}','800px', '500px')" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
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