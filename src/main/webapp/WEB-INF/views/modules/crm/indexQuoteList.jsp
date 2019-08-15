<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>报价单管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	function page(n,s){
		$("#pageNo").val(n);
		$("#pageSize").val(s);
		$("#searchForm").submit();
    	return false;
    }
	</script>
</head>
<body class="gray-bg">
<div class="">
		<div class="ibox">
			<div class="ibox-title">
				<h5>报价单列表 </h5>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 工具栏 -->
				<div class="row">
					<div class="col-sm-12">
						<div class="pull-left">
							
							<a href="${ctx}/crm/crmQuote/indexQuoteForm?customer.id=${crmQuote.customer.id}" class="btn btn-white btn-sm" title="添加报价单" target="_parent"><i class="fa fa-plus"></i> 添加报价单</a>
							<%-- 
							<shiro:hasPermission name="crm:crmQuote:edit">
							    <table:editRow pageModel="page" url="${ctx}/crm/crmQuote/form" title="报价单" id="contentTable"></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="crm:crmQuote:del">
								<table:delRow url="${ctx}/crm/crmQuote/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							
							<shiro:hasPermission name="crm:crmQuote:import">
								<table:importExcel url="${ctx}/crm/crmQuote/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
							
							<shiro:hasPermission name="crm:crmQuote:export">
					       		<table:exportExcel url="${ctx}/crm/crmQuote/export"></table:exportExcel><!-- 导出按钮 -->
					       	</shiro:hasPermission>
					       <button class="btn btn-white btn-sm " data-toggle="tooltip" data-placement="left" onclick="sortOrRefresh()" title="刷新"><i class="glyphicon glyphicon-repeat"></i> 刷新</button>
						--%>
						</div>
						<%-- 
						<div class="pull-right">
							<button  class="btn btn-success btn-rounded btn-outline btn-sm " onclick="search()" ><i class="fa fa-search"></i> 查询</button>
							<button  class="btn btn-success btn-rounded btn-outline btn-sm " onclick="resetSearch()" ><i class="fa fa-refresh"></i> 重置</button>
						</div>--%>
					</div>
				</div>
					
				<!-- 表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<%-- <th><input type="checkbox" class="i-checks"></th>--%>
							<th>单号</th>
							<th>联系人</th>
							<th>来源商机</th>
							<th>总金额</th>
							<th>报价日期</th>
							<th>有效期至</th>
							<th>状态</th>
							<th>负责人</th>
							<th>创建人</th>
							<th>创建时间</th>
							<th width="130px">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${list}" var="crmQuote">
						<tr>
							<%-- <td><input type="checkbox" id="${crmQuote.id}" class="i-checks"></td>--%>
							<td>
								<a href="${ctx}/crm/crmQuote/view?id=${crmQuote.id}" target="_parent">
									${crmQuote.no}
								</a>
							</td>
							<td>
								${crmQuote.contacter.name}
							</td>
							<td>
								${crmQuote.chance.name}
							</td>
							<td>
								${crmQuote.amount}
							</td>
							<td>
								<fmt:formatDate value="${crmQuote.startdate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								<fmt:formatDate value="${crmQuote.enddate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								${fns:getDictLabel(crmQuote.status, 'audit_status', '')}
							</td>
							<td>
								${crmQuote.ownBy.name}
							</td>
							<td>
								${crmQuote.createBy.name}
							</td>
							<td>
								<fmt:formatDate value="${crmQuote.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<td>
								<shiro:hasPermission name="crm:crmQuote:view">
									<a href="${ctx}/crm/crmQuote/view?id=${crmQuote.id}" class="btn btn-info btn-xs" title="查看" target="_parent"><i class="fa fa-search-plus"></i> </a>
								</shiro:hasPermission>
								<c:if test="${crmQuote.status == 0}">
								<shiro:hasPermission name="crm:crmQuote:edit">
			    					<a href="${ctx}/crm/crmQuote/indexQuoteForm?id=${crmQuote.id}" class="btn btn-success btn-xs" title="修改" target="_parent"><i class="fa fa-edit"></i> </a>
								</shiro:hasPermission>
								<shiro:hasPermission name="crm:crmQuote:del">
									<a href="${ctx}/crm/crmQuote/indexDelete?id=${crmQuote.id}" onclick="return confirmx('确认要删除该报价单吗？', this.href)" class="btn  btn-danger btn-xs" title="删除" target="_parent"><i class="fa fa-trash"></i> </a> 
								</shiro:hasPermission>
								<shiro:hasPermission name="crm:crmQuote:audit">
									<a href="${ctx}/crm/crmQuote/audit?id=${crmQuote.id}" onclick="return confirmx('确认要审核该报价单吗？', this.href)" class="btn  btn-success btn-xs" title="审核" target="_parent"><i class="fa fa-check"></i> </a> 
								</shiro:hasPermission>
								</c:if>
								<c:if test="${crmQuote.status == 1}">
								<shiro:hasPermission name="om:omContract:edit">
			    					<a href="${ctx}/om/omContract/quoteToForm?quote.id=${crmQuote.id}" class="btn btn-success btn-xs" title="生成订单" target="_parent"><i class="fa fa-file-text-o"></i> </a>
								</shiro:hasPermission>
								</c:if>
							</td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
				</div>
			</div>
		</div>
	</div>
</body>
</html>