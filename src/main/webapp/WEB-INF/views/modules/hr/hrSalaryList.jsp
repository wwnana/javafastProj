<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>工资表列表</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	</script>
</head>
<body class="gray-bg">
	<div class="wrapper-content">
		<div class="ibox">
			<div class="ibox-title">
				<h5>工资表列表 </h5>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>				
				<!-- 查询栏 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="hrSalary" action="${ctx}/hr/hrSalary/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 查询栏隐藏 -->
								<div class="form-group"><span>年份：</span>
									<form:input path="year" htmlEscape="false" maxlength="4" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>月份：</span>
									<form:input path="month" htmlEscape="false" maxlength="2" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>状态：</span>
									<form:select path="status" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('audit_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
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
							<shiro:hasPermission name="hr:hrSalary:add">
								<table:addRow url="${ctx}/hr/hrSalary/form" title="工资表" pageModel="page" label="当月工资表维护"></table:addRow><!-- 增加按钮 -->
							</shiro:hasPermission>
							<%-- 
							<shiro:hasPermission name="hr:hrSalary:edit">
							    <table:editRow url="${ctx}/hr/hrSalary/form" title="工资表" id="contentTable" pageModel="page"></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="hr:hrSalary:del">
								<table:delRow url="${ctx}/hr/hrSalary/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="hr:hrSalary:import">
								<table:importExcel url="${ctx}/hr/hrSalary/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="hr:hrSalary:export">
					       		<table:exportExcel url="${ctx}/hr/hrSalary/export"></table:exportExcel><!-- 导出按钮 -->
					       	</shiro:hasPermission>
					       	--%>
					       	
						</div>
					</div>
				</div>					
				<!-- 数据表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<th><input type="checkbox" class="i-checks"></th>
							<th>计薪月</th>
							<th>应出勤天数</th>
							<th class="sort-column a.status">状态</th>
							<th>审核人</th>
							<th class="sort-column a.audit_date">审核日期</th>
							<th>制单人</th>
							<th class="sort-column a.create_date">制单日期</th>
							<th width="300px">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="hrSalary">
						<tr>
							<td><input type="checkbox" id="${hrSalary.id}" class="i-checks"></td>
							<td>
								<a href="${ctx}/hr/hrSalary/view?id=${hrSalary.id}" title="查看">
								${hrSalary.year}-${hrSalary.month}
							</a></td>
							<td>
								${hrSalary.workDays}
							</td>
							<td>
								${fns:getDictLabel(hrSalary.status, 'audit_status', '')}
							</td>
							<td>
								${hrSalary.auditBy.name}
							</td>
							<td>
								<fmt:formatDate value="${hrSalary.auditDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<td>
								${hrSalary.createBy.name}
							</td>
							<td>
								<fmt:formatDate value="${hrSalary.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<td>
								<shiro:hasPermission name="hr:hrSalary:view">
									<a href="${ctx}/hr/hrSalary/view?id=${hrSalary.id}" class="btn btn-white btn-sm" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
								</shiro:hasPermission>
								<c:if test="${hrSalary.status == 0}">
								<shiro:hasPermission name="hr:hrSalary:edit">
			    					<a href="${ctx}/hr/hrSalary/form?id=${hrSalary.id}" class="btn btn-white btn-sm" title="修改"><i class="fa fa-pencil"></i> 修改</a>
								</shiro:hasPermission>
								
								<shiro:hasPermission name="hr:hrSalary:del">
									<a href="${ctx}/hr/hrSalary/delete?id=${hrSalary.id}" onclick="return confirmx('确认要删除该工资表吗？', this.href)" class="btn btn-white btn-sm" title="删除"><i class="fa fa-trash"></i> 删除</a> 
								</shiro:hasPermission>
								
								<shiro:hasPermission name="hr:hrSalary:edit">
									<table:exportExcel url="${ctx}/hr/hrSalaryDetail/export?hrSalary.id=${hrSalary.id}"></table:exportExcel><!-- 导出按钮 -->
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