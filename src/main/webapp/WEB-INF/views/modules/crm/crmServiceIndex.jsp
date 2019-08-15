<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>工单主页</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
    
	</script>
</head>
<body class="gray-bg">
	<sys:message content="${message}"/>
	<div class="row ">
        <div class="col-sm-10">
        	<div class="wrapper wrapper-content animated fadeInUp">
                <div class="ibox">
                    <div class="ibox-content ">
                    	<div class="row">
                            <div class="col-sm-12">
                                <div class="m-b-md">
                                	<div class="pull-left">
                                    	<h3><img src="${ctxStatic}/weui/images/app/icon_service.png" class="ibox-title-img">${crmService.name} </h3>
                                    </div>
                                    <div class="pull-right">
										
										<c:if test="${fns:getUser().id == crmService.ownBy.id && crmService.status != 2}">
										<a href="${ctx}/crm/crmService/deal?id=${crmService.id}" onclick="return confirmx('确认要工单已经完成了吗？', this.href)" class="btn btn-success btn-sm" title="完成"><i class="fa fa-check"></i> 我已完成</a>
										</c:if>
										
										<c:if test="${crmService.status == 2 && crmService.auditStatus != 1}">
					    					<a href="#" onclick="openDialog('审核服务工单', '${ctx}/crm/crmService/auditForm?id=${crmService.id}','800px', '500px')" class="btn btn-default btn-sm" title="审核"><i class="fa fa-check"></i> 审核</a>
										</c:if>
										
										<c:if test="${crmService.status != 2}">
										<shiro:hasPermission name="crm:crmService:edit">
					    					<a href="#" onclick="openDialog('修改服务工单', '${ctx}/crm/crmService/form?id=${crmService.id}','800px', '500px')" class="btn btn-default btn-sm" title="修改"><i class="fa fa-edit"></i> 修改</a>
										</shiro:hasPermission>
										
					    				
										<div class="btn-group">
						                    <button data-toggle="dropdown" class="btn btn-default btn-sm dropdown-toggle" aria-expanded="false">更多 <i class="fa fa-chevron-down"></i>
						                    </button>
						                    <ul class="dropdown-menu">
						                        
						                        <li>
						                        	<shiro:hasPermission name="crm:crmService:del">
														<a href="${ctx}/crm/crmService/delete?id=${crmService.id}" onclick="return confirmx('确认要删除该服务工单吗？', this.href)" class="" title="删除"><i class="fa fa-trash"></i> 删除</a> 
													</shiro:hasPermission>
						                        </li>
						                       
						                    </ul>
						                </div>
						                </c:if>
						                
						                <a href="${ctx}/crm/crmService/index?id=${crmService.id}" class="btn btn-default btn-sm" title="刷新"><i class="fa fa-refresh"></i> </a>
					        			<button id="btnCancel" class="btn btn-default btn-sm" type="button" onclick="history.go(-1)" title="返回"><i class="fa fa-rotate-left"></i> </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-5">
                                <dl class="dl-horizontal">
									<dt>工单编码：</dt>
                                    <dd>${crmService.no}</dd>
                                    <dt>工单类型：</dt>
                                    <dd>${fns:getDictLabel(crmService.serviceType, 'service_type', '')}</dd>
                                    <dt>优先级：</dt>
                                    <dd>
                                    	<span class="badge <c:if test='${crmService.levelType == 2}'>badge-danger</c:if> <c:if test='${crmService.levelType == 1}'>badge-warning</c:if> <c:if test='${crmService.levelType == 0}'></c:if> ">
											${fns:getDictLabel(crmService.levelType, 'level_type', '')}
										</span>
                                    </dd>
                                    <dt>创建者：</dt>
                                    <dd>${crmService.createBy.name}</dd>
                                </dl>
                            </div>
                            <div class="col-sm-7" id="cluster_info">
                                <dl class="dl-horizontal">
									<dt>客户：</dt>
									<dd><a href="${ctx}/crm/crmCustomer/index?id=${crmService.customer.id}">${crmService.customer.name}</a></dd>
									<dt>截止日期：</dt>
                                    <dd><fmt:formatDate value="${crmService.endDate}" pattern="yyyy-MM-dd"/></dd>
                                    <dt>完成状态：</dt>
                                    <dd>
                                    	<span class="<c:if test='${crmService.status == 0}'>text-danger</c:if><c:if test='${crmService.status == 1}'>text-info</c:if><c:if test='${crmService.status == 2}'>text-success</c:if>">
                                    		${fns:getDictLabel(crmService.status, 'finish_status', '')}
                                    	</span>
                                    </dd>
                                    <dt>负责人：</dt>
                                    <dd class="">${crmService.ownBy.name}</dd>
                                </dl>
                            </div>
                        </div>
                         <div class="row m-t-sm">
                            <div class="col-sm-12">
                            	<div class="tabs-container">
								 	<ul class="nav nav-tabs">
								 		<li class="active"><a data-toggle="tab" href="#tab-0" aria-expanded="true">概况</a></li>		
								 		<li class=""><a data-toggle="tab" href="#tab-1" aria-expanded="true"> 详细信息</a></li>
								 		<li><a data-toggle="tab" href="#tab-4" aria-expanded="false">操作日志 <span class="badge badge-info"><c:if test="${fn:length(sysDynamicList)>0}">${fn:length(sysDynamicList)}</c:if></span></a></li>
								 	</ul>
								 	<div class="tab-content">
								 		<div class="tab-pane active" id="tab-0">
								                <div class="ibox mt10">
								                	<script type="text/javascript">
														var validateForm;
														function doSubmit(){//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
														  if(validateForm.form()){
															  $("#recordInputForm").submit();
															  return true;
														  }
													
														  return false;
														}
														$(document).ready(function() {
															//$("#name").focus();
															validateForm=$("#recordInputForm").validate({
																submitHandler: function(form){
																	loading('正在提交，请稍等...');
																	form.submit();
																},
																errorContainer: "#messageBox",
																errorPlacement: function(error, element) {
																	$("#messageBox").text("输入有误，请先更正。");
																	if (element.is(":checkbox")||element.is(":radio")||element.parent().is(".input-append")){
																		error.appendTo(element.parent().parent());
																	} else {
																		error.insertAfter(element);
																	}
																}
															});
														});
													</script>
								                	<form:form id="recordInputForm" modelAttribute="crmContactRecord" action="${ctx}/crm/crmContactRecord/save" method="post" class="form-horizontal">
													<form:hidden path="targetType"/>
													<form:hidden path="targetId"/>
													<form:hidden path="targetName"/>
								                	<div class="ibox-title white-bg">
								                        <h5>新建跟进记录</h5>
								                        <div class="ibox-tools">
								                        </div>
								                    </div>
							                    	<div class="ibox-content no-padding" style="height:130px;">
							                    		<form:textarea path="content" htmlEscape="false" style="margin-top: 10px;height: 80px;width: 100%;border:0;" maxlength="500" class="form-control required"  placeholder="发布一条跟进记录..."/>
								                    	<div class="">
									                    	记录类型：
									                    	<form:select path="contactType" class="form-control required input-small">
																<form:options items="${fns:getDictList('contact_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
															</form:select>
															<button class="btn btn-default"> 发  布 </button>
														</div>
								                    </div>
								                    </form:form>
								                </div>
								                <%--跟进记录开始 --%>
								                <div class="row">
								                	<div class="col-lg-12">
								                		<c:forEach items="${crmContactRecordList}" var="crmContactRecord">
								                		<div class="ibox float-e-margins">
										                    <div class="">
										                        <div class="pull-left">
										                        	<div class="social-avatar">
								                                        <a href="" class="pull-left">
								                                            <img alt="image" src="${crmContactRecord.createBy.photo}" onerror="this.src='${ctxStatic}/images/user.jpg'">
								                                        </a>
								                                        <div class="media-body">
								                                            <p><strong>${crmContactRecord.createBy.name}</strong> <c:if test="${not empty crmContactRecord.contactDate}">${fns:getTimeDiffer(crmContactRecord.contactDate)}</c:if>进行了 <strong>${fns:getDictLabel(crmContactRecord.contactType, 'contact_type', '')}</strong></p>
						                                            		<p><small class="text-muted"><fmt:formatDate value="${crmContactRecord.createDate}" pattern="yyyy-MM-dd hh:mm"/> 来自 ${crmContactRecord.createBy.name}</small></p>
								                                        </div>
								                                    </div>
										                        </div>
										                        <div class="ibox-tools" style="padding: 10px;">
										                            <a class="btn btn-default btn-sx dropdown-toggle" data-toggle="dropdown" href="#">
										                                <i class="fa fa-angle-down"></i>
										                            </a>
										                            <ul class="dropdown-menu dropdown-user">
										                                		<li>
											                                    	<a href="#" onclick="openDialog('修改跟进记录', '${ctx}/crm/crmContactRecord/form?id=${crmContactRecord.id}','800px', '500px')"  title="修改" >修改</a>
					                        									</li>
					                        									<li>
					                        										<a href="${ctx}/crm/crmContactRecord/indexDelete?id=${crmContactRecord.id}" onclick="return confirmx('确认要删除该跟进记录吗？', this.href)"  title="删除">删除</a> 
											                                    </li>
										                            </ul>
										                        </div>
										                    </div>
										                    <div class="form-horizontal">
										                    <div class="ibox-content" style="border:0;">
										                        <p>${crmContactRecord.content}</p>
										                    </div>
										                    </div>
										                </div>
										                </c:forEach>
								                	</div>
								                </div>
								                <%--跟进记录结束 --%>
								                
                                        </div>
                                        
								 		<div class="tab-pane" id="tab-1">
                                            
								 			<div class="panel-body">
								 				<div class="form-horizontal">				 				
													<h4 class="page-header">基本信息</h4>
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">工单编码：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${crmService.no}
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">主题：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${crmService.name}
																	</p>
																</div>
															</div>
														</div>
													</div>
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">类型：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${fns:getDictLabel(crmService.serviceType, 'service_type', '')}
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">负责人：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${crmService.ownBy.name}
																	</p>
																</div>
															</div>
														</div>
													</div>
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">订单合同：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${crmService.omContract.no}
																	</p>
																</div>
															</div>
														</div>
													
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">客户：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	<a href="${ctx}/crm/crmCustomer/index?id=${crmService.customer.id}">${crmService.customer.name}</a>
																	</p>
																</div>
															</div>
														</div>
														
													</div>
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">优先级：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${fns:getDictLabel(crmService.levelType, 'level_type', '')}
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">截止日期：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	<fmt:formatDate value="${crmService.endDate}" pattern="yyyy-MM-dd"/>
																	</p>
																</div>
															</div>
														</div>
													</div>
													
													<div class="row">
														<div class="col-sm-12">
															<div class="view-group">
																<label class="col-sm-2 control-label">内容：</label>
																<div class="col-sm-10">
																	<p class="form-control-static">
																	${crmService.content}
																	</p>
																</div>
															</div>
														</div>
													</div>
													<div class="row">
														<div class="col-sm-12">
															<div class="view-group">
																<label class="col-sm-2 control-label">期望结果：</label>
																<div class="col-sm-10">
																	<p class="form-control-static">
																	${crmService.expecte}
																	</p>
																</div>
															</div>
														</div>
													</div>
													<h4 class="page-header">处理信息</h4>
													
													<div class="row">
														
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">处理状态：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${fns:getDictLabel(crmService.status, 'finish_status', '')}
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">处理日期：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	<fmt:formatDate value="${crmService.dealDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
																	</p>
																</div>
															</div>
														</div>
													</div>
													
													<h4 class="page-header">完成结果</h4>
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">满意度：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${fns:getDictLabel(crmService.satisfyType, 'satisfy_type', '')}
																	</p>
																</div>
															</div>
														</div>
														
													</div>
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">审核状态：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${fns:getDictLabel(crmService.auditStatus, 'audit_status', '')}
																	</p>
																</div>
															</div>
														</div>
													</div>
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">审核人：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${crmService.auditBy.name}
																	</p>
																</div>
															</div>
														</div>
													
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">审核日期：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	<fmt:formatDate value="${crmService.auditDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
																	</p>
																</div>
															</div>
														</div>
													</div>
													
													<h4 class="page-header">操作信息</h4>
													
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">更新人：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${crmService.updateBy.name}
																	</p>
																</div>
															</div>
														</div>
													
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">更新时间：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	<fmt:formatDate value="${crmService.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
																	</p>
																</div>
															</div>
														</div>
													</div>
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">创建人：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${crmService.createBy.name}
																	</p>
																</div>
															</div>
														</div>
													
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">创建时间：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	<fmt:formatDate value="${crmService.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
																	</p>
																</div>
															</div>
														</div>
													</div>
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">备注：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${crmService.remarks}
																	</p>
																</div>
															</div>
														</div>
													</div>
												</div>
								 			</div>
								 		</div>
								 		<%--日志 开始 --%>
								 		<div id="tab-4" class="tab-pane">
								 			<div class="panel-body">
								 				<div class="table-responsive">
													<table id="" class="table table-striped table-bordered table-hover table-condensed">
														<thead>
															<tr>
																<th width="150px">日期</th>
																<th width="150px">操作人</th>
																<th>操作内容</th>
															</tr>
														</thead>
														<tbody>
															<c:forEach items="${sysDynamicList }" var="sysDynamic">
															<tr>
																<td><fmt:formatDate value="${sysDynamic.createDate}" pattern="yyyy-MM-dd HH:mm"/></td>
																<td>${sysDynamic.createBy.name}</td>
																<td>
																	<i>${fns:getDictLabel(sysDynamic.actionType, 'action_type', '')}了</i> <strong>${fns:getDictLabel(sysDynamic.objectType, 'object_type', '')} </strong>
																	<a href="#" onclick="toView('${sysDynamic.objectType}','${sysDynamic.targetId}');">${sysDynamic.targetName}</a>
																</td>
															</tr>
															</c:forEach>
														</tbody>
													</table>
												</div>
												
								 				<div class="ibox-content timeline hide">       
								               		<c:forEach items="${sysDynamicList }" var="sysDynamic">
								                       	<div class="timeline-item">
								                            <div class="row">
								                                <div class="col-xs-3 date">
								                                    <i class="fa fa-circle-thin text-navy"></i> ${sysDynamic.createBy.name}<br>
								                                    <small><fmt:formatDate value="${sysDynamic.createDate}" pattern="yyyy-MM-dd"/> <br><fmt:formatDate value="${sysDynamic.createDate}" pattern="HH:mm"/></small>
								                                </div>
								                                <div class="col-xs-9 content">
								                                    <p class="m-b-xs"><i>${fns:getDictLabel(sysDynamic.actionType, 'action_type', '')}了</i> <strong>${fns:getDictLabel(sysDynamic.objectType, 'object_type', '')} </strong></p>
								                                    <p class="small"><a href="#" onclick="toView('${sysDynamic.objectType}','${sysDynamic.targetId}');">${sysDynamic.targetName}</a></p>
								                                </div>
								                            </div>
								                        </div>	
								                    </c:forEach>
								
								                 </div>
								 			</div>
								 		</div>
								 		<%--日志 结束 --%>
					
								 		
								 		
								 	</div>
								</div>
                            </div>
                        </div>
                        
                    </div>
                </div>
            </div>
        </div>
        <div class="col-sm-2">
        	<div class="wrapper wrapper-content project-manager">
                <h4>工单内容</h4>
                <p class="small">
                    ${crmService.content}
                </p>
               
                
            </div>
        </div>
    </div>
    

</body>
</html>