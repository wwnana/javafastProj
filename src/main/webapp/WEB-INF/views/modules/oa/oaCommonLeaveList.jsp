<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>请假单列表</title>
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
				<h5>请假单列表 </h5>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="oaCommonLeave" action="${ctx}/oa/oaCommonLeave/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
								<div class="form-group"><span>请假类型：</span>
									<form:select path="leaveType" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('leave_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
						</form:form>
						<br>
					</div>
				</div>
				<!-- 工具栏 -->
				<div class="row">
					<div class="col-sm-12">
						<div class="pull-left">
							<shiro:hasPermission name="oa:oaCommonLeave:add">
								<table:addRow url="${ctx}/oa/oaCommonLeave/form" title="请假单" ></table:addRow><!-- 增加按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="oa:oaCommonLeave:edit">
							    <table:editRow url="${ctx}/oa/oaCommonLeave/form" title="请假单" id="contentTable" ></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="oa:oaCommonLeave:del">
								<table:delRow url="${ctx}/oa/oaCommonLeave/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="oa:oaCommonLeave:import">
								<table:importExcel url="${ctx}/oa/oaCommonLeave/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="oa:oaCommonLeave:export">
					       		<table:exportExcel url="${ctx}/oa/oaCommonLeave/export"></table:exportExcel><!-- 导出按钮 -->
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
							<th class="sort-column a.start_time">开始时间</th>
							<th class="sort-column a.end_time">结束时间</th>
							<th class="sort-column a.leave_type">请假类型</th>
							<th class="sort-column a.days_num">请假时长(天)</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="oaCommonLeave">
						<tr>
							<td><input type="checkbox" id="${oaCommonLeave.id}" class="i-checks"></td>
							<td>
								<a href="${ctx}/oa/oaCommonAudit/view?id=${oaCommonLeave.oaCommonAudit.id}">${oaCommonLeave.oaCommonAudit.title}</a>
							</td>
							<td>
								${oaCommonLeave.oaCommonAudit.createBy.name}
							</td>
							<td>
								<fmt:formatDate value="${oaCommonLeave.startTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<td>
								<fmt:formatDate value="${oaCommonLeave.endTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<td>
								${fns:getDictLabel(oaCommonLeave.leaveType, 'leave_type', '')}
							</td>
							<td>
								${oaCommonLeave.daysNum}
							</td>
							<td>
								<shiro:hasPermission name="oa:oaCommonLeave:view">
									<a href="#" onclick="openDialogView('查看请假单', '${ctx}/oa/oaCommonLeave/view?id=${oaCommonLeave.id}','800px', '500px')" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
								</shiro:hasPermission>
								<shiro:hasPermission name="oa:oaCommonLeave:edit">
			    					<a href="#" onclick="openDialog('修改请假单', '${ctx}/oa/oaCommonLeave/form?id=${oaCommonLeave.id}','800px', '500px')" class="btn btn-success btn-xs" title="修改"><i class="fa fa-edit"></i><span class="hidden-xs">修改</span></a>
								</shiro:hasPermission>
								
								<shiro:hasPermission name="oa:oaCommonLeave:del">
									<a href="${ctx}/oa/oaCommonLeave/delete?id=${oaCommonLeave.id}" onclick="return confirmx('确认要删除该请假单吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i><span class="hidden-xs">删除</span></a> 
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