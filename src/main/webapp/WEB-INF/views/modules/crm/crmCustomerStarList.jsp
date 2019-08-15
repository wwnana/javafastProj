<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>客户关注管理</title>
	<meta name="decorator" content="default"/>
	
</head>
<body class="">
	<div class="">
		<div class="">
			<div class="row dashboard-header gray-bg">
				<h5>我关注的客户 </h5>
				
			</div>
			
		<div class="ibox-content">
			<sys:message content="${message}"/>
			
			
				<!-- 查询条件 -->
				<div class="row m-b-sm">
					<div class="col-sm-12">
						<div class="pull-left">
							<table:batchRow url="${ctx}/crm/crmCustomerStar/deleteAll" id="contentTable" title="取消关注" label="取消关注" icon="fa-star-o"></table:batchRow>
						</div>
						<div class="pull-right">					
							<form:form id="searchForm" modelAttribute="crmCustomerStar" action="${ctx}/crm/crmCustomerStar/" method="post" class="form-inline m-b-0">
								<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
								<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
								<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
								<div class="form-group"><span>客户名称：</span>
									<form:input path="customer.name" htmlEscape="false" maxlength="30" class="form-control input-medium"/>
								</div>
								<div class="form-group">
									<button class="btn btn-white btn-sm" onclick="search()"><i class="fa fa-search"></i> 查询</button>
									<button class="btn btn-white btn-sm" onclick="resetSearch()"><i class="fa fa-refresh"></i> 重置</button>
								</div>
							</form:form>
						</div>			
					</div>
				</div>
				
				<!-- 表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<th width="30px"><input type="checkbox" class="i-checks"></th>
							<th>客户</th>
							<th width="100px" class="sort-column c.customer_status">客户状态</th>
							<th width="100px" class="sort-column c.customer_level">客户级别</th>
							<th width="100px">首要联系人</th>
							<th width="100px">联系手机</th>
							<th width="100px">下次联系</th>
							<th width="100px" class="sort-column a.create_date">关注日期</th>
							<th width="100px">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="crmCustomerStar">
						<tr>
							<td><input type="checkbox" id="${crmCustomerStar.id}" class="i-checks"></td>
							<td>
								<a href="${ctx}/crm/crmCustomer/index?id=${crmCustomerStar.customer.id}">
									${fns:abbr(crmCustomerStar.customer.name,50)}
								</a>
							</td>
							<td>
								<span class="<c:if test='${crmCustomerStar.customer.customerStatus == 1}'>text-success</c:if><c:if test='${crmCustomerStar.customer.customerStatus == 2}'>text-info</c:if><c:if test='${crmCustomerStar.customer.customerStatus == 3}'>text-danger</c:if>">
									${fns:getDictLabel(crmCustomerStar.customer.customerStatus, 'customer_status', '')}
								</span>
							</td>
							<td>
								${fns:getDictLabel(crmCustomerStar.customer.customerLevel, 'customer_level', '')}
							</td>
							<td>
								${crmCustomerStar.customer.contacterName}
							</td>
							<td>
								${crmCustomerStar.customer.mobile}
							</td>
							<td>
								<fmt:formatDate value="${crmCustomerStar.customer.nextcontactDate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								<fmt:formatDate value="${crmCustomerStar.createDate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								
								
								<a href="${ctx}/crm/crmCustomerStar/delete?id=${crmCustomerStar.id}" onclick="return confirmx('确认要取消关注该客户关注吗？', this.href)" class="" title="取消关注"><i class="fa fa-star-o text-danger"></i>
								<span class="hidden-xs"></span></a> 
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