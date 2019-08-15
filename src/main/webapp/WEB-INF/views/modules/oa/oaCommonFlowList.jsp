<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>流程配置列表</title>
	<meta name="decorator" content="default"/>

</head>
<body class="">
	<div class="">
		<div class="">
			<div class="ibox-title">
				<h5>流程配置列表 </h5>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 查询条件 -->
				<div class="row hide">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="oaCommonFlow" action="${ctx}/oa/oaCommonFlow/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
								<%-- 
								<div class="form-group"><span>审批类型：</span>
									<form:select path="type" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('common_audit_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>流程名称：</span>
									<form:input path="title" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>状态：</span>
									<form:select path="status" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('use_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								--%>
						</form:form>
					</div>
				</div>
				<!-- 工具栏 -->
				<div class="row">
					<div class="col-sm-12 m-b-sm">
						<div class="pull-left">
							<shiro:hasPermission name="oa:oaCommonFlow:list">
								<table:addRow url="${ctx}/oa/oaCommonFlow/form" title="流程配置" pageModel="page"></table:addRow><!-- 增加按钮 -->
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
							<%-- <th><input type="checkbox" class="i-checks"></th>--%>
							<th width="200px" class="sort-column a.type">审批类型</th>
							<th class="sort-column a.title">流程名称</th>
							<th width="100px" class="sort-column a.status">状态</th>
							<th width="200px">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="oaCommonFlow">
						<tr>
							<%--<td><input type="checkbox" id="${oaCommonFlow.id}" class="i-checks"></td>--%>
							<td>
								<a href="${ctx}/oa/oaCommonFlow/view?id=${oaCommonFlow.id}">
								${fns:getDictLabel(oaCommonFlow.type, 'common_audit_type', '')}
							</a></td>
							<td>
								${oaCommonFlow.title}
							</td>
							<td>
								${fns:getDictLabel(oaCommonFlow.status, 'use_status', '')}
							</td>
							<td>
								<shiro:hasPermission name="oa:oaCommonFlow:list">
									<a class="btn btn-info btn-xs" href="#" onclick="openDialog('查看流程', '${ctx}/oa/oaCommonFlow/view?id=${oaCommonFlow.id}','800px', '500px')"><i class="fa fa-search-plus"></i> 查看</a>
								</shiro:hasPermission>
								<shiro:hasPermission name="oa:oaCommonFlow:list">
			    					<a href="${ctx}/oa/oaCommonFlow/form?id=${oaCommonFlow.id}" class="btn btn-success btn-xs" title="修改"><i class="fa fa-edit"></i><span class="hidden-xs">修改</span></a>
								</shiro:hasPermission>
								
								<shiro:hasPermission name="oa:oaCommonFlow:list">
									<a href="${ctx}/oa/oaCommonFlow/delete?id=${oaCommonFlow.id}" onclick="return confirmx('确认要删除该流程配置吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i><span class="hidden-xs">删除</span></a> 
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