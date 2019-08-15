<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>工作汇报列表</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	</script>
</head>
<body class="gray-bg">
<div class="wrapper-content">
	
	<div class="tabs-container">
	 	<ul class="nav nav-tabs">
	 		<li class="active"><a href="${ctx}/oa/oaWorkLog/self">待我批阅</a></li>
	 		<li><a href="${ctx}/oa/oaWorkLog/list">我的报告</a></li>
	 		<li class="pull-right">
	 			<button onClick="javascript:window.location.href='${ctx}/oa/oaWorkLog/form'" title="新建汇报" class="btn btn-success btn-sm"><i class="fa fa-plus"></i> 新建汇报</button>		       	
		       	<shiro:hasPermission name="oa:oaWorkLogRule:list">
			    	<button onClick="javascript:window.location.href='${ctx}/oa/oaWorkLogRule/'" class="btn btn-white btn-sm" title="设置汇报规则"><i class="fa fa-cog"></i> 汇报规则</button>
				</shiro:hasPermission>
				<shiro:hasPermission name="oa:oaWorkLog:export">
		       		<table:exportExcel url="${ctx}/oa/oaWorkLog/export"></table:exportExcel><!-- 导出按钮 -->
		       	</shiro:hasPermission>
	 		</li>
	 	</ul>
	
		<div class="tab-content">
	 		
	 		<div id="tab-1" class="tab-pane active">
	 			<div class="panel-body">
	 				<sys:message content="${message}"/>	
					<!-- 查询栏 -->
						<div class="row">
							<div class="col-sm-12">
								<form:form id="searchForm" modelAttribute="oaWorkLog" action="${ctx}/oa/oaWorkLog/self" method="post" class="form-inline">
									<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
									<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
									<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
										
										<div class="form-group"><span>创建时间：</span>
											<div class="input-group date datepicker">
						                     	<input name="beginCreateDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${oaWorkLog.beginCreateDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
						                     	<span class="input-group-addon">
						                             <span class="fa fa-calendar"></span>
						                     	</span>
									        </div>
									         - 
									        <div class="input-group date datepicker">
						                     	<input name="endCreateDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${oaWorkLog.endCreateDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
						                     	<span class="input-group-addon">
						                             <span class="fa fa-calendar"></span>
						                     	</span>
									        </div>
										</div>
										<div class="form-group"><span>报告人：</span>
											<sys:treeselect id="createBy" name="createBy.id" value="${oaWorkLog.createBy.id}" labelName="ownBy.name" labelValue="${oaWorkLog.createBy.name}"
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
									
									<th >报告标题</th>
									<th width="100px" class="sort-column a.work_log_type">报告类型</th>
									<th width="100px" class="sort-column a.create_by">报告人</th>
									<th width="100px" class="sort-column a.create_date">创建时间</th>
									<th width="100px">操作</th>
								</tr>
							</thead>
							<tbody>
							<c:forEach items="${page.list}" var="oaWorkLog">
								<tr>
									
									<td>
										<a href="${ctx}/oa/oaWorkLog/view?id=${oaWorkLog.id}" title="查看">${oaWorkLog.title}</a>
									</td>
									<td>
										${fns:getDictLabel(oaWorkLog.workLogType, 'work_log_type', '')}
									</td>
									<td>
										${oaWorkLog.createBy.name}
									</td>
									<td>
										<fmt:formatDate value="${oaWorkLog.createDate}" pattern="yyyy-MM-dd"/>
									</td>
									<td>
										<a href="${ctx}/oa/oaWorkLog/view?id=${oaWorkLog.id}" title="查看">查看</a>
									</td>
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