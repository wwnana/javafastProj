<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>模板列表</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	</script>
</head>
<body class="gray-bg">
	<div class="wrapper-content">
		<div class="ibox">
			<div class="ibox-title">
				<h5>模板列表 </h5>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>				
				<!-- 查询栏 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="hrTemplate" action="${ctx}/hr/hrTemplate/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 查询栏隐藏 -->
								
						</form:form>
					</div>
				</div>
				<!-- 工具栏 -->
				<div class="row">
					<div class="col-sm-12 m-b-sm">
						
						<div class="pull-left">
							<shiro:hasPermission name="hr:hrResume:add">
								<table:addRow url="${ctx}/hr/hrTemplate/form" title="模板" pageModel="page"></table:addRow><!-- 增加按钮 -->
							</shiro:hasPermission>
							<%-- 
							<shiro:hasPermission name="hr:hrResume:edit">
							    <table:editRow url="${ctx}/hr/hrTemplate/form" title="模板" id="contentTable" pageModel="page"></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="hr:hrResume:del">
								<table:delRow url="${ctx}/hr/hrTemplate/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="hr:hrResume:import">
								<table:importExcel url="${ctx}/hr/hrTemplate/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="hr:hrResume:export">
					       		<table:exportExcel url="${ctx}/hr/hrTemplate/export"></table:exportExcel><!-- 导出按钮 -->
					       	</shiro:hasPermission>
					       	--%>
						</div>
					</div>
				</div>					
				<!-- 数据表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<%--<th><input type="checkbox" class="i-checks"></th>--%>
							<th class="sort-column a.type">模板分类</th>
							<th class="sort-column a.name">模板名称</th>
							<th class="sort-column a.title">标题</th>
							<th class="sort-column a.is_default">是否默认</th>
							<%--<th>操作</th>--%>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="hrTemplate">
						<tr>
							<%--<td><input type="checkbox" id="${hrTemplate.id}" class="i-checks"></td>--%>
							<td>
								<a href="${ctx}/hr/hrTemplate/form?id=${hrTemplate.id}" title="查看">
								${fns:getDictLabel(hrTemplate.type, 'hr_template_type', '')}
							</a></td>
							<td>
								${hrTemplate.name}
							</td>
							<td>
								${hrTemplate.title}
							</td>
							<td>
								${fns:getDictLabel(hrTemplate.isDefault, 'yes_no', '')}
							</td>
							<%-- 
							<td>
								<shiro:hasPermission name="hr:hrResume:view">
									<a href="${ctx}/hr/hrTemplate/view?id=${hrTemplate.id}" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
								</shiro:hasPermission>
								<shiro:hasPermission name="hr:hrResume:edit">
			    					<a href="${ctx}/hr/hrTemplate/form?id=${hrTemplate.id}" class="btn btn-success btn-xs" title="修改"><i class="fa fa-pencil"></i> 修改</a>
								</shiro:hasPermission>
								
								<shiro:hasPermission name="hr:hrResume:del">
									<a href="${ctx}/hr/hrTemplate/delete?id=${hrTemplate.id}" onclick="return confirmx('确认要删除该模板吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i> 删除</a> 
								</shiro:hasPermission>
							</td>
							--%>
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