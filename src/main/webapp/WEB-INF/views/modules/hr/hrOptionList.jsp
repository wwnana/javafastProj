<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>期权列表</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	</script>
</head>
<body class="gray-bg">
	<div class="wrapper-content">
		<div class="ibox">
			<div class="ibox-title">
				<h5>期权列表 </h5>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>				
				<!-- 查询栏 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="hrOption" action="${ctx}/hr/hrOption/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 查询栏隐藏 -->
								<div class="form-group">
									<button class="btn btn-white btn-sm " onclick="search()"><i class="fa fa-search"></i> 查询</button>
									<button class="btn btn-white btn-sm " onclick="resetSearch()"><i class="fa fa-refresh"></i> 重置</button>
								</div>
						</form:form>
					</div>
				</div>
				<!-- 工具栏 -->
				<div class="row">
					<div class="col-sm-12 m-b-sm">
						<div class="pull-right">
							<div class="btn-group">
								<button id="searchBtn" class="btn btn-white btn-sm" title="搜索"><i class="fa fa-search"></i></button>
								<table:refreshRow></table:refreshRow>
							</div>
						</div>
						<div class="pull-left">
							<shiro:hasPermission name="hr:hrEmployee:add">
								<table:addRow url="${ctx}/hr/hrOption/form" title="期权" pageModel="page"></table:addRow><!-- 增加按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="hr:hrEmployee:edit">
							    <table:editRow url="${ctx}/hr/hrOption/form" title="期权" id="contentTable" pageModel="page"></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="hr:hrEmployee:del">
								<table:delRow url="${ctx}/hr/hrOption/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="hr:hrEmployee:import">
								<table:importExcel url="${ctx}/hr/hrOption/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="hr:hrEmployee:export">
					       		<table:exportExcel url="${ctx}/hr/hrOption/export"></table:exportExcel><!-- 导出按钮 -->
					       	</shiro:hasPermission>
						</div>
					</div>
				</div>					
				<!-- 数据表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<th><input type="checkbox" class="i-checks"></th>
							<th class="sort-column a.grant_date">授予日期</th>
							<th class="sort-column a.grant_num">授予数量</th>
							<th class="sort-column a.proportion">比例</th>
							<th class="sort-column a.round_num">轮次</th>
							<th class="sort-column a.lock_period">锁定期</th>
							<th class="sort-column a.mature_num">已成熟数量</th>
							<th class="sort-column a.option_file">期权合同</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="hrOption">
						<tr>
							<td><input type="checkbox" id="${hrOption.id}" class="i-checks"></td>
							<td>
								<a href="${ctx}/hr/hrOption/view?id=${hrOption.id}" title="查看">
								<fmt:formatDate value="${hrOption.grantDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</a></td>
							<td>
								${hrOption.grantNum}
							</td>
							<td>
								${hrOption.proportion}
							</td>
							<td>
								${hrOption.roundNum}
							</td>
							<td>
								${hrOption.lockPeriod}
							</td>
							<td>
								${hrOption.matureNum}
							</td>
							<td>
								${hrOption.optionFile}
							</td>
							<td>
								<shiro:hasPermission name="hr:hrEmployee:view">
									<a href="${ctx}/hr/hrOption/view?id=${hrOption.id}" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
								</shiro:hasPermission>
								<shiro:hasPermission name="hr:hrEmployee:edit">
			    					<a href="${ctx}/hr/hrOption/form?id=${hrOption.id}" class="btn btn-success btn-xs" title="修改"><i class="fa fa-pencil"></i> 修改</a>
								</shiro:hasPermission>
								
								<shiro:hasPermission name="hr:hrEmployee:del">
									<a href="${ctx}/hr/hrOption/delete?id=${hrOption.id}" onclick="return confirmx('确认要删除该期权吗？', this.href)" class="btn btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i> 删除</a> 
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