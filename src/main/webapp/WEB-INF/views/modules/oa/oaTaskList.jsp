<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>任务管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">

	</script>
</head>

<body class="">
	<div class="">
		<div class="">
			<div class="row dashboard-header gray-bg">
				<div class="pull-left">					
					<a class="btn btn-link" href="${ctx}/oa/oaTask/list">我参与的</a>
					<a class="btn btn-link" href="${ctx}/oa/oaTask/list?createBy.id=${fns:getUser().id}">我创建的</a>
					<a class="btn btn btn-link" href="${ctx}/oa/oaTask/list?ownBy.id=${fns:getUser().id}">我负责的</a>
					<a class="btn btn-link" href="${ctx}/oa/oaTask/list?ownBy.id=${fns:getUser().id}&status=2">我完成的</a>
					<a class="btn btn-link" href="${ctx}/oa/oaTask/list?beginEndDate=${fns:getDate('yyyy-MM-dd')}&endEndDate=${fns:getDayAfter(1)}">今日到期的</a>
					<a class="btn btn-link" href="${ctx}/oa/oaTask/list?beginEndDate=${fns:getDate('yyyy-MM-dd')}&endEndDate=${fns:getDayAfter(7)}">7天内到期的</a>
					<a class="btn btn-link" href="${ctx}/oa/oaTask/list?beginEndDate=${fns:getDate('yyyy-MM-dd')}&endEndDate=${fns:getDayAfter(30)}">30天内到期的</a>
				</div>
				<div class="pull-right">					
					<button id="searchBtn" class="btn btn-white btn-sm" title="搜索"><i class="fa fa-search"></i> 搜索</button>
					<shiro:hasPermission name="oa:oaTask:del">
						<table:delRow url="${ctx}/oa/oaTask/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
					</shiro:hasPermission>
					<shiro:hasPermission name="oa:oaTask:export">
					       		<table:exportExcel url="${ctx}/oa/oaTask/export"></table:exportExcel><!-- 导出按钮 -->
					</shiro:hasPermission>
					<shiro:hasPermission name="oa:oaTask:add">
						<a class="btn btn-success btn-sm" href="${ctx}/oa/oaTask/form" title="创建任务"><i class="fa fa-plus"></i> 创建任务</a>
					</shiro:hasPermission>
					
				</div>			
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>	
			
				
				<!-- 查询条件 -->
				<div class="row text-center">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="oaTask" action="${ctx}/oa/oaTask/${oaTask.self?'self':''}" method="post" class="form-inline">
							<form:hidden path="relationId" />
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 查询栏 -->
								<div class="form-group"><span>任务名称：</span>
									<form:input path="name" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>任务类型：</span>
									<form:select path="relationType" class="form-control input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('relation_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>截止日期：</span>
									<div class="input-group date datepicker">
				                     	<input name="beginEndDate" type="text" readonly="readonly" class="form-control input-xmini" value="<fmt:formatDate value="${oaTask.beginEndDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
							         - 
							        <div class="input-group date datepicker">
				                     	<input name="endEndDate" type="text" readonly="readonly" class="form-control input-xmini" value="<fmt:formatDate value="${oaTask.endEndDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
								</div>
								<div class="form-group"><span>优先级：</span>
									<form:select path="levelType" class="form-control input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('level_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>任务状态：</span>
									<form:select path="status" class="form-control input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('task_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group">
									<button class="btn btn-white btn-sm " onclick="search()"><i class="fa fa-search"></i> 查询</button>
									<button class="btn btn-white btn-sm " onclick="resetSearch()"><i class="fa fa-refresh"></i> 重置</button>
								</div>
						</form:form>
					</div>
				</div>
				
					
				<!-- 表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<th width="30px"><input type="checkbox" class="i-checks"></th>
							<th class="sort-column name">任务名称</th>
							<th class="sort-column relation_name">项目名称</th>
							<th class="sort-column a.own_by" width="100px">负责人</th>
							
							<th class="sort-column end_date" width="100px">截止日期</th>
							<th class="sort-column level_type" width="100px">优先级</th>
							
							<th class="sort-column status" width="100px">任务状态</th>
							<th width="200px">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="oaTask">
						<tr>
							<td><input type="checkbox" id="${oaTask.id}" class="i-checks"></td>
							<td>
								<a href="${ctx}/oa/oaTask/view?id=${oaTask.id}">${oaTask.name}</a>
							</td>
							<td>
								${oaTask.relationName}
							</td>
							<td>
								${oaTask.ownBy.name}
							</td>
							
							<td>
								<fmt:formatDate value="${oaTask.endDate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								<span class="<c:if test='${oaTask.levelType == 2}'>badge badge-danger</c:if><c:if test='${oaTask.levelType == 1}'>badge badge-warning</c:if><c:if test='${oaTask.levelType == 0}'>badge badge-info</c:if>">
									${fns:getDictLabel(oaTask.levelType, 'level_type', '')}
								</span>
							</td>
							<td>
								<span class="<c:if test='${oaTask.status == 0}'>text-muted</c:if><c:if test='${oaTask.status == 1}'>text-danger</c:if><c:if test='${oaTask.status == 2}'>text-success</c:if><c:if test='${oaTask.status == 3}'>text-warning</c:if>">
								${fns:getDictLabel(oaTask.status, 'task_status', '')}
								</span>
							</td>

							<td>
								 
									<c:if test="${oaTask.status != 1}">
										<a href="${ctx}/oa/oaTask/deal?id=${oaTask.id}&status=1" onclick="return confirmx('确认要启动该任务吗？', this.href)" title="启动">开始</a>
									</c:if>
									<c:if test="${oaTask.status == 1}">
										<span class="text-muted">开始</span>
									</c:if>
									
									<c:if test="${oaTask.status != 2}">
										<a href="${ctx}/oa/oaTask/deal?id=${oaTask.id}&status=2" onclick="return confirmx('确认要将该任务标记为已完成吗？', this.href)" title="完成">完成</a>
									</c:if>
									<c:if test="${oaTask.status == 2}">
										<span class="text-muted">完成</span>
									</c:if>
									
									<c:if test="${oaTask.status != 3}">
										<a href="${ctx}/oa/oaTask/deal?id=${oaTask.id}&status=3" onclick="return confirmx('确认要关闭该任务吗？', this.href)" title="关闭">关闭</a>
									</c:if>
									<c:if test="${oaTask.status == 3}">
										<span class="text-muted">关闭</span>
									</c:if>
								
								<shiro:hasPermission name="oa:oaTask:edit">
			    					<a href="${ctx}/oa/oaTask/form?id=${oaTask.id}"  title="修改">修改</a>
									<a href="${ctx}/oa/oaTask/delete?id=${oaTask.id}" onclick="return confirmx('确认要删除该任务吗？', this.href)" title="删除">删除</a>
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