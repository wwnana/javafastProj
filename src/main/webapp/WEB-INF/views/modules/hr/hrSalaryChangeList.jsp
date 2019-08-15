<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>调薪列表</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	</script>
</head>
<body class="gray-bg">
	<div class="wrapper-content">
		<div class="ibox">
			<div class="ibox-title">
				<h5>调薪列表 </h5>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>				
				<!-- 查询栏 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="hrSalaryChange" action="${ctx}/hr/hrSalaryChange/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 查询栏隐藏 -->
								<div class="form-group"><span>员工：</span>
									<form:input path="hrEmployee.name" htmlEscape="false" maxlength="30" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>调薪生效时间：</span>
									<div class="input-group date datepicker">
				                     	<input name="beginEffectDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${hrSalaryChange.beginEffectDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
							         - 
							        <div class="input-group date datepicker">
				                     	<input name="endEffectDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${hrSalaryChange.endEffectDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
								</div>
								<div class="form-group"><span>状态：</span>
									<form:select path="status" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('audit_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
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
							<%-- 
							<shiro:hasPermission name="hr:hrSalaryChange:add">
								<table:addRow url="${ctx}/hr/hrSalaryChange/form" title="调薪" pageModel="page"></table:addRow><!-- 增加按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="hr:hrSalaryChange:edit">
							    <table:editRow url="${ctx}/hr/hrSalaryChange/form" title="调薪" id="contentTable" pageModel="page"></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="hr:hrSalaryChange:del">
								<table:delRow url="${ctx}/hr/hrSalaryChange/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="hr:hrSalaryChange:import">
								<table:importExcel url="${ctx}/hr/hrSalaryChange/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
							
					       	--%>
					       	<shiro:hasPermission name="hr:hrSalaryChange:export">
					       		<table:exportExcel url="${ctx}/hr/hrSalaryChange/export"></table:exportExcel><!-- 导出按钮 -->
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
							<th class="sort-column a.hr_employee_id">员工</th>
							<th class="sort-column a.old_base_salary">调薪前基本工资</th>
							<th class="sort-column a.base_salary">调薪后基本工资</th>
							<th class="sort-column a.change_range">调整幅度</th>
							<th class="sort-column a.effect_date">调薪生效时间</th>
							<th class="sort-column a.status">状态</th>
							<th class="sort-column a.audit_by">审核人</th>
							<th class="sort-column a.audit_date">审核日期</th>
							<th class="sort-column a.create_by">制单人</th>
							<th class="sort-column a.create_date">制单日期</th>
							<th width="250px">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="hrSalaryChange">
						<tr>
							<td><input type="checkbox" id="${hrSalaryChange.id}" class="i-checks"></td>
							<td>
								<a href="${ctx}/hr/hrSalaryChange/view?id=${hrSalaryChange.id}" title="查看">
								${hrSalaryChange.hrEmployee.name}
							</a></td>
							<td>
								${hrSalaryChange.oldBaseSalary}
							</td>
							<td>
								${hrSalaryChange.baseSalary}
							</td>
							<td>
								${hrSalaryChange.changeRange}%
							</td>
							<td>
								<fmt:formatDate value="${hrSalaryChange.effectDate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								${fns:getDictLabel(hrSalaryChange.status, 'audit_status', '')}
							</td>
							<td>
								${hrSalaryChange.auditBy.name}
							</td>
							<td>
								<fmt:formatDate value="${hrSalaryChange.auditDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<td>
								${hrSalaryChange.createBy.name}
							</td>
							<td>
								<fmt:formatDate value="${hrSalaryChange.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<td>
								<shiro:hasPermission name="hr:hrSalaryChange:view">
									<a href="${ctx}/hr/hrSalaryChange/view?id=${hrSalaryChange.id}" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
								</shiro:hasPermission>
								<c:if test="${hrSalaryChange.status==0}">
								<shiro:hasPermission name="hr:hrSalaryChange:edit">
			    					<a href="${ctx}/hr/hrSalaryChange/form?id=${hrSalaryChange.id}" class="btn btn-success btn-xs" title="修改"><i class="fa fa-pencil"></i> 修改</a>
								</shiro:hasPermission>
								
								<shiro:hasPermission name="hr:hrSalaryChange:del">
									<a href="${ctx}/hr/hrSalaryChange/audit?id=${hrSalaryChange.id}" onclick="return confirmx('确认要核准该调薪吗？', this.href)" class="btn btn-success btn-xs" title="核准"><i class="fa fa-check"></i> 核准</a> 
								</shiro:hasPermission>
								
								<shiro:hasPermission name="hr:hrSalaryChange:del">
									<a href="${ctx}/hr/hrSalaryChange/delete?id=${hrSalaryChange.id}" onclick="return confirmx('确认要删除该调薪吗？', this.href)" class="btn btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i> 删除</a> 
								</shiro:hasPermission>
								</c:if>
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