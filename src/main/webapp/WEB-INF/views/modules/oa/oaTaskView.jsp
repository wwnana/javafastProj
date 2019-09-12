<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>任务查看</title>
	<meta name="decorator" content="default"/>
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
<div class="wrapper-content">
	<div class="ibox">
		<div class="ibox-title">
			<h5>任务查看</h5>
		</div>
		<div class="ibox-content">
			<sys:message content="${message}"/>	
			
			<form:form id="inputForm" modelAttribute="oaTask" action="${ctx}/oa/oaTask/save" method="post" class="form-horizontal">
			<form:hidden path="id"/>
			<form:hidden path="no"/>
				
			<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-5 control-label">任务名称</label>
						<div class="col-sm-7">
							<p class="form-control-static">${oaTask.name}</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-5 control-label">任务编号</label>
						<div class="col-sm-7">
							<p class="form-control-static">${oaTask.no}</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-5 control-label">任务类型</label>
						<div class="col-sm-7">
							<p class="form-control-static">${fns:getDictLabel(oaTask.relationType, 'relation_type', '')}</p>
						</div>
					</div>
				</div>
				<c:if test="${not empty oaTask.relationName}">
				<div class="col-sm-6" id="select_div">
					<div class="view-group">
						<label class="col-sm-5 control-label">关联${fns:getDictLabel(oaTask.relationType, 'relation_type', '')}</label>
						<div class="col-sm-7">
							<p class="form-control-static">
								<a href="#" onclick="toView('${oaTask.relationType}', '${oaTask.relationId}')">${oaTask.relationName}</a>
							</p>
						</div>
					</div>
				</div>
				</c:if>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-5 control-label">优先级</label>
						<div class="col-sm-7">
							<p class="form-control-static">${fns:getDictLabel(oaTask.levelType, 'level_type', '')}</p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-5 control-label">截止日期</label>
						<div class="col-sm-7">
							<p class="form-control-static"><fmt:formatDate value="${oaTask.endDate}" pattern="yyyy-MM-dd"/></p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-5 control-label">当前进度</label>
						<div class="col-sm-7">
							<p class="form-control-static">
							${oaTask.schedule}%
	                        </p>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="view-group">
						<label class="col-sm-5 control-label">任务状态</label>
						<div class="col-sm-7">
							<p class="form-control-static">${fns:getDictLabel(oaTask.status, 'task_status', '')}</p>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">任务成员</h4>
			<div class="row">
				<div class="col-sm-12">
					<div class="view-group">
						<label class="col-sm-2 control-label">负责人</label>
						<div class="col-sm-10">
							<p class="form-control-static">${oaTask.ownBy.name}</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="view-group">
						<label class="col-sm-2 control-label">参与人</label>
						<div class="col-sm-10">
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
			
			<h4 class="page-header">任务详情</h4>
			<div class="row">
				<div class="col-sm-12">
					<div class="view-group">
						<div class="col-sm-12">
							<p class="form-control-static">${oaTask.content}</p>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="view-group">
						<div class="col-sm-12">
							<form:hidden id="files" path="files" htmlEscape="false" maxlength="2000" class="form-control input-xlarge"/>
							<sys:ckfinder input="files" type="files" uploadPath="/file" selectMultiple="true" readonly="true"/>
						</div>
					</div>
				</div>
			</div>
			<div class="hr-line-dashed"></div>
			
			
			<div class="form-actions">
				<div class="btn-group">
				
				<c:if test="${fns:getUser().id == oaTask.createBy.id || fns:getUser().id == oaTask.ownBy.id}">
						<c:if test="${oaTask.status != 2}">
							<a href="${ctx}/oa/oaTask/deal?id=${oaTask.id}&status=1" onclick="return confirmx('确认要启动该任务吗？', this.href)" class="btn btn-white" title="启动"><i class="fa fa-play"></i>
								<span class="hidden-xs">启动</span>
							</a> 
						</c:if>
						<c:if test="${oaTask.status != 2}">
							<a href="${ctx}/oa/oaTask/deal?id=${oaTask.id}&status=2" onclick="return confirmx('确认要将该任务标记为已完成吗？', this.href)" class="btn  btn-white" title="完成"><i class="fa fa-check"></i>
								<span class="hidden-xs">完成</span>
							</a> 
						</c:if>
						<c:if test="${oaTask.status != 2}">
							<a href="${ctx}/oa/oaTask/deal?id=${oaTask.id}&status=3" onclick="return confirmx('确认要关闭该任务吗？', this.href)" class="btn btn-white" title="关闭"><i class="fa fa-ban"></i>
								<span class="hidden-xs">关闭</span>
							</a>
						</c:if>
					
					<shiro:hasPermission name="oa:oaTask:edit">
    					<a href="${ctx}/oa/oaTask/form?id=${oaTask.id}" class="btn btn-white" title="修改"><i class="fa fa-edit"></i>
							<span class="hidden-xs">修改</span></a>
					</shiro:hasPermission>
					<shiro:hasPermission name="oa:oaTask:del">
						<a href="${ctx}/oa/oaTask/delete?id=${oaTask.id}" onclick="return confirmx('确认要删除该任务吗？', this.href)" class="btn  btn-white" title="删除"><i class="fa fa-trash"></i>
							<span class="hidden-xs">删除</span></a> 
					</shiro:hasPermission>
				</c:if>
					
					<button id="btnCancel" class="btn btn-white" type="button" value="返 回" onclick="history.go(-1)"><i class="fa fa-repeat"></i> 返回</button>
				</div>
			</div>
			<br>
			
			
			
			
		<div class="tabs-container">
	            <ul class="nav nav-tabs">
					<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">查阅情况</a>
	                </li>
					
	            </ul>
          	   <div class="tab-content">
          	   	<div class="panel-body">
					<div id="tab-1" class="tab-pane table-responsive active">
					<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed">
						<thead>
							<tr>
								<th class="hide"></th>
								<th>接受人</th>
								<th>阅读标记</th>
								<th>阅读时间</th>
								<shiro:hasPermission name="oa:oaTask:edit"><th width="10">&nbsp;</th></shiro:hasPermission>
							</tr>
						</thead>
						<tbody id="oaTaskRecordList">
							<c:forEach items="${oaTask.oaTaskRecordList}" var="oaTaskRecord">
									<tr>
										<td>
											${oaTaskRecord.user.name}
										</td>
										<td>
											${fns:getDictLabel(oaTaskRecord.readFlag, 'oa_notify_read', '')}
										</td>
										<td>
											<fmt:formatDate value="${oaTaskRecord.readDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
										</td>
									</tr>
								</c:forEach>
						</tbody>
						
					</table>
					
				</div>
				</div>
			</div>
			</div>
	
		</form:form>
	</div>
</div>
</div>
</body>
</html>