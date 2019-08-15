<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>发起任务</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function(){
			top.$.jBox.tip.mess = null;
		});
		function page(n,s){
        	location = '${ctx}/act/task/process/?pageNo='+n+'&pageSize='+s;
        }
	</script>
</head>
<body class="gray-bg">
<div class="wrapper-content">
		<ul class="nav nav-tabs">
			<li><a href="${ctx}/act/task/todo/">待办任务</a></li>
			<li><a href="${ctx}/act/task/historic/">已办任务</a></li>
			<li class="active"><a href="${ctx}/act/task/process/">新建任务</a></li>
		</ul>
		<div class="ibox">
			
			<div class="ibox-content">
				<div class="row">
					<div class="col-sm-12">
					
					<sys:message content="${message}"/>
					<form id="searchForm" action="${ctx}/act/task/process/" method="post"  class="form-inline">
						<div class="form-group">
						<select id="category" name="category" class="form-control input-medium">
							<option value="">全部分类</option>
							<c:forEach items="${fns:getDictList('act_category')}" var="dict">
								<option value="${dict.value}" ${dict.value==category?'selected':''}>${dict.label}</option>
							</c:forEach>
						</select>
						</div>
						<div class="form-group">
									<button class="btn btn-white btn-sm " onclick="search()"><i class="fa fa-search"></i> 查询</button>
									<button class="btn btn-white btn-sm " onclick="resetSearch()"><i class="fa fa-refresh"></i> 重置</button>
							</div>
					</form>
					<table class="table table-striped table-bordered table-condensed">
						<thead>
							<tr>
								<th>流程分类</th>
								<th>流程标识</th>
								<th>流程名称</th>
								<th>流程图</th>
								<th>流程版本</th>
								<th>更新时间</th>
								<th>操作</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${page.list}" var="object">
								<c:set var="process" value="${object[0]}" />
								<c:set var="deployment" value="${object[1]}" />
								<tr>
									<td>${fns:getDictLabel(process.category,'act_category','无分类')}</td>
									<td><a href="${ctx}/act/task/form?procDefId=${process.id}">${process.key}</a></td>
									<td>${process.name}</td>
									<td>
									<a target="_blank" href="${ctx}/act/task/processPic?procDefId=${process.id}">${process.diagramResourceName}</a>
									<%-- <a target="_blank" href="${pageContext.request.contextPath}/act/diagram-viewer?processDefinitionId=${process.id}">${process.diagramResourceName}</a> --%><%--
										<a target="_blank" href="${ctx}/act/process/resource/read?procDefId=${process.id}&resType=image">${process.diagramResourceName}</a>--%>
									</td>
									<td><b title='流程版本号'>V: ${process.version}</b></td>
									<td><fmt:formatDate value="${deployment.deploymentTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
									<td>
										<a href="${ctx}/act/task/form?procDefId=${process.id}">启动流程</a>
									</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
					<table:page page="${page}"></table:page>
				<br/>
			</div>
		</div>
	</div>
</body>
</html>

