<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>供应商管理</title>
	<meta name="decorator" content="default"/>

</head>
<body class="">
<div class="">
	<div class="">
			<div class="row dashboard-header gray-bg">
				<h5>供应商列表</h5>
				<div class="pull-right">					
					<button id="searchBtn" class="btn btn-white btn-sm" title="搜索"><i class="fa fa-search"></i></button>
					<a class="btn btn-white btn-sm" href="${ctx}/wms/wmsSupplier/list" title="刷新"><i class="fa fa-refresh"></i></a>
					
							
							<shiro:hasPermission name="wms:wmsSupplier:edit">
							    <table:editRow pageModel="" url="${ctx}/wms/wmsSupplier/form" title="供应商" id="contentTable"></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="wms:wmsSupplier:del">
								<table:delRow url="${ctx}/wms/wmsSupplier/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							<%--
							<shiro:hasPermission name="wms:wmsSupplier:import">
								<table:importExcel url="${ctx}/wms/wmsSupplier/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="wms:wmsSupplier:export">
					       		<table:exportExcel url="${ctx}/wms/wmsSupplier/export"></table:exportExcel><!-- 导出按钮 -->
					       	</shiro:hasPermission>
					       	 --%>
					       	 
					       	 
					       	 
					<shiro:hasPermission name="wms:wmsSupplier:add">
						<a class="btn btn-success btn-sm" href="${ctx}/wms/wmsSupplier/form?supplierType.id=${wmsSupplier.supplierType.id}&supplierType.name=${wmsSupplier.supplierType.name}" title="添加供应商"><i class="fa fa-plus"></i> 添加供应商</a>
					</shiro:hasPermission>
					
				</div>			
			</div>

           	<div class="ibox-content" id="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="wmsSupplier" action="${ctx}/wms/wmsSupplier/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 搜索栏隐藏 -->
								<div class="form-group"><span>编号：</span>
									<form:input path="no" htmlEscape="false" maxlength="30" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>名称：</span>
									<form:input path="name" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>联系电话：</span>
									<form:input path="phone" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>状态：</span>
									<form:select path="status" class="input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('use_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<%-- 
								<div class="form-group"><span>创建人：</span>
									<form:select path="createBy.id" class="input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>创建时间：</span>
									<input name="beginCreateDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${wmsSupplier.beginCreateDate}" pattern="yyyy-MM-dd"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/> - 
									<input name="endCreateDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${wmsSupplier.endCreateDate}" pattern="yyyy-MM-dd"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
								</div>
								--%>
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
							<th class="sort-column name">名称</th>
							<th class="sort-column t.name">供应商分类</th>
							<th width="100px" class="sort-column contact_name">联系人</th>
							<th width="150px" class="sort-column phone">联系电话</th>
							
							<th width="100px" class="sort-column status">状态</th>
							<%--
							<th width="100px" class="sort-column a.create_by">创建人</th>
							<th width="100px" class="sort-column a.create_date">创建时间</th>
							 --%>
							<th width="130px">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="wmsSupplier">
						<tr>
							<td><input type="checkbox" id="${wmsSupplier.id}" class="i-checks"></td>
							<td>
								<a href="#" onclick="openDialogView('查看供应商', '${ctx}/wms/wmsSupplier/view?id=${wmsSupplier.id}','800px', '500px')">${wmsSupplier.name}</a>
							</td>
							<td>
								${wmsSupplier.supplierType.name}
							</td>
							<td>
								${wmsSupplier.contactName}
							</td>
							<td>
								${wmsSupplier.phone}
							</td>
							
							<td>
								${fns:getDictLabel(wmsSupplier.status, 'use_status', '')}
							</td>
							<%-- 
							<td>
								${wmsSupplier.createBy.name}
							</td>
							<td>
								<fmt:formatDate value="${wmsSupplier.createDate}" pattern="yyyy-MM-dd"/>
							</td>
							--%>
							<td>
								<shiro:hasPermission name="wms:wmsSupplier:view">
									<a href="#" onclick="openDialogView('查看供应商', '${ctx}/wms/wmsSupplier/view?id=${wmsSupplier.id}','800px', '500px')" class="" title="查看">查看</a>
								</shiro:hasPermission>
								<shiro:hasPermission name="wms:wmsSupplier:edit">
			    					<a href="${ctx}/wms/wmsSupplier/form?id=${wmsSupplier.id}" title="修改">修改</a>
									<a href="${ctx}/wms/wmsSupplier/delete?id=${wmsSupplier.id}" onclick="return confirmx('确认要删除该供应商吗？', this.href)" class="" title="删除">删除</a> 
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