<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>已办任务</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			
		});
		function page(n,s){
        	location = '${ctx}/act/task/historic/?pageNo='+n+'&pageSize='+s;
        }
	</script>
</head>
<body class="gray-bg">
<div class="wrapper-content">
		<ul class="nav nav-tabs">
						<li><a href="${ctx}/act/task/todo/">待办任务</a></li>
						<li class="active"><a href="${ctx}/act/task/historic/">已办任务</a></li>
						<%-- <li><a href="${ctx}/act/task/process/">新建任务</a></li> --%>
					</ul>
		<div class="ibox">
			
			<div class="ibox-content">
				<div class="row">
					<div class="col-sm-12">
					
					
					<sys:message content="${message}"/>
					<form:form id="searchForm" modelAttribute="act" action="${ctx}/act/task/historic/" method="get" class="form-inline">
						<div class="form-group"><label>流程类型：&nbsp;</label>
							<form:select path="procDefKey" class="input-medium">
								<form:option value="" label="全部流程"/>
								<form:options items="${fns:getDictList('act_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
							</div>
							<div class="form-group">
								<label>创建时间：</label>
								<div class="input-group date datepicker">
					                 <input name="beginDate" type="text" readonly="readonly" class="form-control input-small" 
					                 value="<fmt:formatDate value="${act.beginDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
					                 <span class="input-group-addon">
					                      <span class="fa fa-calendar"></span>
					                 </span>
								</div>
								-
								<div class="input-group date datepicker">
					                 <input name="endDate" type="text" readonly="readonly" class="form-control input-small" 
					                 value="<fmt:formatDate value="${act.endDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
					                 <span class="input-group-addon">
					                      <span class="fa fa-calendar"></span>
					                 </span>
								</div>
							</div>
							<div class="form-group">
									<button class="btn btn-white btn-sm " onclick="search()"><i class="fa fa-search"></i> 查询</button>
									<button class="btn btn-white btn-sm " onclick="resetSearch()"><i class="fa fa-refresh"></i> 重置</button>
							</div>
					</form:form>
					
					
					<table id="contentTable" class="table table-striped table-bordered table-condensed">
						<thead>
							<tr>
								<th>标题</th>
								<th>当前环节</th><%--
								<th>任务内容</th> --%>
								<th>所属项目</th>
								<th>流程名称</th>
								<th>流程版本</th>
								<th>完成时间</th>
								<th>操作</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${page.list}" var="act">
								<c:set var="task" value="${act.histTask}" />
								<c:set var="vars" value="${act.vars}" />
								<c:set var="procDef" value="${act.procDef}" /><%--
								<c:set var="procExecUrl" value="${act.procExecUrl}" /> --%>
								<c:set var="status" value="${act.status}" />
								<c:set var="project" value="${act.project}" />
								<tr>
									<td>
										<a href="${ctx}/act/task/form?taskId=${task.id}&taskName=${fns:urlEncode(task.name)}&taskDefKey=${task.taskDefinitionKey}&procInsId=${task.processInstanceId}&procDefId=${task.processDefinitionId}&status=${status}">${fns:abbr(not empty vars.map.title ? vars.map.title : task.id, 60)}</a>
									</td>
									<td>
										<a target="_blank" href="${pageContext.request.contextPath}/act/diagram-viewer?processDefinitionId=${task.processDefinitionId}&processInstanceId=${task.processInstanceId}">${task.name}</a><%--
										<a target="_blank" href="${ctx}/act/task/trace/photo/${task.processDefinitionId}/${task.executionId}">${task.name}</a>
										<a target="_blank" href="${ctx}/act/task/trace/info/${task.processInstanceId}">${task.name}</a> --%>
									</td><%--
									<td>${task.description}</td> --%>
									<td>${project.name}</td>
									<td>${procDef.name}</td>
									<td><b title='流程版本号'>V: ${procDef.version}</b></td>
									<td><fmt:formatDate value="${task.endTime}" type="both"/></td>
									<td>
										<a href="${ctx}/act/task/form?taskId=${task.id}&taskName=${fns:urlEncode(task.name)}&taskDefKey=${task.taskDefinitionKey}&procInsId=${task.processInstanceId}&procDefId=${task.processDefinitionId}&status=${status}&id=${project.id}">详情</a>
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

