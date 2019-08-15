<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>应付款主页</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
    
	</script>
</head>
<body class="gray-bg">
	<sys:message content="${message}"/>
	<div class="row ">
        <div class="col-sm-12">
        	<div class="wrapper wrapper-content animated fadeInUp">
                <div class="ibox">
                    <div class="ibox-content ">
                    	<div class="row">
                            <div class="col-sm-12">
                                <div class="m-b-md">
                                	<div class="pull-left">
                                    	<h2><span class="btn btn-info"><i class="fa fa-home"></i></span> ${fiPaymentAble.no }</h2>
                                    </div>
                                    <div class="pull-right">
										
										<c:if test="${fiPaymentAble.status != 2}">	
											<shiro:hasPermission name="fi:fiPaymentBill:add">
						    					<a href="#" onclick="openDialog('添加付款单', '${ctx}/fi/fiPaymentBill/form?fiPaymentAble.id=${fiPaymentAble.id}&fiPaymentAble.name=${fiPaymentAble.no}&supplier.id=${fiPaymentAble.supplier.id}&supplier.name=${fiPaymentAble.supplier.name}','800px', '500px')" class="btn btn-info btn-sm" title="添加付款单"><i class="fa fa-plus"></i>
													<span class="hidden-xs">添加付款单</span></a>
											</shiro:hasPermission>	
					
											
										</c:if>
					
										<c:if test="${fiPaymentAble.status == 0}">
										<div class="btn-group">
						                    <button data-toggle="dropdown" class="btn btn-default btn-sm dropdown-toggle" aria-expanded="false">更多 <i class="fa fa-chevron-down"></i>
						                    </button>
						                    <ul class="dropdown-menu">
						                        <li>
						                        	<shiro:hasPermission name="fi:fiPaymentAble:edit">
								    					<a href="#" onclick="openDialog('修改应付款', '${ctx}/fi/fiPaymentAble/editForm?id=${fiPaymentAble.id}','800px', '500px')" class="" title="修改"><i class="fa fa-edit"></i> 修改</a>
													</shiro:hasPermission>
						                        </li>
						                        <li>
						                        	<shiro:hasPermission name="fi:fiPaymentAble:del">
														<a href="${ctx}/fi/fiPaymentAble/delete?id=${fiPaymentAble.id}" onclick="return confirmx('确认要删除该应付款吗？', this.href)" class="" title="删除"><i class="fa fa-trash"></i> 删除</a> 
													</shiro:hasPermission>
						                        </li>
						                       
						                    </ul>
						                </div>
						                </c:if>
						                <a href="${ctx}/fi/fiPaymentAble/index?id=${fiPaymentAble.id}" class="btn btn-default btn-sm" title="刷新"><i class="fa fa-refresh"></i> </a>
					        			<button id="btnCancel" class="btn btn-default btn-sm" type="button" onclick="history.go(-1)" title="返回"><i class="fa fa-rotate-left"></i> </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-5">
                                <dl class="dl-horizontal">
									<dt>应付金额：</dt>
                                    <dd>${fiPaymentAble.amount }</dd>
                                    <dt>往来单位：</dt>
                                    <dd>
                                    	<c:if test="${not empty fiPaymentAble.supplier.id}">
											[供应商] ${fiPaymentAble.supplier.name}
										</c:if>
										<c:if test="${not empty fiPaymentAble.customer.id}">
											<a href="${ctx}/crm/crmCustomer/index?id=${fiPaymentAble.customer.id}">[客户] ${fiPaymentAble.customer.name}</a>
										</c:if>
									</dd>
                                    <dt>状态：</dt>
                                    <dd><span class="text-navy">${fns:getDictLabel(fiPaymentAble.status, 'finish_status', '')}</span></dd>
                                    <dt>创建者：</dt>
                                    <dd>${fiPaymentAble.createBy.name}</dd>
                                </dl>
                            </div>
                            <div class="col-sm-7" id="cluster_info">
                                <dl class="dl-horizontal">
									<dt>实际已付：</dt>
                                    <dd>
                                    	${fiPaymentAble.realAmt }
                                    	<c:if test="${(fiPaymentAble.amount - fiPaymentAble.realAmt) > 0}">
											（差额：<span class="text-warning">${fiPaymentAble.amount - fiPaymentAble.realAmt}</span>）
										</c:if>
                                    </dd>
                                    <dt>关联单据：</dt>
                                    <dd>
                                    	<c:if test="${not empty fiPaymentAble.purchase.id}">
                                    		[采购单] ${fiPaymentAble.purchase.no}
                                    	</c:if>
                                    	<c:if test="${not empty fiPaymentAble.returnorder.id}">
                                    		[退货单] ${fiPaymentAble.returnorder.no}
                                    	</c:if>
						
									</dd>
                                    <dt>应付时间：</dt>
                                    <dd><fmt:formatDate value="${fiPaymentAble.ableDate}" pattern="yyyy-MM-dd"/></dd>
                                    <dt>负责人：</dt>
                                    <dd class="project-people">
                                        <a href="#">
                                            <img alt="image" class="img-circle" src="${fiPaymentAble.ownBy.photo}"  onerror="this.src='${ctxStatic}/images/user.jpg'"> ${fiPaymentAble.ownBy.name}
                                        </a>
                                        
                                    </dd>
                                </dl>
                            </div>
                        </div>
                         <div class="row m-t-sm">
                            <div class="col-sm-12">
                            	<div class="tabs-container">
								 	<ul class="nav nav-tabs">
								 		<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true"><i class="fa fa-laptop"></i> 详细信息</a></li>
								 		<li><a data-toggle="tab" href="#tab-3" aria-expanded="false">付款单 <span class="badge badge-info"><c:if test="${fn:length(fiPaymentAble.fiPaymentBillList)>0}">${fn:length(fiPaymentAble.fiPaymentBillList)}</c:if></span></a></li>
								 		<li><a data-toggle="tab" href="#tab-4" aria-expanded="false">操作日志 <span class="badge badge-info"><c:if test="${fn:length(sysDynamicList)>0}">${fn:length(sysDynamicList)}</c:if></span></a></li>
								 	</ul>
								 	<div class="tab-content">
								 		<div class="tab-pane active" id="tab-1">
                                            
								 			<div class="panel-body">
								 				<div class="form-horizontal">				 				
													<h4 class="page-header">基本信息</h4>
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">单号：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${fiPaymentAble.no }
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">状态：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${fns:getDictLabel(fiPaymentAble.status, 'finish_status', '')}
																	</p>
																</div>
															</div>
														</div>
													</div>
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">往来单位：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	<c:if test="${not empty fiPaymentAble.supplier.id}">
																		[供应商] ${fiPaymentAble.supplier.name}
																	</c:if>
																	<c:if test="${not empty fiPaymentAble.customer.id}">
																		<a href="${ctx}/crm/crmCustomer/index?id=${fiPaymentAble.customer.id}">[客户] ${fiPaymentAble.customer.name}</a>
																	</c:if>
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">关联单据：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	<c:if test="${not empty fiPaymentAble.purchase.id}">
							                                    		[采购单] ${fiPaymentAble.purchase.no}
							                                    	</c:if>
							                                    	<c:if test="${not empty fiPaymentAble.returnorder.id}">
							                                    		[退货单] ${fiPaymentAble.returnorder.no}
							                                    	</c:if>
																	</p>
																</div>
															</div>
														</div>
													</div>
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">应付金额：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${fiPaymentAble.amount }	
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">实际已付：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${fiPaymentAble.realAmt }
																	</p>
																</div>
															</div>
														</div>
													</div>
													<div class="row">
													
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">应付时间：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	<fmt:formatDate value="${fiPaymentAble.ableDate}" pattern="yyyy-MM-dd"/>
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">负责人：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${fiPaymentAble.ownBy.name}
																	</p>
																</div>
															</div>
														</div>
													</div>
													
													
													<h4 class="page-header">操作信息</h4>
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">创建人：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																		${fiPaymentAble.createBy.name}
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">创建时间：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																		<fmt:formatDate value="${fiPaymentAble.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
																	</p>
																</div>
															</div>
														</div>
													</div>
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">更新人：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																		${fiPaymentAble.updateBy.name}
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">更新时间：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																		<fmt:formatDate value="${fiPaymentAble.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
																	</p>
																</div>
															</div>
														</div>
													</div>
													
													<h4 class="page-header">其他信息</h4>
													<div class="row">
														<div class="col-sm-12">
															<div class="view-group">
																<label class="col-sm-2 control-label">备注：</label>
																<div class="col-sm-10">
																	<p class="form-control-static">${fiPaymentAble.remarks}</p>
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
															<th style="min-width:100px;width:100px;">单号</th>
															<th style="min-width:250px;">往来单位</th>
															<th style="min-width:100px;width:100px;">付款金额</th>
															<th style="min-width:100px;width:100px;">付款时间</th>
															<th style="min-width:150px;">付款账户</th>
															<th style="min-width:100px;width:100px;">负责人</th>
															<th style="min-width:100px;width:100px;">状态</th>
															<th style="min-width:100px;">备注</th>
															<th style="min-width:150px;width:150px;">操作</th>
														</tr>
													</thead>
													<tbody>
														<c:forEach items="${fiPaymentAble.fiPaymentBillList}" var="fiPaymentBill">
															<tr>
																		<td>
																			<a href="#" onclick="openDialogView('查看付款单', '${ctx}/fi/fiPaymentBill/view?id=${fiPaymentBill.id}','800px', '500px')">${fiPaymentBill.no}</a>
																		</td>
																		<td>
																			<c:if test="${not empty fiPaymentBill.supplier.id}">
																				[供应商] ${fiPaymentBill.supplier.name}
																			</c:if>
																			<c:if test="${not empty fiPaymentBill.customer.id}">
																				[客户] ${fiPaymentBill.customer.name}
																			</c:if>
																		</td>
																		<td>
																			${fiPaymentBill.amount}
																		</td>
																		<td>
																			<fmt:formatDate value="${fiPaymentBill.dealDate}" pattern="yyyy-MM-dd"/>
																		</td>
																		<td>
																			${fiPaymentBill.fiAccount.name}
																		</td>
																		<td>
																			${fiPaymentBill.ownBy.name}
																		</td>
																		<td>
																			${fns:getDictLabel(fiPaymentBill.status, 'audit_status', '')}
																		</td>
																		<td>
																			${fiPaymentBill.remarks}
																		</td>
																		<td>
																			<a href="#" onclick="openDialogView('查看付款单', '${ctx}/fi/fiPaymentBill/view?id=${fiPaymentBill.id}','800px', '500px')" class="" title="查看">查看</a>
																			
																			<c:if test="${fiPaymentBill.status == 0}">
																			<shiro:hasPermission name="fi:fiPaymentBill:edit">
														    					<a href="#" onclick="openDialog('修改付款单', '${ctx}/fi/fiPaymentBill/form?id=${fiPaymentBill.id}','800px', '500px')" class="" title="修改">修改</a>
																			</shiro:hasPermission>
																			<shiro:hasPermission name="fi:fiPaymentBill:del">
																				<a href="${ctx}/fi/fiPaymentBill/delete?id=${fiPaymentBill.id}" onclick="return confirmx('确认要删除该付款单吗？', this.href)" class="" title="删除">删除</a> 
																			</shiro:hasPermission>
																			<shiro:hasPermission name="fi:fiPaymentBill:audit">
																				<a href="${ctx}/fi/fiPaymentBill/audit?id=${fiPaymentBill.id}" onclick="return confirmx('确认要审核该付款单吗？', this.href)" class="" title="审核">审核</a> 
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
        <div class="col-sm-2 hide">
        	<div class="wrapper wrapper-content project-manager">
                <h4>应付款描述</h4>
                <p class="small">
                    ${fiPaymentAble.remarks}
                </p>
               
                
            </div>
        </div>
    </div>
    

</body>
</html>