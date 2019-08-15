<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<jsp:useBean id="now" class="java.util.Date" />  
<html>
<head>
	<title>主页</title>
	<meta name="decorator" content="default"/>    
	<link href="${ctxStatic}/hplus/css/calendar.css" rel="stylesheet">
    <script type="text/javascript">
	    function toView(relationType, targetId){
	    	
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
    <style type="text/css">
    	.table > tbody > tr > td {
		    border-bottom: 1px solid #e7eaec;
		    border-top: 0;
		}
		
    </style>
</head>

<body class="gray-bg">
	
    <div class="wrapper-content">
		<sys:message content="${message}"/>
		
        <div class="row">
            <div class="col-sm-6">
            	<div class="ibox float-e-margins">
					<div class="ibox-title">
						<h5><a href="${ctx}/oa/oaProject" class="h5">项目总览</a></h5>
					</div>
					<div class="ibox-content">
						<div>
		                    <table class="table table-bordered">
		                        <tbody>
		                            <tr>
		                                <td>
		                                    <button type="button" class="btn btn-success m-r-sm">${projectCount }</button>
		                                    	总项目数
		                                </td>
		                                <td>
		                                    <button type="button" class="btn btn-success m-r-sm">${ownProjectCount}</button>
		                                    	我负责的
		                                </td>
		                                <td>
		                                    <button type="button" class="btn btn-danger m-r-sm">${projectCount - ownProjectCount}</button>
		                                    	我参与的
		                                </td>
		                            </tr>
		                        </tbody>
		                    </table>
		                </div>
					</div>
				</div>
				
				<div class="ibox float-e-margins">
					<div class="ibox-title">
						<h5><a href="${ctx}/oa/oaProject" class="h5">项目列表</a></h5>
						<div class="ibox-tools">
	                        <a class="" href="${ctx}/oa/oaProject">
	                            <i class="fa fa-chevron-right"></i>
	                        </a>
	                    </div>
					</div>
					<div class="ibox-content no-padding height430">
						
                   		
						<div class="table-responsive">
						<table id="contentTable" class="table table-hover">
							<thead>
								<tr>
									<th>项目名称</th>
									<th>负责人</th>
									<th>进度</th>
									<th>状态</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach items="${projectPage.list }" var="oaProject" varStatus="status">
									<tr>
										<td>
											<a href="${ctx}/oa/oaProject/view?id=${oaProject.id}" title="查看">
												${oaProject.name}
										</td>
										<td width="100px">
											${oaProject.ownBy.name}
										</td>
										<td width="50px">
											<small>${oaProject.schedule}%</small>
										</td>
										<td width="60px">
											<span class="<c:if test='${oaProject.status == 1}'>text-success</c:if><c:if test='${oaProject.status == 2}'>text-info</c:if><c:if test='${oaProject.status == 3}'>text-muted</c:if>">
												${fns:getDictLabel(oaProject.status, 'task_status', '')}
											</span>
										</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
						</div>
					</div>
				</div>
            </div>
            <div class="col-sm-6">
            	<div class="ibox float-e-margins">
					<div class="ibox-title">
						<h5><a href="${ctx}/oa/oaTask" class="h5">任务总览</a></h5>
					</div>
					<div class="ibox-content">
						<div>
		                    <table class="table table-bordered">
		                        <tbody>
		                            <tr>
		                                <td>
		                                    <button type="button" class="btn btn-info m-r-sm">${taskCount }</button>
		                                    	总任务数
		                                </td>
		                                <td>
		                                    <button type="button" class="btn btn-success m-r-sm">${ownTaskCount}</button>
		                                    	我负责的
		                                </td>
		                                <td>
		                                    <button type="button" class="btn btn-danger m-r-sm">${taskCount - ownTaskCount}</button>
		                                    	我参与的
		                                </td>
		                            </tr>
		                        </tbody>
		                    </table>
		                </div>
					</div>
				</div>
				
				<div class="ibox float-e-margins">
					<div class="ibox-title">
						<h5><a href="${ctx}/oa/oaTask" class="h5">任务列表</a></h5>
						<div class="ibox-tools">
	                        <a class="" href="${ctx}/oa/oaTask">
	                            <i class="fa fa-chevron-right"></i>
	                        </a>
	                    </div>
					</div>
					<div class="ibox-content no-padding height430">
						
						<div class="table-responsive">
						<table id="contentTable" class="table table-hover">
							<thead>
								<tr>
									<th>任务名称</th>
									<th>负责人</th>
									<th>优先级</th>
									<th>状态</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach items="${taskPage.list }" var="oaTask" varStatus="status">
									<tr>
										<td>
											<a href="${ctx}/oa/oaTask/view?id=${oaTask.id}">${oaTask.name}</a>
										</td>
										<td width="100px">
											${oaTask.ownBy.name}
										</td>
										<td width="60px">
											<span class="<c:if test='${oaTask.levelType == 2}'>badge badge-danger</c:if><c:if test='${oaTask.levelType == 1}'>badge badge-warning</c:if><c:if test='${oaTask.levelType == 0}'>badge badge-info</c:if>">
												${fns:getDictLabel(oaTask.levelType, 'level_type', '')}
											</span>
										</td>
										<td width="60px">
											<span class="<c:if test='${oaTask.status == 1}'>text-success</c:if><c:if test='${oaTask.status == 2}'>text-info</c:if><c:if test='${oaTask.status == 3}'>text-muted</c:if>">
											${fns:getDictLabel(oaTask.status, 'task_status', '')}
											</span>
										</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
						</div>
					</div>
				</div>
            </div>
            <div class="col-sm-6 hide">
				
				
			</div>
			
        </div>
    </div>	
   
   
</body>
</html>