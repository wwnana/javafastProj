<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>电子钱包余额列表</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
		});
	</script>
</head>
<body class="gray-bg">
	<div class="wrapper-content">
		<div class="ibox">
			<div class="ibox-title">
				<h5>电子钱包余额列表 </h5>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="payBankbookBalance" action="${ctx}/pay/payBankbookBalance/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
								<div class="form-group"><span>企业编号：</span>
									<form:input path="id" htmlEscape="false" maxlength="30" class="form-control input-medium"/>
								</div>
						</form:form>
					</div>
				</div>
				<!-- 工具栏 -->
				<div class="row">
					<div class="col-sm-12 m-b-sm">
						<div class="pull-left">
							<%--
							<shiro:hasPermission name="pay:payBankbookBalance:add">
								<table:addRow url="${ctx}/pay/payBankbookBalance/form" title="电子钱包余额" ></table:addRow><!-- 增加按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="pay:payBankbookBalance:edit">
							    <table:editRow url="${ctx}/pay/payBankbookBalance/form" title="电子钱包余额" id="contentTable" ></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="pay:payBankbookBalance:del">
								<table:delRow url="${ctx}/pay/payBankbookBalance/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							 
							<shiro:hasPermission name="pay:payBankbookBalance:import">
								<table:importExcel url="${ctx}/pay/payBankbookBalance/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
							--%>
							<shiro:hasPermission name="pay:payBankbookBalance:edit">
								<a href="${ctx}/pay/payBankbookBalance/monthSettleAccounts" onclick="return confirmx('确认要启动月结吗？', this.href)" class="btn btn-white btn-sm"><i class="fa fa-check"></i> 月结</a>
							</shiro:hasPermission>
							<shiro:hasPermission name="pay:payBankbookBalance:export">
					       		<table:exportExcel url="${ctx}/pay/payBankbookBalance/export"></table:exportExcel><!-- 导出按钮 -->
					       	</shiro:hasPermission>
					       	<table:refreshRow></table:refreshRow>
						</div>
						<div class="pull-right">
							<button  class="btn btn-success btn-rounded btn-outline btn-sm " onclick="search()" ><i class="fa fa-search"></i> 查询</button>
							<button  class="btn btn-success btn-rounded btn-outline btn-sm " onclick="resetSearch()" ><i class="fa fa-refresh"></i> 重置</button>
						</div>
					</div>
				</div>
					
				<!-- 表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<th><input type="checkbox" class="i-checks"></th>
							<th class="sort-column a.id">企业编号</th>
							<th class="sort-column a.balance">余额</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="payBankbookBalance">
						<tr>
							<td><input type="checkbox" id="${payBankbookBalance.id}" class="i-checks"></td>
							<td>
								${payBankbookBalance.id}
							</td>
							<td>
								${payBankbookBalance.balance}
							</td>
							<td>
								<%-- 
								<shiro:hasPermission name="pay:payBankbookBalance:view">
									<a href="#" onclick="openDialogView('查看电子钱包余额', '${ctx}/pay/payBankbookBalance/view?id=${payBankbookBalance.id}','800px', '500px')" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
								</shiro:hasPermission>
								<shiro:hasPermission name="pay:payBankbookBalance:edit">
			    					<a href="#" onclick="openDialog('修改电子钱包余额', '${ctx}/pay/payBankbookBalance/form?id=${payBankbookBalance.id}','800px', '500px')" class="btn btn-success btn-xs" title="修改"><i class="fa fa-edit"></i><span class="hidden-xs">修改</span></a>
								</shiro:hasPermission>
								
								<shiro:hasPermission name="pay:payBankbookBalance:del">
									<a href="${ctx}/pay/payBankbookBalance/delete?id=${payBankbookBalance.id}" onclick="return confirmx('确认要删除该电子钱包余额吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i><span class="hidden-xs">删除</span></a> 
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