<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>产品库存管理</title>
	<meta name="decorator" content="default"/>

</head>
<body class="gray-bg">
	<div class="">
		<div class="">
			<div class="row dashboard-header gray-bg">
				<h5>产品库存</h5>
				<div class="pull-right">					
					<button id="searchBtn" class="btn btn-white btn-sm" title="搜索"><i class="fa fa-search"></i></button>
					<a class="btn btn-white btn-sm" href="${ctx}/wms/wmsStock/" title="刷新"><i class="fa fa-refresh"></i></a>
					<shiro:hasPermission name="wms:wmsStock:export">
			       		<table:exportExcel url="${ctx}/wms/wmsStock/export"></table:exportExcel><!-- 导出按钮 -->
			       	</shiro:hasPermission>
					
				</div>			
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>	

				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="wmsStock" action="${ctx}/wms/wmsStock/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 搜索栏隐藏 -->
								<div class="form-group"><span>产品编号：</span>
									<form:input path="product.no" htmlEscape="false" maxlength="30" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>产品名称：</span>
									<form:input path="product.name" htmlEscape="false" maxlength="30" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>仓库：</span>
									<sys:tableselect id="warehouse" name="warehouse.id" value="${wmsStock.warehouse.id}" labelName="warehouse.name" labelValue="${wmsStock.warehouse.name}" 
										title="仓库" url="${ctx}/wms/wmsWarehouse/selectList" cssClass="form-control input-small" allowClear="false" allowInput="false"/>
						
								</div>
								<div class="form-group">
									<button class="btn btn-white btn-sm" onclick="search()"><i class="fa fa-search"></i> 查询</button>
									<button class="btn btn-white btn-sm" onclick="resetSearch()"><i class="fa fa-refresh"></i> 重置</button>
								</div>
						</form:form>
					</div>
				</div>
				<%-- 
				<!-- 工具栏 -->
				<div class="row">
					<div class="col-sm-12">
						<div class="pull-left">
						
							<shiro:hasPermission name="wms:wmsStock:add">
								<table:addRow url="${ctx}/wms/wmsStock/form" title="产品库存"></table:addRow><!-- 增加按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="wms:wmsStock:edit">
							    <table:editRow url="${ctx}/wms/wmsStock/form" title="产品库存" id="contentTable"></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="wms:wmsStock:del">
								<table:delRow url="${ctx}/wms/wmsStock/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="wms:wmsStock:import">
								<table:importExcel url="${ctx}/wms/wmsStock/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
						
							<shiro:hasPermission name="wms:wmsStock:export">
					       		<table:exportExcel url="${ctx}/wms/wmsStock/export"></table:exportExcel><!-- 导出按钮 -->
					       	</shiro:hasPermission>
					       <button class="btn btn-white btn-sm " data-toggle="tooltip" data-placement="left" onclick="sortOrRefresh()" title="刷新"><i class="glyphicon glyphicon-repeat"></i> 刷新</button>
						
						</div>
						<div class="pull-right">
							<div class="btn-group">
								<button id="searchBtn" class="btn btn-white btn-sm" title="搜索"><i class="fa fa-search"></i></button>
								<table:refreshRow></table:refreshRow>
							</div>
						</div>
					</div>
				</div>
				--%>	
				<!-- 表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<th width="50px"><input type="checkbox" class="i-checks"></th>
							<th width="150px" class="sort-column p.no">产品编号</th>
							<th class="sort-column p.name">产品名称</th>
							<th width="100px" class="sort-column p.unit_type">单位</th>
							<th class="sort-column warehouse_id">仓库</th>
							<th width="100px" class="sort-column stock_num">库存数</th>
							<th width="100px" class="sort-column warn_num">预警数</th>
							<th width="100px">状态</th>
							<th width="100px">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="wmsStock">
						<tr>
							<td><input type="checkbox" id="${wmsStock.id}" class="i-checks"></td>
							<td><a href="#" onclick="openDialogView('查看产品信息', '${ctx}/wms/wmsProduct/view?id=${wmsStock.product.id}','800px', '500px')">
								${wmsStock.product.no}
							</a></td>
							<td>
								${wmsStock.product.name}
							</td>
							<td>
								${fns:getDictLabel(wmsStock.product.unitType, 'unit_type', '')}
							</td>
							<td>
								${wmsStock.warehouse.name}
							</td>
							<td>
								${wmsStock.stockNum}
							</td>
							<td>
								${wmsStock.warnNum}
							</td>
							<td>
								<c:if test="${wmsStock.stockNum <= wmsStock.warnNum}">
									<button type="button" class="btn btn-danger btn-xs"><i class="fa fa-bell"></i> 库存不足</button>
								</c:if>
							</td>
							<td>
								
								<shiro:hasPermission name="wms:wmsStock:edit">
			    					<a href="#" onclick="openDialog('设置预警', '${ctx}/wms/wmsStock/warnForm?id=${wmsStock.id}','800px', '500px')" class="btn btn-success btn-xs" title="设置预警"><i class="fa fa-edit"></i>
										<span class="hidden-xs">设置预警</span></a>
								</shiro:hasPermission>
								<%-- 
								<shiro:hasPermission name="wms:wmsStock:del">
									<a href="${ctx}/wms/wmsStock/delete?id=${wmsStock.id}" onclick="return confirmx('确认要删除该产品库存吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i>
										<span class="hidden-xs">删除</span></a> 
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