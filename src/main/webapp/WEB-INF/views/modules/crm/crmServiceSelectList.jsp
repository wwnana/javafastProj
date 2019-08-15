<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>服务工单列表选择器</title>
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
<body class="">
	<div class="">
		<div class="">
			<div class="ibox-content">
			<sys:message content="${message}"/>
				<!-- 查询栏 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="crmService" action="${ctx}/crm/crmService/selectList" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
								<div class="form-group"><span>工单编码：</span>
									<form:input path="no" htmlEscape="false" maxlength="50" class="form-control input-small"/>
								</div>
								<div class="form-group"><span>主题：</span>
									<form:input path="name" htmlEscape="false" maxlength="50" class="form-control input-small"/>
								</div>
								<div class="form-group"><span>类型：</span>
									<form:select path="serviceType" class="form-control input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('service_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>客户：</span>
									<form:input path="customer.id" htmlEscape="false" maxlength="30" class="form-control input-small"/>
								</div>
								<div class="form-group"><span>负责人：</span>
									<sys:treeselect id="ownBy" name="ownBy.id" value="${crmService.ownBy.id}" labelName="ownBy.name" labelValue="${crmService.ownBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>优先级：</span>
									<form:select path="levelType" class="form-control input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('level_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>截止日期：</span>
									<div class="input-group date datepicker">
				                     	<input name="beginEndDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${crmService.beginEndDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
							         - 
							        <div class="input-group date datepicker">
				                     	<input name="endEndDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${crmService.endEndDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
								</div>
								<div class="form-group"><span>处理状态：</span>
									<form:select path="status" class="form-control input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('finish_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>处理日期：</span>
									<div class="input-group date datepicker">
				                     	<input name="beginDealDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${crmService.beginDealDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
							         - 
							        <div class="input-group date datepicker">
				                     	<input name="endDealDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${crmService.endDealDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
								</div>
								<div class="form-group"><span>满意度：</span>
									<form:select path="satisfyType" class="form-control input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('satisfy_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>审核日期：</span>
									<div class="input-group date datepicker">
				                     	<input name="beginAuditDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${crmService.beginAuditDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
							         - 
							        <div class="input-group date datepicker">
				                     	<input name="endAuditDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${crmService.endAuditDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
								</div>
								<div class="form-group"><span>创建时间：</span>
									<div class="input-group date datepicker">
				                     	<input name="beginCreateDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${crmService.beginCreateDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
							         - 
							        <div class="input-group date datepicker">
				                     	<input name="endCreateDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${crmService.endCreateDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
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
							<th><input type="checkbox" class="i-checks"></th>
							<th class="sort-column a.no">工单编码</th>
							<th class="sort-column a.name">主题</th>
							<th class="sort-column a.service_type">类型</th>
							<th class="sort-column a.order_id">订单合同</th>
							<th class="sort-column a.customer_id">客户</th>
							<th class="sort-column a.own_by">负责人</th>
							<th class="sort-column a.level_type">优先级</th>
							<th class="sort-column a.end_date">截止日期</th>
							<th class="sort-column a.status">处理状态</th>
							<th class="sort-column a.deal_date">处理日期</th>
							<th class="sort-column a.satisfy_type">满意度</th>
							<th class="sort-column a.audit_by">审核人</th>
							<th class="sort-column a.audit_date">审核日期</th>
							<th class="sort-column a.create_by">创建人</th>
							<th class="sort-column a.create_date">创建时间</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="crmService">
						<tr>
							<td><input type="checkbox" id="${crmService.id}" class="i-checks"></td>
							<td class="codelabel">${crmService.no}</td>
							<td>${crmService.name}</td>
							<td>${fns:getDictLabel(crmService.serviceType, 'service_type', '')}</td>
							<td>${crmService.omContract.id}</td>
							<td>${crmService.customer.id}</td>
							<td>${crmService.ownBy.name}</td>
							<td>${fns:getDictLabel(crmService.levelType, 'level_type', '')}</td>
							<td><fmt:formatDate value="${crmService.endDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
							<td>${fns:getDictLabel(crmService.status, 'finish_status', '')}</td>
							<td><fmt:formatDate value="${crmService.dealDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
							<td>${fns:getDictLabel(crmService.satisfyType, 'satisfy_type', '')}</td>
							<td>${crmService.auditBy.name}</td>
							<td><fmt:formatDate value="${crmService.auditDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
							<td>${crmService.createBy.id}</td>
							<td><fmt:formatDate value="${crmService.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
							<td>
								<shiro:hasPermission name="crm:crmService:view">
									<a href="#" onclick="openDialogView('查看服务工单', '${ctx}/crm/crmService/view?id=${crmService.id}','800px', '500px')" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
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