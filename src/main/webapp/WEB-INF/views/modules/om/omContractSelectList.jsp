<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>合同选择器</title>
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
<div class="">
		<div class="ibox">
			
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 查询条件 -->
				<c:if test="${empty omOrder.customer.id}">
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="omContract" action="${ctx}/om/omContract/selectList" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
								<div class="form-group"><span>合同编号：</span>
									<form:input path="no" htmlEscape="false" maxlength="30" class="form-control input-small"/>
								</div>
								<div class="form-group"><span>客户：</span>
									<sys:tableselect id="customer" name="customer.id" value="${omContract.customer.id}" labelName="customer.name" labelValue="${omContract.customer.name}" 
										title="客户" url="${ctx}/crm/crmCustomer/selectList" cssClass="form-control input-small" dataMsgRequired=""  allowClear="true" allowInput="false"/>
								</div>
															
								<div class="form-group"><span>状态：</span>
									<form:select path="status" class="form-control input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('audit_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>销售负责人：</span>
									<sys:treeselect id="ownBy" name="ownBy.id" value="${omContract.ownBy.id}" labelName="ownBy.name" labelValue="${omContract.ownBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>签约日期：</span>
									<div class="input-group date datepicker">
			                            <input name="beginDealDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${omContract.beginDealDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
			                         - 
			                        <div class="input-group" data-autoclose="true">
			                        	 <input name="endDealDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${omContract.endDealDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
								</div>
								<%--
								
								
								<div class="form-group"><span>销售订单：</span>
									<form:input path="order.id" htmlEscape="false" maxlength="30" class="form-control input-small"/>
								</div>
								<div class="form-group"><span>报价单：</span>
									<form:input path="quote.id" htmlEscape="false" maxlength="30" class="form-control input-small"/>
								</div>
								<div class="form-group"><span>商机：</span>
									<form:input path="chance.id" htmlEscape="false" maxlength="30" class="form-control input-small"/>
								</div>
								
								
								<div class="form-group"><span>交付时间：</span>
									<input name="beginDeliverDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-small"
										value="<fmt:formatDate value="${omContract.beginDeliverDate}" pattern="yyyy-MM-dd"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/> - 
									<input name="endDeliverDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-small"
										value="<fmt:formatDate value="${omContract.endDeliverDate}" pattern="yyyy-MM-dd"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
								</div>
								
								
								<div class="form-group"><span>创建人：</span>
									<sys:treeselect id="createBy" name="createBy.id" value="${omContract.createBy.id}" labelName="createBy.name" labelValue="${omContract.createBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>创建时间：</span>
									<input name="beginCreateDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-small"
										value="<fmt:formatDate value="${omContract.beginCreateDate}" pattern="yyyy-MM-dd"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/> - 
									<input name="endCreateDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-small"
										value="<fmt:formatDate value="${omContract.endCreateDate}" pattern="yyyy-MM-dd"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
								</div>
								--%>
								<div class="form-group">
									<button class="btn btn-white btn-sm" onclick="search()"><i class="fa fa-search"></i> 查询</button>
									<button class="btn btn-white btn-sm" onclick="resetSearch()"><i class="fa fa-refresh"></i> 重置</button>
								</div>
						</form:form>
					</div>
				</div>
				</c:if>
					
				<!-- 表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<th><input type="checkbox" class="i-checks"></th>
							<th>合同编号</th>
							<th>主题</th>
							<th>客户</th>							
							<th class="sort-column amount">总金额</th>
							<th class="sort-column a.deal_date">签约日期</th>
							<th class="sort-column a.own_by">销售负责人</th>
							<th class="sort-column a.status">状态</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="omContract">
						<tr>
							<td><input type="checkbox" id="${omContract.id}" class="i-checks"></td>
							<td>${omContract.no}</td>
							<td class="codelabel">${fns:abbr(omContract.name,50)}</td>
							<td>${fns:abbr(omContract.customer.name,50)}</td>
							
							<td>${omContract.amount}</td>
							<td><fmt:formatDate value="${omContract.dealDate}" pattern="yyyy-MM-dd"/></td>
							<td>${omContract.ownBy.name}</td>
							<td>${fns:getDictLabel(omContract.status, 'audit_status', '')}</td>
							<td>
								<shiro:hasPermission name="om:omContract:view">
									<a href="#" onclick="openDialogView('查看合同', '${ctx}/om/omContract/index?id=${omContract.id}','800px', '500px')" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
								</shiro:hasPermission>
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