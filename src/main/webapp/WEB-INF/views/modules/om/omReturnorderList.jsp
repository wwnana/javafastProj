<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>销售退单管理</title>
	<meta name="decorator" content="default"/>

</head>
<body class="">
<div class="">
		<div class="">
			<div class="row dashboard-header gray-bg">
				<div class="pull-left">
					<a class="btn btn-link" href="${ctx}/om/omReturnorder/list">全部</a>
					<a class="btn btn-link" href="${ctx}/om/omReturnorder/list?createBy.id=${fns:getUser().id}">我创建的</a>
					<a class="btn btn-link" href="${ctx}/om/omReturnorder/list?ownBy.id=${fns:getUser().id}">我负责的</a>
					<a class="btn btn-link" href="${ctx}/om/omReturnorder/list?ownBy.id=${fns:getUser().id}&status=2">我完成的</a>
					<a class="btn btn-link" href="${ctx}/om/omReturnorder/list?beginDealDate=${fns:getDate('yyyy-MM-dd')}&endDealDate=${fns:getDayAfter(1)}">今日的</a>
					<a class="btn btn-link" href="${ctx}/om/omReturnorder/list?beginDealDate=${fns:getDayAfter(-7)}&endDealDate=${fns:getDayAfter(1)}">7天内的</a>
					<a class="btn btn-link" href="${ctx}/om/omReturnorder/list?beginDealDate=${fns:getDayAfter(-30)}&endDealDate=${fns:getDayAfter(1)}">30天内的</a>
				</div>
				<div class="pull-right">					
					<button id="searchBtn" class="btn btn-white btn-sm" title="搜索"><i class="fa fa-search"></i></button>
					<a class="btn btn-white btn-sm" href="${ctx}/om/omReturnorder/list" title="刷新"><i class="fa fa-refresh"></i></a>
					
					<%-- 
					<shiro:hasPermission name="om:omReturnorder:edit">
					    <table:editRow url="${ctx}/om/omReturnorder/form" title="销售退单" id="contentTable" pageModel="page"></table:editRow><!-- 编辑按钮 -->
					</shiro:hasPermission>
					<shiro:hasPermission name="om:omReturnorder:del">
						<table:delRow url="${ctx}/om/omReturnorder/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
					</shiro:hasPermission>
					
					<shiro:hasPermission name="om:omReturnorder:import">
						<table:importExcel url="${ctx}/om/omReturnorder/import"></table:importExcel><!-- 导入按钮 -->
					</shiro:hasPermission>
					--%>
					<shiro:hasPermission name="om:omReturnorder:export">
			       		<table:exportExcel url="${ctx}/om/omReturnorder/export"></table:exportExcel><!-- 导出按钮 -->
			       	</shiro:hasPermission>
			       	<%-- 
					<shiro:hasPermission name="om:omReturnorder:add">
						<a class="btn btn-success btn-sm" href="${ctx}/om/omReturnorder/form" title="新建销售退单"><i class="fa fa-plus"></i> 新建销售退单</a>
					</shiro:hasPermission>
					--%>
				</div>			
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="omReturnorder" action="${ctx}/om/omReturnorder/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 搜索栏隐藏 -->
								<div class="form-group"><span>单号：</span>
									<form:input path="no" htmlEscape="false" maxlength="30" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>销售类型：</span>
									<form:select path="saleType" class="form-control input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('sale_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>客户名称：</span>
									<form:input path="customer.name" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>关联销售订单：</span>
									<sys:tableselect id="order" name="order.id" value="${omReturnorder.order.id}" labelName="order.name" labelValue="${omReturnorder.order.name}" 
										title="订单" url="${ctx}/om/omOrder/selectList" cssClass="form-control input-small" dataMsgRequired=""  allowClear="true" allowInput="false"/>
									
								</div>
								<div class="form-group"><span>入库仓库：</span>
									<sys:tableselect id="warehouse" name="warehouse.id" value="${omReturnorder.warehouse.id}" labelName="warehouse.name" labelValue="${omReturnorder.warehouse.name}" 
										title="入库仓库" url="${ctx}/wms/wmsWarehouse/selectList" cssClass="form-control input-small" dataMsgRequired=""  allowClear="false" allowInput="false"/>
								</div>
								<div class="form-group"><span>结算账户：</span>
									<sys:tableselect id="fiAccount" name="fiAccount.id" value="${omReturnorder.fiAccount.id}" labelName="fiAccount.name" labelValue="${omReturnorder.fiAccount.name}" 
										title="结算账户" url="${ctx}/fi/fiFinanceAccount/selectList" cssClass="form-control input-small" dataMsgRequired=""  allowClear="true" allowInput="false"/>
									
								</div>
								<div class="form-group"><span>审核状态：</span>
									<form:select path="status" class="form-control input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('audit_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>经办人：</span>
									<sys:treeselect id="dealBy" name="dealBy.id" value="${omReturnorder.dealBy.id}" labelName="dealBy.name" labelValue="${omReturnorder.dealBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>业务日期：</span>
									<div class="input-group date datepicker">
			                            <input name="beginDealDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${omReturnorder.beginDealDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
			                         - 
			                        <div class="input-group" data-autoclose="true">
			                        	 <input name="endDealDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${omReturnorder.endDealDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
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
							<th style="min-width:100px;width:100px;" class="sort-column a.sale_type">销售类型</th>
							<th style="min-width:200px;" class="sort-column c.id">客户</th>
							<th style="min-width:120px;width:120px;" class="sort-column o.no">关联销售订单</th>
							<th style="min-width:150px;width:150px;" class="sort-column w.name">入库仓库</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.num">数量</th>
							<%-- 
							<th style="min-width:100px;width:100px;" class="sort-column a.total_amt">合计</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.other_amt">其他费用</th>
							--%>
							<th style="min-width:100px;width:100px;" class="sort-column a.amount">总计金额</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.actual_amt">实退金额</th>
							<th style="min-width:200px;" class="sort-column f.name">结算账户</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.status">审核状态</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.deal_by">经办人</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.deal_date">业务日期</th>
							<th style="min-width:150px;width:150px;">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="omReturnorder">
						<tr>
							<td><input type="checkbox" id="${omReturnorder.id}" class="i-checks"></td>
							<td><a href="${ctx}/om/omReturnorder/view?id=${omReturnorder.id}">
								${omReturnorder.no}
							</a></td>
							<td>
								${fns:getDictLabel(omReturnorder.saleType, 'sale_type', '')}
							</td>
							<td>
								${omReturnorder.customer.name}
							</td>
							<td>
								${omReturnorder.order.no}
							</td>
							<td>
								${omReturnorder.warehouse.name}
							</td>
							
							<td>
								${omReturnorder.num}
							</td>
							<%--
							<td>
								${omReturnorder.totalAmt}
							</td>
							<td>
								${omReturnorder.otherAmt}
							</td>
							--%>
							<td>
								${omReturnorder.amount}
							</td>
							<td>
								${omReturnorder.actualAmt}
							</td>
							<td>
								${omReturnorder.fiAccount.name}
							</td>
							<td>
								${fns:getDictLabel(omReturnorder.status, 'audit_status', '')}
							</td>
							<td>
								${omReturnorder.dealBy.name}
							</td>
							<td>
								<fmt:formatDate value="${omReturnorder.dealDate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								<shiro:hasPermission name="om:omReturnorder:view">
									<a href="${ctx}/om/omReturnorder/view?id=${omReturnorder.id}" class="" title="查看">查看</a>
								</shiro:hasPermission>
								
								<c:if test="${omReturnorder.status == 0}">
									<shiro:hasPermission name="om:omReturnorder:edit">
				    					<a href="${ctx}/om/omReturnorder/form?id=${omReturnorder.id}" class="" title="修改">修改</a>
									</shiro:hasPermission>
									<shiro:hasPermission name="om:omReturnorder:del">
										<a href="${ctx}/om/omReturnorder/delete?id=${omReturnorder.id}" onclick="return confirmx('确认要删除该销售退单吗？', this.href)" class="" title="删除">删除</a> 
									</shiro:hasPermission>
									
									<shiro:hasPermission name="om:omReturnorder:audit">
										<a href="${ctx}/om/omReturnorder/audit?id=${omReturnorder.id}" onclick="return confirmx('确认要审核该销售退单吗？', this.href)" class="" title="审核">审核</a> 
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