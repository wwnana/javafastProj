<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>富文本测试列表</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	</script>
</head>
<body class="gray-bg">
	<div class="wrapper-content">
		<div class="ibox">
			<div class="ibox-title">
				<h5>富文本测试列表 </h5>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>				
				<!-- 查询栏 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="testNote" action="${ctx}/test/note/testNote/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 查询栏隐藏 -->
								<div class="form-group"><span>标题：</span>
									<form:input path="title" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
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
							<shiro:hasPermission name="test:note:testNote:add">
								<table:addRow url="${ctx}/test/note/testNote/form" title="富文本测试" pageModel="page"></table:addRow><!-- 增加按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="test:note:testNote:edit">
							    <table:editRow url="${ctx}/test/note/testNote/form" title="富文本测试" id="contentTable" pageModel="page"></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="test:note:testNote:del">
								<table:delRow url="${ctx}/test/note/testNote/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
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
							<th class="sort-column a.title">标题</th>
							<th width="200px" class="sort-column a.create_by">创建者</th>
							<th width="200px" class="sort-column a.create_date">创建时间</th>
							<th width="150px">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="testNote">
						<tr>
							<td><input type="checkbox" id="${testNote.id}" class="i-checks"></td>
							<td>
								<a href="${ctx}/test/note/testNote/view?id=${testNote.id}" title="查看">
								${testNote.title}
							</a></td>
							<td>
								${testNote.createBy.name}
							</td>
							<td>
								<fmt:formatDate value="${testNote.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<td>
								<shiro:hasPermission name="test:note:testNote:view">
									<a href="${ctx}/test/note/testNote/view?id=${testNote.id}" class="btn btn-info btn-xs" title="查看">查看</a>
								</shiro:hasPermission>
								<shiro:hasPermission name="test:note:testNote:edit">
			    					<a href="${ctx}/test/note/testNote/form?id=${testNote.id}" class="btn btn-success btn-xs" title="修改">修改</a>
								</shiro:hasPermission>
								
								<shiro:hasPermission name="test:note:testNote:del">
									<a href="${ctx}/test/note/testNote/delete?id=${testNote.id}" onclick="return confirmx('确认要删除该富文本测试吗？', this.href)" class="btn btn-danger btn-xs" title="删除">删除</a> 
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