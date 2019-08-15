<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>常见问题列表</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	
	</script>
</head>
<body class="">
	<div class="">
		<div class="">
			<div class="row dashboard-header gray-bg">
				<div class="pull-left">	
							<shiro:hasPermission name="scm:scmProblem:add">
								<table:addRow url="${ctx}/scm/scmProblem/form?scmProblemType.id=${scmProblem.scmProblemType.id }" title="常见问题" pageModel="page"></table:addRow><!-- 增加按钮 -->
							</shiro:hasPermission>
							<%--
							<shiro:hasPermission name="scm:scmProblem:edit">
							    <table:editRow url="${ctx}/scm/scmProblem/form" title="常见问题" id="contentTable" pageModel="page"></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							
							<shiro:hasPermission name="scm:scmProblem:del">
								<table:delRow url="${ctx}/scm/scmProblem/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							
							 
							<shiro:hasPermission name="scm:scmProblem:import">
								<table:importExcel url="${ctx}/scm/scmProblem/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="scm:scmProblem:export">
					       		<table:exportExcel url="${ctx}/scm/scmProblem/export"></table:exportExcel><!-- 导出按钮 -->
					       	</shiro:hasPermission>
					       	--%>
					       <a href="${ctx}/scm/scmProblem/?status=0" class="btn btn-white btn-sm ">未发布</a>
					       <button class="btn btn-white btn-sm " data-toggle="tooltip" data-placement="left" onclick="sortOrRefresh()" title="刷新"><i class="glyphicon glyphicon-repeat"></i> 刷新</button>
				</div>
				<div class="pull-right">
					<form:form id="searchForm" modelAttribute="scmProblem" action="${ctx}/scm/scmProblem/" method="post" style="padding-bottom: 0;" class="pull-right form-inline">
						<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
						<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
						<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							
                    	<div class="form-group">
	                    	<div class="input-group">	
	                        	<form:input path="name"  class="form-control input-sm" placeholder="搜索问题名称"/>
	                            <div class="input-group-btn">
	                                <button id="btnSubmit" type="submit" class="btn btn-sm btn-info">
	                                    	搜索
	                                </button>
	                            </div>
	                        </div>
                        </div>
                    </form:form>
				</div>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				
					
				<!-- 表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<th>问题名称</th>
							<th width="100px" class="sort-column a.status">状态</th>
							<th width="100px" class="sort-column a.create_by">创建人</th>
							<th width="100px" class="sort-column a.create_date">创建时间</th>
							<%-- <th width="100px">操作</th>--%>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="scmProblem">
						<tr>
							<td>
								<a href="${ctx}/scm/scmProblem/view?id=${scmProblem.id}">
									${scmProblem.name}
								</a>
							</td>
							<td>
								${fns:getDictLabel(scmProblem.status, 'oa_notify_status', '')}
							</td>
							<td>
								${scmProblem.createBy.name}
							</td>
							<td>
								<fmt:formatDate value="${scmProblem.createDate}" pattern="yyyy-MM-dd"/>
							</td>
							<%-- 
							<td>
								<shiro:hasPermission name="scm:scmProblem:view">
									<a href="${ctx}/scm/scmProblem/view?id=${scmProblem.id}" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> </a>
								</shiro:hasPermission>
								<shiro:hasPermission name="scm:scmProblem:edit">
			    					<a href="${ctx}/scm/scmProblem/form?id=${scmProblem.id}" class="btn btn-success btn-xs" title="修改"><i class="fa fa-edit"></i><span class="hidden-xs"></span></a>
								</shiro:hasPermission>
								
								<shiro:hasPermission name="scm:scmProblem:del">
									<a href="${ctx}/scm/scmProblem/delete?id=${scmProblem.id}" onclick="return confirmx('确认要删除该常见问题吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i><span class="hidden-xs"></span></a> 
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
	</div>
</body>
</html>