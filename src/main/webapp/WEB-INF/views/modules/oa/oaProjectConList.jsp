<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>项目咨询流程表列表</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	</script>
</head>
<body class="">
	<div class="">
		<div class="">
			<div class="ibox-header">
				<h5>项目咨询流程表列表 </h5>
				<div class="pull-right">
					<button id="searchBtn" class="btn btn-default btn-sm" title="搜索"><i class="fa fa-search"></i> 搜索</button><!-- 搜索按钮 -->
					<shiro:hasPermission name="oa:oaProjectCon:add">
						<table:addRow url="${ctx}/oa/oaProjectCon/form" title="项目咨询流程表" pageModel="page"></table:addRow><!-- 增加按钮 -->
					</shiro:hasPermission>
					<shiro:hasPermission name="oa:oaProjectCon:edit">
					    <table:editRow url="${ctx}/oa/oaProjectCon/form" title="项目咨询流程表" id="contentTable" pageModel="page"></table:editRow><!-- 编辑按钮 -->
					</shiro:hasPermission>
					<shiro:hasPermission name="oa:oaProjectCon:del">
						<table:delRow url="${ctx}/oa/oaProjectCon/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
					</shiro:hasPermission>
					<shiro:hasPermission name="oa:oaProjectCon:import">
						<table:importExcel url="${ctx}/oa/oaProjectCon/import"></table:importExcel><!-- 导入按钮 -->
					</shiro:hasPermission>
					<shiro:hasPermission name="oa:oaProjectCon:export">
			       		<table:exportExcel url="${ctx}/oa/oaProjectCon/export"></table:exportExcel><!-- 导出按钮 -->
			       	</shiro:hasPermission>
				</div>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>				
				<!-- 查询栏 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="oaProjectCon" action="${ctx}/oa/oaProjectCon/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow>
								<div class="form-group">
									<button class="btn btn-white btn-sm " onclick="search()"><i class="fa fa-search"></i> 查询</button>
									<button class="btn btn-white btn-sm " onclick="resetSearch()"><i class="fa fa-refresh"></i> 重置</button>
								</div>
						</form:form>
					</div>
				</div>
							
				<!-- 数据表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<th width="30px"><input type="checkbox" class="i-checks"></th>
							<th class="sort-column a.project_id">项目名称</th>
							<th class="sort-column a.update_date">更新时间</th>
							<th class="sort-column a.remarks">备注信息</th>
							<th width="200px">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="oaProjectCon">
						<tr>
							<td><input type="checkbox" id="${oaProjectCon.id}" class="i-checks"></td>
							<td>${oaProjectCon.project.name}</td>
							<td>
								<a href="${ctx}/oa/oaProjectCon/view?id=${oaProjectCon.id}" title="查看">
								<fmt:formatDate value="${oaProjectCon.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</a></td>
							<td>
								${oaProjectCon.remarks}
							</td>
							<td>
								<shiro:hasPermission name="oa:oaProjectCon:view">
									<a href="${ctx}/oa/oaProjectCon/view?id=${oaProjectCon.id}" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
								</shiro:hasPermission>
								<shiro:hasPermission name="oa:oaProjectCon:edit">
			    					<a href="${ctx}/oa/oaProjectCon/form?id=${oaProjectCon.id}" class="btn btn-success btn-xs" title="修改"><i class="fa fa-pencil"></i> 修改</a>
								</shiro:hasPermission>
								
								<shiro:hasPermission name="oa:oaProjectCon:del">
									<a href="${ctx}/oa/oaProjectCon/delete?id=${oaProjectCon.id}" onclick="return confirmx('确认要删除该项目咨询流程表吗？', this.href)" class="btn btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i> 删除</a> 
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