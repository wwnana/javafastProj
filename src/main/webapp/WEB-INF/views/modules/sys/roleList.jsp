<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>角色管理</title>
	<meta name="decorator" content="default"/>
</head>
<body class="">
	<div class="">
		
		<div class="">
			<div class="ibox-title">
				<h5>角色列表 </h5>
			</div>
		    <div class="ibox-content">
		    
			<sys:message content="${message}"/>
			
			<!-- 查询条件 -->
			<div class="row hide">
				<div class="col-sm-12">
				<form:form id="searchForm" modelAttribute="role" action="${ctx}/sys/role/" method="post" class="form-inline">
					<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
					<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
					<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
					<div class="form-group">
						<span>角色名称：</span>
							<form:input path="name" value="${role.name}"  htmlEscape="false" maxlength="50"  class=" form-control input-sm"/>
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
						<shiro:hasPermission name="sys:role:add">
							<table:addRow url="${ctx}/sys/role/form" title="角色" label="添加角色"></table:addRow><!-- 增加按钮 -->
						</shiro:hasPermission>
						<%--
						<shiro:hasPermission name="sys:role:edit">
						    <table:editRow url="${ctx}/sys/role/form" id="contentTable"  title="角色" pageModel="page"></table:editRow><!-- 编辑按钮 -->
						</shiro:hasPermission>
						 
						<shiro:hasPermission name="sys:role:del">
							<table:delRow url="${ctx}/sys/role/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
						</shiro:hasPermission>
						--%>
						
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
							<th style="min-width:200px;">角色名称</th>
							
							<th style="min-width:150px;width:150px;">数据范围</th>
							<th style="min-width:200px;width:200px;">操作</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${list}" var="role">
							<tr>
								<%-- <td> <input type="checkbox" id="${role.id}" class="i-checks"></td>--%>
								<td><a href="${ctx}/sys/role/view?id=${role.id}">${role.name}</a></td>
								
								<td>${fns:getDictLabel(role.dataScope, 'sys_data_scope', '无')}</td>
								<td>
									<shiro:hasPermission name="sys:role:edit"> 
									<c:if test="${(role.sysData eq fns:getDictValue('是', 'yes_no', '1') && fns:getUser().admin)||!(role.sysData eq fns:getDictValue('是', 'yes_no', '1'))}">
										<a href="#" onclick="openDialog('修改角色', '${ctx}/sys/role/form?id=${role.id}','800px', '500px')" class="" title="修改">修改</a>
									</c:if>
									</shiro:hasPermission>
									
									<shiro:hasPermission name="sys:role:assign"> 
										<a href="#" onclick="openDialog('权限设置', '${ctx}/sys/role/auth?id=${role.id}','500px', '80%')" class="" title="权限设置">权限设置</a> 
									</shiro:hasPermission>
									<shiro:hasPermission name="sys:role:assign"> 
										<a href="#" onclick="openDialogView('分配用户', '${ctx}/sys/role/assign?id=${role.id}','800px', '80%')" class="" title="分配用户">分配用户</a>
									</shiro:hasPermission>
								</td>
							</tr>
							
						</c:forEach>
						<c:if test="${fns:getSysAccount().id != '0'}">
							<tr>
								<td><a href="${ctx}/sys/role/view?id=admin">企业管理员</a></td>
								<td>所有数据</td>
								<td>
									<shiro:hasPermission name="sys:role:assign"> 
										<a href="#" onclick="openDialogView('分配用户', '${ctx}/sys/role/assign?id=${role.id}','800px', '80%')" class="" title="分配用户">分配用户</a>
									</shiro:hasPermission>
								</td>
							</tr>
						</c:if>
					</tbody>
				</table>
				</div>
				
				
	     	
			</div>
		</div>
		
	</div>
</body>
</html>