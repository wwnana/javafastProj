<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>商品信息(单表)列表</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	</script>
</head>
<body class="">
	<div class="">
		<div class="">
			<div class="row dashboard-header gray-bg">
				<h5>商品信息(单表)列表 </h5>
				<div class="pull-right">
					<button id="searchBtn" class="btn btn-default btn-sm" title="搜索"><i class="fa fa-search"></i> 搜索</button>
					<shiro:hasPermission name="test:one:testOne:add">
						<table:addRow url="${ctx}/test/one/testOne/form" title="商品信息(单表)" pageModel="page"></table:addRow><!-- 增加按钮 -->
					</shiro:hasPermission>
					<shiro:hasPermission name="test:one:testOne:edit">
					    <table:editRow url="${ctx}/test/one/testOne/form" title="商品信息(单表)" id="contentTable" pageModel="page"></table:editRow><!-- 编辑按钮 -->
					</shiro:hasPermission>
					<shiro:hasPermission name="test:one:testOne:del">
						<table:delRow url="${ctx}/test/one/testOne/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
					</shiro:hasPermission>
					<shiro:hasPermission name="test:one:testOne:import">
						<table:importExcel url="${ctx}/test/one/testOne/import"></table:importExcel><!-- 导入按钮 -->
					</shiro:hasPermission>
					<shiro:hasPermission name="test:one:testOne:export">
			       		<table:exportExcel url="${ctx}/test/one/testOne/export"></table:exportExcel><!-- 导出按钮 -->
			       	</shiro:hasPermission>
				</div>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>				
				<!-- 查询栏 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="testOne" action="${ctx}/test/one/testOne/" method="post" class="form-inline">
						<form:hidden path="testTree.id"/>
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow>
								<div class="form-group"><span>商品编码：</span>
									<form:input path="no" htmlEscape="false" maxlength="30" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>商品名称：</span>
									<form:input path="name" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>状态：</span>
									<form:select path="status" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('use_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
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
							<th width="60px">缩略图</th>
							<th class="sort-column a.name">商品名称</th>
							<th width="120px" class="sort-column a.no">商品编码</th>
							<th width="120px" class="sort-column a.product_type_id">商品分类</th>
							<th width="80px" class="sort-column a.unit_type">单位</th>
							<th width="80px" class="sort-column a.spec">规格</th>
							<th width="80px" class="sort-column a.color">颜色</th>
							<th width="80px" class="sort-column a.size">尺寸</th>
							<th width="80px" class="sort-column a.status">状态</th>
							<th width="200px">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="testOne">
						<tr>
							<td><input type="checkbox" id="${testOne.id}" class="i-checks"></td>
							<td align="center">
								<img alt="" src="${testOne.productImg}" width="30px" height="30px">
							</td>
							<td>
								<a href="${ctx}/test/one/testOne/view?id=${testOne.id}" title="查看">${testOne.name}</a>
							</td>
							<td>
								${testOne.no}
							</td>
							<td>
								${testOne.testTree.name}
							</td>
							<td>
								${fns:getDictLabel(testOne.unitType, 'unit_type', '')}
							</td>
							<td>
								${testOne.spec}
							</td>
							<td>
								${testOne.color}
							</td>
							<td>
								${testOne.size}
							</td>
							<td>
								${fns:getDictLabel(testOne.status, 'use_status', '')}
							</td>
							<td>
								<shiro:hasPermission name="test:one:testOne:view">
									<a href="${ctx}/test/one/testOne/view?id=${testOne.id}" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
								</shiro:hasPermission>
								<shiro:hasPermission name="test:one:testOne:edit">
			    					<a href="${ctx}/test/one/testOne/form?id=${testOne.id}" class="btn btn-success btn-xs" title="修改"><i class="fa fa-pencil"></i> 修改</a>
								</shiro:hasPermission>
								
								<shiro:hasPermission name="test:one:testOne:del">
									<a href="${ctx}/test/one/testOne/delete?id=${testOne.id}" onclick="return confirmx('确认要删除该商品信息(单表)吗？', this.href)" class="btn btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i> 删除</a> 
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