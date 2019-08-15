<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>面试列表</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	</script>
</head>
<body class="gray-bg">
	<div class="wrapper-content">
		<div class="ibox">
			<div class="ibox-title">
				<h5>面试列表 </h5>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>				
				<!-- 查询栏 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="hrInterview" action="${ctx}/hr/hrInterview/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 查询栏隐藏 -->
								<div class="form-group"><span>邀约状态 0 未邀约，1 已邀约：</span>
									<form:select path="inviteStatus" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('invite_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>面试地点：</span>
									<form:input path="address" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>签到状态 0： 未签到，1：已签到：</span>
									<form:select path="signStatus" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('sign_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>对应简历ID：</span>
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
					<div class="col-sm-12 m-b-sm">
						<div class="pull-right">
							<div class="btn-group">
								<button id="searchBtn" class="btn btn-white btn-sm" title="搜索"><i class="fa fa-search"></i></button>
								<table:refreshRow></table:refreshRow>
							</div>
						</div>
						<div class="pull-left">
							<shiro:hasPermission name="hr:hrInterview:add">
								<table:addRow url="${ctx}/hr/hrInterview/form" title="面试" pageModel="page"></table:addRow><!-- 增加按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="hr:hrInterview:edit">
							    <table:editRow url="${ctx}/hr/hrInterview/form" title="面试" id="contentTable" pageModel="page"></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="hr:hrInterview:del">
								<table:delRow url="${ctx}/hr/hrInterview/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="hr:hrInterview:import">
								<table:importExcel url="${ctx}/hr/hrInterview/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="hr:hrInterview:export">
					       		<table:exportExcel url="${ctx}/hr/hrInterview/export"></table:exportExcel><!-- 导出按钮 -->
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
							<th class="sort-column a.position">岗位</th>
							<th class="sort-column a.interview_date">面试日期</th>
							<th class="sort-column a.interview_time">面试时间1520</th>
							<th class="sort-column a.invite_status">邀约状态 0 未邀约，1 已邀约</th>
							<th class="sort-column a.address">面试地点</th>
							<th class="sort-column a.sign_status">签到状态 0： 未签到，1：已签到</th>
							<th class="sort-column a.sign_time">签到时间1520</th>
							<th class="sort-column a.interview">面试人</th>
							<th class="sort-column a.interview_status">反馈状态</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="hrInterview">
						<tr>
							<td><input type="checkbox" id="${hrInterview.id}" class="i-checks"></td>
							<td>
								<a href="${ctx}/hr/hrInterview/view?id=${hrInterview.id}" title="查看">
								${hrInterview.position}
							</a></td>
							<td>
								<fmt:formatDate value="${hrInterview.interviewDate}" pattern="yyyy-MM-dd HH:mm"/>
							</td>
							<td>
								<fmt:formatDate value="${hrInterview.interviewTime}" pattern="yyyy-MM-dd HH:mm"/>
							</td>
							<td>
								${fns:getDictLabel(hrInterview.inviteStatus, 'invite_status', '')}
							</td>
							<td>
								${hrInterview.address}
							</td>
							<td>
								${fns:getDictLabel(hrInterview.signStatus, 'sign_status', '')}
							</td>
							<td>
								<fmt:formatDate value="${hrInterview.signTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<td>
								${hrInterview.interviewBy.name}
							</td>
							<td>
								${hrInterview.status}
							</td>
							<td>
								<shiro:hasPermission name="hr:hrInterview:view">
									<a href="${ctx}/hr/hrInterview/view?id=${hrInterview.id}" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
								</shiro:hasPermission>
								<shiro:hasPermission name="hr:hrInterview:edit">
			    					<a href="${ctx}/hr/hrInterview/form?id=${hrInterview.id}" class="btn btn-success btn-xs" title="修改"><i class="fa fa-pencil"></i> 修改</a>
								</shiro:hasPermission>
								
								<shiro:hasPermission name="hr:hrInterview:del">
									<a href="${ctx}/hr/hrInterview/delete?id=${hrInterview.id}" onclick="return confirmx('确认要删除该面试吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i> 删除</a> 
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