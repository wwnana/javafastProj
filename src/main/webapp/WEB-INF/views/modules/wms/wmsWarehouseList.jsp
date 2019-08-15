<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>仓库管理</title>
	<meta name="decorator" content="default"/>

</head>
<body class="gray-bg">
	<div class="">
		<div class="">
			<div class="row dashboard-header gray-bg">
				<h5>仓库列表 </h5>
				<div class="pull-right">					
					<button id="searchBtn" class="btn btn-white btn-sm" title="搜索"><i class="fa fa-search"></i></button>
					<a class="btn btn-white btn-sm" href="${ctx}/oa/oaTask/list" title="刷新"><i class="fa fa-refresh"></i></a>
					
					<shiro:hasPermission name="wms:wmsWarehouse:add">
						<a class="btn btn-success btn-sm" href="#" onclick="openDialog('创建仓库', '${ctx}/wms/wmsWarehouse/form','800px', '500px')" title="创建仓库"><i class="fa fa-plus"></i> 创建仓库</a>
					</shiro:hasPermission>
					
				</div>			
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>	
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="wmsWarehouse" action="${ctx}/wms/wmsWarehouse/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 搜索栏隐藏 -->
								<div class="form-group"><span>仓库编号：</span>
									<form:input path="no" htmlEscape="false" maxlength="30" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>仓库名称：</span>
									<form:input path="name" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>是否默认：</span>
									<form:select path="isDefault" class="input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>状态：</span>
									<form:select path="status" class="input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('use_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
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
							<th width="100px" class="sort-column no">仓库编号</th>
							<th class="sort-column name">仓库名称</th>
							
							<th width="100px">联系人</th>
							<th width="100px">联系电话</th>
							<th>联系地址</th>
							<th width="100px" class="sort-column is_default">是否默认</th>
							<th width="100px" class="sort-column status">状态</th>
							
							<th width="100px">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="wmsWarehouse">
						<tr>
							<td><a href="#" onclick="openDialogView('查看仓库', '${ctx}/wms/wmsWarehouse/view?id=${wmsWarehouse.id}','800px', '500px')">
								${wmsWarehouse.no}
							</a></td>
							<td>
								${wmsWarehouse.name}
							</td>
							
							<td>
								${wmsWarehouse.contactName}
							</td>
							<td>
								${wmsWarehouse.phone}
							</td>
							<td>
								${wmsWarehouse.address}
							</td>
							<td>
								${fns:getDictLabel(wmsWarehouse.isDefault, 'yes_no', '')}
							</td>
							<td>
								${fns:getDictLabel(wmsWarehouse.status, 'use_status', '')}
							</td>
							
							<td>
								<shiro:hasPermission name="wms:wmsWarehouse:view">
									<a href="#" onclick="openDialogView('查看仓库', '${ctx}/wms/wmsWarehouse/view?id=${wmsWarehouse.id}','800px', '500px')" class="" title="查看">查看</a>
								</shiro:hasPermission>
								<shiro:hasPermission name="wms:wmsWarehouse:edit">
			    					<a href="#" onclick="openDialog('修改仓库', '${ctx}/wms/wmsWarehouse/form?id=${wmsWarehouse.id}','800px', '500px')" class="" title="修改">修改</a>
									
									<%-- 
									<a href="${ctx}/wms/wmsWarehouse/delete?id=${wmsWarehouse.id}" onclick="return confirmx('确认要删除该仓库吗？', this.href)" class="" title="删除">删除</a> 
									--%>
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