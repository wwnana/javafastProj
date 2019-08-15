<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>审批记录列表</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	</script>
</head>
<body class="gray-bg">
	<div class="wrapper-content">
		<sys:message content="${message}"/>
		<c:if test="${not empty configMsg}">
				<div class="alert alert-info">
			    	获取企业微信审批数据需要配置审批应用的Secret，请前往进行配置<a class="alert-link" href="${ctx}/sys/sysConfig/secret">立即配置</a>.
			    </div>
		</c:if>
		<div class="tabs-container">
		 	<ul class="nav nav-tabs">
		 		<li <c:if test='${hrApproval.approvalType == 1}'>class="active"</c:if>><a href="${ctx}/hr/hrApproval/list?approvalType=1">请假</a></li>
		 		<li <c:if test='${hrApproval.approvalType == 2}'>class="active"</c:if>><a href="${ctx}/hr/hrApproval/list?approvalType=2">报销</a></li>
		 		<li <c:if test='${hrApproval.approvalType == 3}'>class="active"</c:if>><a href="${ctx}/hr/hrApproval/list?approvalType=3">费用</a></li>
		 		<li <c:if test='${hrApproval.approvalType == 4}'>class="active"</c:if>><a href="${ctx}/hr/hrApproval/list?approvalType=4">出差</a></li>
		 		<li <c:if test='${hrApproval.approvalType == 5}'>class="active"</c:if>><a href="${ctx}/hr/hrApproval/list?approvalType=5">采购</a></li>
		 		<li <c:if test='${hrApproval.approvalType == 6}'>class="active"</c:if>><a href="${ctx}/hr/hrApproval/list?approvalType=6">加班</a></li>
		 		<li <c:if test='${hrApproval.approvalType == 7}'>class="active"</c:if>><a href="${ctx}/hr/hrApproval/list?approvalType=7">外出</a></li>
		 		<li <c:if test='${hrApproval.approvalType == 8}'>class="active"</c:if>><a href="${ctx}/hr/hrApproval/list?approvalType=8">用章</a></li>
		 		<li <c:if test='${hrApproval.approvalType == 9}'>class="active"</c:if>><a href="${ctx}/hr/hrApproval/list?approvalType=9">付款</a></li>
		 		<li <c:if test='${hrApproval.approvalType == 10}'>class="active"</c:if>><a href="${ctx}/hr/hrApproval/list?approvalType=10">用车</a></li>
		 		<li <c:if test='${hrApproval.approvalType == 11}'>class="active"</c:if>><a href="${ctx}/hr/hrApproval/list?approvalType=11">绩效</a></li>
		 		<li <c:if test='${hrApproval.approvalType == 20}'>class="active"</c:if>><a href="${ctx}/hr/hrApproval/list?approvalType=20">补卡 </a></li>
		 		<li class="pull-right">
		 			<div style="margin:5px;">
		 				<a href="${ctx}/hr/hrApproval/export" title="导出" class="btn btn-white btn-bitbucket pull-right"><i class="fa fa-file-excel-o"></i> 导出</a>
		 				<a id="searchBtn" class="btn btn-white btn-bitbucket" title="搜索"><i class="fa fa-search"></i> 搜索</a>
		 				<a href="${ctx}/sys/sysConfig/secret" title="设置" class="btn btn-white btn-bitbucket pull-right"><i class="fa fa-cog"></i> 设置</a>
		 			</div>
		 		</li>
		 	</ul>
		 	<div class="tab-content">
		 		<div id="tab-1" class="tab-pane active">
		 			<div class="panel-body">
						<!-- 查询栏 -->
						<div class="row">
							<div class="col-sm-12">
								<form:form id="searchForm" modelAttribute="hrApproval" action="${ctx}/hr/hrApproval/" method="post" class="form-inline">
									<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
									<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
									<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
									<table:searchRow></table:searchRow><!-- 查询栏隐藏 -->
									<form:hidden path="approvalType"/>
										<div class="form-group"><span>日期：</span>
											<div class="input-group date datepicker">
						                     	<input name="startDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${hrApproval.startDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
						                     	<span class="input-group-addon">
						                             <span class="fa fa-calendar"></span>
						                     	</span>
									        </div>
									         - 
									        <div class="input-group date datepicker">
						                     	<input name="endDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${hrApproval.endDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
						                     	<span class="input-group-addon">
						                             <span class="fa fa-calendar"></span>
						                     	</span>
									        </div>
										</div>
										<div class="form-group"><span>部门：</span>
											<sys:treeselect id="office" name="office.id" value="${hrApproval.office.id}" labelName="office.name" labelValue="${hrApproval.office.name}"
												title="部门" url="/sys/office/treeData?type=2" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
										</div>
										
										<div class="form-group"><span>状态：</span>
											<form:select path="spStatus" class="form-control input-small">
												<form:option value="" label="全部"/>
												<form:options items="${fns:getDictList('common_audit_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
											</form:select>
										</div>
										<div class="form-group"><span>用户：</span>
											<sys:treeselect id="user" name="user.id" value="${hrApproval.user.id}" labelName="user.name" labelValue="${hrApproval.user.name}"
												title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
										</div>
										<div class="form-group">
											<button class="btn btn-white btn-sm " onclick="search()"><i class="fa fa-search"></i> 查询</button>
											<button class="btn btn-white btn-sm " onclick="resetSearch()"><i class="fa fa-refresh"></i> 重置</button>
										</div>
								</form:form>
							</div>
						</div>
						<!-- 数据表格 -->
						<div class="table-responsive">
						<table id="contentTable" class="table table-bordered table-striped table-hover">
							<thead>
								<tr>
									<th width="100px">审批编号</th>
									<th>审批名称</th>
									<th width="160px">提交时间</th>
									<th width="100px">申请人</th>
									<th width="150px">申请人部门</th>	
									
									<c:if test="${hrApproval.approvalType == 1}">
									<th width="100px">请假类型</th>	
									</c:if>
									<c:if test="${hrApproval.approvalType == 2}">
									<th width="100px">报销类型</th>	
									<th width="100px">报销金额</th>	
									</c:if>
									<c:if test="${hrApproval.approvalType == 20}">
									<th width="100px">补卡时间</th>	
									</c:if>
															
									<th width="100px">审批状态</th>									
									<th width="100px">操作</th>
								</tr>
							</thead>
							<tbody>
							<c:forEach items="${page.list}" var="hrApproval">
								<tr>
									<td>
										<a href="#" onclick="openDialogView('查看审批记录', '${ctx}/hr/hrApproval/view?id=${hrApproval.id}','800px', '500px')">
											${hrApproval.id}
										</a>
									</td>
									<td>
										<a href="#" onclick="openDialogView('查看审批记录', '${ctx}/hr/hrApproval/view?id=${hrApproval.id}','800px', '500px')">
											${hrApproval.name}
										</a>
									</td>
									<td>
										<fmt:formatDate value="${hrApproval.applyTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
									</td>
									<td>
										${hrApproval.applyName}
									</td>
									<td>
										${hrApproval.office.name}
									</td>
									
									<c:if test="${hrApproval.approvalType == 1}">
									<td>
										<c:if test="${hrApproval.leaveType==1}">年假</c:if>
										<c:if test="${hrApproval.leaveType==2}">事假</c:if>
										<c:if test="${hrApproval.leaveType==3}">病假</c:if>
										<c:if test="${hrApproval.leaveType==4}">调休假</c:if>
										<c:if test="${hrApproval.leaveType==5}">婚假</c:if>
										<c:if test="${hrApproval.leaveType==6}">产假</c:if>
										<c:if test="${hrApproval.leaveType==7}">陪产假</c:if>
										<c:if test="${hrApproval.leaveType==8}">其他</c:if>
									</td>
									</c:if>
									<c:if test="${hrApproval.approvalType == 2}">
									<td>
										<c:if test="${hrApproval.expenseType==1}">差旅费</c:if>
										<c:if test="${hrApproval.expenseType==2}">交通费</c:if>
										<c:if test="${hrApproval.expenseType==3}">招待费</c:if>
										<c:if test="${hrApproval.expenseType==4}">其他报销</c:if>
									</td>
									</c:if>
									<c:if test="${hrApproval.approvalType == 20}">
									<td></td>
									</c:if>
									
									<td>
										<c:if test="${hrApproval.spStatus==1}">审批中</c:if>
										<c:if test="${hrApproval.spStatus==2}">已通过</c:if>
										<c:if test="${hrApproval.spStatus==3}">已驳回</c:if>
										<c:if test="${hrApproval.spStatus==4}">已取消</c:if>
										<c:if test="${hrApproval.spStatus==6}">通过后撤销</c:if>
									</td>
									
									<td>
										<shiro:hasPermission name="hr:hrApproval:view">
											<a href="#" onclick="openDialogView('查看审批记录', '${ctx}/hr/hrApproval/view?id=${hrApproval.id}','800px', '500px')" class="btn btn-default btn-sm" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
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
		</div>
	</div> 
		 	
		 	
		 	

</body>
</html>