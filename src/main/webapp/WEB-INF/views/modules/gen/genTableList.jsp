<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>业务表管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	
	</script>
</head>
<body class="gray-bg">
<div class="">
		<div class="">
			<div class="row dashboard-header gray-bg">
				<h5>业务表单列表 </h5>
				<div class="pull-right">					
					<button id="searchBtn" class="btn btn-white btn-sm" title="搜索"><i class="fa fa-search"></i> 搜索</button>
					<a class="btn btn-white btn-sm" href="${ctx}/gen/genTable/list" title="刷新"><i class="fa fa-refresh"></i> 刷新</a>
					<shiro:hasPermission name="crm:crmChance:edit">
					    <table:editRow url="${ctx}/gen/genTable/form" title="表单" id="contentTable" pageModel="page"></table:editRow><!-- 编辑按钮 -->
					</shiro:hasPermission>
					<shiro:hasPermission name="gen:genTable:del">
						<table:delRow url="${ctx}/gen/genTable/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
					</shiro:hasPermission>
					
					<shiro:hasPermission name="gen:genTable:edit">
						<a class="btn btn-success btn-sm" href="${ctx}/gen/genTable/form" title="创建商机"><i class="fa fa-plus"></i> 创建表单</a>
					</shiro:hasPermission>
				</div>			
			</div>
			 
    		<div class="ibox-content">
			<sys:message content="${message}" hideType="1"/>
	
			<!-- 查询条件 -->
			<div class="row">
				<div class="col-sm-12">
					<form:form id="searchForm" modelAttribute="genTable" action="${ctx}/gen/genTable/" method="post" class="form-inline">
						<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
						<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
						<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
						<table:searchRow></table:searchRow><!-- 搜索栏隐藏 -->
						<div class="form-group">
							<span>表名：</span><form:input path="nameLike" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
						</div>
						<div class="form-group">
							<span>说明：</span><form:input path="comments" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
						</div>
						<div class="form-group">
							<span>父表表名：</span><form:input path="parentTable" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
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
							<th class="sort-column name">表名</th>
							<th>说明</th>
							<th class="sort-column class_name">类名</th>
							<th class="sort-column parent_table">父表</th>
							<th width="100px">生成模板</th>
							<th>功能名称</th>
							<th width="90px">表单模型</th>
							<th width="200px">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="genTable">
						<tr>
							<td><input type="checkbox" id="${genTable.id}" class="i-checks"></td>
							<td><a href="${ctx}/gen/genTable/form?id=${genTable.id}">${genTable.name}</a></td>
							<td>${genTable.comments}</td>
							<td>${genTable.className}</td>
							<td title="点击查询子表"><a href="javascript:" onclick="$('#parentTable').val('${genTable.parentTable}');$('#searchForm').submit();">${genTable.parentTable}</a></td>
							<td>
								<c:if test="${genTable.category eq 'curd'}">单表</c:if>
								<c:if test="${genTable.category eq 'curd_many'}">一对多</c:if>
								<c:if test="${genTable.category eq 'treeTable'}">树结构</c:if>
								<c:if test="${genTable.category eq 'treeTableAndList'}">左树右表</c:if>
								<c:if test="${genTable.category eq 'dao'}">仅持久层</c:if>
								<c:if test="${genTable.category eq 'api'}">API接口</c:if>
							</td>
							<td>${genTable.functionNameSimple}</td>
							<td>${fns:getDictLabel(genTable.pageModel, 'page_model', '')}</td>
							<td>
							<shiro:hasPermission name="gen:genTable:edit">
								<a href="${ctx}/gen/genTable/form?id=${genTable.id}" class="" title="修改">修改</a>
								<a href="${ctx}/gen/genTable/delete?id=${genTable.id}" onclick="return confirmx('确认要删除该表单吗？', this.href)" class="" title="删除">删除</a> 
								<a href="${ctx}/gen/genTable/form?id=${genTable.id}" class="">生成代码</a>					
								
								<a href="#" onclick="openDialog('生成菜单', '${ctx}/gen/genTable/menuForm?genTableId=${genTable.id}','800px', '500px')" class="" >生成菜单</a>
							</shiro:hasPermission>
							</td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
				<!-- 分页代码 -->
				<table:page page="${page}"></table:page>
			</div>
		</div>
	</div>
</div>
</body>
</html>
