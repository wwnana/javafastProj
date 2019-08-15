<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>订单主页</title>
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
                                    	<h2><span class="btn btn-info"><i class="fa fa-home"></i></span> ${omOrder.no} </h2>
                                    </div>
                                    <div class="pull-right">
										
										<c:if test="${omOrder.status == 0}">
											<shiro:hasPermission name="om:omOrder:audit">
												<a href="${ctx}/om/omOrder/audit?id=${omOrder.id}" onclick="return confirmx('确认要审核该订单吗？', this.href)" class="btn btn-default btn-sm" title="审核"><i class="fa fa-check"></i>
													<span class="hidden-xs">审核</span></a> 
											</shiro:hasPermission>
											
											<shiro:hasPermission name="om:omOrder:edit">
						    					<a href="${ctx}/om/omOrder/form?id=${omOrder.id}" class="btn btn-default btn-sm" title="编辑"><i class="fa fa-edit"></i>
													<span class="hidden-xs">编辑</span></a>
											</shiro:hasPermission>
											
											
										</c:if>
								
										<div class="btn-group">
						                    <button data-toggle="dropdown" class="btn btn-default btn-sm dropdown-toggle" aria-expanded="false">更多 <i class="fa fa-chevron-down"></i>
						                    </button>
						                    <ul class="dropdown-menu">
						                        <c:if test="${omOrder.status == 0}">
						                        <li>
						                        	<shiro:hasPermission name="om:omOrder:del">
														<a href="${ctx}/om/omOrder/delete?id=${omOrder.id}" onclick="return confirmx('确认要删除该订单吗？', this.href)"  title="删除"><i class="fa fa-trash"></i>
															<span class="hidden-xs">删除</span></a> 
													</shiro:hasPermission>
						                        </li>
						                       </c:if>
						                       <li>
						                       	<a href="${ctx}/om/omOrder/print?id=${omOrder.id}" title="打印" target="_blank"><i class="fa fa-print"></i> <span class="hidden-xs">打印</span></a>
						                       </li>
						                    </ul>
						                </div>
						                
						                <a href="${ctx}/om/omOrder/index?id=${omOrder.id}" class="btn btn-default btn-sm" title="刷新"><i class="fa fa-refresh"></i> </a>
					        			<button id="btnCancel" class="btn btn-default btn-sm" type="button" onclick="history.go(-1)" title="返回"><i class="fa fa-rotate-left"></i> </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-5">
                                <dl class="dl-horizontal">
									<dt>订单编号：</dt>
                                    <dd>${omOrder.no}</dd>
                                    <dt>订单状态：</dt>
                                    <dd><span class="text-navy">${fns:getDictLabel(omOrder.status, 'audit_status', '')}</span></dd>
                                    <dt>创建者：</dt>
                                    <dd>${omOrder.createBy.name}</dd>
                                </dl>
                            </div>
                            <div class="col-sm-7" id="cluster_info">
                                <dl class="dl-horizontal">
									<dt>客户名称：</dt>
                                    <dd><a href="${ctx}/crm/crmCustomer/index?id=${omOrder.customer.id}">${omOrder.customer.name}</a></dd>
                                    <dt>创建日期：</dt>
                                    <dd><fmt:formatDate value="${omOrder.createDate}" pattern="yyyy-MM-dd"/></dd>
                                    <dt>负责人：</dt>
                                    <dd class="project-people">
                                        <a href="#">
                                            <img alt="image" class="img-circle" src="${omOrder.ownBy.photo}"  onerror="this.src='${ctxStatic}/images/user.jpg'"> ${omOrder.ownBy.name}
                                        </a>
                                        
                                    </dd>
                                </dl>
                            </div>
                        </div>
                         <div class="row m-t-sm">
                            <div class="col-sm-12">
                            	<div class="tabs-container">
								 	<ul class="nav nav-tabs">
								 		<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">详细信息</a></li>
								 		<li><a data-toggle="tab" href="#tab-3" aria-expanded="false">订单明细<span class="badge badge-info"><c:if test="${fn:length(omOrder.omOrderDetailList)>0}">${fn:length(omOrder.omOrderDetailList)}</c:if></span></a></li>
								 		<li><a data-toggle="tab" href="#tab-4" aria-expanded="false">应收款<span class="badge badge-info"><c:if test="${fn:length(fiReceiveAbleList)>0}">${fn:length(fiReceiveAbleList)}</c:if></span></a></li>
								 		<li><a data-toggle="tab" href="#tab-5" aria-expanded="false">收款单<span class="badge badge-info"><c:if test="${fn:length(fiReceiveBillList)>0}">${fn:length(fiReceiveBillList)}</c:if></span></a></li>
								 		<li><a data-toggle="tab" href="#tab-10" aria-expanded="false">操作日志 <span class="badge badge-info"><c:if test="${fn:length(sysDynamicList)>0}">${fn:length(sysDynamicList)}</c:if></span></a></li>
								 	</ul>
								 	<div class="tab-content">
								 		<div class="tab-pane active" id="tab-1">
                                            
								 			<div class="panel-body">
								 				<div class="form-horizontal">				 				
													<h4 class="page-header">基本信息</h4>
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">订单编号</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																		${omOrder.no}
																	</p>
																</div>
															</div>
														</div>
														
													</div>
													
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">客户</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																		<a href="${ctx}/crm/crmCustomer/index?id=${omOrder.customer.id}">${omOrder.customer.name}</a>
																	</p>
																</div>
															</div>
														</div>
														
													</div>
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">订单总金额</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																		${omOrder.amount}
																	</p>
																</div>
															</div>
														</div>
													</div>
													
													
													<h4 class="page-header">操作信息</h4>
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">销售负责人</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																		${omOrder.ownBy.name}
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">状态</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																		${fns:getDictLabel(omOrder.status, 'audit_status', '')}
																	</p>
																</div>
															</div>
														</div>
													</div>
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">创建人</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																		${omOrder.createBy.name}
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">创建时间</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																		<fmt:formatDate value="${omOrder.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
																	</p>
																</div>
															</div>
														</div>
													</div>
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">审核人</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																		${omOrder.auditBy.name}
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">审核时间</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																		<fmt:formatDate value="${omOrder.auditDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
																	</p>
																</div>
															</div>
														</div>
													</div>
													
												</div>
								 			</div>
								 		</div>
								 		
										
								 		<div id="tab-3" class="tab-pane">
								 			<div class="panel-body">
								 				<div class="table-responsive">
								 					<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed">
														<thead>
															<tr>
																<th>产品编号</th>
																<th>产品名称</th>
																<th>规格</th>
																<th>单位</th>
																<th>单价(元)</th>
																<th>数量</th>
																<th>金额(元)</th>
																
																<th>备注</th>
															</tr>
														</thead>
														<tbody>
															<c:forEach items="${omOrder.omOrderDetailList}" var="omOrderDetail">
																<tr>
																			<td>
																				${omOrderDetail.product.no}
																			</td>
																			<td>
																				${omOrderDetail.product.name}
																			</td>
																			<td>
																				${omOrderDetail.product.spec}
																			</td>
																			<td>
																				${omOrderDetail.unitType}
																			</td>
																			<td>
																				${omOrderDetail.price}
																			</td>
																			<td>
																				${omOrderDetail.num}
																			</td>
																			<td>
																				${omOrderDetail.amount}
																			</td>
																			
																			<td>
																				${omOrderDetail.remarks}
																			</td>
																</tr>
															</c:forEach>
														</tbody>
													</table>	
													<div class="pull-right">
														总数量：${omOrder.num}， 总计：${omOrder.totalAmt}， 其他费用：${omOrder.otherAmt}， 总金额：${omOrder.amount}
													</div>
								 				</div>
								 			</div>
								 		</div>
								 		<%--应收款 --%>
								 		<div id="tab-4" class="tab-pane">
								 			<div class="panel-body">
								 				<div class="table-responsive">
								 					<table id="contentTable" class="table table-bordered table-hover">
														<thead>
															<tr>
																<th>单号</th>
																<th width="100px">应收金额</th>
																<th width="100px">实际已收</th>
																<th width="100px">差额</th>
																<th width="100px">应收时间</th>
																
																<th width="80px">状态</th>
																<th width="100px">负责人</th>
																<th width="100px">创建时间</th>
																<th width="120px">操作</th>
															</tr>
														</thead>
														<tbody>
														<c:forEach items="${fiReceiveAbleList}" var="fiReceiveAble">
															<tr>
																<td><a href="${ctx}/fi/fiReceiveAble/index?id=${fiReceiveAble.id}">
																	${fiReceiveAble.no}
																</a></td>
																
																<td>
																	${fiReceiveAble.amount}
																</td>
																<td>
																	${fiReceiveAble.realAmt}
																</td>
																<td>
																	<c:if test="${(fiReceiveAble.amount - fiReceiveAble.realAmt) > 0}">
																		<span class="label label-warning">${fiReceiveAble.amount - fiReceiveAble.realAmt}</span>
																	</c:if>								
																</td>
																<td>
																	<fmt:formatDate value="${fiReceiveAble.ableDate}" pattern="yyyy-MM-dd"/>
																</td>
																
																<td>
																	${fns:getDictLabel(fiReceiveAble.status, 'finish_status', '')}
																</td>
																<td>
																	${fiReceiveAble.ownBy.name}
																</td>
																<td>
																	<fmt:formatDate value="${fiReceiveAble.createDate}" pattern="yyyy-MM-dd"/>
																</td>
																<td>
																	
																	<c:if test="${fiReceiveAble.status != 2}">
																	<shiro:hasPermission name="fi:fiReceiveAble:edit">
												    					<a href="#" onclick="openDialog('修改应收款', '${ctx}/fi/fiReceiveAble/editForm?id=${fiReceiveAble.id}','800px', '500px')" class="" title="修改">修改</a>
																	</shiro:hasPermission>
																	<shiro:hasPermission name="fi:fiReceiveBill:add">
												    					<a href="#" onclick="openDialog('添加收款单', '${ctx}/fi/fiReceiveBill/form?fiReceiveAble.id=${fiReceiveAble.id}&fiReceiveAble.name=${fiReceiveAble.no}&customer.id=${fiReceiveAble.customer.id}&customer.name=${fiReceiveAble.customer.name}','800px', '500px')" class="" title="添加收款单">添加收款单</a>
																	</shiro:hasPermission>
																	
																	</c:if>
																</td>
															</tr>
														</c:forEach>
														</tbody>
													</table>
								 				</div>
								 			</div>
								 		</div>
								 		<%--收款单 --%>
								 		<div id="tab-5" class="tab-pane">
								 			<div class="panel-body">
								 				<div class="table-responsive">
								 					<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed">
														<thead>
															<tr>
																<th class="hide"></th>
																<th>单号</th>
																<th>收款金额</th>
																<th>收款时间</th>
																<th>收款账户</th>
																<th>收款人</th>
																<th>是否开票</th>
																<th>开票金额</th>
																<th>状态</th>
																<th>备注</th>
																
															</tr>
														</thead>
														<tbody>
															<c:forEach items="${fiReceiveBillList}" var="fiReceiveBill">
																<tr>
																	<td>
																		${fiReceiveBill.no}
																	</td>
																	<td>
																		${fiReceiveBill.amount}
																	</td>
																	<td>
																		<fmt:formatDate value="${fiReceiveBill.dealDate}" pattern="yyyy-MM-dd"/>
																	</td>
																	<td>
																		${fiReceiveBill.fiAccount.name}
																	</td>
																	<td>
																		${fiReceiveBill.ownBy.name}
																	</td>
																	<td>
																		${fns:getDictLabel(fiReceiveBill.isInvoice, 'yes_no', '')}
																	</td>
																	<td>
																		${fiReceiveBill.invoiceAmt}
																	</td>
																	
																	<td>
																		${fns:getDictLabel(fiReceiveBill.status, 'audit_status', '')}
																	</td>
																	<td>
																		${fiReceiveBill.remarks}
																	</td>
																</tr>
															</c:forEach>
														</tbody>
														</table>
								 				</div>
								 			</div>
								 		</div>
								 		<%--日志 开始 --%>
								 		<div id="tab-10" class="tab-pane">
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
                <h4>订单备注</h4>
                <p class="small">
                    ${omOrder.remarks}
                </p>
                <br>
               
                
            </div>
        </div>
    </div>
    

</body>
</html>