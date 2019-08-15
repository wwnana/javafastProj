<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>合同管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
		});
		//0:隐藏tip, 1隐藏box,不设置显示全部
		top.$.jBox.closeTip();
	</script>
</head>
<body class="gray-bg">
<div class="">
		<div class="ibox">
			<div class="ibox-title">
				<h5>合同列表 </h5>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 工具栏 -->
				<div class="row">
					<div class="col-sm-12">
						<div class="pull-left">
							<a href="${ctx}/om/omContract/indexContractForm?customer.id=${omContract.customer.id}" class="btn btn-white btn-sm"> <i class="fa fa-plus"></i> 添加合同订单</a>
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
							
							<shiro:hasPermission name="om:omContract:export">
					       		<table:exportExcel url="${ctx}/om/omContract/export"></table:exportExcel><!-- 导出按钮 -->
					       	</shiro:hasPermission>
					       <button class="btn btn-white btn-sm " data-toggle="tooltip" data-placement="left" onclick="sortOrRefresh()" title="刷新"><i class="glyphicon glyphicon-repeat"></i> 刷新</button>
						--%>
						</div>
						<%-- 
						<div class="pull-right">
							<button  class="btn btn-success btn-rounded btn-outline btn-sm " onclick="search()" ><i class="fa fa-search"></i> 查询</button>
							<button  class="btn btn-success btn-rounded btn-outline btn-sm " onclick="resetSearch()" ><i class="fa fa-refresh"></i> 重置</button>
						</div>
						--%>
					</div>
				</div>
					
				<!-- 表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-hover">
					<thead>
						<tr>
							<%-- <th><input type="checkbox" class="i-checks"></th>--%>
							<th>合同编号</th>
							<th>主题</th>
							<%-- 
							<th class="sort-column order_id">销售订单</th>
							<th class="sort-column quote_id">报价单</th>
							<th class="sort-column chance_id">商机</th>
							--%>
							<th>总金额</th>
							<th>签约日期</th>
							<th>交付时间</th>
							<th>生效时间</th>
							<th>到期时间</th>
							<th>销售负责人</th>
							<th>状态</th>
							<th>创建人</th>
							<th>创建时间</th>
							<th width="120px">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${list}" var="omContract">
						<tr>
							<%-- <td><input type="checkbox" id="${omContract.id}" class="i-checks"></td>--%>
							<td><a href="${ctx}/om/omContract/index?id=${omContract.id}">
								${omContract.no}
							</a></td>
							<td>
								${fns:abbr(omContract.name,50)}
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
								<fmt:formatDate value="${omContract.startDate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								<fmt:formatDate value="${omContract.endDate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								${omContract.ownBy.name}
							</td>
							<td>
								${fns:getDictLabel(omContract.status, 'audit_status', '')}
							</td>
							<td>
								${omContract.createBy.name}
							</td>
							<td>
								<fmt:formatDate value="${omContract.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<td>
								<shiro:hasPermission name="om:omContract:view">
									<a href="${ctx}/om/omContract/index?id=${omContract.id}" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> </a>
								</shiro:hasPermission>
								<c:if test="${omContract.status == 0}">
									<shiro:hasPermission name="om:omContract:edit">
				    					<a href="${ctx}/om/omContract/indexContractForm?id=${omContract.id}" class="btn btn-success btn-xs" title="修改"><i class="fa fa-edit"></i> </a>
									</shiro:hasPermission>
								
									<shiro:hasPermission name="om:omContract:del">
										<a href="${ctx}/om/omContract/indexDelete?id=${omContract.id}" onclick="return confirmx('确认要删除该合同吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i> </a> 
									</shiro:hasPermission>
									
									<shiro:hasPermission name="om:omContract:audit">
										<a href="${ctx}/om/omContract/audit?id=${omContract.id}" onclick="return confirmx('确认要审核该合同吗？', this.href)" class="btn  btn-success btn-xs" title="审核"><i class="fa fa-check"></i> </a> 
									</shiro:hasPermission>
								</c:if>
								<c:if test="${omContract.status == 1}">
								
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