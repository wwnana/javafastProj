<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>任务主页</title>
	<meta name="decorator" content="default"/>
	<style type="text/css">
	.btn-lg {
	    padding: 8px 16px;
	    font-size: 14px;
	}
	</style>
	<script type="text/javascript">
	function toView(relationType, targetId){
    	
		if(relationType == "20"){//项目		
    		window.location.href = "${ctx}/oa/oaProject/view?id="+targetId;
    	}
    	if(relationType == "0"){//客户    		
    		window.location.href = "${ctx}/crm/crmCustomer/index?id="+targetId;
    	}
    	if(relationType == "1"){
    		openDialogView("联系人", "${ctx}/crm/crmContacter/view?id="+targetId, '800px', '500px');
    	}
    	if(relationType == "3"){
    		openDialogView("商机", "${ctx}/crm/crmChance/index?id="+targetId, '800px', '500px');
    	}
    	if(relationType == "4"){//报价
    		window.location.href = "${ctx}/crm/crmQuote/view?id="+targetId;
    	}
    	if(relationType == "5"){//订单
    		window.location.href = "${ctx}/om/omContract/index?id="+targetId;
    	}
    	if(relationType == "11"){//采购单
    		window.location.href = "${ctx}/wms/wmsPurchase/view?id="+targetId;
    	}
    	if(relationType == "12"){//入库单
    		window.location.href = "${ctx}/wms/wmsInstock/view?id="+targetId;
    	}
    	if(relationType == "13"){//出库单
    		window.location.href = "${ctx}/wms/wmsOutstock/view?id="+targetId;
    	}
    }
	</script>
