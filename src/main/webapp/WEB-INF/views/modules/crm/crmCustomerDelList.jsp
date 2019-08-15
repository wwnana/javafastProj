<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>客户回收站</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		
	</script>
</head>
<body class="">
	<div class="">
		<div class="">
			<div class="row dashboard-header gray-bg">
				<h5>回收站客户列表 </h5> 
				<div class="pull-right">					
				</div>			
			</div>
			
		<div class="ibox-content">
			<sys:message content="${message}"/>
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						
					</div>
				</div>
				
				<!-- 工具栏 -->
				<div class="row m-b-sm">
					<div class="col-sm-12">
						<div class="pull-left">
							<table:batchRow url="${ctx}/crm/crmCustomer/replayAll" id="contentTable" title="批量还原客户" label="批量还原" icon="fa-check"></table:batchRow>
						</div>
						<div class="pull-right">					
							<form:form id="searchForm" modelAttribute="crmCustomer" action="${ctx}/crm/crmCustomer/delList" method="post" class="form-inline m-b-0">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
								<div class="form-group"><span>客户名称：</span>
									<form:input path="name" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								
								<div class="form-group">
									<button class="btn btn-white btn-sm " onclick="search()"><i class="fa fa-search"></i> 查询</button>
									<button class="btn btn-white btn-sm " onclick="resetSearch()"><i class="fa fa-refresh"></i> 重置</button>
								</div>
						</form:form>
						</div>
					</div>
				</div>
					
				<!-- 表格 -->
				<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed">
					<thead>
						<tr>
							<th width="30px"><input type="checkbox" class="i-checks"></th>
							<th>客户名称</th>							
							<th width="100px">客户状态</th>
							<th width="100px">客户级别</th>
							<th width="100px">客户行业</th>
							<th width="100px">客户来源</th>
							
							<th  width="100px" class="sort-column a.create_by">创建者</th>
							<th  width="100px" class="sort-column a.create_date">创建时间</th>
							<th width="120px">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="crmCustomer">
						<tr>
							<td><input type="checkbox" id="${crmCustomer.id}" class="i-checks"></td>
							<td><a  href="#" onclick="openDialogView('查看客户信息', '${ctx}/crm/crmCustomer/view?id=${crmCustomer.id}','1000px', '80%')">
								${fns:abbr(crmCustomer.name,50)}
							</a></td>
							
							<td>
								<span class="<c:if test='${crmCustomer.customerStatus == 1}'>text-success</c:if><c:if test='${crmCustomer.customerStatus == 2}'>text-info</c:if><c:if test='${crmCustomer.customerStatus == 3}'>text-danger</c:if>">
									${fns:getDictLabel(crmCustomer.customerStatus, 'customer_status', '')}
								</span>
							</td>
							<td>
								${fns:getDictLabel(crmCustomer.customerLevel, 'customer_level', '')}
							</td>
							<td>
								${fns:getDictLabel(crmCustomer.industryType, 'industry_type', '')}
							</td>
							<td>
								${fns:getDictLabel(crmCustomer.sourType, 'sour_type', '')}
							</td>
							<td>
								${crmCustomer.createBy.name}
							</td>
							<td>
								<fmt:formatDate value="${crmCustomer.createDate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								<shiro:hasPermission name="crm:crmCustomer:view">
									<a  href="#" onclick="openDialogView('查看客户信息', '${ctx}/crm/crmCustomer/view?id=${crmCustomer.id}','1000px', '80%')" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
								</shiro:hasPermission>
								<shiro:hasPermission name="crm:crmCustomer:edit">
			    					
									<a href="${ctx}/crm/crmCustomer/replay?id=${crmCustomer.id}" onclick="return confirmx('确认要还原该客户吗？', this.href)" class="btn  btn-danger btn-xs" title="还原"><i class="fa fa-trash"></i>
										<span class="hidden-xs">还原</span></a> 
								</shiro:hasPermission>
								
							</td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
				<table:page page="${page}"></table:page>
				<br/>
			</div>
		</div>
	</div>
</body>
</html>