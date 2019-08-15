<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>库存流水管理</title>
	<meta name="decorator" content="default"/>

</head>
<body class="">
<div class="">
		<div class="">
			<div class="row dashboard-header gray-bg">
				<h5>库存流水列表 </h5>
				<div class="pull-right">					
					<button id="searchBtn" class="btn btn-white btn-sm" title="搜索"><i class="fa fa-search"></i></button>
					<a class="btn btn-white btn-sm" href="${ctx}/crm/crmCustomer/list" title="刷新"><i class="fa fa-refresh"></i></a>
					<%-- 
							<shiro:hasPermission name="wms:wmsStockJournal:add">
								<table:addRow url="${ctx}/wms/wmsStockJournal/form" title="库存流水"></table:addRow><!-- 增加按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="wms:wmsStockJournal:edit">
							    <table:editRow url="${ctx}/wms/wmsStockJournal/form" title="库存流水" id="contentTable"></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="wms:wmsStockJournal:del">
								<table:delRow url="${ctx}/wms/wmsStockJournal/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
						
							<shiro:hasPermission name="wms:wmsStockJournal:import">
								<table:importExcel url="${ctx}/wms/wmsStockJournal/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
						--%>
							<shiro:hasPermission name="wms:wmsStockJournal:export">
					       		<table:exportExcel url="${ctx}/wms/wmsStockJournal/export"></table:exportExcel><!-- 导出按钮 -->
					       	</shiro:hasPermission>
					
				</div>			
			</div>
			
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="wmsStockJournal" action="${ctx}/wms/wmsStockJournal/" method="post" class="form-inline">
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
								<div class="form-group"><span>操作类型：</span>
									<form:select path="dealType" class="input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('deal_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>仓库：</span>
									<sys:tableselect id="warehouse" name="warehouse.id" value="${wmsStockJournal.warehouse.id}" labelName="warehouse.name" labelValue="${wmsStockJournal.warehouse.name}" 
										title="仓库" url="${ctx}/wms/wmsWarehouse/selectList" cssClass="form-control input-small" dataMsgRequired=""  allowClear="false" allowInput="false"/>
								</div>
								<div class="form-group"><span>操作人：</span>
									<sys:treeselect id="createBy" name="createBy.id" value="${wmsStockJournal.createBy.id}" labelName="createBy.name" labelValue="${wmsStockJournal.createBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>操作日期：</span>
									<div class="input-group date datepicker">
			                            <input name="beginCreateDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${wmsStockJournal.beginCreateDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
			                         - 
			                        <div class="input-group" data-autoclose="true">
			                        	 <input name="endCreateDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${wmsStockJournal.endCreateDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>			                        
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
							<th style="min-width:100px;width:100px;" class="sort-column p.no">产品编号</th>
							<th style="min-width:200px;" class="sort-column p.name">产品名称</th>
							<th style="min-width:100px;width:100px;" class="sort-column p.unit_type">单位</th>
							<th style="min-width:100px;width:100px;" class="sort-column deal_type">操作类型</th>
							<th style="min-width:100px;width:100px;" class="sort-column num">数量</th>
							<th style="min-width:100px;width:100px;" class="sort-column notes">摘要</th>
							<th style="min-width:150px;width:150px;" class="sort-column w.name">仓库</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.create_by">操作人</th>
							<th style="min-width:150px;width:150px;" class="sort-column a.create_date">操作日期</th>
							<th style="min-width:100px;width:100px;">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="wmsStockJournal">
						<tr>
							<td><input type="checkbox" id="${wmsStockJournal.id}" class="i-checks"></td>
							<td>
								<a href="#" onclick="openDialogView('查看库存流水', '${ctx}/wms/wmsStockJournal/view?id=${wmsStockJournal.id}','800px', '500px')">
								${wmsStockJournal.product.no}
							</a></td>
							<td>
								${wmsStockJournal.product.name}
							</td>
							<td>
								${fns:getDictLabel(wmsStockJournal.product.unitType, 'unit_type', '')}
							</td>
							<td>
								${fns:getDictLabel(wmsStockJournal.dealType, 'deal_type', '')}
							</td>
							<td>
								${wmsStockJournal.num}
							</td>
							<td>
								${wmsStockJournal.notes}
							</td>
							<td>
								${wmsStockJournal.warehouse.name}
							</td>
							<td>
								${wmsStockJournal.createBy.name}
							</td>
							<td>
								<fmt:formatDate value="${wmsStockJournal.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<td>
								<shiro:hasPermission name="wms:wmsStockJournal:view">
									<a href="#" onclick="openDialogView('查看库存流水', '${ctx}/wms/wmsStockJournal/view?id=${wmsStockJournal.id}','800px', '500px')" class="" title="查看">查看</a>
								</shiro:hasPermission>
								<%-- 
								<shiro:hasPermission name="wms:wmsStockJournal:edit">
			    					<a href="#" onclick="openDialog('修改库存流水', '${ctx}/wms/wmsStockJournal/form?id=${wmsStockJournal.id}','800px', '500px')" class="btn btn-success btn-xs" title="修改"><i class="fa fa-edit"></i>
										<span class="hidden-xs">修改</span></a>
									<a href="${ctx}/wms/wmsStockJournal/delete?id=${wmsStockJournal.id}" onclick="return confirmx('确认要删除该库存流水吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i>
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