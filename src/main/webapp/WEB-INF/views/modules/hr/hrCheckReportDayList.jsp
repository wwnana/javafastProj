<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>每日打卡汇总列表</title>
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
	 	<ul class="nav nav-tabs">
	 		<li class="active"><a href="${ctx}/hr/hrCheckReportDay/">按日统计</a></li>
	 		<li><a href="${ctx}/hr/hrCheckReport/">按月统计</a></li>
	 		<li class="pull-right">
	 			<div style="margin:5px;">
	 				<shiro:hasPermission name="hr:hrCheckReport:export">
	 					<table:exportExcel url="${ctx}/hr/hrCheckReportDay/export" label="导出日报"></table:exportExcel><!-- 导出按钮 -->
	 				</shiro:hasPermission>
	 				<shiro:hasPermission name="hr:hrCheckReport:list">
	 					<a href="${ctx}/hr/hrCheckRule/" class="btn btn-white btn-sm"><i class="fa fa-cog"></i> 打卡规则</a>
	 				</shiro:hasPermission>
	 			</div>
		 	</li>
	 	</ul>
	
		<div class="tab-content">
	 		
	 		<div id="tab-1" class="tab-pane active">
	 			<div class="panel-body">
	 				<sys:message content="${message}"/>	
					<!-- 查询栏 -->
						<div class="row">
							<div class="col-sm-12">
								<form:form id="searchForm" modelAttribute="hrCheckReportDay" action="${ctx}/hr/hrCheckReportDay/" method="post" class="form-inline">
									<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
									<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
									<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
										<div class="form-group"><span>日期：</span>
											<div class="input-group date datepicker">
						                     	<input name="startDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${hrCheckReportDay.startDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
						                     	<span class="input-group-addon">
						                             <span class="fa fa-calendar"></span>
						                     	</span>
									        </div>
									         - 
									        <div class="input-group date datepicker">
						                     	<input name="endDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${hrCheckReportDay.endDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
						                     	<span class="input-group-addon">
						                             <span class="fa fa-calendar"></span>
						                     	</span>
									        </div>
										</div>
										<div class="form-group"><span>部门：</span>
											<sys:treeselect id="office" name="office.id" value="${hrCheckReportDay.office.id}" labelName="office.name" labelValue="${hrCheckReportDay.office.name}"
												title="部门" url="/sys/office/treeData?type=2" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="false"/>
										</div>
										
										<div class="form-group"><span>状态：</span>
											<form:select path="checkinStatus" class="form-control input-small">
												<form:option value="" label="全部"/>
												<form:options items="${fns:getDictList('checkin_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
											</form:select>
										</div>
										
										<div class="form-group"><span>用户：</span>
											<form:select path="user.id" class="form-control input-small">
												<form:option value="" label=""/>
												<form:options items="${fns:getUserList()}" itemLabel="name" itemValue="id" htmlEscape="false"/>
										    </form:select>
				    						<%-- 
											<sys:treeselect id="user" name="user.id" value="${hrCheckReportDay.user.id}" labelName="user.name" labelValue="${hrCheckReportDay.user.name}"
												title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
												--%>
										</div>
										<div class="form-group">
											<button class="btn btn-white btn-sm " onclick="search()"><i class="fa fa-search"></i> 查询</button>
											<button class="btn btn-white btn-sm " onclick="resetSearch()"><i class="fa fa-refresh"></i> 重置</button>
										</div>
								</form:form>
							</div>
						</div>
						<%-- 
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
									<shiro:hasPermission name="hr:hrCheckReport:add">
										<table:addRow url="${ctx}/hr/hrCheckReportDay/form" title="每日打卡汇总" ></table:addRow><!-- 增加按钮 -->
									</shiro:hasPermission>
									<shiro:hasPermission name="hr:hrCheckReport:edit">
									    <table:editRow url="${ctx}/hr/hrCheckReportDay/form" title="每日打卡汇总" id="contentTable" ></table:editRow><!-- 编辑按钮 -->
									</shiro:hasPermission>
									<shiro:hasPermission name="hr:hrCheckReport:del">
										<table:delRow url="${ctx}/hr/hrCheckReportDay/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
									</shiro:hasPermission>
									<shiro:hasPermission name="hr:hrCheckReport:import">
										<table:importExcel url="${ctx}/hr/hrCheckReportDay/import"></table:importExcel><!-- 导入按钮 -->
									</shiro:hasPermission>
									<shiro:hasPermission name="hr:hrCheckReport:export">
							       		<table:exportExcel url="${ctx}/hr/hrCheckReportDay/export"></table:exportExcel><!-- 导出按钮 -->
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
									<%-- <th><input type="checkbox" class="i-checks"></th>--%>
									<th>日期</th>
									<th>姓名</th>
									<th>部门</th>
									<th>所属规则</th>
									<th>最早</th>
									<th>最晚</th>
									<th>次数</th>
									<th>工作时长</th>
									<th>审批单</th>
									<th>状态</th>
									<th>校准状态</th>
									<%--<th width="100px">操作</th>--%>
								</tr>
							</thead>
							<tbody>
							<c:forEach items="${page.list}" var="hrCheckReportDay">
								<tr>
									<%-- <td><input type="checkbox" id="${hrCheckReportDay.id}" class="i-checks"></td>--%>
									<td>
										<a href="#" onclick="openDialogView('<fmt:formatDate value="${hrCheckReportDay.checkinDate}" pattern="yyyy-MM-dd"/>打卡记录', '${ctx}/hr/hrCheckReportDay/view?id=${hrCheckReportDay.id}','700px', '400px')">
												<fmt:formatDate value="${hrCheckReportDay.checkinDate}" pattern="yyyy-MM-dd"/>
										</a>
									</td>
									<td>
										${hrCheckReportDay.user.name}
									</td>
									<td>
										${hrCheckReportDay.office.name}
									</td>
									<td>
										${hrCheckReportDay.groupname}
									</td>
									<td>
										<fmt:formatDate value="${hrCheckReportDay.firstCheckinTime}" pattern="HH:mm"/>
									</td>
									<td>
										<fmt:formatDate value="${hrCheckReportDay.lastCheckinTime}" pattern="HH:mm"/>
									</td>
									<td>
										<a href="#" onclick="openDialogView('<fmt:formatDate value="${hrCheckReportDay.checkinDate}" pattern="yyyy-MM-dd"/>打卡记录', '${ctx}/hr/hrCheckReportDay/view?id=${hrCheckReportDay.id}','700px', '400px')" class="btn btn-success btn-xs">
										${hrCheckReportDay.checkinNum}
										</a>

									</td>
									<td>
										${hrCheckReportDay.workHours/3600}
									</td>
									<td>
										<c:if test="${not empty hrCheckReportDay.hrApproval.id}">
										<a href="#" onclick="openDialogView('查看审批记录', '${ctx}/hr/hrApproval/view?id=${hrCheckReportDay.hrApproval.id}','800px', '500px')">
											${fns:abbr(hrCheckReportDay.hrApproval.name,10)}
											<c:if test="${hrCheckReportDay.hrApproval.approvalType==1}">${hrCheckReportDay.hrApproval.leaveDuration/24}天</c:if>
										</a>
										</c:if>
										<c:if test="${empty hrCheckReportDay.hrApproval.id}">
											--
										</c:if>
									</td>
									<td>
										<a href="#" onclick="openDialogView('查看每日打卡汇总', '${ctx}/hr/hrCheckReportDay/view?id=${hrCheckReportDay.id}','800px', '500px')" title="查看">
										<span <c:if test='${hrCheckReportDay.checkinStatus==1}'>class="text-danger"</c:if>>
											${fns:getDictLabel(hrCheckReportDay.checkinStatus, 'checkin_status', '')} &nbsp;
										</span>
										</a>
									</td>
									<td>
										<span <c:if test='${hrCheckReportDay.auditStatus==1}'>class="text-danger"</c:if>>
											${fns:getDictLabel(hrCheckReportDay.auditStatus, 'checkin_status', '')} &nbsp;
										</span>

									</td>
									<%--
									<td>
										 
										<c:if test='${hrCheckReportDay.checkinStatus==1}'>
										<shiro:hasPermission name="hr:hrCheckReport:edit">
					    					<a href="#" onclick="openDialog('校准', '${ctx}/hr/hrCheckReportDay/form?id=${hrCheckReportDay.id}','800px', '500px')" class="btn btn-success btn-xs" title="校准">校准</a>
										</shiro:hasPermission>
										</c:if>
										
										<shiro:hasPermission name="hr:hrCheckReport:view">
											<a href="#" onclick="openDialogView('查看每日打卡汇总', '${ctx}/hr/hrCheckReportDay/view?id=${hrCheckReportDay.id}','800px', '500px')" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
										</shiro:hasPermission>
										<shiro:hasPermission name="hr:hrCheckReport:edit">
					    					<a href="#" onclick="openDialog('修改每日打卡汇总', '${ctx}/hr/hrCheckReportDay/form?id=${hrCheckReportDay.id}','800px', '500px')" class="btn btn-success btn-xs" title="修改"><i class="fa fa-edit"></i> 修改</a>
										</shiro:hasPermission>
										
										<shiro:hasPermission name="hr:hrCheckReport:del">
											<a href="${ctx}/hr/hrCheckReportDay/delete?id=${hrCheckReportDay.id}" onclick="return confirmx('确认要删除该每日打卡汇总吗？', this.href)" class="btn btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i> 删除</a> 
										</shiro:hasPermission>
										
									</td>
									--%>
								</tr>
							</c:forEach>
							</tbody>
						</table>
						<table:page page="${page}"></table:page>
						</div>
				</div>
			</div>
			<div id="tab-2" class="tab-pane">
	 			<div class="panel-body">
	 				
	 			</div>
	 		</div>	
		</div>
	</div>
</div>
</body>
</html>