<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>差旅单列表</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
		});
		//0:隐藏tip, 1隐藏box,不设置显示全部
		top.$.jBox.closeTip();
	</script>
</head>
<body class="gray-bg">
	<div class="wrapper-content">
		<div class="ibox">
			<div class="ibox-title">
				<h5>差旅单列表 </h5>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="oaCommonTravel" action="${ctx}/oa/oaCommonTravel/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
						</form:form>
						<br>
					</div>
				</div>
				<!-- 工具栏 -->
				<div class="row">
					<div class="col-sm-12">
						<div class="pull-left">
							<shiro:hasPermission name="oa:oaCommonTravel:add">
								<table:addRow url="${ctx}/oa/oaCommonTravel/form" title="差旅单" ></table:addRow><!-- 增加按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="oa:oaCommonTravel:edit">
							    <table:editRow url="${ctx}/oa/oaCommonTravel/form" title="差旅单" id="contentTable" ></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="oa:oaCommonTravel:del">
								<table:delRow url="${ctx}/oa/oaCommonTravel/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="oa:oaCommonTravel:import">
								<table:importExcel url="${ctx}/oa/oaCommonTravel/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="oa:oaCommonTravel:export">
					       		<table:exportExcel url="${ctx}/oa/oaCommonTravel/export"></table:exportExcel><!-- 导出按钮 -->
					       	</shiro:hasPermission>
					       <button class="btn btn-white btn-sm " data-toggle="tooltip" data-placement="left" onclick="sortOrRefresh()" title="刷新"><i class="glyphicon glyphicon-repeat"></i> 刷新</button>
						
						</div>
						<div class="pull-right">
							<button  class="btn btn-success btn-rounded btn-outline btn-sm " onclick="search()" ><i class="fa fa-search"></i> 查询</button>
							<button  class="btn btn-success btn-rounded btn-outline btn-sm " onclick="resetSearch()" ><i class="fa fa-refresh"></i> 重置</button>
						</div>
					</div>
				</div>
					
				<!-- 表格 -->
				<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable">
					<thead>
						<tr>
							<th><input type="checkbox" class="i-checks"></th>
							<th class="sort-column c.title">标题</th>
							<th class="sort-column u8.name">申请人</th>
							<th class="sort-column a.start_address">出发地</th>
							<th class="sort-column a.dest_address">出差城市</th>
							<th class="sort-column a.start_time">开始时间</th>
							<th class="sort-column a.end_time">结束时间</th>
							<th class="sort-column a.budget_amt">预算金额</th>
							<th class="sort-column a.advance_amt">预支金额</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="oaCommonTravel">
						<tr>
							<td><input type="checkbox" id="${oaCommonTravel.id}" class="i-checks"></td>
							<td>
								<a href="${ctx}/oa/oaCommonAudit/view?id=${oaCommonTravel.oaCommonAudit.id}">${oaCommonTravel.oaCommonAudit.title}</a>
							</td>
							<td>
								${oaCommonTravel.oaCommonAudit.createBy.name}
							</td>
							<td>
								${oaCommonTravel.startAddress}
							</td>
							<td>
								${oaCommonTravel.destAddress}
							</td>
							<td>
								<fmt:formatDate value="${oaCommonTravel.startTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<td>
								<fmt:formatDate value="${oaCommonTravel.endTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<td>
								${oaCommonTravel.budgetAmt}
							</td>
							<td>
								${oaCommonTravel.advanceAmt}
							</td>
							<td>
								<shiro:hasPermission name="oa:oaCommonTravel:view">
									<a href="#" onclick="openDialogView('查看差旅单', '${ctx}/oa/oaCommonTravel/view?id=${oaCommonTravel.id}','800px', '500px')" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
								</shiro:hasPermission>
								<shiro:hasPermission name="oa:oaCommonTravel:edit">
			    					<a href="#" onclick="openDialog('修改差旅单', '${ctx}/oa/oaCommonTravel/form?id=${oaCommonTravel.id}','800px', '500px')" class="btn btn-success btn-xs" title="修改"><i class="fa fa-edit"></i><span class="hidden-xs">修改</span></a>
								</shiro:hasPermission>
								
								<shiro:hasPermission name="oa:oaCommonTravel:del">
									<a href="${ctx}/oa/oaCommonTravel/delete?id=${oaCommonTravel.id}" onclick="return confirmx('确认要删除该差旅单吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i><span class="hidden-xs">删除</span></a> 
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