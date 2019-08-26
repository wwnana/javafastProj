<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>项目主页</title>
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
	<div class="row border-bottom white-bg dashboard-header">
        <div class="col-sm-2">
        
        </div>
        <div class="col-sm-8">
        	<div class="text-center">
        		<span class="index-title">${oaProject.name}</span>
        	</div>
        </div>
        <div class="col-sm-2">
        	<div class="pull-right">
				<a href="${ctx}/oa/oaProject/view?id=${oaProject.id}" class="btn btn-default btn-sm" title="刷新"><i class="fa fa-refresh"></i> 刷新</a> 
        	</div>
        </div>
        <br><br>
    </div>
    <sys:message content="${message}"/>
<div class="wrapper-content pb80">
	<div class="row">
		<div class="col-sm-9">
			<div class="ibox float-e-margins hide">
				
                <div class="panel-body">
                    <div class="row">
						<div class="col-sm-2 text-center">
							<button class="btn btn-success btn-circle btn-lg pull-right" style="width: 100px;height: 100px;border-radius: 50px;font-size: 50px;" type="button">
								${fn:substring(oaProject.name, 0, 1)}
                            </button>
                    	</div>
						<div class="col-sm-9">
							<div class="form-horizontal">								
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
							</div>
						</div>
						<div class="col-sm-1 pull-right">
								<a href="${ctx}/oa/oaProject/form?id=${oaProject.id}" title="修改" class="btn btn-white btn-bitbucket pull-right"><i class="fa fa-edit"></i></a>
						</div>	
                    </div>
                </div>
			</div>
			
			<div class="tabs-container">
			 	<ul class="nav nav-tabs">
			 		<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">项目详情</a></li>
			 		<li><a data-toggle="tab" href="#tab-2" aria-expanded="false">任务 <span class="badge badge-info"><c:if test="${fn:length(oaTaskList)>0}">${fn:length(oaTaskList)}</c:if></span></a></li>
			 		<li><a data-toggle="tab" href="#tab-3" aria-expanded="false">查阅</a></li>
			 		<li><a data-toggle="tab" href="#tab-4" aria-expanded="false">流程模板</a></li>
			 	</ul>
			 	<div class="tab-content">
			 		<div id="tab-1" class="tab-pane active">
			 			<div class="panel-body">
			 				<div class="form-horizontal">				 				

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
												<input type="hidden" id="files" value="${oaProject.files }" />
												<sys:ckfinder input="files" type="files" uploadPath="/file" selectMultiple="true" readonly="true"/>
											</div>
										</div>
									</div>
								</div>
						
							</div>
			 			</div>
			 		</div>
			 		<div id="tab-2" class="tab-pane">
			 			<div class="panel-body">
			 				<%--任务 开始 --%>
			 				<div class="row">
				 				<div class="col-sm-12 m-b-sm">
					   					<a href="${ctx}/oa/oaTask/form?relationType=20&relationId=${oaProject.id}" class="btn btn-white btn-sm" title="添加任务"><i class="fa fa-plus"></i>
											<span class="hidden-xs">添加任务</span></a>
								</div>
							</div>
							<div class="table-responsive">
							<table id="contentTable" class="table table-bordered table-striped table-hover">
								<thead>
									<tr>
										<th width="30px"><input type="checkbox" class="i-checks"></th>
										<th>任务名称</th>
										<th width="100px">负责人</th>
										
										<th width="100px">截止日期</th>
										<th width="100px">优先级</th>
										
										<th width="100px">任务状态</th>
										<th width="200px">操作</th>
									</tr>
								</thead>
								<tbody>
								<c:forEach items="${oaTaskList}" var="oaTask">
									<tr>
										<td><input type="checkbox" id="${oaTask.id}" class="i-checks"></td>
										<td>
											<a href="${ctx}/oa/oaTask/view?id=${oaTask.id}">${oaTask.name}</a>
										</td>
										<td>
											${oaTask.ownBy.name}
										</td>
										
										<td>
											<fmt:formatDate value="${oaTask.endDate}" pattern="yyyy-MM-dd"/>
										</td>
										<td>
											<span class="<c:if test='${oaTask.levelType == 2}'>badge badge-danger</c:if><c:if test='${oaTask.levelType == 1}'>badge badge-warning</c:if><c:if test='${oaTask.levelType == 0}'>badge badge-info</c:if>">
												${fns:getDictLabel(oaTask.levelType, 'level_type', '')}
											</span>
										</td>
										<td>
											<span class="<c:if test='${oaTask.status == 1}'>text-success</c:if><c:if test='${oaTask.status == 2}'>text-info</c:if><c:if test='${oaTask.status == 3}'>text-muted</c:if>">
											${fns:getDictLabel(oaTask.status, 'task_status', '')}
											</span>
										</td>
			
										<td>
											 
												<c:if test="${oaTask.status != 1}">
													<a href="${ctx}/oa/oaTask/deal?id=${oaTask.id}&status=1&proId=${oaTask.relationId}" onclick="return confirmx('确认要启动该任务吗？', this.href)" title="启动">开始</a>
												</c:if>
												<c:if test="${oaTask.status == 1}">
													<span class="text-muted">开始</span>
												</c:if>
												
												<c:if test="${oaTask.status != 2}">
													<a href="${ctx}/oa/oaTask/deal?id=${oaTask.id}&status=2&proId=${oaTask.relationId}" onclick="return confirmx('确认要将该任务标记为已完成吗？', this.href)" title="完成">完成</a>
												</c:if>
												<c:if test="${oaTask.status == 2}">
													<span class="text-muted">完成</span>
												</c:if>
												
												<c:if test="${oaTask.status != 3}">
													<a href="${ctx}/oa/oaTask/deal?id=${oaTask.id}&status=3&proId=${oaTask.relationId}" onclick="return confirmx('确认要关闭该任务吗？', this.href)" title="关闭">关闭</a>
												</c:if>
												<c:if test="${oaTask.status == 3}">
													<span class="text-muted">关闭</span>
												</c:if>
											
											<shiro:hasPermission name="oa:oaTask:edit">
						    					<a href="${ctx}/oa/oaTask/form?id=${oaTask.id}"  title="修改">修改</a>
												<a href="${ctx}/oa/oaTask/delete?id=${oaTask.id}" onclick="return confirmx('确认要删除该任务吗？', this.href)" title="删除">删除</a>
											</shiro:hasPermission>
										</td>
									</tr>
								</c:forEach>
								</tbody>
							</table>
							</div>
							<%--任务 结束 --%>
			 			</div>
			 		</div>
			 		<div id="tab-3" class="tab-pane">
			 			<div class="panel-body">
			 				<%--查阅情况 开始 --%>
			 				<div class="table-responsive">
							<table id="contentTable" class="table table-bordered table-striped table-hover">
								<thead>
									<tr>
										<th width="33%">接受人</th>
										<th width="33%">阅读标记</th>
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
							<%--查阅情况 结束 --%>
			 			</div>
			 		</div>
					<div id="tab-4" class="tab-pane">
			 			<div class="panel-body">
			 				<div class="table-responsive">
			 				
			 				<table id="contentTable" class="table table-bordered table-striped table-hover">
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
									<td><a target="_blank" href="${ctx}/act/task/processPic?procDefId=${process.id}">${process.diagramResourceName}</a><%--
										<a target="_blank" href="${ctx}/act/process/resource/read?procDefId=${process.id}&resType=image">${process.diagramResourceName}</a>--%></td>
									<td><b title='流程版本号'>V: ${process.version}</b></td>
									<td><fmt:formatDate value="${deployment.deploymentTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
									<td>
										<a href="${ctx}/act/task/form?procDefId=${process.id}&id=${oaProject.id}">启动流程</a>
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
		
		</div>
		</div>
		<div class="col-sm-3">
			
            <div class="ibox float-e-margins">
                <div class="ibox-title">                        
                    <h5>基本信息 </h5>
                    <div class="ibox-tools">
                    	<c:if test="${not empty diffDay && diffDay == 0}">
                    		<span class="badge badge-warning">今日到期</span>
                    	</c:if>
                    	<c:if test="${not empty diffDay && diffDay > 0}">
                    		<span class="badge badge-info">${diffDay}天后到期</span>
                    	</c:if>
                    </div> 
                </div>
                <div class="ibox-content">
                	<div class="form-horizontal" style="margin: 0 !important;">
                			
								
								
								<div class="row">
									<div class="col-sm-12">
										<div class="view-group">
											<label class="col-sm-4 control-label">开始日期：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												<fmt:formatDate value="${oaProject.startDate}" pattern="yyyy-MM-dd"/>
												</p>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-12">
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
									<div class="col-sm-12">
										<div class="view-group">
											<label class="col-sm-4 control-label">状态：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
													<span class="<c:if test='${oaProject.status == 1}'>text-success</c:if><c:if test='${oaProject.status == 2}'>text-info</c:if><c:if test='${oaProject.status == 3}'>text-muted</c:if>">
														${fns:getDictLabel(oaProject.status, 'task_status', '')}
													</span>
												</p>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-12">
										<div class="view-group">
											<label class="col-sm-4 control-label">进度：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${oaProject.schedule}%
												</p>
											</div>
										</div>
									</div>
								</div>								
								<div class="row">
									<div class="col-sm-12">
										<div class="view-group">
											<label class="col-sm-4 control-label">创建者：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${oaProject.createBy.name}
												</p>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-12">
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
								<div class="row">
									<div class="col-sm-12">
										<div class="view-group">
											<label class="col-sm-4 control-label">负责人：</label>
											<div class="col-sm-8">
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
											<label class="col-sm-4 control-label">参与人：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												<c:forEach items="${oaProject.oaProjectRecordList}" var="oaProjectRecord">
													<c:if test="${oaProjectRecord.user.name != oaProject.ownBy.name}">
														${oaProjectRecord.user.name}，
													</c:if>
												</c:forEach>
												</p>
											</div>
										</div>
									</div>
								</div>
							</div>
                	
                </div>
            </div>    
			<div class="ibox float-e-margins">
				<div class="ibox-title">                        
                    <h5>历史记录</h5>
                </div>
                 <div class="ibox-content timeline">       
               		<c:forEach items="${sysDynamicList }" var="sysDynamic">
                       	<div class="timeline-item">
                            <div class="row">
                                <div class="col-xs-3 date">
                                    <i class="fa fa-circle-thin text-navy"></i> ${sysDynamic.createBy.name}<br>
                                    <small><fmt:formatDate value="${sysDynamic.createDate}" pattern="yyyy-MM-dd"/> <br><fmt:formatDate value="${sysDynamic.createDate}" pattern="HH:mm"/></small>
                                </div>
                                <div class="col-xs-7 content">
                                    <p class="m-b-xs"><i>${fns:getDictLabel(sysDynamic.actionType, 'action_type', '')}了</i> <strong>${fns:getDictLabel(sysDynamic.objectType, 'object_type', '')} </strong></p>
                                    <p class="small"><a href="#" onclick="toView('${sysDynamic.objectType}','${sysDynamic.targetId}');">${sysDynamic.targetName}</a></p>
                                </div>
                            </div>
                        </div>	
                    </c:forEach>

                    </div>
			</div>
		</div>
		
</div>

	<div class="row dashboard-footer white-bg">
         <div class="col-sm-12">
        	<div class="text-center">
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
								
								<c:if test="${oaProject.status != 3}">
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
    </div>
</div>
</body>
</html>