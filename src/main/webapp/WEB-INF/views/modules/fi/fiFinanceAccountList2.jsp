<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>结算账户管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">

	</script>
</head>
<body class="gray-bg">
	<div class="">
		<div class="">
			<div class="row dashboard-header gray-bg">
				<div class="pull-left">					
					<a class="btn btn-link" href="${ctx}/fi/fiFinanceAccount/list2">结算账户列表</a>
				</div>
				<div class="pull-right">
					<a href="${ctx}/fi/fiFinanceAccount/list" class="btn btn-white btn-sm" title="列块展示"><i class="fa fa-th-large"></i></a>
					<a href="${ctx}/fi/fiFinanceAccount/list2" class="btn btn-white btn-sm active" title="列表展示"><i class="fa fa-list-ul"></i></a>
					<shiro:hasPermission name="fi:fiFinanceAccount:export">
					    <table:exportExcel url="${ctx}/fi/fiFinanceAccount/export"></table:exportExcel><!-- 导出按钮 -->
					</shiro:hasPermission>
					<shiro:hasPermission name="fi:fiFinanceAccount:add">
						<a class="btn btn-success btn-sm" href="#" onclick="openDialog('添加结算账户', '${ctx}/fi/fiFinanceAccount/form','800px', '500px')" title="添加账户"><i class="fa fa-plus"></i> 添加账户</a>
					</shiro:hasPermission>
					
				</div>			
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>
				<form:form id="searchForm" modelAttribute="fiFinanceAccount" action="${ctx}/fi/fiFinanceAccount/list2" method="post" class="">
					<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
					<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
				</form:form>
				
				<!-- 表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<th class="sort-column name">账户名称</th>
							<th width="200px">开户银行</th>
							<th width="200px">开户账号</th>
							<th width="130px" class="sort-column balance">余额</th>
							<th width="80px">是否默认</th>
							<th width="80px" class="sort-column status">状态</th>
							<th width="100px">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="fiFinanceAccount">
						<tr>
							<td><a href="#" onclick="openDialogView('查看结算账户', '${ctx}/fi/fiFinanceAccount/view?id=${fiFinanceAccount.id}','800px', '500px')">
								${fiFinanceAccount.name}
							</a></td>
							<td>
								${fiFinanceAccount.bankName}
							</td>
							<td>
								${fiFinanceAccount.bankcardNo}
							</td>
							<td>
								${fiFinanceAccount.balance}
							</td>
							<td>
								${fns:getDictLabel(fiFinanceAccount.isDefault, 'yes_no', '')}
							</td>
							<td>
								${fns:getDictLabel(fiFinanceAccount.status, 'use_status', '')}
							</td>
							<td>
								<shiro:hasPermission name="fi:fiFinanceAccount:view">
									<a href="#" onclick="openDialogView('查看结算账户', '${ctx}/fi/fiFinanceAccount/view?id=${fiFinanceAccount.id}','800px', '500px')" class="" title="查看">查看</a>
								</shiro:hasPermission>
								<shiro:hasPermission name="fi:fiFinanceAccount:edit">
			    					<a href="#" onclick="openDialog('修改结算账户', '${ctx}/fi/fiFinanceAccount/form?id=${fiFinanceAccount.id}','800px', '500px')" class="" title="修改">修改</a>
								</shiro:hasPermission>
								<%-- 
								<shiro:hasPermission name="fi:fiFinanceAccount:del">
									<a href="${ctx}/fi/fiFinanceAccount/delete?id=${fiFinanceAccount.id}" onclick="return confirmx('确认要删除该结算账户吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i>
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