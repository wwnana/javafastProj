<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>调拨单列表</title>
	<meta name="decorator" content="default"/>

</head>
<body class="">
	<div class="">
		<div class="">
			<div class="row dashboard-header gray-bg">
				<div class="pull-left">			
					<a class="btn btn-link" href="${ctx}/wms/wmsAllot/list">全部</a>
					<a class="btn btn-link" href="${ctx}/wms/wmsAllot/list?ownBy.id=${fns:getUser().id}">我负责的</a>
					<a class="btn btn-link" href="${ctx}/wms/wmsAllot/list?ownBy.id=${fns:getUser().id}&status=2">我完成的</a>
					<a class="btn btn-link" href="${ctx}/wms/wmsAllot/list?beginDealDate=${fns:getDate('yyyy-MM-dd')}&endDealDate=${fns:getDayAfter(1)}">今日的</a>
					<a class="btn btn-link" href="${ctx}/wms/wmsAllot/list?beginDealDate=${fns:getDayAfter(-7)}&endDealDate=${fns:getDayAfter(1)}">7天内的</a>
					<a class="btn btn-link" href="${ctx}/wms/wmsAllot/list?beginDealDate=${fns:getDayAfter(-30)}&endDealDate=${fns:getDayAfter(1)}">30天内的</a>
				</div>
				<div class="pull-right">					
					<button id="searchBtn" class="btn btn-white btn-sm" title="搜索"><i class="fa fa-search"></i></button>
					<a class="btn btn-white btn-sm" href="${ctx}/crm/crmCustomer/list" title="刷新"><i class="fa fa-refresh"></i></a>
					
							<%-- 
							<shiro:hasPermission name="wms:wmsAllot:edit">
							    <table:editRow url="${ctx}/wms/wmsAllot/form" title="调拨单" id="contentTable" pageModel="page"></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="wms:wmsAllot:del">
								<table:delRow url="${ctx}/wms/wmsAllot/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="wms:wmsAllot:import">
								<table:importExcel url="${ctx}/wms/wmsAllot/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="wms:wmsAllot:export">
					       		<table:exportExcel url="${ctx}/wms/wmsAllot/export"></table:exportExcel><!-- 导出按钮 -->
					       	</shiro:hasPermission>
					       	--%>
					       	
					<shiro:hasPermission name="wms:wmsAllot:add">
						<a class="btn btn-success btn-sm" href="${ctx}/wms/wmsAllot/form" title="新建调拨单"><i class="fa fa-plus"></i> 新建调拨单</a>
					</shiro:hasPermission>
					
				</div>			
			</div>
			
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="wmsAllot" action="${ctx}/wms/wmsAllot/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 搜索栏隐藏 -->
								<div class="form-group"><span>单号：</span>
									<form:input path="no" htmlEscape="false" maxlength="30" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>审核状态：</span>
									<form:select path="status" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('audit_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>业务日期：</span>
									<div class="input-group date datepicker">
			                            <input name="beginDealDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${wmsAllot.beginDealDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
			                         - 
			                        <div class="input-group" data-autoclose="true">
			                        	 <input name="endDealDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${wmsAllot.endDealDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
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
							<th style="min-width:100px;width:100px;" class="sort-column a.no">单号</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.num">总数量</th>
							<th style="min-width:150px;width:150px;" class="sort-column ow.name">调出仓库</th>
							<th style="min-width:150px;width:150px;" class="sort-column iw.nae">调入出库</th>
							<th style="min-width:120px;width:120px;" class="sort-column a.logistics_company">物流公司</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.logistics_no">物流单号</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.logistics_amount">运费</th>
							<th style="min-width:100px;width:100px;" class="sort-column f.name">支付账户</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.status">审核状态</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.deal_by">经办人</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.deal_date">业务日期</th>
							<%-- 
							<th class="sort-column a.create_by">制单人</th>
							<th class="sort-column a.create_date">制单时间</th>
							<th class="sort-column a.audit_by">审核人</th>
							<th class="sort-column a.audit_date">审核时间</th>
							--%>
							<th style="min-width:150px;width:150px;">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="wmsAllot">
						<tr>
							<td><input type="checkbox" id="${wmsAllot.id}" class="i-checks"></td>
							<td>
								<a href="${ctx}/wms/wmsAllot/view?id=${wmsAllot.id}">
								${wmsAllot.no}
							</a></td>
							<td>
								${wmsAllot.num}
							</td>
							<td>
								${wmsAllot.outWarehouse.name}
							</td>
							<td>
								${wmsAllot.inWarehouse.name}
							</td>
							<td>
								${wmsAllot.logisticsCompany}
							</td>
							<td>
								${wmsAllot.logisticsNo}
							</td>
							<td>
								${wmsAllot.logisticsAmount}
							</td>
							<td>
								${wmsAllot.fiAccount.name}
							</td>
							<td>
								<span class="<c:if test='${wmsAllot.status == 0}'>text-danger</c:if>">
									${fns:getDictLabel(wmsAllot.status, 'audit_status', '')}
								</span>
							</td>
							<td>
								${wmsAllot.dealBy.name}
							</td>
							<td>
								<fmt:formatDate value="${wmsAllot.dealDate}" pattern="yyyy-MM-dd"/>
							</td>
							<%-- 
							<td>
								${wmsAllot.createBy.name}
							</td>
							<td>
								<fmt:formatDate value="${wmsAllot.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<td>
								${wmsAllot.auditBy.name}
							</td>
							<td>
								<fmt:formatDate value="${wmsAllot.auditDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							--%>
							<td>
								<shiro:hasPermission name="wms:wmsAllot:view">
									<a href="${ctx}/wms/wmsAllot/view?id=${wmsAllot.id}" class="" title="查看">查看</a>
								</shiro:hasPermission>
								<c:if test="${wmsAllot.status == 0}">
								<shiro:hasPermission name="wms:wmsAllot:edit">
			    					<a href="${ctx}/wms/wmsAllot/form?id=${wmsAllot.id}" class="" title="修改"><span class="hidden-xs">修改</span></a>
								</shiro:hasPermission>
								
								<shiro:hasPermission name="wms:wmsAllot:audit">
									<a href="${ctx}/wms/wmsAllot/audit?id=${wmsAllot.id}" onclick="return confirmx('确认要审核该调拨单吗？', this.href)" class="" title="审核"><span class="hidden-xs">审核</span></a> 
								</shiro:hasPermission>
								
								<shiro:hasPermission name="wms:wmsAllot:del">
									<a href="${ctx}/wms/wmsAllot/delete?id=${wmsAllot.id}" onclick="return confirmx('确认要删除该调拨单吗？', this.href)" class="" title="删除"><span class="hidden-xs">删除</span></a> 
								</shiro:hasPermission>
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