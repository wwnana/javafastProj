<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>工资明细列表</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	</script>
</head>
<body class="gray-bg">
	<div class="wrapper-content">
		<div class="ibox">
			<div class="ibox-title">
				<h5>工资明细列表 </h5>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>				
				<!-- 查询栏 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="hrSalaryDetail" action="${ctx}/hr/hrSalaryDetail/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 查询栏隐藏 -->
								<div class="form-group"><span>员工：</span>
									<form:input path="hrEmployeeId" htmlEscape="false" maxlength="30" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>姓名：</span>
									<form:input path="name" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
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
							<shiro:hasPermission name="hr:hrSalaryDetail:add">
								<table:addRow url="${ctx}/hr/hrSalaryDetail/form" title="工资明细" pageModel="page"></table:addRow><!-- 增加按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="hr:hrSalaryDetail:edit">
							    <table:editRow url="${ctx}/hr/hrSalaryDetail/form" title="工资明细" id="contentTable" pageModel="page"></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="hr:hrSalaryDetail:del">
								<table:delRow url="${ctx}/hr/hrSalaryDetail/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="hr:hrSalaryDetail:import">
								<table:importExcel url="${ctx}/hr/hrSalaryDetail/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="hr:hrSalaryDetail:export">
					       		<table:exportExcel url="${ctx}/hr/hrSalaryDetail/export"></table:exportExcel><!-- 导出按钮 -->
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
							<th class="sort-column a.name">姓名</th>
							<th class="sort-column a.must_work_days">应出勤天数</th>
							<th class="sort-column a.real_work_days">实际出勤天数</th>
							<th class="sort-column a.extra_work_days">加班天数</th>
							<th class="sort-column a.leave_days">请假天数</th>
							<th class="sort-column a.absent_days">旷工天数</th>
							<th class="sort-column a.base_salary">基本工资</th>
							<th class="sort-column a.post_salary">岗位工资</th>
							<th class="sort-column a.bonus_salary">奖金</th>
							<th class="sort-column a.overtime_salary">加班费</th>
							<th class="sort-column a.should_amt">应发合计</th>
							<th class="sort-column a.social_amt">社保</th>
							<th class="sort-column a.fund_amt">公积金</th>
							<th class="sort-column a.tax_amt">个税</th>
							<th class="sort-column a.seduct_salary">应扣工资</th>
							<th class="sort-column a.real_amt">实发工资</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="hrSalaryDetail">
						<tr>
							<td><input type="checkbox" id="${hrSalaryDetail.id}" class="i-checks"></td>
							<td>
								<a href="${ctx}/hr/hrSalaryDetail/view?id=${hrSalaryDetail.id}" title="查看">
								${hrSalaryDetail.name}
							</a></td>
							<td>
								${hrSalaryDetail.mustWorkDays}
							</td>
							<td>
								${hrSalaryDetail.realWorkDays}
							</td>
							<td>
								${hrSalaryDetail.extraWorkDays}
							</td>
							<td>
								${hrSalaryDetail.leaveDays}
							</td>
							<td>
								${hrSalaryDetail.absentDays}
							</td>
							<td>
								${hrSalaryDetail.baseSalary}
							</td>
							<td>
								${hrSalaryDetail.postSalary}
							</td>
							<td>
								${hrSalaryDetail.bonusSalary}
							</td>
							<td>
								${hrSalaryDetail.overtimeSalary}
							</td>
							<td>
								${hrSalaryDetail.shouldAmt}
							</td>
							<td>
								${hrSalaryDetail.socialAmt}
							</td>
							<td>
								${hrSalaryDetail.fundAmt}
							</td>
							<td>
								${hrSalaryDetail.taxAmt}
							</td>
							<td>
								${hrSalaryDetail.seductSalary}
							</td>
							<td>
								${hrSalaryDetail.realAmt}
							</td>
							<td>
								<shiro:hasPermission name="hr:hrSalaryDetail:view">
									<a href="${ctx}/hr/hrSalaryDetail/view?id=${hrSalaryDetail.id}" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
								</shiro:hasPermission>
								<shiro:hasPermission name="hr:hrSalaryDetail:edit">
			    					<a href="${ctx}/hr/hrSalaryDetail/form?id=${hrSalaryDetail.id}" class="btn btn-success btn-xs" title="修改"><i class="fa fa-pencil"></i> 修改</a>
								</shiro:hasPermission>
								
								<shiro:hasPermission name="hr:hrSalaryDetail:del">
									<a href="${ctx}/hr/hrSalaryDetail/delete?id=${hrSalaryDetail.id}" onclick="return confirmx('确认要删除该工资明细吗？', this.href)" class="btn btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i> 删除</a> 
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