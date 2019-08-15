<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>预定订单列表</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	</script>
</head>
<body class="">
	<div class="">
		<div class="">
			<div class="row dashboard-header gray-bg">
				<h5>预定订单列表 </h5>
				<div class="pull-right">
					<button id="searchBtn" class="btn btn-default btn-sm" title="搜索"><i class="fa fa-search"></i> 搜索</button><!-- 搜索按钮 -->
					<shiro:hasPermission name="pay:payBookOrder:add">
						<table:addRow url="${ctx}/pay/payBookOrder/form" title="预定订单" pageModel="page"></table:addRow><!-- 增加按钮 -->
					</shiro:hasPermission>
					<shiro:hasPermission name="pay:payBookOrder:edit">
					    <table:editRow url="${ctx}/pay/payBookOrder/form" title="预定订单" id="contentTable" pageModel="page"></table:editRow><!-- 编辑按钮 -->
					</shiro:hasPermission>
					<shiro:hasPermission name="pay:payBookOrder:del">
						<table:delRow url="${ctx}/pay/payBookOrder/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
					</shiro:hasPermission>
					<shiro:hasPermission name="pay:payBookOrder:import">
						<table:importExcel url="${ctx}/pay/payBookOrder/import"></table:importExcel><!-- 导入按钮 -->
					</shiro:hasPermission>
					<shiro:hasPermission name="pay:payBookOrder:export">
			       		<table:exportExcel url="${ctx}/pay/payBookOrder/export"></table:exportExcel><!-- 导出按钮 -->
			       	</shiro:hasPermission>
				</div>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>				
				<!-- 查询栏 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="payBookOrder" action="${ctx}/pay/payBookOrder/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow>
								<div class="form-group"><span>订单编号：</span>
									<form:input path="no" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>产品名称：</span>
									<form:input path="productId" htmlEscape="false" maxlength="30" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>手机号码：</span>
									<form:input path="mobile" htmlEscape="false" maxlength="30" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>姓名：</span>
									<form:input path="name" htmlEscape="false" maxlength="30" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>公司名称：</span>
									<form:input path="company" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>支付状态：</span>
									<form:select path="status" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('pay_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>支付类型：</span>
									<form:select path="payType" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('pay_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>创建时间：</span>
									<div class="input-group date datepicker">
				                     	<input name="beginCreateDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${payBookOrder.beginCreateDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
							         - 
							        <div class="input-group date datepicker">
				                     	<input name="endCreateDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${payBookOrder.endCreateDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
								</div>
								<div class="form-group">
									<button class="btn btn-white btn-sm " onclick="search()"><i class="fa fa-search"></i> 查询</button>
									<button class="btn btn-white btn-sm " onclick="resetSearch()"><i class="fa fa-refresh"></i> 重置</button>
								</div>
						</form:form>
					</div>
				</div>
							
				<!-- 数据表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<th width="30px"><input type="checkbox" class="i-checks"></th>
							<th class="sort-column a.no">订单编号</th>
							<th class="sort-column a.amount">订单金额</th>
							<th class="sort-column a.product_id">产品名称</th>
							<th class="sort-column a.mobile">手机号码</th>
							<th class="sort-column a.name">姓名</th>
							<th class="sort-column a.company">公司名称</th>
							<th class="sort-column a.scale_type">企业规模</th>
							<th class="sort-column a.email">电子邮箱</th>
							<th class="sort-column a.qq">QQ</th>
							<th class="sort-column a.notes">留言</th>
							<th class="sort-column a.status">支付状态</th>
							<th class="sort-column a.pay_type">支付类型</th>
							<th class="sort-column a.create_date">创建时间</th>
							<th width="200px">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="payBookOrder">
						<tr>
							<td><input type="checkbox" id="${payBookOrder.id}" class="i-checks"></td>
							<td>
								<a href="${ctx}/pay/payBookOrder/view?id=${payBookOrder.id}" title="查看">
								${payBookOrder.no}
							</a></td>
							<td>
								${payBookOrder.amount}
							</td>
							<td>
								<c:if test="${payBookOrder.productId == 0}">JavaFast企业标准版2.0</c:if>
								<c:if test="${payBookOrder.productId == 1}">JavaFast企业高级版2.0</c:if>
							</td>
							<td>
								${payBookOrder.mobile}
							</td>
							<td>
								${payBookOrder.name}
							</td>
							<td>
								${payBookOrder.company}
							</td>
							<td>
								${payBookOrder.scaleType}
							</td>
							<td>
								${payBookOrder.email}
							</td>
							<td>
								${payBookOrder.qq}
							</td>
							<td>
								${payBookOrder.notes}
							</td>
							<td>
								${fns:getDictLabel(payBookOrder.status, 'pay_status', '')}
							</td>
							<td>
								${fns:getDictLabel(payBookOrder.payType, 'pay_type', '')}
							</td>
							<td>
								<fmt:formatDate value="${payBookOrder.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<td>
								<shiro:hasPermission name="pay:payBookOrder:view">
									<a href="${ctx}/pay/payBookOrder/view?id=${payBookOrder.id}" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
								</shiro:hasPermission>
								<shiro:hasPermission name="pay:payBookOrder:edit">
			    					<a href="${ctx}/pay/payBookOrder/form?id=${payBookOrder.id}" class="btn btn-success btn-xs" title="修改"><i class="fa fa-pencil"></i> 修改</a>
								</shiro:hasPermission>
								
								<shiro:hasPermission name="pay:payBookOrder:del">
									<a href="${ctx}/pay/payBookOrder/delete?id=${payBookOrder.id}" onclick="return confirmx('确认要删除该预定订单吗？', this.href)" class="btn btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i> 删除</a> 
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