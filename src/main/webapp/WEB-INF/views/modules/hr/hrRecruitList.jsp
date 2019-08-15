<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>招聘任务列表</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	</script>
</head>
<body class="gray-bg">
	<div class="wrapper-content">
		<div class="ibox">
			<div class="ibox-title">
				<h5>招聘任务列表 </h5>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>				
				<!-- 查询栏 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="hrRecruit" action="${ctx}/hr/hrRecruit/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 查询栏隐藏 -->
								<div class="form-group"><span>岗位名称：</span>
									<form:input path="name" htmlEscape="false" maxlength="64" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>状态：</span>
									<form:select path="status" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('recruit_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
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
							<shiro:hasPermission name="hr:hrRecruit:add">
								<table:addRow url="${ctx}/hr/hrRecruit/form" title="招聘任务" pageModel="page" label="新增招聘任务"></table:addRow><!-- 增加按钮 -->
							</shiro:hasPermission>
							<%--
							<shiro:hasPermission name="hr:hrRecruit:edit">
							    <table:editRow url="${ctx}/hr/hrRecruit/form" title="招聘任务" id="contentTable" pageModel="page"></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							 
							<shiro:hasPermission name="hr:hrRecruit:del">
								<table:delRow url="${ctx}/hr/hrRecruit/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							
							<shiro:hasPermission name="hr:hrRecruit:import">
								<table:importExcel url="${ctx}/hr/hrRecruit/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="hr:hrRecruit:export">
					       		<table:exportExcel url="${ctx}/hr/hrRecruit/export"></table:exportExcel><!-- 导出按钮 -->
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
							<th>岗位名称</th>
							<th>需求部门</th>
							<th>招聘人数</th>
							<th>招聘进度</th>
							<th>接收简历</th>
							<th>已面试</th>
							<th>已发送offer</th>
							<th>已入职</th>
							<th class="sort-column a.status">状态</th>
							<th width="200px">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="hrRecruit">
						<tr>
							<td>
								<a href="${ctx}/hr/hrRecruit/view?id=${hrRecruit.id}" title="查看">
								${hrRecruit.name}
								</a>
							</td>
							<td>
								${hrRecruit.depart}
							</td>
							<td>
								${hrRecruit.recruitNum}
							</td>
							<td>
								${hrRecruit.schedule}%
							</td>
							<td>
								${hrRecruit.resumeNum}
							</td>
							<td>
								${hrRecruit.interviewNum}
							</td>
							<td>
								${hrRecruit.offerNum}
							</td>
							<td>
								${hrRecruit.entryNum}
							</td>
							<td>
								${fns:getDictLabel(hrRecruit.status, 'recruit_status', '')}
							</td>
							<td>
								<shiro:hasPermission name="hr:hrRecruit:view">
									<a href="${ctx}/hr/hrRecruit/view?id=${hrRecruit.id}" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
								</shiro:hasPermission>
								<shiro:hasPermission name="hr:hrRecruit:edit">
			    					<a href="${ctx}/hr/hrRecruit/form?id=${hrRecruit.id}" class="btn btn-success btn-xs" title="修改"><i class="fa fa-pencil"></i> 修改</a>
								</shiro:hasPermission>
								
								<shiro:hasPermission name="hr:hrRecruit:del">
								<c:if test="${hrRecruit.status == 0}">
									<a href="${ctx}/hr/hrRecruit/delete?id=${hrRecruit.id}" onclick="return confirmx('确认要删除该招聘任务吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i> 删除</a> 
								</c:if>
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