<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>企业帐户管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
		});
		//0:隐藏tip, 1隐藏box,不设置显示全部
		top.$.jBox.closeTip();
	</script>
</head>
<body class="gray-bg">
<div class="wrapper-content">
		<div class="ibox">
			<div class="ibox-title">
				<h5>企业帐户列表 </h5>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="sysAccount" action="${ctx}/sys/sysAccount/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
								<div class="form-group"><span>企业编号：</span>
									<form:input path="id" htmlEscape="false" maxlength="30" class="form-control input-small"/>
								</div>
								<div class="form-group"><span>公司名称：</span>
									<form:input path="name" htmlEscape="false" maxlength="30" class="form-control input-small"/>
								</div>
								<div class="form-group"><span>手机：</span>
									<form:input path="mobile" htmlEscape="false" maxlength="20" class="form-control input-small"/>
								</div>
								<div class="form-group"><span>管理员账号：</span>
									<form:input path="adminUserId" htmlEscape="false" maxlength="30" class="form-control input-small"/>
								</div>
								<br>
								<div class="form-group"><span>启用状态：</span>
									<form:select path="status" class="form-control input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('use_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>短信状态：</span>
									<form:select path="smsStatus" class="form-control input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>付费状态：</span>
									<form:select path="payStatus" class="form-control input-small">
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
						<div class="pull-left">
							<%--
							<shiro:hasPermission name="sys:sysAccount:add">
								<table:addRow url="${ctx}/sys/sysAccount/form" title="企业帐户"></table:addRow><!-- 增加按钮 -->
							</shiro:hasPermission>
					       	 --%>
					       <shiro:hasPermission name="sys:sysAccount:edit">
							    <table:editRow url="${ctx}/sys/sysAccount/form" title="企业帐户" id="contentTable"></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
					       <table:batchRow url="${ctx}/sys/sysAccount/useAll" id="contentTable" title="启用帐户" label="启用帐户" name="useAll"></table:batchRow>
					       <table:batchRow url="${ctx}/sys/sysAccount/unUseAll" id="contentTable" title="禁用帐户" label="禁用帐户" name="unUseAll"></table:batchRow>
					       <table:batchRow url="${ctx}/sys/sysAccount/unSmsAll" id="contentTable" title="停用短信" label="停用短信" name="unSmsAll"></table:batchRow>
					       <table:batchRow url="${ctx}/sys/sysAccount/getPermanentInfoAll" id="contentTable" title="更新企业微信的授权信息" label="更新企业微信的授权信息" name="getPermanentInfoAll"></table:batchRow>
					       <a href="${ctx}/sys/sysAccount/updateAllAccount" class="btn btn-white btn-sm">更新所有企业用户数</a>
					       <shiro:hasPermission name="sys:sysAccount:export">
					       		<table:exportExcel url="${ctx}/sys/sysAccount/export"></table:exportExcel><!-- 导出按钮 -->
					       </shiro:hasPermission>
					       <button class="btn btn-white btn-sm " data-toggle="tooltip" data-placement="left" onclick="sortOrRefresh()" title="刷新"><i class="glyphicon glyphicon-repeat"></i> 刷新</button>
						
						</div>
						
					</div>
				</div>
					
				<!-- 表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<th><input type="checkbox" class="i-checks"></th>
							<th class="sort-column id">企业编号</th>
							<th>公司名称</th>
							<th>手机</th>
							
							<th>管理员账号</th>
							<th class="sort-column max_user_num">授权用户数</th>
							<th class="sort-column now_user_num">当前用户数</th>
							<th class="sort-column status">启用状态</th>
							<th class="sort-column a.pay_status">付费状态</th>
							<th class="sort-column b.balance">帐户余额</th>
							<th class="sort-column a.sms_status">开通短信</th>
							<th>API接口授权</th>
							<th class="sort-column create_date">创建时间</th>
							<th>企业微信ID</th>
							<th>企业微信授权方应用ID</th>
							<th>永久授权码</th>
							<th>企业微信管理员</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="sysAccount">
						<tr>
							<td><input type="checkbox" id="${sysAccount.id}" class="i-checks"></td>
							<td>
								${sysAccount.id}
							</td>
							<td><a href="#" onclick="openDialogView('查看企业帐户', '${ctx}/sys/sysAccount/form?id=${sysAccount.id}','800px', '500px')">
								${sysAccount.name}
							</a></td>
							<td>
								${sysAccount.mobile}
							</td>
							
							<td>
								${sysAccount.adminUserId}
							</td>
							<td>
								${sysAccount.maxUserNum}
							</td>
							<td>
								${sysAccount.nowUserNum}
							</td>
							<td>
								${fns:getDictLabel(sysAccount.status, 'use_status', '')}
							</td>
							<td>
								<c:if test="${sysAccount.payStatus == 0}">未付费</c:if>
								<c:if test="${sysAccount.payStatus == 2}">欠费</c:if>
								<c:if test="${sysAccount.payStatus == 1}">付费</c:if>
							</td>
							<td>
								${sysAccount.balance}
							</td>
							<td>
								<c:if test="${sysAccount.smsStatus == 0}">否</c:if>
								<c:if test="${sysAccount.smsStatus == 1}">是</c:if>
							</td>
							<td>
								<c:if test="${not empty sysAccount.apiSecret }">已授权</c:if>
								<c:if test="${empty sysAccount.apiSecret }">未授权</c:if>
							</td>
							<td>
								<fmt:formatDate value="${sysAccount.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<td>
								${sysAccount.corpid}
							</td>
							<td>
								${sysAccount.agentid}
							</td>
							<td>
								<c:if test="${not empty sysAccount.permanentCode}">已获得</c:if>
							</td>
							<td>
								${sysAccount.userid}
							</td>
							<td>
								
								<shiro:hasPermission name="sys:sysAccount:view">
									<a href="#" onclick="openDialogView('查看企业帐户', '${ctx}/sys/sysAccount/form?id=${sysAccount.id}','800px', '500px')" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
								</shiro:hasPermission>
								
								<shiro:hasPermission name="sys:sysAccount:edit">
									<a href="${ctx}/sys/sysAccount/createKeySecret?id=${sysAccount.id}" onclick="return confirmx('确认要对该企业帐户授权API接口吗？', this.href)" class="btn btn-success btn-xs" title="授权API接口"><i class="fa fa-check"></i>
										<span class="hidden-xs">授权</span></a> 
								</shiro:hasPermission>
								
								<%-- 
								<shiro:hasPermission name="sys:sysAccount:edit">
			    					<a href="#" onclick="openDialog('修改企业帐户', '${ctx}/sys/sysAccount/form?id=${sysAccount.id}','800px', '500px')" class="btn btn-success btn-xs" title="修改"><i class="fa fa-edit"></i>
										<span class="hidden-xs">修改</span></a>
								</shiro:hasPermission>
								<shiro:hasPermission name="sys:sysAccount:del">
									<a href="${ctx}/sys/sysAccount/delete?id=${sysAccount.id}" onclick="return confirmx('确认要删除该企业帐户吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i>
										<span class="hidden-xs">删除</span></a> 
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