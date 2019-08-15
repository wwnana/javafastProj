<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>指令回调消息列表</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	</script>
</head>
<body class="gray-bg">
	<div class="wrapper-content">
		<div class="ibox">
			<div class="ibox-title">
				<h5>指令回调消息列表 </h5>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>				
				<!-- 查询栏 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="qwsSuiteNotice" action="${ctx}/qws/qwsSuiteNotice/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 查询栏隐藏 -->
								<div class="form-group"><span>接收时间：</span>
									<div class="input-group date datepicker">
				                     	<input name="beginCreateDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${qwsSuiteNotice.beginCreateDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
							         - 
							        <div class="input-group date datepicker">
				                     	<input name="endCreateDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${qwsSuiteNotice.endCreateDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
								</div>
								<div class="form-group"><span>处理状态：</span>
									<form:select path="status" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
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
							<shiro:hasPermission name="qws:qwsSuiteNotice:add">
								<table:addRow url="${ctx}/qws/qwsSuiteNotice/form" title="指令回调消息" pageModel="page"></table:addRow><!-- 增加按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="qws:qwsSuiteNotice:edit">
							    <table:editRow url="${ctx}/qws/qwsSuiteNotice/form" title="指令回调消息" id="contentTable" pageModel="page"></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="qws:qwsSuiteNotice:del">
								<table:delRow url="${ctx}/qws/qwsSuiteNotice/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="qws:qwsSuiteNotice:import">
								<table:importExcel url="${ctx}/qws/qwsSuiteNotice/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="qws:qwsSuiteNotice:export">
					       		<table:exportExcel url="${ctx}/qws/qwsSuiteNotice/export"></table:exportExcel><!-- 导出按钮 -->
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
							<th width="8%" class="sort-column a.suite_id">第三方应用的SuiteId</th>
							<th width="8%" class="sort-column a.info_type">消息类型</th>
							<th width="10%" class="sort-column a.auth_corp_id">授权方的corpid</th>
							<th width="10%" class="sort-column a.change_type">通讯录变更类型</th>
							<th width="10%" class="sort-column a.user_id">成员ID</th>
							<th width="10%" class="sort-column a.party_id">部门ID</th>
							<th width="10%" class="sort-column a.create_date">接收时间</th>
							<th width="10%" class="sort-column a.status">处理状态</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="qwsSuiteNotice">
						<tr>
							<td><input type="checkbox" id="${qwsSuiteNotice.id}" class="i-checks"></td>
							<td>
								<a href="${ctx}/qws/qwsSuiteNotice/view?id=${qwsSuiteNotice.id}" title="查看">
								${qwsSuiteNotice.suiteId}
							</a></td>
							<td>
								${qwsSuiteNotice.infoType}
							</td>
							<td>
								${qwsSuiteNotice.authCorpId}
							</td>
							<td>
								${qwsSuiteNotice.changeType}
							</td>
							<td>
								${qwsSuiteNotice.user.name}
							</td>
							<td>
								${qwsSuiteNotice.partyId}
							</td>
							<td>
								<fmt:formatDate value="${qwsSuiteNotice.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<td>
								${fns:getDictLabel(qwsSuiteNotice.status, 'yes_no', '')}
							</td>
							<td>
								<shiro:hasPermission name="qws:qwsSuiteNotice:view">
									<a href="${ctx}/qws/qwsSuiteNotice/view?id=${qwsSuiteNotice.id}" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
								</shiro:hasPermission>
								<shiro:hasPermission name="qws:qwsSuiteNotice:edit">
			    					<a href="${ctx}/qws/qwsSuiteNotice/form?id=${qwsSuiteNotice.id}" class="btn btn-success btn-xs" title="修改"><i class="fa fa-pencil"></i> 修改</a>
								</shiro:hasPermission>
								
								<shiro:hasPermission name="qws:qwsSuiteNotice:del">
									<a href="${ctx}/qws/qwsSuiteNotice/delete?id=${qwsSuiteNotice.id}" onclick="return confirmx('确认要删除该指令回调消息吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i> 删除</a> 
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