<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>任务管理</title>
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
				<h5>任务列表 </h5>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 查询条件 -->
				<div class="">
					<div class="">
						<form:form id="searchForm" modelAttribute="oaTask" action="${ctx}/oa/oaTask/indexTaskList" method="post" class="form-inline">
							<form:hidden path="relationId" />
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
								
						</form:form>
					</div>
				</div>
				<!-- 工具栏 -->
				<div class="row">
					<div class="col-sm-12">
						<div class="pull-left">
							<shiro:hasPermission name="oa:oaTask:add">
								<c:if test="${not empty oaTask.relationId}">
									<a href="${ctx}/oa/oaTask/form?relationId=${oaTask.relationId}&relationName=${oaTask.relationName}&relationType=0" title="任务" target="_parent" class="btn btn-white btn-sm"><i class="fa fa-plus"></i> 创建任务</a><!-- 增加按钮 -->
								</c:if>
								<c:if test="${empty oaTask.relationId}">
									<a href="${ctx}/oa/oaTask/form?relationId=${oaTask.relationId}&relationName=${oaTask.relationName}&relationType=0" title="任务" target="_parent" class="btn btn-white btn-sm"><i class="fa fa-plus"></i> 创建任务</a><!-- 增加按钮 -->
								</c:if>
							</shiro:hasPermission>
					       <button class="btn btn-white btn-sm " data-toggle="tooltip" data-placement="left" onclick="sortOrRefresh()" title="刷新"><i class="glyphicon glyphicon-repeat"></i> 刷新</button>
						
						</div>
					</div>
				</div>
					
				<!-- 表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<%--<th><input type="checkbox" class="i-checks"></th>--%>
							<th>任务名称</th>
							<th>截止日期</th>
							<th>优先级</th>
							<th>进度(%)</th>
							<th>负责人</th>
							<th>任务状态</th>
							<%-- 
							<th class="sort-column create_by">创建者</th>
							<th class="sort-column create_date">创建时间</th>
							--%>
							<th width="150px">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="oaTask">
						<tr>
							<%--<td><input type="checkbox" id="${oaTask.id}" class="i-checks"></td>--%>
							<td>
								<a href="${ctx}/oa/oaTask/view?id=${oaTask.id}" target="_parent">${oaTask.name}</a>
							</td>
							<td>
								<fmt:formatDate value="${oaTask.endDate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								${fns:getDictLabel(oaTask.levelType, 'level_type', '')}
							</td>
							<td>
								${oaTask.schedule}
							</td>
							<td>
								${oaTask.ownBy.name}
							</td>
							<td>
								${fns:getDictLabel(oaTask.status, 'task_status', '')}
							</td>
							<%-- 
							<td>
								${oaTask.createBy.name}
							</td>
							<td>
								<fmt:formatDate value="${oaTask.createDate}" pattern="yyyy-MM-dd"/>
							</td>
							--%>
							<td>
								 
								
								<shiro:hasPermission name="oa:oaTask:edit">
			    					<a href="${ctx}/oa/oaTask/form?id=${oaTask.id}" class="btn btn-success btn-xs" title="修改" target="_parent"><i class="fa fa-edit"></i>
										<span class="hidden-xs"></span></a>
								</shiro:hasPermission>
								<shiro:hasPermission name="oa:oaTask:del">
									<a href="${ctx}/oa/oaTask/indexDelete?id=${oaTask.id}" onclick="return confirmx('确认要删除该任务吗？', this.href)" class="btn  btn-danger btn-xs" title="删除" target="_parent"><i class="fa fa-trash"></i>
										<span class="hidden-xs"></span></a> 
								</shiro:hasPermission>
								
								<shiro:hasPermission name="oa:oaTask:deal">
									<c:if test="${oaTask.status != 2}">
										<a href="${ctx}/oa/oaTask/deal?id=${oaTask.id}&status=1" onclick="return confirmx('确认要启动该任务吗？', this.href)" class="btn  btn-info btn-xs" title="启动" target="_parent"><i class="fa fa-play"></i>
											<span class="hidden-xs"></span></a> 
									</c:if>
									<c:if test="${oaTask.status != 2}">
										<a href="${ctx}/oa/oaTask/deal?id=${oaTask.id}&status=2" onclick="return confirmx('确认要将该任务标记为已完成吗？', this.href)" class="btn  btn-success btn-xs" title="完成" target="_parent"><i class="fa fa-check"></i>
											<span class="hidden-xs"></span></a> 
									</c:if>
										<a href="${ctx}/oa/oaTask/deal?id=${oaTask.id}&status=3" onclick="return confirmx('确认要关闭该任务吗？', this.href)" class="btn  btn-danger btn-xs" title="关闭" target="_parent"><i class="fa fa-ban"></i>
											<span class="hidden-xs"></span></a> 
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