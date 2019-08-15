<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>合同管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">

	</script>
</head>
<body class="">
	<div class="">
		<div class="">
			<div class="row dashboard-header gray-bg">
				<div class="pull-left">	
					<a class="btn btn-link" href="${ctx}/om/omContract/list">全部</a>
					<a class="btn btn-link" href="${ctx}/om/omContract/list?createBy.id=${fns:getUser().id}">我创建的</a>
					<a class="btn btn-link" href="${ctx}/om/omContract/list?ownBy.id=${fns:getUser().id}">我负责的</a>
					<a class="btn btn-link" href="${ctx}/om/omContract/list?status=0">待审核的</a>
					<a class="btn btn-link" href="${ctx}/om/omContract/list?dealDate=${fns:getDate('yyyy-MM-dd')}">今日签约</a>
					<a class="btn btn-link" href="${ctx}/om/omContract/list?beginDealDate=${fns:getDayAfter(-7)}&endDealDate=${fns:getDate('yyyy-MM-dd')}">7天内签约</a>
					<a class="btn btn-link" href="${ctx}/om/omContract/list?beginDealDate=${fns:getDayAfter(-30)}&endDealDate=${fns:getDate('yyyy-MM-dd')}">30天内签约</a>
					<%-- 
					<a class="btn btn-link" href="${ctx}/om/omContract/list?deliverDate=${fns:getDate('yyyy-MM-dd')}">今日交付</a>
					<a class="btn btn-link" href="${ctx}/om/omContract/list?deliverDate=${fns:getDayAfter(1)}">明天交付</a>
					<a class="btn btn-link" href="${ctx}/om/omContract/list?beginDeliverDate=${fns:getDate('yyyy-MM-dd')}&endDeliverDate=${fns:getDayAfter(7)}">7天内交付</a>
					<a class="btn btn-link" href="${ctx}/om/omContract/list?beginDeliverDate=${fns:getDate('yyyy-MM-dd')}&endDeliverDate=${fns:getDayAfter(30)}">30天内交付</a>
					--%>
					
				</div>
				<div class="pull-right">
					<div class="form-inline" style="padding-bottom: 0px;">					
						<div class="form-group">
                          	<form id="searchForm2" action="${ctx}/om/omContract/" method="post">
	                    	<div class="input-group">	
	                        	<input type="text" id="keywords" name="keywords" value="${omContract.keywords}"  class=" form-control input-sm" placeholder="搜索客户名称"/>
	                            <div class="input-group-btn">
	                                <button id="btnSubmit" type="submit" class="btn btn-sm btn-white">
	                                    	<i class="fa fa-search"></i>
	                                </button>
	                                <button id="searchBtn" type="button" class="btn btn-white btn-sm" title="筛选 "><i class="fa fa-angle-double-down"></i> 筛选</button>      
	                            </div>
	                        </div>
	                        </form>
                        </div>
                        <div class="form-group">
                        	<%-- 
							<shiro:hasPermission name="om:omContract:edit">
							    <table:editRow pageModel="page" url="${ctx}/om/omContract/form" title="合同" id="contentTable"></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							
							<shiro:hasPermission name="om:omContract:del">
								<table:delRow url="${ctx}/om/omContract/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							
							<shiro:hasPermission name="om:omContract:import">
								<table:importExcel url="${ctx}/om/omContract/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
							--%>
                        	<shiro:hasPermission name="om:omContract:add">
								<a class="btn btn-success btn-sm" href="${ctx}/om/omContract/form" title="新建合同订单"><i class="fa fa-plus"></i> 新建合同订单</a>
							</shiro:hasPermission>
							<div class="btn-group">
		                        <button data-toggle="dropdown" class="btn btn-white btn-sm dropdown-toggle" aria-expanded="false">更多 <span class="caret"></span>
		                        </button>
		                        <ul class="dropdown-menu">
		                            <li>
		                            	<shiro:hasPermission name="om:omContract:export">
								       		<table:exportExcel url="${ctx}/om/omContract/export"></table:exportExcel><!-- 导出按钮 -->
								       	</shiro:hasPermission>
		                            </li>
		                            
		                        </ul>
		                    </div>
		                    
                        </div>
                    </div>
				</div>	
			</div>
			
			
			
		<div class="ibox-content">
			<sys:message content="${message}"/>
			
	
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="omContract" action="${ctx}/om/omContract/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 搜索栏 -->
								<div class="form-group"><span>合同编号：</span>
									<form:input path="no" htmlEscape="false" maxlength="30" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>主题：</span>
									<form:input path="name" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>客户名称：</span>
									<form:input path="customer.name" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>签约日期：</span>
									<div class="input-group date datepicker">
			                            <input name="beginDealDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${omContract.beginDealDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
			                         - 
			                        <div class="input-group" data-autoclose="true">
			                        	 <input name="endDealDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${omContract.endDealDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
								</div>
								<div class="form-group"><span>负责人：</span>
									<sys:treeselect id="ownBy" name="ownBy.id" value="${omContract.ownBy.id}" labelName="ownBy.name" labelValue="${omContract.ownBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>状态：</span>
									<form:select path="status" class="form-control input-small" cssClass="input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('audit_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<%-- 
								<div class="form-group"><span>销售订单：</span>
									<form:input path="order.id" htmlEscape="false" maxlength="30" class="form-control input-small"/>
								</div>
								<div class="form-group"><span>合同订单：</span>
									<form:input path="quote.id" htmlEscape="false" maxlength="30" class="form-control input-small"/>
								</div>
								<div class="form-group"><span>商机：</span>
									<form:input path="chance.id" htmlEscape="false" maxlength="30" class="form-control input-small"/>
								</div>
								
								<div class="form-group"><span>签约日期：</span>
									<input name="beginDealDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-small"
										value="<fmt:formatDate value="${omContract.beginDealDate}" pattern="yyyy-MM-dd"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/> - 
									<input name="endDealDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-small"
										value="<fmt:formatDate value="${omContract.endDealDate}" pattern="yyyy-MM-dd"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
								</div>
								<div class="form-group"><span>交付时间：</span>
									<input name="beginDeliverDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-small"
										value="<fmt:formatDate value="${omContract.beginDeliverDate}" pattern="yyyy-MM-dd"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/> - 
									<input name="endDeliverDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-small"
										value="<fmt:formatDate value="${omContract.endDeliverDate}" pattern="yyyy-MM-dd"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
								</div>

								
								<div class="form-group"><span>创建者</span>
									<sys:treeselect id="createBy" name="createBy.id" value="${omContract.createBy.id}" labelName="createBy.name" labelValue="${omContract.createBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>创建时间</span>
									<div class="input-group date datepicker">
			                            <input name="beginCreateDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${omContract.beginCreateDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
			                         - 
			                        <div class="input-group" data-autoclose="true">
			                        	 <input name="endCreateDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${omContract.endCreateDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
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
							<th style="min-width:100px;width:100px;">合同编号</th>
							<%-- 
							<th class="sort-column order_id">销售订单</th>
							<th class="sort-column quote_id">报价单</th>
							<th class="sort-column chance_id">商机</th>
							--%>
							<th style="min-width:250px;">客户</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.amount">总金额</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.deal_date">签约日期</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.deliver_date">交付时间</th>
							
							
							<th style="min-width:100px;width:100px;" class="sort-column a.status">状态</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.own_by">负责人</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.create_date">创建时间</th>
							<th style="min-width:150px;width:150px;">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="omContract">
						<tr>
							<td><input type="checkbox" id="${omContract.id}" class="i-checks"></td>
							<td><a href="${ctx}/om/omContract/index?id=${omContract.id}">
								${omContract.no}
							</a></td>
							
							<td>
								<a href="${ctx}/crm/crmCustomer/index?id=${omContract.customer.id}" title="跟进">
									${fns:abbr(omContract.customer.name,50)}
								</a>
							</td>
							<%-- 
							<td>
								${omContract.order.id}
							</td>
							<td>
								${omContract.quote.id}
							</td>
							<td>
								${omContract.chance.id}
							</td>
							--%>
							<td>
								${omContract.amount}
							</td>
							<td>
								<fmt:formatDate value="${omContract.dealDate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								<fmt:formatDate value="${omContract.deliverDate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								<span class="<c:if test='${omContract.status == 0}'>text-danger</c:if>">
									${fns:getDictLabel(omContract.status, 'audit_status', '')}
								</span>
							</td>
							<td>
								${omContract.ownBy.name}
							</td>
							<td>
								<fmt:formatDate value="${omContract.createDate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								<shiro:hasPermission name="om:omContract:view">
									<a href="${ctx}/om/omContract/index?id=${omContract.id}" class="" title="查看">查看</a>
								</shiro:hasPermission>
								<c:if test="${omContract.status == 0}">
									<shiro:hasPermission name="om:omContract:edit">
				    					<a href="${ctx}/om/omContract/form?id=${omContract.id}" class="" title="修改">修改</a>
									</shiro:hasPermission>
									
									<shiro:hasPermission name="om:omContract:del">
										<a href="${ctx}/om/omContract/delete?id=${omContract.id}" onclick="return confirmx('确认要删除该合同吗？', this.href)" class="" title="删除">删除</a> 
									</shiro:hasPermission>
									
									<shiro:hasPermission name="om:omContract:audit">
										<a href="${ctx}/om/omContract/audit?id=${omContract.id}" onclick="return confirmx('确认要审核该合同吗？', this.href)" class="" title="审核">审核</a> 
									</shiro:hasPermission>
									
								</c:if>
								<c:if test="${omContract.status == 1}">
									<shiro:hasPermission name="om:omContract:revoke">
										<a href="${ctx}/om/omContract/revoke?id=${omContract.id}" onclick="return confirmx('撤销合同会自动删除关联的应收款和出库单，确认要撤销该合同吗？', this.href)" class="" title="撤销">撤销</a> 
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