</head>
<body class="gray-bg">
	<div class="row border-bottom white-bg dashboard-header">
        <div class="col-sm-2">
        
        </div>
        <div class="col-sm-8">
        	<div class="text-center">
        		<span class="index-title">${oaTask.name}</span>
        	</div>
        </div>
        <div class="col-sm-2">
        	<div class="pull-right">
				<a href="${ctx}/oa/oaTask/view?id=${oaTask.id}" class="btn btn-default btn-sm" title="刷新"><i class="fa fa-refresh"></i> 刷新</a> 
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
								${fn:substring(oaTask.name, 0, 1)}
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
												<fmt:formatDate value="${oaTask.startDate}" pattern="yyyy-MM-dd"/>
												</p>
											</div>
										</div>
									</div>
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">截止日期：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												<fmt:formatDate value="${oaTask.endDate}" pattern="yyyy-MM-dd"/>
												</p>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-6">
										<div class="view-group">
											<label class="col-sm-4 control-label">状态：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												${fns:getDictLabel(oaTask.status, 'task_status', '')}
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
												${oaTask.ownBy.name}
												</p>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="col-sm-1 pull-right">
								<a href="${ctx}/oa/oaTask/form?id=${oaTask.id}" title="修改" class="btn btn-white btn-bitbucket pull-right"><i class="fa fa-edit"></i></a>
						</div>	
                    </div>
                </div>
			</div>
			
			<div class="tabs-container">
			 	<ul class="nav nav-tabs">
			 		<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">任务详情</a></li>
			 		<li><a data-toggle="tab" href="#tab-2" aria-expanded="false">查阅</a></li>
			 	</ul>
			 	<div class="tab-content">
			 		<div id="tab-1" class="tab-pane active">
			 			<div class="panel-body">
			 				<div class="form-horizontal">				 				
								
								
								
								<div class="row">
									<div class="col-sm-12">
										${oaTask.content}
									</div>
								</div>
								
								<div class="row">
									<div class="col-sm-12">
										<input type="hidden" id="files" value="${oaTask.files}" />
												<sys:ckfinder input="files" type="files" uploadPath="/file" selectMultiple="true" readonly="true"/>
									</div>
								</div>
						
							</div>
			 			</div>
			 		</div>

			 		<div id="tab-2" class="tab-pane">
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
									<c:forEach items="${oaTask.oaTaskRecordList}" var="oaTaskRecord">
										<tr>
											<td>
												${oaTaskRecord.user.name}
											</td>
											<td>
												${fns:getDictLabel(oaTaskRecord.readFlag, 'oa_notify_read', '')}
											</td>
											<td>
												<fmt:formatDate value="${oaTaskRecord.readDate}" pattern="yyyy-MM-dd"/>
											</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>	
							</div>
							<%--查阅情况 结束 --%>
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
                			
								<c:if test="${not empty oaTask.relationId}">
								<div class="row">
									<div class="col-sm-12">
										<div class="view-group">
											<label class="col-sm-4 control-label">任务类型：</label>
											<div class="col-sm-8">
												<p class="form-control-static">${fns:getDictLabel(oaTask.relationType, 'relation_type', '')}</p>
											</div>
										</div>
									</div>
									<c:if test="${not empty oaTask.relationName}">
								</div>
								<div class="row">
									<div class="col-sm-12" id="select_div">
										<div class="view-group">
											<label class="col-sm-4 control-label">关联${fns:getDictLabel(oaTask.relationType, 'relation_type', '')}：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
													<a href="#" onclick="toView('${oaTask.relationType}', '${oaTask.relationId}')">${oaTask.relationName}</a>
												</p>
											</div>
										</div>
									</div>
									</c:if>
								</div>
								</c:if>
								<div class="row">
									<div class="col-sm-12">
										<div class="view-group">
											<label class="col-sm-4 control-label">截止日期：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												<fmt:formatDate value="${oaTask.endDate}" pattern="yyyy-MM-dd"/>
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
												${fns:getDictLabel(oaTask.status, 'task_status', '')}
												</p>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-12">
										<div class="view-group">
											<label class="col-sm-4 control-label">优先级：</label>
											<div class="col-sm-8">
												<p class="form-control-static">${fns:getDictLabel(oaTask.levelType, 'level_type', '')}</p>
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
												${oaTask.createBy.name}
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
												<fmt:formatDate value="${oaTask.createDate}" pattern="yyyy-MM-dd"/>
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
												${oaTask.ownBy.name}
												</p>
											</div>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="col-sm-12">
										<div class="view-group">
											<label class="col-sm-4 control-label">抄送给：</label>
											<div class="col-sm-8">
												<p class="form-control-static">
												<c:forEach items="${oaTask.oaTaskRecordList}" var="oaTaskRecord">
													<c:if test="${oaTaskRecord.user.name != oaTask.ownBy.name}">
														${oaTaskRecord.user.name}，
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
</div>

	<div class="row dashboard-footer white-bg">
         <div class="col-sm-12">
        	<div class="text-center">
        			<div class="btn-group">
							
								<c:if test="${oaTask.status != 1}">
									<a href="${ctx}/oa/oaTask/deal?id=${oaTask.id}&status=1" onclick="return confirmx('确认要启动该任务吗？', this.href)" class="btn btn-white btn-lg" title="启动">启动</a> 
								</c:if>
								<c:if test="${oaTask.status == 1}">
									<button class="btn btn-white btn-lg" disabled="disabled">启动</button>
								</c:if>
								
								<c:if test="${oaTask.status != 2}">
									<a href="${ctx}/oa/oaTask/deal?id=${oaTask.id}&status=2" onclick="return confirmx('确认要将该任务标记为已完成吗？', this.href)" class="btn btn-white btn-lg" title="完成">完成</a> 
								</c:if>
								<c:if test="${oaTask.status == 2}">
									<button class="btn btn-white btn-lg" disabled="disabled">完成</button>
								</c:if>
								
								<c:if test="${oaTask.status != 3}">
									<a href="${ctx}/oa/oaTask/deal?id=${oaTask.id}&status=3" onclick="return confirmx('确认要关闭该任务吗？', this.href)" class="btn btn-white btn-lg" title="关闭">关闭</a>
								</c:if>
								<c:if test="${oaTask.status == 3}">
									<button class="btn btn-white btn-lg" disabled="disabled">关闭</button>
								</c:if>
						
							<shiro:hasPermission name="oa:oaTask:edit">
						    	<a href="${ctx}/oa/oaTask/form?id=${oaTask.id}" class="btn btn-white btn-lg" title="修改">修改</a>
							</shiro:hasPermission>
							<shiro:hasPermission name="oa:oaTask:del">
								<a href="${ctx}/oa/oaTask/delete?id=${oaTask.id}" onclick="return confirmx('确认要删除该任务吗？', this.href)" class="btn btn-white btn-lg" title="删除">删除</a> 
							</shiro:hasPermission>
							
							<a id="btnCancel" class="btn btn-white btn-lg" onclick="history.go(-1)">返回</a>
							</div>
							
        	</div>
        </div>
    </div>
</body>
</html>