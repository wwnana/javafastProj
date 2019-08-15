<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>商机管理</title>
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
				<h5>商机列表 </h5>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				
				
				<!-- 工具栏 -->
				<div class="row">
					<div class="col-sm-12">
						<div class="pull-left">
							<shiro:hasPermission name="crm:crmChance:add">
								<a href="${ctx}/crm/crmChance/form?customer.id=${crmChance.customer.id}&customer.name=${crmChance.customer.name}" class="btn btn-white btn-sm" title="创建商机" target="_parent"><i class="fa fa-plus"></i> 创建商机</a>
							</shiro:hasPermission>
							<%-- 
							<shiro:hasPermission name="crm:crmChance:edit">
							    <table:editRow url="${ctx}/crm/crmChance/form" title="商机" id="contentTable"></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="crm:crmChance:del">
								<table:delRow url="${ctx}/crm/crmChance/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							
							<shiro:hasPermission name="crm:crmChance:import">
								<table:importExcel url="${ctx}/crm/crmChance/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
							
							<shiro:hasPermission name="crm:crmChance:export">
					       		<table:exportExcel url="${ctx}/crm/crmChance/export"></table:exportExcel><!-- 导出按钮 -->
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
							<%--<th><input type="checkbox" class="i-checks"></th> --%>
							<th>商机名称</th>
							<th>销售金额(元)</th>
							<th>销售阶段</th>
							<th>赢单率(%)</th>
							<%-- 
							<th class="sort-column change_type">商机类型</th>
							<th class="sort-column sour_type">商机来源</th>
							<th class="sort-column a.nextcontact_date">下次联系时间</th>
							<th class="sort-column a.nextcontact_note">联系内容</th>
							--%>
							<th>负责人</th>
							<th>创建者</th>
							<th>创建时间</th>
							<th width="150px">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${list}" var="crmChance">
						<tr>
							<%-- <td><input type="checkbox" id="${crmChance.id}" class="i-checks"></td>--%>
							<td>
								<a href="${ctx}/crm/crmChance/index?id=${crmChance.id}" target="_parent">
									${fns:abbr(crmChance.name,50)}
								</a>
							</td>
							
							<td>
								${crmChance.saleAmount}
							</td>
							<td>
								${fns:getDictLabel(crmChance.periodType, 'period_type', '')}
							</td>
							<td>
								${crmChance.probability}
							</td>
							<%-- 
								${fns:getDictLabel(crmChance.changeType, 'change_type', '')}
							</td>
							<td>
								${fns:getDictLabel(crmChance.sourType, 'sour_type', '')}
							</td>
							<td>
								<fmt:formatDate value="${crmChance.nextcontactDate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								${crmChance.nextcontactNote}
							</td>
							--%>
							<td>
								${crmChance.ownBy.name}
							</td>
							<td>
								${crmChance.createBy.name}
							</td>
							<td>
								<fmt:formatDate value="${crmChance.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<td>
								<shiro:hasPermission name="crm:crmChance:view">
									<a href="${ctx}/crm/crmChance/index?id=${crmChance.id}" class="btn btn-info btn-xs" title="查看" target="_parent"><i class="fa fa-search-plus"></i> </a>
								</shiro:hasPermission>
								<shiro:hasPermission name="crm:crmChance:edit">
			    					<a href="${ctx}/crm/crmChance/form?id=${crmChance.id}" class="btn btn-success btn-xs" title="修改" target="_parent"><i class="fa fa-edit"></i> </a>
								</shiro:hasPermission>
								<shiro:hasPermission name="crm:crmChance:del">
									<a href="${ctx}/crm/crmChance/indexDelete?id=${crmChance.id}" onclick="return confirmx('确认要删除该商机吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i></a> 
								</shiro:hasPermission>
								<shiro:hasPermission name="crm:crmQuote:edit">
				   					<a href="${ctx}/crm/crmQuote/form?chance.id=${crmChance.id}&chance.name=${crmChance.name}&customer.id=${crmChance.customer.id}&customer.name=${crmChance.customer.name}" class="btn btn-success btn-xs" title="创建报价单"><i class="fa fa-file-o"></i> </a>
								</shiro:hasPermission>
								<shiro:hasPermission name="om:omContract:add">
				   					<a href="${ctx}/om/omContract/form?chance.id=${crmChance.id}&chance.name=${crmChance.name}&customer.id=${crmChance.customer.id}&customer.name=${crmChance.customer.name}" class="btn btn-success btn-xs" title="创建合同订单"><i class="fa fa-file"></i> 
										</a>
								</shiro:hasPermission>
								
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