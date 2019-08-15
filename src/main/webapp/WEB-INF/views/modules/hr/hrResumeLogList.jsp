<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>HR日志列表</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	</script>
</head>
<body class="gray-bg">
	<div class="wrapper-content">
		<div class="ibox">
			<div class="ibox-title">
				<h5>HR日志列表 </h5>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>				
				<!-- 查询栏 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="hrResumeLog" action="${ctx}/hr/hrResumeLog/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 查询栏隐藏 -->
								<div class="form-group"><span>简历编号：</span>
									<form:input path="hrResumeId" htmlEscape="false" maxlength="64" class="form-control input-medium"/>
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
					<div class="col-sm-12">
						<div class="pull-right m-b-sm">
							<div class="btn-group">
								<button id="searchBtn" class="btn btn-white btn-sm" title="搜索"><i class="fa fa-search"></i></button>
								<table:refreshRow></table:refreshRow>
							</div>
						</div>
						<div class="pull-left">
							<shiro:hasPermission name="hr:hrResumeLog:add">
								<table:addRow url="${ctx}/hr/hrResumeLog/form" title="HR日志" pageModel="page"></table:addRow><!-- 增加按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="hr:hrResumeLog:edit">
							    <table:editRow url="${ctx}/hr/hrResumeLog/form" title="HR日志" id="contentTable" pageModel="page"></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="hr:hrResumeLog:del">
								<table:delRow url="${ctx}/hr/hrResumeLog/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="hr:hrResumeLog:import">
								<table:importExcel url="${ctx}/hr/hrResumeLog/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="hr:hrResumeLog:export">
					       		<table:exportExcel url="${ctx}/hr/hrResumeLog/export"></table:exportExcel><!-- 导出按钮 -->
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
							<th class="sort-column a.note">内容</th>
							<th class="sort-column a.type">事件类型： 1上传简历，2邀约面试，3：下发录用OFFER，4：入职</th>
							<th class="sort-column a.create_date">创建时间</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="hrResumeLog">
						<tr>
							<td><input type="checkbox" id="${hrResumeLog.id}" class="i-checks"></td>
							<td>
								<a href="${ctx}/hr/hrResumeLog/view?id=${hrResumeLog.id}" title="查看">
								${hrResumeLog.note}
							</a></td>
							<td>
								${hrResumeLog.type}
							</td>
							<td>
								<fmt:formatDate value="${hrResumeLog.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<td>
								<shiro:hasPermission name="hr:hrResumeLog:view">
									<a href="${ctx}/hr/hrResumeLog/view?id=${hrResumeLog.id}" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
								</shiro:hasPermission>
								<shiro:hasPermission name="hr:hrResumeLog:edit">
			    					<a href="${ctx}/hr/hrResumeLog/form?id=${hrResumeLog.id}" class="btn btn-success btn-xs" title="修改"><i class="fa fa-pencil"></i> 修改</a>
								</shiro:hasPermission>
								
								<shiro:hasPermission name="hr:hrResumeLog:del">
									<a href="${ctx}/hr/hrResumeLog/delete?id=${hrResumeLog.id}" onclick="return confirmx('确认要删除该HR日志吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i> 删除</a> 
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