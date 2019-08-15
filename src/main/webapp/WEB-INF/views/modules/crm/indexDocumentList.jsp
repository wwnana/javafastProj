<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>附件列表</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
		});
	</script>
</head>
<body class="gray-bg">
	<div class="">
		<div class="ibox">
			<div class="ibox-title">
				<h5>附件列表 </h5>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 查询条件 -->
				<form:form id="searchForm" modelAttribute="crmDocument" action="${ctx}/crm/crmDocument/indexDocumentList" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
								
						</form:form>
						
				<!-- 工具栏 -->
				<div class="row">
					<div class="col-sm-12 m-b-sm">
						<div class="pull-left">
							<shiro:hasPermission name="crm:crmCustomer:add">
								<table:addRow url="${ctx}/crm/crmDocument/form?customer.id=${crmDocument.customer.id}" title="附件" target="crmContent" width="500px" height="300px"></table:addRow><!-- 增加按钮 -->
							</shiro:hasPermission>
							
					       	<table:refreshRow></table:refreshRow>
						</div>
						
					</div>
				</div>
					
				<!-- 表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<th>附件名称</th>
							<th>上传时间</th>
							<th>上传人</th>
							<th width="100px">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="crmDocument">
						<tr>
							<td>
								<a href="${crmDocument.content}" title="${crmDocument.name}" target="_blank">
								${crmDocument.name}
							</a></td>
							
							<td>
								<fmt:formatDate value="${crmDocument.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<td>
								${crmDocument.createBy.name}
							</td>
							<td>
								
								<c:if test="${fns:getUser().id == crmDocument.createBy.id}">
								<shiro:hasPermission name="crm:crmCustomer:edit">
			    					<a href="#" onclick="openDialog('修改附件', '${ctx}/crm/crmDocument/form?id=${crmDocument.id}','500px', '300px', 'crmContent')" class="btn btn-success btn-xs" title="修改"><i class="fa fa-edit"></i><span class="hidden-xs"></span></a>
								</shiro:hasPermission>
								
								<shiro:hasPermission name="crm:crmCustomer:del">
									<a href="${ctx}/crm/crmDocument/delete?id=${crmDocument.id}" onclick="return confirmx('确认要删除该附件吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i><span class="hidden-xs"></span></a> 
								</shiro:hasPermission>
								</c:if>
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