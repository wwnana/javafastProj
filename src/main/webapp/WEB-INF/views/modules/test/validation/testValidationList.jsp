<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>校验测试表单列表</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	</script>
</head>
<body class="gray-bg">
	<div class="wrapper-content">
		<div class="ibox">
			<div class="ibox-title">
				<h5>校验测试表单列表 </h5>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>				
				<!-- 查询栏 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="testValidation" action="${ctx}/test/validation/testValidation/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 查询栏隐藏 -->
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
							<shiro:hasPermission name="test:validation:testValidation:add">
								<table:addRow url="${ctx}/test/validation/testValidation/form" title="校验测试表单" ></table:addRow><!-- 增加按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="test:validation:testValidation:edit">
							    <table:editRow url="${ctx}/test/validation/testValidation/form" title="校验测试表单" id="contentTable" ></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="test:validation:testValidation:del">
								<table:delRow url="${ctx}/test/validation/testValidation/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							
						</div>
					</div>
				</div>					
				<!-- 数据表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<th width="30px"><input type="checkbox" class="i-checks"></th>
							<th class="sort-column a.name">非空</th>
							<th class="sort-column a.num">金额</th>
							<th class="sort-column a.num2">整数</th>
							<th class="sort-column a.new_date">日期</th>
							<th class="sort-column a.date2">时间</th>
							<th class="sort-column a.mobile">手机号码</th>
							<th class="sort-column a.email">邮箱</th>
							<th class="sort-column a.url">网址</th>
							<th width="150px">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="testValidation">
						<tr>
							<td><input type="checkbox" id="${testValidation.id}" class="i-checks"></td>
							<td>
								<a href="#" onclick="openDialogView('查看校验测试表单', '${ctx}/test/validation/testValidation/view?id=${testValidation.id}','800px', '500px')">
								${testValidation.name}
							</a></td>
							<td>
								${testValidation.num}
							</td>
							<td>
								${testValidation.num2}
							</td>
							<td>
								<fmt:formatDate value="${testValidation.newDate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								<fmt:formatDate value="${testValidation.date2}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<td>
								${testValidation.mobile}
							</td>
							<td>
								${testValidation.email}
							</td>
							<td>
								${testValidation.url}
							</td>
							<td>
								<shiro:hasPermission name="test:validation:testValidation:view">
									<a href="#" onclick="openDialogView('查看校验测试表单', '${ctx}/test/validation/testValidation/view?id=${testValidation.id}','800px', '500px')" class="btn btn-info btn-xs" title="查看">查看</a>
								</shiro:hasPermission>
								<shiro:hasPermission name="test:validation:testValidation:edit">
			    					<a href="#" onclick="openDialog('修改校验测试表单', '${ctx}/test/validation/testValidation/form?id=${testValidation.id}','800px', '500px')" class="btn btn-success btn-xs" title="修改">修改</a>
								</shiro:hasPermission>
								
								<shiro:hasPermission name="test:validation:testValidation:del">
									<a href="${ctx}/test/validation/testValidation/delete?id=${testValidation.id}" onclick="return confirmx('确认要删除该校验测试表单吗？', this.href)" class="btn btn-danger btn-xs" title="删除">删除</a> 
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