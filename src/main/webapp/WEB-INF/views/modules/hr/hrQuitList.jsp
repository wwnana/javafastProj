<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>离职列表</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	</script>
</head>
<body class="gray-bg">
	<div class="wrapper-content">
		<div class="ibox">
			<div class="ibox-title">
				<h5>离职列表 </h5>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>				
				<!-- 查询栏 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="hrQuit" action="${ctx}/hr/hrQuit/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 查询栏隐藏 -->
								<div class="form-group"><span>离职时间：</span>
									<div class="input-group date datepicker">
				                     	<input name="beginQuitDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${hrQuit.beginQuitDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
							         - 
							        <div class="input-group date datepicker">
				                     	<input name="endQuitDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${hrQuit.endQuitDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
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
							<%-- 
							<shiro:hasPermission name="hr:hrEmployee:add">
								<table:addRow url="${ctx}/hr/hrQuit/form" title="离职" pageModel="page"></table:addRow><!-- 增加按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="hr:hrEmployee:edit">
							    <table:editRow url="${ctx}/hr/hrQuit/form" title="离职" id="contentTable" pageModel="page"></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="hr:hrEmployee:del">
								<table:delRow url="${ctx}/hr/hrQuit/deleteAll" id="contentTable"></table:delRow><!-- 撤销按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="hr:hrEmployee:import">
								<table:importExcel url="${ctx}/hr/hrQuit/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
							
					       	--%>
					       	<shiro:hasPermission name="hr:hrEmployee:export">
					       		<table:exportExcel url="${ctx}/hr/hrQuit/export"></table:exportExcel><!-- 导出按钮 -->
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
							<th class="sort-column a.quit_type">离职类型</th>
							<th class="sort-column a.quit_date">离职时间</th>
							<th class="sort-column a.quit_cause">离职原因</th>
							<th class="sort-column a.apply_quit_cause">申请离职原因</th>
							<th class="sort-column a.compensation">补偿金</th>
							<th class="sort-column a.social_over_month">社保减员月</th>
							<th class="sort-column a.fund_over_month">公积金减员月</th>
							<th class="sort-column a.annual_leave">剩余年假</th>
							<th class="sort-column a.rest_leave">剩余调休</th>
							<th class="sort-column a.work_status">工作交接</th>
							<th class="sort-column a.status">状态</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="hrQuit">
						<tr>
							<td><input type="checkbox" id="${hrQuit.id}" class="i-checks"></td>
							<td>
								<a href="${ctx}/hr/hrQuit/view?id=${hrQuit.id}" title="查看">
								${fns:getDictLabel(hrQuit.quitType, 'quit_type', '')}
							</a></td>
							<td>
								<fmt:formatDate value="${hrQuit.quitDate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								${hrQuit.quitCause}
							</td>
							<td>
								${hrQuit.applyQuitCause}
							</td>
							<td>
								${hrQuit.compensation}
							</td>
							<td>
								${fns:getDictLabel(hrQuit.socialOverMonth, 'over_month_type', '')}
							</td>
							<td>
								${fns:getDictLabel(hrQuit.fundOverMonth, 'over_month_type', '')}
							</td>
							<td>
								${hrQuit.annualLeave}
							</td>
							<td>
								${hrQuit.restLeave}
							</td>
							<td>
								${fns:getDictLabel(hrQuit.workStatus, 'finish_status', '')}
							</td>
							<td>
								${fns:getDictLabel(hrQuit.status, 'audit_status', '')}
							</td>
							<td>
								<shiro:hasPermission name="hr:hrEmployee:view">
									<a href="${ctx}/hr/hrQuit/view?id=${hrQuit.id}" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
								</shiro:hasPermission>
								<c:if test="${hrQuit.status == 0}">
								<shiro:hasPermission name="hr:hrEmployee:edit">
			    					<a href="${ctx}/hr/hrQuit/form?id=${hrQuit.id}" class="btn btn-success btn-xs" title="修改"><i class="fa fa-pencil"></i> 修改</a>
			    					<a href="${ctx}/hr/hrQuit/audit?id=${hrQuit.id}" onclick="return confirmx('确认要核准该离职吗？', this.href)" class="btn btn-success btn-xs" title="核准"><i class="fa fa-check"></i> 核准</a> 
								</shiro:hasPermission>
								
								<shiro:hasPermission name="hr:hrEmployee:del">
									<a href="${ctx}/hr/hrQuit/delete?id=${hrQuit.id}" onclick="return confirmx('确认要撤销该离职吗？', this.href)" class="btn btn-danger btn-xs" title="撤销"><i class="fa fa-trash"></i> 撤销</a> 
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