<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>知识评论列表</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
		});
	</script>
</head>
<body class="gray-bg">
	<div class="wrapper-content">
		<div class="ibox">
			<div class="ibox-title">
				<h5>知识评论列表 </h5>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="kmsComment" action="${ctx}/kms/kmsComment/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
						</form:form>
					</div>
				</div>
				<!-- 工具栏 -->
				<div class="row">
					<div class="col-sm-12 m-b-sm">
						<div class="pull-left">
							<shiro:hasPermission name="kms:kmsComment:add">
								<table:addRow url="${ctx}/kms/kmsComment/form" title="知识评论" ></table:addRow><!-- 增加按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="kms:kmsComment:edit">
							    <table:editRow url="${ctx}/kms/kmsComment/form" title="知识评论" id="contentTable" ></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="kms:kmsComment:del">
								<table:delRow url="${ctx}/kms/kmsComment/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="kms:kmsComment:import">
								<table:importExcel url="${ctx}/kms/kmsComment/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="kms:kmsComment:export">
					       		<table:exportExcel url="${ctx}/kms/kmsComment/export"></table:exportExcel><!-- 导出按钮 -->
					       	</shiro:hasPermission>
					       	<table:refreshRow></table:refreshRow>
						</div>
						<div class="pull-right">
							<button  class="btn btn-success btn-rounded btn-outline btn-sm " onclick="search()" ><i class="fa fa-search"></i> 查询</button>
							<button  class="btn btn-success btn-rounded btn-outline btn-sm " onclick="resetSearch()" ><i class="fa fa-refresh"></i> 重置</button>
						</div>
					</div>
				</div>
					
				<!-- 表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<th><input type="checkbox" class="i-checks"></th>
							<th class="sort-column a.content">评论内容</th>
							<th class="sort-column a.create_by">评论人</th>
							<th class="sort-column a.create_date">评论时间</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="kmsComment">
						<tr>
							<td><input type="checkbox" id="${kmsComment.id}" class="i-checks"></td>
							<td>
								<a href="#" onclick="openDialogView('查看知识评论', '${ctx}/kms/kmsComment/view?id=${kmsComment.id}','800px', '500px')">
								${kmsComment.content}
							</a></td>
							<td>
								${kmsComment.createBy.name}
							</td>
							<td>
								<fmt:formatDate value="${kmsComment.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<td>
								<shiro:hasPermission name="kms:kmsComment:view">
									<a href="#" onclick="openDialogView('查看知识评论', '${ctx}/kms/kmsComment/view?id=${kmsComment.id}','800px', '500px')" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
								</shiro:hasPermission>
								<shiro:hasPermission name="kms:kmsComment:edit">
			    					<a href="#" onclick="openDialog('修改知识评论', '${ctx}/kms/kmsComment/form?id=${kmsComment.id}','800px', '500px')" class="btn btn-success btn-xs" title="修改"><i class="fa fa-edit"></i><span class="hidden-xs">修改</span></a>
								</shiro:hasPermission>
								
								<shiro:hasPermission name="kms:kmsComment:del">
									<a href="${ctx}/kms/kmsComment/delete?id=${kmsComment.id}" onclick="return confirmx('确认要删除该知识评论吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i><span class="hidden-xs">删除</span></a> 
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