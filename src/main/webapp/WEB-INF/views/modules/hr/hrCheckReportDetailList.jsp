<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>每日打卡明细列表</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	</script>
</head>
<body class="gray-bg">
<div class="wrapper-content">
	<c:if test="${not empty configMsg}">
	<div class="alert alert-info">
    	打卡数据来源于企业微信，获取企业微信打卡数据需要配置打卡应用的Secret，请前往进行配置<a class="alert-link" href="${ctx}/sys/sysConfig/secret">立即配置</a>.
    </div>
    </c:if>
	<div class="tabs-container">

	
		<div class="tab-content">
	 		<div id="tab-1" class="tab-pane">
	 			<div class="panel-body">
	 			
	 			</div>
	 		</div>
	 		<div id="tab-2" class="tab-pane active">
	 			<div class="panel-body">
	 				<sys:message content="${message}"/>
	 					<!-- 查询栏 --><a class="btn btn-white btn-sm" href="${ctx}/hr/hrCheckReportDetail/synch" title="同步企业微信打卡"><i class="fa fa-repeat"></i> 同步企业微信打卡</a>
						<div class="row">
							<div class="col-sm-12">
								<form:form id="searchForm" modelAttribute="hrCheckReportDetail" action="${ctx}/hr/hrCheckReportDetail/" method="post" class="form-inline">
									<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
									<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
									<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
										<div class="form-group"><span>打卡日期：</span>
											<div class="input-group date datepicker">
						                     	<input name="startDate" type="text" readonly="readonly" class="form-control input-small" value="${hrCheckReportDetail.startDate}" onclick="WdatePicker({dateFmt:'yyyyMMdd',isShowClear:true});" >
						                     	<span class="input-group-addon">
						                             <span class="fa fa-calendar"></span>
						                     	</span>
									        </div>
									         - 
									        <div class="input-group date datepicker">
						                     	<input name="endDate" type="text" readonly="readonly" class="form-control input-small" value="${hrCheckReportDetail.endDate}" onclick="WdatePicker({dateFmt:'yyyyMMdd',isShowClear:true});" >
						                     	<span class="input-group-addon">
						                             <span class="fa fa-calendar"></span>
						                     	</span>
									        </div>
										</div>
										<div class="form-group"><span>部门：</span>
											<sys:treeselect id="office" name="office.id" value="${hrCheckReportDetail.office.id}" labelName="office.name" labelValue="${hrCheckReportDetail.office.name}"
												title="部门" url="/sys/office/treeData?type=2" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
										</div>
										<div class="form-group"><span>用户：</span>
											<sys:treeselect id="user" name="user.id" value="${hrCheckReportDetail.user.id}" labelName="user.name" labelValue="${hrCheckReportDetail.user.name}"
												title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
										</div>
										<div class="form-group"><span>状态：</span>
											<form:select path="checkinStatus" class="form-control input-medium">
												<form:option value="" label=""/>
												<form:options items="${fns:getDictList('checkin_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
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
						<%-- 
						<div class="row">
							<div class="col-sm-12">
								<div class="pull-right">
									<div class="btn-group">
										<button id="searchBtn" class="btn btn-white btn-sm" title="搜索"><i class="fa fa-search"></i></button>
										<table:refreshRow></table:refreshRow>
									</div>
								</div>
								<div class="pull-left">
									<shiro:hasPermission name="hr:hrCheckReport:add">
										<table:addRow url="${ctx}/hr/hrCheckReportDetail/form" title="每日打卡明细" pageModel="page"></table:addRow><!-- 增加按钮 -->
									</shiro:hasPermission>
									<shiro:hasPermission name="hr:hrCheckReport:edit">
									    <table:editRow url="${ctx}/hr/hrCheckReportDetail/form" title="每日打卡明细" id="contentTable" pageModel="page"></table:editRow><!-- 编辑按钮 -->
									</shiro:hasPermission>
									<shiro:hasPermission name="hr:hrCheckReport:del">
										<table:delRow url="${ctx}/hr/hrCheckReportDetail/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
									</shiro:hasPermission>
									<shiro:hasPermission name="hr:hrCheckReport:import">
										<table:importExcel url="${ctx}/hr/hrCheckReportDetail/import"></table:importExcel><!-- 导入按钮 -->
									</shiro:hasPermission>
									<shiro:hasPermission name="hr:hrCheckReport:export">
							       		<table:exportExcel url="${ctx}/hr/hrCheckReportDetail/export"></table:exportExcel><!-- 导出按钮 -->
							       	</shiro:hasPermission>
								</div>
							</div>
						</div>		
						--%>			
						<!-- 数据表格 -->
						<div class="table-responsive">
						<table id="contentTable" class="table table-bordered table-striped table-hover">
							<thead>
								<tr>
									<th><input type="checkbox" class="i-checks"></th>
									<th>打卡日期</th>
									<th>姓名</th>
									<th>部门</th>
									<th>所属规则</th>
									<th class="sort-column a.checkin_type">打卡类型</th>
									<th class="sort-column a.exception_type">异常类型</th>
									<th class="sort-column a.location_title">地点</th>
									<th class="sort-column a.location_detail">详细地址</th>
									<th class="sort-column a.notes">备注</th>
									<th class="sort-column a.checkin_status">状态</th>
									<th>操作</th>
								</tr>
							</thead>
							<tbody>
							<c:forEach items="${page.list}" var="hrCheckReportDetail">
								<tr>
									<td><input type="checkbox" id="${hrCheckReportDetail.id}" class="i-checks"></td>
									<td>
										<a href="#" onclick="openDialog('打卡记录', '${ctx}/hr/hrCheckReportDetail/view?id=${hrCheckReportDetail.id}','800px', '500px')" title="查看">
											<fmt:formatDate value="${hrCheckReportDetail.sdate}" pattern="yyyy-MM-dd"/>
										</a>
									</td>
									<td>
										${hrCheckReportDetail.user.name}
									</td>
									<td>
										${hrCheckReportDetail.office.name}
									</td>
									<td>
										${hrCheckReportDetail.groupname}
									</td>
									<td>
										${hrCheckReportDetail.checkinType}
									</td>
									<td>
										${hrCheckReportDetail.exceptionType}
									</td>
									<td>
										${hrCheckReportDetail.locationTitle}
									</td>
									<td>
										${hrCheckReportDetail.locationDetail}
									</td>
									<td>
										${hrCheckReportDetail.notes}
									</td>
									<td>
										<span <c:if test='${hrCheckReportDetail.checkinStatus==1}'>class="text-danger"</c:if>>
										${fns:getDictLabel(hrCheckReportDetail.checkinStatus, 'checkin_status', '')}
										</span>
									</td>
									<td>
										<c:if test='${hrCheckReportDetail.checkinStatus==1}'>
										<shiro:hasPermission name="hr:hrCheckReport:edit">
					    					<a href="#" onclick="openDialog('校准', '${ctx}/hr/hrCheckReportDetail/form?id=${hrCheckReportDetail.id}','800px', '500px')" class="btn btn-success btn-xs" title="校准">校准</a>
										</shiro:hasPermission>
										</c:if>
										<%--
										
										
										<shiro:hasPermission name="hr:hrCheckReport:view">
											<a href="${ctx}/hr/hrCheckReportDetail/view?id=${hrCheckReportDetail.id}" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
										</shiro:hasPermission>
										<shiro:hasPermission name="hr:hrCheckReport:edit">
					    					<a href="${ctx}/hr/hrCheckReportDetail/form?id=${hrCheckReportDetail.id}" class="btn btn-success btn-xs" title="修改"><i class="fa fa-pencil"></i> 修改</a>
										</shiro:hasPermission>
										
										<shiro:hasPermission name="hr:hrCheckReport:del">
											<a href="${ctx}/hr/hrCheckReportDetail/delete?id=${hrCheckReportDetail.id}" onclick="return confirmx('确认要删除该每日打卡明细吗？', this.href)" class="btn btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i> 删除</a> 
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
		</div>
	</div>
</body>
</html>