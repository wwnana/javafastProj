<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>采购单管理</title>
	<meta name="decorator" content="default"/>

</head>
<body class="gray-bg">
<div class="">
		<div class="">
			<div class="row dashboard-header gray-bg">
				<div class="pull-left">
					<a class="btn btn-link" href="${ctx}/wms/wmsPurchase/list">全部</a>
					<a class="btn btn-link" href="${ctx}/wms/wmsPurchase/list?createBy.id=${fns:getUser().id}">我创建的</a>
					<a class="btn btn-link" href="${ctx}/wms/wmsPurchase/list?ownBy.id=${fns:getUser().id}">我负责的</a>
					<a class="btn btn-link" href="${ctx}/wms/wmsPurchase/list?ownBy.id=${fns:getUser().id}&status=2">我完成的</a>
					<a class="btn btn-link" href="${ctx}/wms/wmsPurchase/list?beginDealDate=${fns:getDate('yyyy-MM-dd')}&endDealDate=${fns:getDayAfter(1)}">今日的</a>
					<a class="btn btn-link" href="${ctx}/wms/wmsPurchase/list?beginDealDate=${fns:getDayAfter(-7)}&endDealDate=${fns:getDayAfter(1)}">7天内的</a>
					<a class="btn btn-link" href="${ctx}/wms/wmsPurchase/list?beginDealDate=${fns:getDayAfter(-30)}&endDealDate=${fns:getDayAfter(1)}">30天内的</a>
				</div>
				<div class="pull-right">					
					<button id="searchBtn" class="btn btn-white btn-sm" title="搜索"><i class="fa fa-search"></i></button>
					<a class="btn btn-white btn-sm" href="${ctx}/wms/wmsPurchase/list" title="刷新"><i class="fa fa-refresh"></i></a>
					
					<%-- 
					<shiro:hasPermission name="wms:wmsPurchase:edit">
					    <table:editRow url="${ctx}/wms/wmsPurchase/form" title="采购单" id="contentTable" pageModel="page"></table:editRow><!-- 编辑按钮 -->
					</shiro:hasPermission>
					<shiro:hasPermission name="wms:wmsPurchase:del">
						<table:delRow url="${ctx}/wms/wmsPurchase/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
					</shiro:hasPermission>
					
					<shiro:hasPermission name="wms:wmsPurchase:import">
						<table:importExcel url="${ctx}/wms/wmsPurchase/import"></table:importExcel><!-- 导入按钮 -->
					</shiro:hasPermission>
					--%>
					<shiro:hasPermission name="wms:wmsPurchase:export">
			       		<table:exportExcel url="${ctx}/wms/wmsPurchase/export"></table:exportExcel><!-- 导出按钮 -->
			       	</shiro:hasPermission>
					<shiro:hasPermission name="wms:wmsPurchase:add">
						<a class="btn btn-success btn-sm" href="${ctx}/wms/wmsPurchase/form" title="新建采购单"><i class="fa fa-plus"></i> 新建采购单</a>
					</shiro:hasPermission>
					
				</div>			
			</div>

			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="wmsPurchase" action="${ctx}/wms/wmsPurchase/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 搜索栏隐藏 -->
								<div class="form-group"><span>单号：</span>
									<form:input path="no" htmlEscape="false" maxlength="30" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>供应商：</span>
									<form:input path="supplier.id" htmlEscape="false" maxlength="30" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>审核状态：</span>
									<form:select path="status" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('audit_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>经办人：</span>
									<sys:treeselect id="dealBy" name="dealBy.id" value="${wmsPurchase.dealBy.id}" labelName="dealBy.name" labelValue="${wmsPurchase.dealBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>业务日期：</span>
									<div class="input-group date datepicker">
			                            <input name="beginDealDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${wmsPurchase.beginDealDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
			                         - 
			                        <div class="input-group" data-autoclose="true">
			                        	 <input name="endDealDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${wmsPurchase.endDealDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
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
							<th width="150px" class="sort-column no">单号</th>
							<th>供应商</th>
							<th width="100px">总数量</th>
							<%-- 
							<th class="sort-column total_amt">合计</th>
							<th class="sort-column tax_amt">税额</th>
							<th class="sort-column other_amt">其他费用</th>
							--%>
							<th width="100px" class="sort-column amount">总金额</th>
							<th width="100px" class="sort-column status">审核状态</th>
							<th width="100px" class="sort-column deal_by">经办人</th>
							<th width="100px" class="sort-column deal_date">业务日期</th>
							<%-- 
							<th class="sort-column create_by">制单人</th>
							<th class="sort-column create_date">制单时间</th>
							<th class="sort-column audit_by">审核人</th>
							<th class="sort-column audit_date">审核时间</th>
							--%>
							<th width="150px">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="wmsPurchase">
						<tr>
							<td><input type="checkbox" id="${wmsPurchase.id}" class="i-checks"></td>
							<td><a href="${ctx}/wms/wmsPurchase/view?id=${wmsPurchase.id}">
								${wmsPurchase.no}
							</a></td>
							<td>
								${wmsPurchase.supplier.name}
							</td>
							
							<td>
								${wmsPurchase.num}
							</td>
							<%-- 
							<td>
								${wmsPurchase.totalAmt}
							</td>
							<td>
								${wmsPurchase.taxAmt}
							</td>
							<td>
								${wmsPurchase.otherAmt}
							</td>
							--%>
							<td>
								${wmsPurchase.amount}
							</td>
							
							<td>
								<span class="<c:if test='${wmsPurchase.status == 0}'>text-danger</c:if>">
									${fns:getDictLabel(wmsPurchase.status, 'audit_status', '')}
								</span>
							</td>
							<td>
								${wmsPurchase.dealBy.name}
							</td>
							<td>
								<fmt:formatDate value="${wmsPurchase.dealDate}" pattern="yyyy-MM-dd"/>
							</td>
							<%-- 
							<td>
								${wmsPurchase.createBy.name}
							</td>
							<td>
								<fmt:formatDate value="${wmsPurchase.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<td>
								${wmsPurchase.auditBy.name}
							</td>
							<td>
								<fmt:formatDate value="${wmsPurchase.auditDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							--%>
							<td>
								<%-- 
								<shiro:hasPermission name="wms:wmsPurchase:view">
									<a href="${ctx}/wms/wmsPurchase/view?id=${wmsPurchase.id}" class="" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
								</shiro:hasPermission>
								--%>
								<c:if test="${wmsPurchase.status == 0}">
								<shiro:hasPermission name="wms:wmsPurchase:edit">
			    					<a href="${ctx}/wms/wmsPurchase/form?id=${wmsPurchase.id}" class="" title="修改">修改</a>
								</shiro:hasPermission>
								
								<shiro:hasPermission name="wms:wmsPurchase:audit">
									<a href="${ctx}/wms/wmsPurchase/audit?id=${wmsPurchase.id}" onclick="return confirmx('确认要审核该采购单吗？', this.href)" class="" title="审核">审核</a> 
								</shiro:hasPermission>								
								
								<shiro:hasPermission name="wms:wmsPurchase:del">
									<a href="${ctx}/wms/wmsPurchase/delete?id=${wmsPurchase.id}" onclick="return confirmx('确认要删除该采购单吗？', this.href)" class="" title="删除">删除</a> 
								</shiro:hasPermission>
								</c:if>
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