<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>审批管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			
		});
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#searchForm").submit();
        	return false;
        }
	</script>
</head>
<body class="">
	<div class="">
		<div class="">
			<div class="row dashboard-header gray-bg">
				<h5>审批列表 </h5>
				<div class="pull-right">
							<shiro:hasPermission name="oa:testAudit:edit">
								<table:addRow url="${ctx}/oa/testAudit/form" title="审批申请流程" label="审批申请流程" pageModel="page"></table:addRow>
							</shiro:hasPermission>
				</div>
			</div>
			<div class="ibox-content">
				
			<sys:message content="${message}"/>
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="testAudit" action="${ctx}/oa/testAudit/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<div class="form-group">
							<label>姓名：</label>
							
								<sys:treeselect id="user" name="user.id" value="${testAudit.user.id}" labelName="user.name" labelValue="${testAudit.user.name}" 
									title="用户" url="/sys/office/treeData?type=3" cssStyle="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
							</div>	
							<div class="form-group">
									<button class="btn btn-white btn-sm " onclick="search()"><i class="fa fa-search"></i> 查询</button>
									<button class="btn btn-white btn-sm " onclick="resetSearch()"><i class="fa fa-refresh"></i> 重置</button>
							</div>
						</form:form>
					</div>
				</div>
				
				
				<!-- 表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead><tr><th>姓名</th><th>部门</th><th>岗位职级</th><th>申请事由</th><th>申请时间</th><shiro:hasPermission name="oa:testAudit:edit"><th>操作</th></shiro:hasPermission></tr></thead>
					<tbody>
					<c:forEach items="${page.list}" var="testAudit">
						<tr>
							<td><a href="${ctx}/oa/testAudit/form?id=${testAudit.id}">${testAudit.user.name}</a></td>
							<td>${testAudit.office.name}</td>
							<td>${testAudit.post}</td>
							<td>${testAudit.content}</td>
							<td><fmt:formatDate value="${testAudit.createDate}" type="both" pattern="yyyy-MM-dd HH:mm:ss"/></td>
							<shiro:hasPermission name="oa:testAudit:edit"><td>
			    				<a href="${ctx}/oa/testAudit/form?id=${testAudit.id}">详情</a>
								<a href="${ctx}/oa/testAudit/delete?id=${testAudit.id}" onclick="return confirmx('确认要删除该审批吗？', this.href)">删除</a>
							</td></shiro:hasPermission>
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