<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>足迹管理</title>
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
				<h5>足迹列表 </h5>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="sysBrowseLog" action="${ctx}/sys/sysBrowseLog/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
								<div class="form-group"><span>目标类型：</span>
									<form:select path="targetType" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('target_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>浏览者：</span>
									<form:input path="userId" htmlEscape="false" maxlength="30" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>最新浏览时间：</span>
									<input name="beginBrowseDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${sysBrowseLog.beginBrowseDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/> - 
									<input name="endBrowseDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${sysBrowseLog.endBrowseDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
								</div>
						</form:form>
					</div>
				</div>
				<!-- 工具栏 -->
				<div class="row">
					<div class="col-sm-12 m-b-sm">
						<div class="pull-left">
							<shiro:hasPermission name="sys:sysBrowseLog:add">
								<table:addRow url="${ctx}/sys/sysBrowseLog/form" title="足迹"></table:addRow><!-- 增加按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="sys:sysBrowseLog:edit">
							    <table:editRow url="${ctx}/sys/sysBrowseLog/form" title="足迹" id="contentTable"></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="sys:sysBrowseLog:del">
								<table:delRow url="${ctx}/sys/sysBrowseLog/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="sys:sysBrowseLog:import">
								<table:importExcel url="${ctx}/sys/sysBrowseLog/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="sys:sysBrowseLog:export">
					       		<table:exportExcel url="${ctx}/sys/sysBrowseLog/export"></table:exportExcel><!-- 导出按钮 -->
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
							<th class="sort-column target_type">目标类型</th>
							<th class="sort-column target_id">目标ID</th>
							<th class="sort-column target_name">目标名称</th>
							<th class="sort-column user_id">浏览者</th>
							<th class="sort-column browse_date">最新浏览时间</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="sysBrowseLog">
						<tr>
							<td><input type="checkbox" id="${sysBrowseLog.id}" class="i-checks"></td>
							<td><a href="#" onclick="openDialogView('查看足迹', '${ctx}/sys/sysBrowseLog/form?id=${sysBrowseLog.id}','800px', '500px')">
								${fns:getDictLabel(sysBrowseLog.targetType, 'target_type', '')}
							</a></td>
							<td>
								${sysBrowseLog.targetId}
							</td>
							<td>
								${sysBrowseLog.targetName}
							</td>
							<td>
								${sysBrowseLog.userId}
							</td>
							<td>
								<fmt:formatDate value="${sysBrowseLog.browseDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<td>
								<shiro:hasPermission name="sys:sysBrowseLog:view">
									<a href="#" onclick="openDialogView('查看足迹', '${ctx}/sys/sysBrowseLog/form?id=${sysBrowseLog.id}','800px', '500px')" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
								</shiro:hasPermission>
								<shiro:hasPermission name="sys:sysBrowseLog:edit">
			    					<a href="#" onclick="openDialog('修改足迹', '${ctx}/sys/sysBrowseLog/form?id=${sysBrowseLog.id}','800px', '500px')" class="btn btn-success btn-xs" title="修改"><i class="fa fa-edit"></i>
										<span class="hidden-xs">修改</span></a>
								</shiro:hasPermission>
								<shiro:hasPermission name="sys:sysBrowseLog:del">
									<a href="${ctx}/sys/sysBrowseLog/delete?id=${sysBrowseLog.id}" onclick="return confirmx('确认要删除该足迹吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i>
										<span class="hidden-xs">删除</span></a> 
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