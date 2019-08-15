<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>联系人管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	function page(n,s){
		$("#pageNo").val(n);
		$("#pageSize").val(s);
		$("#searchForm").submit();
    	return false;
    }
	</script>
</head>
<body class="gray-bg">
<div class="">
		<div class="ibox">
			<div class="ibox-title">
				<h5>联系人列表 </h5>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				
				<!-- 工具栏 -->
				<div class="row">
						<div class="col-sm-12">
							<div class="pull-left">
								<shiro:hasPermission name="crm:crmContacter:add">
									<a href="${ctx}/crm/crmContacter/form?customer.id=${crmContacter.customer.id}" class="btn btn-white btn-sm" target="_parent">添加联系人</a>
							</shiro:hasPermission>
							<%--
							<shiro:hasPermission name="crm:crmContacter:edit">
							    <table:editRow url="${ctx}/crm/crmContacter/form" title="联系人" id="contentTable"></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							
							<shiro:hasPermission name="crm:crmContacter:del">
								<table:delRow url="${ctx}/crm/crmContacter/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							
							<shiro:hasPermission name="crm:crmContacter:import">
								<table:importExcel url="${ctx}/crm/crmContacter/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="crm:crmContacter:export">
					       		<table:exportExcel url="${ctx}/crm/crmContacter/export"></table:exportExcel><!-- 导出按钮 -->
					       	</shiro:hasPermission>
					       	
					       <button class="btn btn-white btn-sm " data-toggle="tooltip" data-placement="left" onclick="sortOrRefresh()" title="刷新"><i class="glyphicon glyphicon-repeat"></i> 刷新</button>
						 --%>
						</div>
						<%--
						<div class="pull-right">
							<button  class="btn btn-success btn-rounded btn-outline btn-sm " onclick="search()" ><i class="fa fa-search"></i> 查询</button>
							<button  class="btn btn-success btn-rounded btn-outline btn-sm " onclick="resetSearch()" ><i class="fa fa-refresh"></i> 重置</button>
						</div>
						--%>
						</div>
						
				</div>
				<!-- 表格 -->
				<div class="table-responsive"> 
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<%-- <th><input type="checkbox" class="i-checks"></th>--%>
							
							<th>姓名</th>							
							<th>职务</th>
							<th>手机</th>
							<th>电话</th>
							<th>邮箱</th>							
							<th>QQ</th>
							<th>是否首要</th>
							<th width="150px">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${list}" var="crmContacter">
						<tr>
							<%--<td><input type="checkbox" id="${crmContacter.id}" class="i-checks"></td>--%>
							<td>
								<a href="#" onclick="openDialogView('查看联系人', '${ctx}/crm/crmContacter/view?id=${crmContacter.id}','800px', '500px')">
								${crmContacter.name}
								</a>
							</td>
							<td>
								${crmContacter.jobType}
							</td>
							<td>
								${crmContacter.mobile}
							</td>
							<td>
								${crmContacter.tel}
							</td>
							<td>
								${crmContacter.email}
							</td>
							<td>
								<c:if test="${not empty crmContacter.qq}">
									<a target="_blank" href="http://wpa.qq.com/msgrd?v=3&uin=${crmContacter.qq}&site=qq&menu=yes" title="点击打开QQ对话框">
										${crmContacter.qq}
									</a>
								</c:if>
							</td>
							<td>
								<c:if test="${crmContacter.isDefault == 1}"><i class="fa fa-check text-navy"></i></c:if>
							</td>
							<td>
								<shiro:hasPermission name="crm:crmContacter:view">
									<a href="#" onclick="openDialogView('查看联系人', '${ctx}/crm/crmContacter/view?id=${crmContacter.id}','800px', '500px')" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> </a>
								</shiro:hasPermission>
								<shiro:hasPermission name="crm:crmContacter:edit">
			    					<a href="${ctx}/crm/crmContacter/form?id=${crmContacter.id}" class="btn btn-success btn-xs" title="修改" target="_parent"><i class="fa fa-edit"></i> </a>
									<a href="${ctx}/crm/crmContacter/setDefault?id=${crmContacter.id}" onclick="return confirmx('确认要将${crmContacter.name}设为首要联系人吗？', this.href)" class="btn btn-success btn-xs" title="设为首要联系人"><i class="fa fa-tag"></i></a> 
								</shiro:hasPermission>
								<shiro:hasPermission name="crm:crmContacter:del">
									<a href="${ctx}/crm/crmContacter/indexDelete?id=${crmContacter.id}" onclick="return confirmx('确认要删除该联系人吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i></a> 
								</shiro:hasPermission>
							</td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
				<br/>
				</div>
			</div>
		</div>
	</div>
</body>
</html>