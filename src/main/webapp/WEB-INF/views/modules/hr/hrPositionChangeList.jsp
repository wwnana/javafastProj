<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>调岗列表</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	</script>
</head>
<body class="gray-bg">
	<div class="wrapper-content">
		<div class="ibox">
			<div class="ibox-title">
				<h5>调岗列表 </h5>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>				
				<!-- 查询栏 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="hrPositionChange" action="${ctx}/hr/hrPositionChange/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 查询栏隐藏 -->
								<div class="form-group"><span>调岗时间：</span>
									<div class="input-group date datepicker">
				                     	<input name="beginChangeDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${hrPositionChange.beginChangeDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
							         - 
							        <div class="input-group date datepicker">
				                     	<input name="endChangeDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${hrPositionChange.endChangeDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
								</div>
								<div class="form-group"><span>员工：</span>
									<sys:tableselect id="hrEmployee" name="hrEmployee.id" value="${hrPositionChange.hrEmployee.id}" labelName="hrEmployee.name" labelValue="${hrPositionChange.hrEmployee.name}" 
										title="客户" url="${ctx}/hr/hrEmployee/selectList" cssClass="form-control input-small" dataMsgRequired=""  allowClear="true" allowInput="false"/>
										
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
						<div class="pull-right">
							<div class="btn-group">
								<button id="searchBtn" class="btn btn-white btn-sm" title="搜索"><i class="fa fa-search"></i></button>
								<table:refreshRow></table:refreshRow>
							</div>
						</div>
						<div class="pull-left">
							<%-- 
							<shiro:hasPermission name="hr:hrEmployee:add">
								<table:addRow url="${ctx}/hr/hrPositionChange/form" title="调岗" pageModel="page"></table:addRow><!-- 增加按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="hr:hrEmployee:edit">
							    <table:editRow url="${ctx}/hr/hrPositionChange/form" title="调岗" id="contentTable" pageModel="page"></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="hr:hrEmployee:del">
								<table:delRow url="${ctx}/hr/hrPositionChange/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="hr:hrEmployee:import">
								<table:importExcel url="${ctx}/hr/hrPositionChange/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
							
					       	--%>
					       	<shiro:hasPermission name="hr:hrEmployee:export">
					       		<table:exportExcel url="${ctx}/hr/hrPositionChange/export"></table:exportExcel><!-- 导出按钮 -->
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
							<th class="sort-column h.name">姓名</th>
							<th class="sort-column a.old_office_id">调整前部门</th>
							<th class="sort-column a.old_position">调整前岗位</th>
							<th class="sort-column a.old_position_level">调整前职级</th>
							<th class="sort-column a.office_id">调整后部门</th>
							<th class="sort-column a.position">调整后岗位</th>
							<th class="sort-column a.position_level">调整后职级</th>
							<th class="sort-column a.change_date">调岗时间</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="hrPositionChange">
						<tr>
							<td><input type="checkbox" id="${hrPositionChange.id}" class="i-checks"></td>
							<td>
								<a href="${ctx}/hr/hrPositionChange/view?id=${hrPositionChange.id}" title="查看">
								${hrPositionChange.hrEmployee.name}
							</a></td>
							<td>
								${hrPositionChange.oldOffice.name}
							</td>
							<td>
								${hrPositionChange.oldPosition}
							</td>
							<td>
								${hrPositionChange.oldPositionLevel}
							</td>
							<td>
								${hrPositionChange.office.name}
							</td>
							<td>
								${hrPositionChange.position}
							</td>
							<td>
								${hrPositionChange.positionLevel}
							</td>
							<td>
								<fmt:formatDate value="${hrPositionChange.changeDate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								<shiro:hasPermission name="hr:hrEmployee:view">
									<a href="${ctx}/hr/hrPositionChange/view?id=${hrPositionChange.id}" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
								</shiro:hasPermission>
								<%-- 
								<shiro:hasPermission name="hr:hrEmployee:edit">
			    					<a href="${ctx}/hr/hrPositionChange/form?id=${hrPositionChange.id}" class="btn btn-success btn-xs" title="修改"><i class="fa fa-pencil"></i> 修改</a>
								</shiro:hasPermission>
								
								<shiro:hasPermission name="hr:hrEmployee:del">
									<a href="${ctx}/hr/hrPositionChange/delete?id=${hrPositionChange.id}" onclick="return confirmx('确认要删除该调岗吗？', this.href)" class="btn btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i> 删除</a> 
								</shiro:hasPermission>
								--%>
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