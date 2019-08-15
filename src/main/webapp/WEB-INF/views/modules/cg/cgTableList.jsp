<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>表单设计列表</title>
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
				<h5>表单设计列表 </h5>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="cgTable" action="${ctx}/cg/cgTable/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
								<div class="form-group"><span>表名称：</span>
									<form:input path="name" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>表描述：</span>
									<form:input path="comments" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>关联父表：</span>
									<form:input path="parentTable" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>同步数据库：</span>
									<form:select path="isSynch" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
						</form:form>
						<br>
					</div>
				</div>
				<!-- 工具栏 -->
				<div class="row">
					<div class="col-sm-12 m-b-sm">
						<div class="pull-left">
							<shiro:hasPermission name="cg:cgTable:add">
								<table:addRow url="${ctx}/cg/cgTable/form" title="创建表单" pageModel="page" label="创建表单"></table:addRow><!-- 增加按钮 -->
								<a href="${ctx}/cg/cgTable/importByDBForm" class="btn btn-white btn-sm " title="从数据库导入"><i class="fa fa-folder-open-o"></i> 从数据库导入表单</a>
							</shiro:hasPermission>
							<shiro:hasPermission name="cg:cgTable:edit">
							    <table:editRow url="${ctx}/cg/cgTable/form" title="表单设计" id="contentTable" pageModel="page"></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="cg:cgTable:del">
								<table:delRow url="${ctx}/cg/cgTable/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							<%-- 
							<shiro:hasPermission name="cg:cgTable:import">
								<table:importExcel url="${ctx}/cg/cgTable/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="cg:cgTable:export">
					       		<table:exportExcel url="${ctx}/cg/cgTable/export"></table:exportExcel><!-- 导出按钮 -->
					       	</shiro:hasPermission>
					       	--%>
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
							<th class="sort-column a.name">表名称</th>
							<th class="sort-column a.comments">表描述</th>
							<th class="sort-column a.class_name">实体类名称</th>
							<th class="sort-column a.parent_table">关联父表</th>
							<th class="sort-column a.parent_table_fk">关联父表外键</th>
							<th class="sort-column a.cg_category">模板分类</th>
							<th class="sort-column a.function_author">功能作者</th>
							<th class="sort-column a.page_model">页面模型</th>
							<th class="sort-column a.is_synch">同步数据库</th>
							<th class="sort-column a.create_date">创建时间</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="cgTable">
						<tr>
							<td><input type="checkbox" id="${cgTable.id}" class="i-checks"></td>
							<td>
								<a href="${ctx}/cg/cgTable/view?id=${cgTable.id}">
								${cgTable.name}
							</a></td>
							<td>
								${cgTable.comments}
							</td>
							<td>
								${cgTable.className}
							</td>
							<td>
								${cgTable.parentTable}
							</td>
							<td>
								${cgTable.parentTableFk}
							</td>
							<td>
								${cgTable.cgCategory}
							</td>
							<td>
								${cgTable.functionAuthor}
							</td>
							<td>
								${fns:getDictLabel(cgTable.pageModel, 'page_model', '')}
							</td>
							<td>
								${fns:getDictLabel(cgTable.isSynch, 'yes_no', '')}
							</td>
							<td>
								<fmt:formatDate value="${cgTable.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<td>
								<shiro:hasPermission name="cg:cgTable:view">
									<a href="${ctx}/cg/cgTable/view?id=${cgTable.id}" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
								</shiro:hasPermission>
								<shiro:hasPermission name="cg:cgTable:edit">
			    					<a href="${ctx}/cg/cgTable/form?id=${cgTable.id}" class="btn btn-success btn-xs" title="修改"><i class="fa fa-edit"></i><span class="hidden-xs">修改</span></a>
								</shiro:hasPermission>
								
								<shiro:hasPermission name="cg:cgTable:del">
									<a href="${ctx}/cg/cgTable/delete?id=${cgTable.id}" onclick="return confirmx('确认要删除该表单设计吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i><span class="hidden-xs">删除</span></a> 
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