<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>项目列表</title>
	<meta name="decorator" content="default"/>
</head>
<body class="">
	<div class="">
		<div class="">
			<div class="row dashboard-header gray-bg">
				<div class="pull-left">					
					<a class="btn btn-link" href="${ctx}/oa/oaProject/list2">我参与的</a>
					<a class="btn btn-link" href="${ctx}/oa/oaProject/list2?createBy.id=${fns:getUser().id}">我创建的</a>
					<a class="btn btn-link" href="${ctx}/oa/oaProject/list2?ownBy.id=${fns:getUser().id}">我负责的</a>
					<a class="btn btn-link" href="${ctx}/oa/oaProject/list2?ownBy.id=${fns:getUser().id}&status=2">我完成的</a>
					<a class="btn btn-link" href="${ctx}/oa/oaProject/list2?beginEndDate=${fns:getDate('yyyy-MM-dd')}&endEndDate=${fns:getDayAfter(1)}">今日到期的</a>
					<a class="btn btn-link" href="${ctx}/oa/oaProject/list2?beginEndDate=${fns:getDate('yyyy-MM-dd')}&endEndDate=${fns:getDayAfter(7)}">7天内到期的</a>
					<a class="btn btn-link" href="${ctx}/oa/oaProject/list2?beginEndDate=${fns:getDate('yyyy-MM-dd')}&endEndDate=${fns:getDayAfter(30)}">30天内到期的</a>
				</div>
				<div class="pull-right">
					<a href="${ctx}/oa/oaProject/list" class="btn btn-white btn-sm" title="列块展示"><i class="fa fa-th-large"></i></a>
					<a href="${ctx}/oa/oaProject/list2" class="btn btn-white btn-sm active" title="列表展示"><i class="fa fa-list-ul"></i></a>
					<button id="searchBtn" class="btn btn-white btn-sm" title="搜索"><i class="fa fa-search"></i> 搜索</button>
					
					
					<shiro:hasPermission name="oa:oaProject:export">
					     <table:exportExcel url="${ctx}/oa/oaProject/export"></table:exportExcel><!-- 导出按钮 -->
					</shiro:hasPermission>
					<shiro:hasPermission name="oa:oaProject:add">
						<a class="btn btn-success btn-sm" href="${ctx}/oa/oaProject/form" title="创建项目"><i class="fa fa-plus"></i> 创建项目</a>
					</shiro:hasPermission>
					
				</div>			
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>	
				<!-- 查询栏 -->
				<div class="row text-center">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="oaProject" action="${ctx}/oa/oaProject/list2" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 查询栏隐藏 -->
								<div class="form-group"><span>项目名称：</span>
									<form:input path="name" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>负责人：</span>
									<sys:treeselect id="ownBy" name="ownBy.id" value="${oaProject.ownBy.id}" labelName="ownBy.name" labelValue="${oaProject.ownBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>项目状态：</span>
									<form:select path="status" class="form-control input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('task_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group">
									<button class="btn btn-white btn-sm " onclick="search()"><i class="fa fa-search"></i> 查询</button>
									<a class="btn btn-white btn-sm " href="${ctx}/oa/oaProject/list2"><i class="fa fa-refresh"></i> 重置</a>
								</div>
						</form:form>
					</div>
				</div>
				
				<!-- 数据表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<th class="sort-column a.name">项目名称</th>
							<th class="sort-column a.own_by" width="100px">负责人</th>
							<th class="sort-column a.start_date" width="100px">开始日期</th>
							<th class="sort-column a.end_date" width="100px">截止日期</th>
							<th class="sort-column a.schedule" width="100px">进度</th>
							
							<th class="sort-column a.status" width="100px">状态</th>
							<th width="200px">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="oaProject">
						<tr>
							<td>
								<a href="${ctx}/oa/oaProject/view?id=${oaProject.id}" title="查看">
									${oaProject.name}
								</a>
							</td>
							<td>
								${oaProject.ownBy.name}
							</td>
							<td>
								<fmt:formatDate value="${oaProject.startDate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								<fmt:formatDate value="${oaProject.endDate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								<small>${oaProject.schedule}%</small>
								
							</td>
							
							<td>
								<span class="<c:if test='${oaProject.status == 0}'>text-muted</c:if><c:if test='${oaProject.status == 1}'>text-danger</c:if><c:if test='${oaProject.status == 2}'>text-success</c:if><c:if test='${oaProject.status == 3}'>text-warning</c:if>">
								${fns:getDictLabel(oaProject.status, 'task_status', '')}
								</span>
							</td>
							<td>
									<c:if test="${oaProject.status != 1}">
										<a href="${ctx}/oa/oaProject/deal?id=${oaProject.id}&status=1" onclick="return confirmx('确认要启动该任务吗？', this.href)" title="启动">开始</a>
									</c:if>
									<c:if test="${oaProject.status == 1}">
										<span class="text-muted">开始</span>
									</c:if>
									
									<c:if test="${oaProject.status != 2}">
										<a href="${ctx}/oa/oaProject/deal?id=${oaProject.id}&status=2" onclick="return confirmx('确认要将该任务标记为已完成吗？', this.href)" title="完成">完成</a>
									</c:if>
									<c:if test="${oaProject.status == 2}">
										<span class="text-muted">完成</span>
									</c:if>
									
									<c:if test="${oaProject.status != 3}">
										<a href="${ctx}/oa/oaProject/deal?id=${oaProject.id}&status=3" onclick="return confirmx('确认要关闭该任务吗？', this.href)" title="关闭">关闭</a>
									</c:if>
									<c:if test="${oaProject.status == 3}">
										<span class="text-muted">关闭</span>
									</c:if>
							
								
								<shiro:hasPermission name="oa:oaProject:edit">
			    					<a href="${ctx}/oa/oaProject/form?id=${oaProject.id}"  title="修改">修改</a>
									<a href="${ctx}/oa/oaProject/delete?id=${oaProject.id}" onclick="return confirmx('确认要删除该项目吗？', this.href)" title="删除">删除</a> 
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