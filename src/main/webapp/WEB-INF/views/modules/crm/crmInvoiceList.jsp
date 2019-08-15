<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>开票信息管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
		});
		//0:隐藏tip, 1隐藏box,不设置显示全部
		top.$.jBox.closeTip();
	</script>
</head>
<body class="">
<div class="">
		<div class="">
			<c:if test="${empty crmInvoice.customer.id}">
			<div class="ibox-title">
				<h5>开票信息列表 </h5>
			</div>
			</c:if>
			<div class="ibox-content">
			<sys:message content="${message}"/>
				<c:if test="${empty crmInvoice.customer.id}">
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="crmInvoice" action="${ctx}/crm/crmInvoice/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<form:hidden path="customer.id"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
								<div class="form-group"><span>发票抬头：</span>
									<form:input path="regName" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>税务登记号：</span>
									<form:input path="taxNo" htmlEscape="false" maxlength="30" class="form-control input-medium"/>
								</div>
								<div class="form-group">
									<button class="btn btn-white btn-sm" onclick="search()"><i class="fa fa-search"></i> 查询</button>
									<button class="btn btn-white btn-sm" onclick="resetSearch()"><i class="fa fa-refresh"></i> 重置</button>
								</div>
						</form:form>
					</div>
				</div>
				</c:if>
				<!-- 工具栏 -->
				<div class="row">
					<div class="col-sm-12 m-b-sm">
						<div class="pull-left">
							<shiro:hasPermission name="crm:crmCustomer:add">
								<a href="${ctx}/crm/crmInvoice/form?customer.id=${crmInvoice.customer.id}" class="btn btn-success btn-sm" title="添加"><i class="fa fa-plus"></i> 新建</a>
							</shiro:hasPermission>
							<%-- 
							<shiro:hasPermission name="crm:crmCustomer:edit">
							    <table:editRow url="${ctx}/crm/crmInvoice/form" title="开票信息" id="contentTable"></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							
							<shiro:hasPermission name="crm:crmCustomer:del">
								<table:delRow url="${ctx}/crm/crmInvoice/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							
							<shiro:hasPermission name="crm:crmCustomer:import">
								<table:importExcel url="${ctx}/crm/crmInvoice/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
							--%>
							<c:if test="${empty crmInvoice.customer.id}">
							<shiro:hasPermission name="crm:crmCustomer:export">
					       		<table:exportExcel url="${ctx}/crm/crmInvoice/export"></table:exportExcel><!-- 导出按钮 -->
					       	</shiro:hasPermission>
					       	</c:if>
						</div>
						
					</div>
				</div>
					
				<!-- 表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<th>抬头</th>
							<th>税号</th>
							<th>单位地址</th>
							<th>单位电话</th>							 
							
							<th>开户行</th>
							<th>账号</th>
							<th width="100px">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="crmInvoice">
						<tr>
							<td><a href="#" onclick="openDialogView('查看开票信息', '${ctx}/crm/crmInvoice/view?id=${crmInvoice.id}','800px', '500px')">
								${crmInvoice.regName}
							</a></td>
							<td>
								${crmInvoice.taxNo}
							</td>
							<td>
								${crmInvoice.regAddress}
							</td>
							<td>
								${crmInvoice.regPhone}
							</td>
							
							<td>
								${crmInvoice.bankName}
							</td>
							<td>
								${crmInvoice.bankNo}
							</td>
							<td>
								
								<shiro:hasPermission name="crm:crmCustomer:edit">
			    					<a href="${ctx}/crm/crmInvoice/form?id=${crmInvoice.id}" class="" title="修改">修改</a>
								</shiro:hasPermission>
								
								<shiro:hasPermission name="crm:crmCustomer:del">
									<a href="${ctx}/crm/crmInvoice/delete?id=${crmInvoice.id}" onclick="return confirmx('确认要删除该开票信息吗？', this.href)" class="" title="删除">删除</a> 
								</shiro:hasPermission>
								
							</td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
				<c:if test="${fn:length(page.list)>10}">
				<table:page page="${page}"></table:page>
				</c:if>
				</div>
			</div>
		</div>
	</div>
</body>
</html>