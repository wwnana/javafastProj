<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>客户标签列表</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
		});
		//0:隐藏tip, 1隐藏box,不设置显示全部
		top.$.jBox.closeTip();
	</script>
</head>
<body class="gray-bg">
	<div class="">
		<div class="">
			<div class="row dashboard-header gray-bg">
				<div class="pull-left">
					<h5>客户标签列表 </h5>
				</div>
				<div class="pull-right">
					
							
							<shiro:hasPermission name="crm:crmCustomer:edit">
							    <table:editRow url="${ctx}/crm/crmTag/form" title="客户标签" id="contentTable"  width="400px" height="200px"></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="crm:crmCustomer:del">
								<table:delRow url="${ctx}/crm/crmTag/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							<%-- 
							<shiro:hasPermission name="crm:crmCustomer:import">
								<table:importExcel url="${ctx}/crm/crmTag/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="crm:crmCustomer:export">
					       		<table:exportExcel url="${ctx}/crm/crmTag/export"></table:exportExcel><!-- 导出按钮 -->
					       	</shiro:hasPermission>
					       	--%>
					       <button class="btn btn-white btn-sm " data-toggle="tooltip" data-placement="left" onclick="sortOrRefresh()" title="刷新"><i class="glyphicon glyphicon-repeat"></i> 刷新</button>
					       <shiro:hasPermission name="crm:crmCustomer:add">
								<a class="btn btn-success btn-sm" onclick="openDialog('新建客户标签', '${ctx}/crm/crmTag/form','500px', '300px')" title="新建客户标签"><i class="fa fa-plus"></i> 新建客户标签</a>
							</shiro:hasPermission>
						
				</div>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="crmTag" action="${ctx}/crm/crmTag/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 搜索栏 -->
								<div class="form-group"><span>标签名称：</span>
									<form:input path="name" htmlEscape="false" maxlength="30" class="form-control input-medium"/>
								</div>
								<div class="form-group">
									<button class="btn btn-white btn-sm" onclick="search()"><i class="fa fa-search"></i> 查询</button>
									<button class="btn btn-white btn-sm" onclick="resetSearch()"><i class="fa fa-refresh"></i> 重置</button>
									
								</div>
						</form:form>
					</div>
				</div>
				
					
				<!-- 表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<th width="30px"><input type="checkbox" class="i-checks"></th>
							<th class="sort-column a.name">标签名称</th>
							<th width="130px">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="crmTag">
						<tr>
							<td><input type="checkbox" id="${crmTag.id}" class="i-checks"></td>
							<td>
								<a href="#" onclick="openDialogView('查看客户标签', '${ctx}/crm/crmTag/view?id=${crmTag.id}','500px', '300px')">
								${crmTag.name}
							</a></td>
							
							<td>
								
								<c:if test="${fns:getUser().id == crmTag.createBy.id}">
								<shiro:hasPermission name="crm:crmCustomer:edit">
			    					<a href="#" onclick="openDialog('修改客户标签', '${ctx}/crm/crmTag/form?id=${crmTag.id}','500px', '300px')" class="btn btn-success btn-xs" title="修改"><i class="fa fa-edit"></i><span class="hidden-xs">修改</span></a>
								</shiro:hasPermission>
								
								<shiro:hasPermission name="crm:crmCustomer:del">
									<a href="${ctx}/crm/crmTag/delete?id=${crmTag.id}" onclick="return confirmx('确认要删除该客户标签吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i><span class="hidden-xs">删除</span></a> 
								</shiro:hasPermission>
								</c:if>
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