<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>OFFER列表</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	</script>
</head>
<body class="gray-bg">
	<div class="wrapper-content">
		<div class="ibox">
			<div class="ibox-title">
				<h5>OFFER列表 </h5>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>				
				<!-- 查询栏 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="hrOffer" action="${ctx}/hr/hrOffer/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 查询栏隐藏 -->
								<div class="form-group"><span>简历ID：</span>
									<form:input path="hrResume.id" htmlEscape="false" maxlength="64" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>报到时间：</span>
									<div class="input-group date datepicker">
				                     	<input name="beginReportDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${hrOffer.beginReportDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
							         - 
							        <div class="input-group date datepicker">
				                     	<input name="endReportDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${hrOffer.endReportDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
								</div>
								<div class="form-group"><span>状态：</span>
									<form:select path="status" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('invite_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>创建时间：</span>
									<div class="input-group date datepicker">
				                     	<input name="beginCreateDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${hrOffer.beginCreateDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
							         - 
							        <div class="input-group date datepicker">
				                     	<input name="endCreateDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${hrOffer.endCreateDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
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
							<shiro:hasPermission name="hr:hrOffer:add">
								<table:addRow url="${ctx}/hr/hrOffer/form" title="OFFER" pageModel="page"></table:addRow><!-- 增加按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="hr:hrOffer:edit">
							    <table:editRow url="${ctx}/hr/hrOffer/form" title="OFFER" id="contentTable" pageModel="page"></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="hr:hrOffer:del">
								<table:delRow url="${ctx}/hr/hrOffer/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="hr:hrOffer:import">
								<table:importExcel url="${ctx}/hr/hrOffer/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="hr:hrOffer:export">
					       		<table:exportExcel url="${ctx}/hr/hrOffer/export"></table:exportExcel><!-- 导出按钮 -->
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
							<th class="sort-column a.hr_resume_id">简历ID</th>
							<th class="sort-column a.validity_period">有效期(天)</th>
							<th class="sort-column a.report_date">报到时间</th>
							<th class="sort-column a.probation_period">试用期</th>
							<th class="sort-column a.position">入职岗位</th>
							<th class="sort-column a.department">入职部门</th>
							<th class="sort-column a.formal_salary_base">转正工资(元)</th>
							<th class="sort-column a.probation_salary_base">试用期工资(元)</th>
							<th class="sort-column a.status">状态( 1：已发送，2：已确认)</th>
							<th class="sort-column a.create_date">创建时间</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="hrOffer">
						<tr>
							<td><input type="checkbox" id="${hrOffer.id}" class="i-checks"></td>
							<td>
								<a href="${ctx}/hr/hrOffer/view?id=${hrOffer.id}" title="查看">
								${hrOffer.hrResume.id}
							</a></td>
							<td>
								${hrOffer.validityPeriod}
							</td>
							<td>
								<fmt:formatDate value="${hrOffer.reportDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<td>
								${hrOffer.probationPeriod}
							</td>
							<td>
								${hrOffer.position}
							</td>
							<td>
								${hrOffer.department}
							</td>
							<td>
								${hrOffer.formalSalaryBase}
							</td>
							<td>
								${hrOffer.probationSalaryBase}
							</td>
							<td>
								${fns:getDictLabel(hrOffer.status, 'invite_status', '')}
							</td>
							<td>
								<fmt:formatDate value="${hrOffer.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<td>
								<shiro:hasPermission name="hr:hrOffer:view">
									<a href="${ctx}/hr/hrOffer/view?id=${hrOffer.id}" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
								</shiro:hasPermission>
								<shiro:hasPermission name="hr:hrOffer:edit">
			    					<a href="${ctx}/hr/hrOffer/form?id=${hrOffer.id}" class="btn btn-success btn-xs" title="修改"><i class="fa fa-pencil"></i> 修改</a>
								</shiro:hasPermission>
								
								<shiro:hasPermission name="hr:hrOffer:del">
									<a href="${ctx}/hr/hrOffer/delete?id=${hrOffer.id}" onclick="return confirmx('确认要删除该OFFER吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i> 删除</a> 
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