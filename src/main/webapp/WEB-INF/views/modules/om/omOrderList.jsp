<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>销售订单管理</title>
	<meta name="decorator" content="default"/>

</head>
<body class="">
<div class="">
		<div class="">
			<div class="row dashboard-header gray-bg">
				<div class="pull-left">				
					<a class="btn btn-link" href="${ctx}/om/omOrder/list">全部</a>
					<a class="btn btn-link" href="${ctx}/om/omOrder/list?createBy.id=${fns:getUser().id}">我创建的</a>
					<a class="btn btn-link" href="${ctx}/om/omOrder/list?ownBy.id=${fns:getUser().id}">我负责的</a>
					<a class="btn btn-link" href="${ctx}/om/omOrder/list?ownBy.id=${fns:getUser().id}&status=2">我完成的</a>
					<a class="btn btn-link" href="${ctx}/om/omOrder/list?beginDealDate=${fns:getDate('yyyy-MM-dd')}&endDealDate=${fns:getDayAfter(1)}">今日的</a>
					<a class="btn btn-link" href="${ctx}/om/omOrder/list?beginDealDate=${fns:getDayAfter(-7)}&endDealDate=${fns:getDayAfter(1)}">7天内的</a>
					<a class="btn btn-link" href="${ctx}/om/omOrder/list?beginDealDate=${fns:getDayAfter(-30)}&endDealDate=${fns:getDayAfter(1)}">30天内的</a>
				</div>
				<div class="pull-right">					
					<button id="searchBtn" class="btn btn-white btn-sm" title="搜索"><i class="fa fa-search"></i></button>
					<a class="btn btn-white btn-sm" href="${ctx}/crm/crmCustomer/list" title="刷新"><i class="fa fa-refresh"></i></a>
					<%-- 
					<shiro:hasPermission name="om:omOrder:edit">
					    <table:editRow url="${ctx}/om/omOrder/form" title="订单" id="contentTable" pageModel="page"></table:editRow><!-- 编辑按钮 -->
					</shiro:hasPermission>
					
					<shiro:hasPermission name="om:omOrder:del">
						<table:delRow url="${ctx}/om/omOrder/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
					</shiro:hasPermission>
					
					<shiro:hasPermission name="om:omOrder:import">
						<table:importExcel url="${ctx}/om/omOrder/import"></table:importExcel><!-- 导入按钮 -->
					</shiro:hasPermission>
					--%>
					<shiro:hasPermission name="om:omOrder:export">
					       	<table:exportExcel url="${ctx}/om/omOrder/export"></table:exportExcel><!-- 导出按钮 -->
					</shiro:hasPermission>
					<shiro:hasPermission name="om:omOrder:add">
						<a class="btn btn-success btn-sm" href="${ctx}/om/omOrder/form" title="新建订单"><i class="fa fa-plus"></i> 新建订单</a>
					</shiro:hasPermission>
					
				</div>			
			</div>
			
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="omOrder" action="${ctx}/om/omOrder/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 搜索栏隐藏 -->
								<div class="form-group"><span>单号：</span>
									<form:input path="no" htmlEscape="false" maxlength="30" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>销售类型：</span>
									<form:select path="saleType" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('sale_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>客户名称：</span>
									<form:input path="customer.name" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>结算账户：</span>
									<sys:tableselect id="fiAccount" name="fiAccount.id" value="${omOrder.fiAccount.id}" labelName="fiAccount.name" labelValue="${omOrder.fiAccount.name}" 
										title="结算账户" url="${ctx}/fi/fiFinanceAccount/selectList" cssClass="form-control input-small" dataMsgRequired=""  allowClear="true" allowInput="false"/>
									
								</div>
								<div class="form-group"><span>审核状态：</span>
									<form:select path="status" class="form-control input-medium" cssClass="input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('audit_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>经办人：</span>
									<sys:treeselect id="dealBy" name="dealBy.id" value="${omOrder.dealBy.id}" labelName="dealBy.name" labelValue="${omOrder.dealBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>业务日期：</span>
									<div class="input-group date datepicker">
			                            <input name="beginDealDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${omOrder.beginDealDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
			                         - 
			                        <div class="input-group" data-autoclose="true">
			                        	 <input name="endDealDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${omOrder.endDealDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
								</div>
								<%-- 
								<div class="form-group"><span>制单人：</span>
									<sys:treeselect id="createBy" name="createBy.id" value="${omOrder.createBy.id}" labelName="createBy.name" labelValue="${omOrder.createBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-medium" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>制单时间：</span>
									<input name="beginCreateDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${omOrder.beginCreateDate}" pattern="yyyy-MM-dd"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/> - 
									<input name="endCreateDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${omOrder.endCreateDate}" pattern="yyyy-MM-dd"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
								</div>
								<div class="form-group"><span>审核人：</span>
									<sys:treeselect id="auditBy" name="auditBy.id" value="${omOrder.auditBy.id}" labelName="auditBy.name" labelValue="${omOrder.auditBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-medium" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>审核时间：</span>
									<input name="beginAuditDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${omOrder.beginAuditDate}" pattern="yyyy-MM-dd"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/> - 
									<input name="endAuditDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${omOrder.endAuditDate}" pattern="yyyy-MM-dd"/>"
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
							<th style="min-width:100px;width:100px;" class="sort-column no">单号</th>
							<th style="min-width:100px;width:100px;" class="sort-column sale_type">销售类型</th>
							<th style="min-width:250px;" class="sort-column c.name">客户</th>
							
							<th style="min-width:100px;width:100px;" class="sort-column num">总数量</th>
							<%-- 
							<th style="min-width:100px;width:100px;" class="sort-column total_amt">合计</th>
							<th style="min-width:100px;width:100px;" class="sort-column other_amt">其他费用</th>
							--%>
							<th style="min-width:100px;width:100px;" class="sort-column amount">总计金额</th>
							<th style="min-width:200px;" class="sort-column f.name">结算账户</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.receive_amt">回款金额</th>
							<%-- <th style="min-width:100px;width:100px;" class="sort-column a.is_invoice">是否开票</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.invoice_amt">开票金额</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.profit_amt">毛利润</th>--%>
							<th style="min-width:100px;width:100px;" class="sort-column status">审核状态</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.deal_by">经办人</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.deal_date">业务日期</th>
							<%-- 
							<th style="min-width:100px;width:100px;" class="sort-column a.create_by">制单人</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.create_date">制单时间</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.audit_by">审核人</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.audit_date">审核时间</th>
							--%>
							<th style="min-width:100px;width:100px;">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="omOrder">
						<tr>
							<td><input type="checkbox" id="${omOrder.id}" class="i-checks"></td>
							<td><a href="${ctx}/om/omOrder/index?id=${omOrder.id}">
								${omOrder.no}
							</a></td>
							<td>
								${fns:getDictLabel(omOrder.saleType, 'sale_type', '')}
							</td>
							<td>
								${omOrder.customer.name}
							</td>
							
							<td>
								${omOrder.num}
							</td>
							<%--
							<td>
								${omOrder.totalAmt}
							</td>
							<td>
								${omOrder.otherAmt}
							</td>
							--%>
							<td>
								${omOrder.amount}
							</td>
							<td>
								${omOrder.fiAccount.name}
							</td>
							<td>
								${omOrder.receiveAmt}
							</td>
							<%-- 
							<td>
								${fns:getDictLabel(omOrder.isInvoice, 'yes_no', '')}
							</td>
							<td>
								${omOrder.invoiceAmt}
							</td>
							<td>
								${omOrder.profitAmt}
							</td>
							--%>
							<td>
								<span class="<c:if test='${omOrder.status == 0}'>text-danger</c:if>">
									${fns:getDictLabel(omOrder.status, 'audit_status', '')}
								</span>
							</td>
							<td>
								${omOrder.dealBy.name}
							</td>
							<td>
								<fmt:formatDate value="${omOrder.dealDate}" pattern="yyyy-MM-dd"/>
							</td>
							<%-- 
							<td>
								${omOrder.createBy.name}
							</td>
							<td>
								<fmt:formatDate value="${omOrder.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<td>
								${omOrder.auditBy.name}
							</td>
							<td>
								<fmt:formatDate value="${omOrder.auditDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							--%>
							<td>
								
								
								<c:if test="${omOrder.status == 0}">
								<shiro:hasPermission name="om:omOrder:edit">
			    					<a href="${ctx}/om/omOrder/form?id=${omOrder.id}" class="" title="修改">修改</a>
								</shiro:hasPermission>
								
								<shiro:hasPermission name="om:omOrder:del">
									<a href="${ctx}/om/omOrder/delete?id=${omOrder.id}" onclick="return confirmx('确认要删除该销售订单吗？', this.href)" class="" title="删除">删除</a> 
								</shiro:hasPermission>
								
								</c:if>
								<c:if test="${omOrder.status == 1}">
								<shiro:hasPermission name="om:omReturnorder:edit">
			    					<a href="${ctx}/om/omReturnorder/form?order.id=${omOrder.id}" class="" title="退货">退货</a>
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