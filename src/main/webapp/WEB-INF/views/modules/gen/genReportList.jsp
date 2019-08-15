<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>图表配置列表</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
		});
		//0:隐藏tip, 1隐藏box,不设置显示全部
		top.$.jBox.closeTip();
		function toShow(url){
			layer.alert(url);
		}
	</script>
</head>
<body class="">
	<div class="">
		<div class="">
			<div class="row dashboard-header gray-bg">
				<h5>图表配置列表 </h5>
				<div class="pull-right">
					<button id="searchBtn" class="btn btn-white btn-sm" title="搜索"><i class="fa fa-search"></i> 搜索</button>
					<shiro:hasPermission name="gen:genReport:add">
						<table:addRow url="${ctx}/gen/genReport/form" title="图表配置" width="80%" height="80%"></table:addRow><!-- 增加按钮 -->
					</shiro:hasPermission>
					<shiro:hasPermission name="gen:genReport:edit">
					    <table:editRow url="${ctx}/gen/genReport/form" title="图表配置" id="contentTable" width="1200px" height="80%"></table:editRow><!-- 编辑按钮 -->
					</shiro:hasPermission>
					<shiro:hasPermission name="gen:genReport:del">
						<table:delRow url="${ctx}/gen/genReport/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
					</shiro:hasPermission>
					<shiro:hasPermission name="gen:genReport:edit">
						<table:batchRow url="${ctx}/gen/genReport/auditAll" id="contentTable" label="发布" title="业务报表"></table:batchRow><!-- 删除按钮 -->
					</shiro:hasPermission>
					<button class="btn btn-white btn-sm " data-toggle="tooltip" data-placement="left" onclick="sortOrRefresh()" title="刷新"><i class="glyphicon glyphicon-repeat"></i> 刷新</button>
				</div>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}" hideType="1"/>
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="genReport" action="${ctx}/gen/genReport/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow>
								<span>业务分类：</span>
							<form:select path="countType" class="form-control input-medium">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('count_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
							<div class="form-group"><span>名称：</span>
									<form:input path="name" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>表名：</span>
									<form:input path="tableName" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>图表类型：</span>
									<form:select path="reportType" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('report_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group">
									<button class="btn btn-white btn-sm" onclick="search()"><i class="fa fa-search"></i> 查询</button>
									<button class="btn btn-white btn-sm" onclick="resetSearch()"><i class="fa fa-refresh"></i> 重置</button>
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
							<th width="100px">业务分类</th>
							<th class="sort-column a.name">名称</th>
							<th class="sort-column a.comments">描述</th>
							<th width="100px" class="sort-column a.report_type">图表类型</th>
							<th width="100px" class="sort-column a.status">发布状态</th>
							<th width="100px" class="sort-column a.sort">排序</th>
							<th width="200px">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="genReport">
						<tr>
							<td><input type="checkbox" id="${genReport.id}" class="i-checks"></td>
							<td>
								${fns:getDictLabel(genReport.countType, 'count_type', '')}
							</td>
							<td><a href="#" onclick="openDialogView('测试图表', '${ctx}/gen/genReport/report?id=${genReport.id}','80%', '80%')" title="查看图表">
								${genReport.name}
							</a></td>
							<td>
								${genReport.comments}
							</td>
							
							<td>
								${fns:getDictLabel(genReport.reportType, 'report_type', '')}
							</td>
							<td>
								${fns:getDictLabel(genReport.status, 'oa_notify_status', '')}
							</td>
							<td>
								${genReport.sort }
							</td>
							<td>
								
								<shiro:hasPermission name="gen:genReport:edit">
			    					<a href="#" onclick="openDialog('修改图表配置', '${ctx}/gen/genReport/form?id=${genReport.id}','80%', '80%')" class="" title="修改">修改</a>
								</shiro:hasPermission>
								<shiro:hasPermission name="gen:genReport:del">
									<a href="${ctx}/gen/genReport/delete?id=${genReport.id}" onclick="return confirmx('确认要删除该图表配置吗？', this.href)" class="" title="删除">删除</a> 
								</shiro:hasPermission>
								
								<a href="${ctx}/gen/genReport/report?id=${genReport.id}" class="" title="查看图表">测试图表</a>
										
								<a href="#" onclick="toShow('/gen/genReport/report?id=${genReport.id}')" class="" title="图表地址">图表地址</a>
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