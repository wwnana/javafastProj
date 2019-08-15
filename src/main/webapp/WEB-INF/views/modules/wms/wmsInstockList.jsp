<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>入库单管理</title>
	<meta name="decorator" content="default"/>

</head>
<body class="">
<div class="">
		<div class="">
			<div class="row dashboard-header gray-bg">
				<div class="pull-left">				
					<a class="btn btn-link" href="${ctx}/wms/wmsInstock/list">全部</a>
					<a class="btn btn-link" href="${ctx}/wms/wmsInstock/list?ownBy.id=${fns:getUser().id}">我负责的</a>
					<a class="btn btn-link" href="${ctx}/wms/wmsInstock/list?ownBy.id=${fns:getUser().id}&status=2">我完成的</a>
					<a class="btn btn-link" href="${ctx}/wms/wmsInstock/list?beginDealDate=${fns:getDate('yyyy-MM-dd')}&endDealDate=${fns:getDayAfter(1)}">今日的</a>
					<a class="btn btn-link" href="${ctx}/wms/wmsInstock/list?beginDealDate=${fns:getDayAfter(-7)}&endDealDate=${fns:getDayAfter(1)}">7天内的</a>
					<a class="btn btn-link" href="${ctx}/wms/wmsInstock/list?beginDealDate=${fns:getDayAfter(-30)}&endDealDate=${fns:getDayAfter(1)}">30天内的</a>
				</div>
				<div class="pull-right">					
					<button id="searchBtn" class="btn btn-white btn-sm" title="搜索"><i class="fa fa-search"></i></button>
					<a class="btn btn-white btn-sm" href="${ctx}/crm/crmCustomer/list" title="刷新"><i class="fa fa-refresh"></i></a>
					<%--
							<shiro:hasPermission name="wms:wmsInstock:add">
								<table:addRow url="${ctx}/wms/wmsInstock/form" title="入库单" width="1000px" height="80%"></table:addRow><!-- 增加按钮 -->
							</shiro:hasPermission>
							
							<shiro:hasPermission name="wms:wmsInstock:edit">
							    <table:editRow url="${ctx}/wms/wmsInstock/form" title="入库单" id="contentTable" width="1000px" height="80%"></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							 
							<shiro:hasPermission name="wms:wmsInstock:del">
								<table:delRow url="${ctx}/wms/wmsInstock/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							
							<shiro:hasPermission name="wms:wmsInstock:import">
								<table:importExcel url="${ctx}/wms/wmsInstock/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
							--%>
							<shiro:hasPermission name="wms:wmsInstock:export">
					       		<table:exportExcel url="${ctx}/wms/wmsInstock/export"></table:exportExcel><!-- 导出按钮 -->
					       	</shiro:hasPermission>
					
				</div>			
			</div>
			
			
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="wmsInstock" action="${ctx}/wms/wmsInstock/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 搜索栏隐藏 -->
								<div class="form-group"><span>入库类型：</span>
									<form:select path="instockType" class="form-control input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('instock_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>入库单号：</span>
									<form:input path="no" htmlEscape="false" maxlength="30" class="form-control input-small"/>
								</div>
								<div class="form-group"><span>关联采购单号：</span>
									<sys:tableselect id="purchase" name="purchase.id" value="${wmsInstock.purchase.id}" labelName="purchase.name" labelValue="${wmsInstock.purchase.name}" 
										title="采购单" url="${ctx}/wms/wmsPurchase/selectList" cssClass="form-control input-small" dataMsgRequired=""  allowClear="false" allowInput="false"/>
								</div>
								<div class="form-group"><span>入库仓库：</span>
									<sys:tableselect id="warehouse" name="warehouse.id" value="${wmsInstock.warehouse.id}" labelName="warehouse.name" labelValue="${wmsInstock.warehouse.name}" 
										title="供应商" url="${ctx}/wms/wmsWarehouse/selectList" cssClass="form-control input-small" dataMsgRequired=""  allowClear="false" allowInput="false"/>
								</div>
								<div class="form-group"><span>审核状态：</span>
									<form:select path="status" class="form-control input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('audit_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>经办人：</span>
									<sys:treeselect id="dealBy" name="dealBy.id" value="${wmsInstock.dealBy.id}" labelName="dealBy.name" labelValue="${wmsInstock.dealBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>业务日期：</span>
									<div class="input-group date datepicker">
			                            <input name="beginDealDate" type="text" readonly="readonly" class="form-control input-xmini" value="<fmt:formatDate value="${wmsInstock.beginDealDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
			                         - 
			                        <div class="input-group" data-autoclose="true">
			                        	 <input name="endDealDate" type="text" readonly="readonly" class="form-control input-xmini" value="<fmt:formatDate value="${wmsInstock.endDealDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
								</div>
								<%-- 
								<div class="form-group"><span>制单人：</span>
									<sys:treeselect id="createBy" name="createBy.id" value="${wmsInstock.createBy.id}" labelName="createBy.name" labelValue="${wmsInstock.createBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-medium" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>制单时间：</span>
									<input name="beginCreateDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${wmsInstock.beginCreateDate}" pattern="yyyy-MM-dd"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/> - 
									<input name="endCreateDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${wmsInstock.endCreateDate}" pattern="yyyy-MM-dd"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
								</div>
								<div class="form-group"><span>审核人：</span>
									<form:input path="auditBy.id" htmlEscape="false" maxlength="30" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>审核时间：</span>
									<input name="auditDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${wmsInstock.auditDate}" pattern="yyyy-MM-dd"/>"
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
							<th style="min-width:100px;width:100px;" class="sort-column no">入库单号</th>
							<th style="min-width:100px;width:100px;" class="sort-column instock_type">入库类型</th>
							<th style="min-width:120px;width:120px;" class="sort-column p.no">关联采购单号</th>
							<th style="min-width:100px;width:100px;" class="sort-column num">总数量</th>
							<th style="min-width:100px;width:100px;" class="sort-column real_num">已入库数量</th>
							<th style="min-width:100px;width:100px;">剩余数量</th>
							<th style="min-width:120px;width:120px;" class="sort-column w.name">入库仓库</th>
							<th style="min-width:100px;width:100px;" class="sort-column status">审核状态</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.deal_by">经办人</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.deal_date">业务日期</th>
							<%-- 
							<th style="min-width:100px;width:100px;" class="sort-column create_by">制单人</th>
							<th style="min-width:100px;width:100px;" class="sort-column create_date">制单时间</th>
							<th style="min-width:100px;width:100px;" class="sort-column audit_by">审核人</th>
							<th style="min-width:100px;width:100px;" class="sort-column audit_date">审核时间</th>
							--%>
							<th style="min-width:150px;width:150px;">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="wmsInstock">
						<tr>
							<td><input type="checkbox" id="${wmsInstock.id}" class="i-checks"></td>
							<td><a href="${ctx}/wms/wmsInstock/view?id=${wmsInstock.id}">
								${wmsInstock.no}
							</a></td>
							<td>
								${fns:getDictLabel(wmsInstock.instockType, 'instock_type', '')}
							</td>
							<td>
								<a href="${ctx}/wms/wmsPurchase/view?id=${wmsInstock.purchase.id}">${wmsInstock.purchase.no}</a>
							</td>
							<td>
								${wmsInstock.num}
							</td>
							<td>
								${wmsInstock.realNum}
							</td>
							<td>
								${wmsInstock.num - wmsInstock.realNum}
							</td>
							<td>
								${wmsInstock.warehouse.name}
							</td>
							<td>
								<span class="<c:if test='${wmsInstock.status == 0}'>text-danger</c:if>">
									${fns:getDictLabel(wmsInstock.status, 'audit_status', '')}
								</span>
							</td>
							<td>
								${wmsInstock.dealBy.name}
							</td>
							<td>
								<fmt:formatDate value="${wmsInstock.dealDate}" pattern="yyyy-MM-dd"/>
							</td>
							<%-- 
							<td>
								${wmsInstock.createBy.name}
							</td>
							<td>
								<fmt:formatDate value="${wmsInstock.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<td>
								${wmsInstock.auditBy.name}
							</td>
							<td>
								<fmt:formatDate value="${wmsInstock.auditDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							--%>
							<td>
								<shiro:hasPermission name="wms:wmsInstock:view">
									<a href="${ctx}/wms/wmsInstock/view?id=${wmsInstock.id}" class="" title="查看">查看</a>
								</shiro:hasPermission>
								
								<c:if test="${wmsInstock.status == 0}">
								<shiro:hasPermission name="wms:wmsInstock:edit">
			    					<a href="${ctx}/wms/wmsInstock/form?id=${wmsInstock.id}" class="" title="入库"><span class="hidden-xs">入库</span></a>
								</shiro:hasPermission>	
									<c:if test="${wmsInstock.num == wmsInstock.realNum}">
										<shiro:hasPermission name="wms:wmsInstock:audit">	
											<a href="${ctx}/wms/wmsInstock/audit?id=${wmsInstock.id}" onclick="return confirmx('确认要审核该入库单吗？', this.href)" class="" title="审核"><span class="hidden-xs">审核</span></a>
										</shiro:hasPermission>
									</c:if>
								<%-- 
								<shiro:hasPermission name="wms:wmsInstock:del">		
									<a href="${ctx}/wms/wmsInstock/delete?id=${wmsInstock.id}" onclick="return confirmx('确认要删除该入库单吗？', this.href)" class="" title="删除"><span class="hidden-xs">删除</span></a> 
								</shiro:hasPermission>
								--%>
								</c:if>
							</td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
				</div>
				<table:page page="${page}"></table:page>
			</div>
		</div>
	</div>
</body>
</html>