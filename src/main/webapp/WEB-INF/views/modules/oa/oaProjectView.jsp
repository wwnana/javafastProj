<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>项目查看</title>
	<meta name="decorator" content="default"/>
	<style type="text/css">
	.btn-lg {
	    padding: 8px 16px;
	    font-size: 14px;
	}
	</style>
	<script type="text/javascript">		
	</script>
</head>
<body class="gray-bg">
<div class="wrapper-content">
	<div class="row ">
        <div class="col-sm-6">
        	<div class="ibox">
				<div class="ibox-title">
					<h5>项目查看</h5>
				</div>
				<div class="ibox-content">
					<sys:message content="${message}"/>
					<form:form id="inputForm" modelAttribute="oaProject" action="${ctx}/oa/oaProject/save" method="post" class="form-horizontal">
					<form:hidden path="id"/>
						<h4 class="page-header">基本信息</h4>
						<div class="row">
							<div class="col-sm-6">
								<div class="view-group">
									<label class="col-sm-4 control-label">项目编号：</label>
									<div class="col-sm-8">
										<p class="form-control-static">
										${oaProject.no}
										</p>
									</div>
								</div>
							</div>
							<div class="col-sm-6">
								<div class="view-group">
									<label class="col-sm-4 control-label">项目名称：</label>
									<div class="col-sm-8">
										<p class="form-control-static">
										${oaProject.name}
										</p>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-6">
								<div class="view-group">
									<label class="col-sm-4 control-label">开始日期：</label>
									<div class="col-sm-8">
										<p class="form-control-static">
										<fmt:formatDate value="${oaProject.startDate}" pattern="yyyy-MM-dd"/>
										</p>
									</div>
								</div>
							</div>
							<div class="col-sm-6">
								<div class="view-group">
									<label class="col-sm-4 control-label">截止日期：</label>
									<div class="col-sm-8">
										<p class="form-control-static">
										<fmt:formatDate value="${oaProject.endDate}" pattern="yyyy-MM-dd"/>
										</p>
									</div>
								</div>
							</div>
						</div>
						
						
						<div class="row">
							<div class="col-sm-6">
								<div class="view-group">
									<label class="col-sm-4 control-label">进度：</label>
									<div class="col-sm-8">
										<p class="form-control-static">
										${oaProject.schedule}%
										</p>
									</div>
								</div>
							</div>
							<div class="col-sm-6">
								<div class="view-group">
									<label class="col-sm-4 control-label">状态：</label>
									<div class="col-sm-8">
										<p class="form-control-static">
										${fns:getDictLabel(oaProject.status, 'task_status', '')}
										</p>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-6">
								<div class="view-group">
									<label class="col-sm-4 control-label">创建者：</label>
									<div class="col-sm-8">
										<p class="form-control-static">
										${oaProject.createBy.name}
										</p>
									</div>
								</div>
							</div>
							<div class="col-sm-6">
								<div class="view-group">
									<label class="col-sm-4 control-label">创建时间：</label>
									<div class="col-sm-8">
										<p class="form-control-static">
										<fmt:formatDate value="${oaProject.createDate}" pattern="yyyy-MM-dd"/>
										</p>
									</div>
								</div>
							</div>
						</div>
						<h4 class="page-header">项目成员</h4>
						<div class="row">
							<div class="col-sm-12">
								<div class="view-group">
									<label class="col-sm-2 control-label">负责人：</label>
									<div class="col-sm-10">
										<p class="form-control-static">
										${oaProject.ownBy.name}
										</p>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-12">
								<div class="view-group">
									<label class="col-sm-2 control-label">参与人：</label>
									<div class="col-sm-10">
										<p class="form-control-static">
										<c:forEach items="${oaProject.oaProjectRecordList}" var="oaTaskRecord">
											<c:if test="${oaTaskRecord.user.name != oaTask.ownBy.name}">
												${oaTaskRecord.user.name}，
											</c:if>
										</c:forEach>
										</p>
									</div>
								</div>
							</div>
						</div>
						
						<h4 class="page-header">项目详情</h4>
						<div class="row">
							<div class="col-sm-12">
								<div class="view-group">
									<div class="col-sm-12">
										<p class="form-control-static">
										${oaProject.content}
										</p>
									</div>
								</div>
							</div>
						</div>
						
						<div class="row">
							<div class="col-sm-12">
								<div class="view-group">
									<div class="col-sm-12">
										<form:hidden id="files" path="files" htmlEscape="false" maxlength="2000" />
										<sys:ckfinder input="files" type="files" uploadPath="/file" selectMultiple="true" readonly="true"/>
									</div>
								</div>
							</div>
						</div>
						
						
						<br>
					</form:form>
				</div>
			</div>
			
			
			<div class="hr-line-dashed"></div>
						<div class="form-actions">
							<div class="btn-group">
							
								<c:if test="${oaProject.status != 1}">
									<a href="${ctx}/oa/oaProject/deal?id=${oaProject.id}&status=1" onclick="return confirmx('确认要启动该项目吗？', this.href)" class="btn btn-white btn-lg" title="启动">启动</a> 
								</c:if>
								<c:if test="${oaProject.status == 1}">
									<button class="btn btn-white btn-lg" disabled="disabled">启动</button>
								</c:if>
								
								<c:if test="${oaProject.status != 2}">
									<a href="${ctx}/oa/oaProject/deal?id=${oaProject.id}&status=2" onclick="return confirmx('确认要将该项目标记为已完成吗？', this.href)" class="btn btn-white btn-lg" title="完成">完成</a> 
								</c:if>
								<c:if test="${oaProject.status == 2}">
									<button class="btn btn-white btn-lg" disabled="disabled">完成</button>
								</c:if>
								
								<c:if test="${oaProject.status != 2}">
									<a href="${ctx}/oa/oaProject/deal?id=${oaProject.id}&status=3" onclick="return confirmx('确认要关闭该项目吗？', this.href)" class="btn btn-white btn-lg" title="关闭">关闭</a>
								</c:if>
								<c:if test="${oaProject.status == 3}">
									<button class="btn btn-white btn-lg" disabled="disabled">关闭</button>
								</c:if>
						
							<shiro:hasPermission name="oa:oaProject:edit">
						    	<a href="${ctx}/oa/oaProject/form?id=${oaProject.id}" class="btn btn-white btn-lg" title="修改">修改</a>
							</shiro:hasPermission>
							<shiro:hasPermission name="oa:oaProject:del">
								<a href="${ctx}/oa/oaProject/delete?id=${oaProject.id}" onclick="return confirmx('确认要删除该项目吗？', this.href)" class="btn btn-white btn-lg" title="删除">删除</a> 
							</shiro:hasPermission>
							
							<a id="btnCancel" class="btn btn-white btn-lg" onclick="history.go(-1)">返回</a>
							</div>
						</div>
						
        </div>
        
        
        <div class="col-sm-6">
        	<!-- 明细 -->
			<div class="tabs-container">
		    	<ul class="nav nav-tabs">
					<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">关联任务</a></li>
					<li class=""><a data-toggle="tab" href="#tab-2" aria-expanded="true">查阅情况</a></li>
		    	</ul>
	          	<div class="tab-content">	          	   	
					<div id="tab-1" class="tab-pane table-responsive active">
						<div class="panel-body">
							<table id="contentTable" class="table">
								<thead>
									<tr>
										<th>任务名称</th>
										<th>进度(%)</th>
										<th>负责人</th>
										<th>完成状态</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${oaTaskList}" var="oaTask">
										<tr>
											<td>
												<a href="${ctx}/oa/oaTask/view?id=${oaTask.id}">${oaTask.name}</a>
											</td>
											<td>
												${oaTask.schedule}
											</td>
											<td>
												${oaTask.ownBy.name}
											</td>
											<td>
												${fns:getDictLabel(oaTask.status, 'task_status', '')}
											</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
							<a href="${ctx}/oa/oaTask/form?relationType=20&relationId=${oaProject.id}" class="btn btn-white btn-sm">添加任务</a>
						</div>
					</div>
					<div id="tab-2" class="tab-pane table-responsive">
						<div class="panel-body">
							<table id="contentTable" class="table">
								<thead>
									<tr>
										<th>接受人</th>
										<th>阅读标记</th>
										<th>阅读时间</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${oaProject.oaProjectRecordList}" var="oaProjectRecord">
										<tr>
											<td>
												${oaProjectRecord.user.name}
											</td>
											<td>
												${fns:getDictLabel(oaProjectRecord.readFlag, 'oa_notify_read', '')}
											</td>
											<td>
												<fmt:formatDate value="${oaProjectRecord.readDate}" pattern="yyyy-MM-dd"/>
											</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>					
						</div>
					</div>
				</div>
			</div>
        </div>

</div>
</body>
</html>