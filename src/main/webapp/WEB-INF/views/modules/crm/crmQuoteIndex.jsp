<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>报价单主页</title>
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
                                		<h2>
                                    		<img src="${ctxStatic}/weui/images/app/icon_list.png" class="ibox-title-img">${crmQuote.no}                                    		
                                    	</h2>
                                    </div>
                                    <div class="pull-right">
										
										<c:if test="${crmQuote.status == 0}">
											<shiro:hasPermission name="crm:crmQuote:edit">
						    					<a href="${ctx}/crm/crmQuote/form?id=${crmQuote.id}" class="btn btn-default btn-sm" title="修改"><i class="fa fa-edit"></i>
													<span class="hidden-xs">修改</span></a>
											</shiro:hasPermission>
											
											<shiro:hasPermission name="crm:crmQuote:audit">
												<a href="${ctx}/crm/crmQuote/audit?id=${crmQuote.id}" onclick="return confirmx('确认要审核该报价单吗？', this.href)" class="btn btn-default btn-sm" title="审核"><i class="fa fa-check"></i>
													<span class="hidden-xs">审核</span></a> 
											</shiro:hasPermission>
											</c:if>
											<c:if test="${crmQuote.status == 1}">
											<shiro:hasPermission name="om:omContract:edit">
						    					<a href="${ctx}/om/omContract/quoteToForm?quote.id=${crmQuote.id}" class="btn btn-default btn-sm" title="生成订单合同"><i class="fa fa-edit"></i>
													<span class="hidden-xs">生成订单合同</span></a>
											</shiro:hasPermission>
										</c:if>
										
										
								
										<div class="btn-group">
						                    <button data-toggle="dropdown" class="btn btn-default btn-sm dropdown-toggle" aria-expanded="false">更多 <i class="fa fa-chevron-down"></i>
						                    </button>
						                    <ul class="dropdown-menu">
						                        <c:if test="${crmQuote.status == 0}">
						                        <li>
						                        	<shiro:hasPermission name="crm:crmQuote:del">
														<a href="${ctx}/crm/crmQuote/delete?id=${crmQuote.id}" onclick="return confirmx('确认要删除该报价单吗？', this.href)" class="btn  btn-danger" title="删除"><i class="fa fa-trash"></i>
															<span class="hidden-xs">删除</span></a> 
													</shiro:hasPermission>
						                        </li>
						                       </c:if>
						                       <li>
						                       		<a href="${ctx}/crm/crmQuote/print?id=${crmQuote.id}"  title="打印" target="_blank"><i class="fa fa-print"></i> <span class="hidden-xs">打印</span></a>
						                       </li>
						                    </ul>
						                </div>
						                
						                <a href="${ctx}/crm/crmQuote/view?id=${crmQuote.id}" class="btn btn-default btn-sm" title="刷新"><i class="fa fa-refresh"></i> </a>
					        			<button id="btnCancel" class="btn btn-default btn-sm" type="button" onclick="history.go(-1)" title="返回"><i class="fa fa-rotate-left"></i> </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-5">
                                <dl class="dl-horizontal">
									<dt>报价编号：</dt>
                                    <dd>${crmQuote.no}</dd>
                                    <dt>报价金额：</dt>
                                    <dd>${crmQuote.amount}元</dd>
                                    <dt>报价状态：</dt>
                                    <dd>
                                    	<span class="<c:if test='${crmQuote.status == 0}'>text-danger</c:if><c:if test='${crmQuote.status == 1}'>text-success</c:if>">
                                    	${fns:getDictLabel(crmQuote.status, 'audit_status', '')}
                                    	</span>
                                    <dt>创建者：</dt>
                                    <dd>${crmQuote.createBy.name}</dd>
                                </dl>
                            </div>
                            <div class="col-sm-7" id="cluster_info">
                                <dl class="dl-horizontal">
									<dt>客户名称：</dt>
                                    <dd><a href="${ctx}/crm/crmCustomer/index?id=${crmQuote.customer.id}">${crmQuote.customer.name}</a></dd>
                                    <dt>报价日期：</dt>
                                    <dd><fmt:formatDate value="${crmQuote.startdate}" pattern="yyyy-MM-dd"/></dd>
                                    <dt>截止日期：</dt>
                                    <dd><fmt:formatDate value="${crmQuote.enddate}" pattern="yyyy-MM-dd"/></dd>
                                    <dt>负责人：</dt>
                                    <dd>${crmQuote.ownBy.name}</dd>
                                </dl>
                            </div>
                        </div>
                         <div class="row m-t-sm">
                            <div class="col-sm-12">
                            	<div class="tabs-container">
								 	<ul class="nav nav-tabs">
								 		<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">详细信息</a></li>
								 		<li><a data-toggle="tab" href="#tab-3" aria-expanded="false">报价明细 <span class="badge badge-info"><c:if test="${fn:length(crmQuote.crmQuoteDetailList)>0}">${fn:length(crmQuote.crmQuoteDetailList)}</c:if></span></a></li>
			 							<li><a data-toggle="tab" href="#tab-4" aria-expanded="false">关联合同 <span class="badge badge-info"><c:if test="${fn:length(omContractList)>0}">${fn:length(omContractList)}</c:if></span></a></li>
								 		<li><a data-toggle="tab" href="#tab-5" aria-expanded="false">操作日志 <span class="badge badge-info"><c:if test="${fn:length(sysDynamicList)>0}">${fn:length(sysDynamicList)}</c:if></span></a></li>
								 	</ul>
								 	<div class="tab-content">
								 		<div class="tab-pane active" id="tab-1">
                                            
								 			<div class="panel-body">
								 				<div class="form-horizontal">				 				
													<h4 class="page-header">基本信息</h4>
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">客户</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																		<a href="${ctx}/crm/crmCustomer/index?id=${crmQuote.customer.id}">${crmQuote.customer.name}</a>
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">单号</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																		${crmQuote.no}
																	</p>
																</div>
															</div>
														</div>
														
													</div>
													<div class="row">
														
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">联系人</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																		${crmQuote.contacter.name}
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">关联商机</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																		<a href="${ctx}/crm/crmChance/index?id=${crmQuote.chance.id}">${crmQuote.chance.name}</a>
																	</p>
																</div>
															</div>
														</div>
													</div>
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">总金额</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																		${crmQuote.amount}元
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">状态</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																		${fns:getDictLabel(crmQuote.status, 'audit_status', '')}
																	</p>
																</div>
															</div>
														</div>
													</div>
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">报价日期</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																		<fmt:formatDate value="${crmQuote.startdate}" pattern="yyyy-MM-dd"/>
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">有效期至</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																		<fmt:formatDate value="${crmQuote.enddate}" pattern="yyyy-MM-dd"/>
																	</p>
																</div>
															</div>
														</div>
														
													</div>
													
													
													<h4 class="page-header">操作信息</h4>
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">制单人</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																		${crmQuote.createBy.name}
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">制单时间</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																		<fmt:formatDate value="${crmQuote.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
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
																		${crmQuote.auditBy.name}
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">审核时间</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																		<fmt:formatDate value="${crmQuote.auditDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
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
								 				<%--报价单明细 开始 --%>
												<div class="table-responsive">
												<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed">
													<thead>
														<tr>
															<th width="50px">序号</th>
															<th width="150px">产品编号</th>
															<th>产品名称</th>
															<th width="100px">规格</th>
															<th width="100px">单位</th>
															<th width="100px">单价(元)</th>
															<th width="100px">数量</th>
															<th width="100px">金额(元)</th>
															<th>备注</th>
														</tr>
													</thead>
													<tbody>
														<c:forEach items="${crmQuote.crmQuoteDetailList}" var="crmQuoteDetail" varStatus="sta">
															<tr>
																		<td>${sta.index + 1}</td>
																		<td>
																			${crmQuoteDetail.product.no}
																		</td>
																		<td>
																			${crmQuoteDetail.product.name}
																		</td>
																		<td>
																			${crmQuoteDetail.product.spec}
																		</td>
																		<td>
																			${crmQuoteDetail.unitType}
																		</td>
																		<td>
																			${crmQuoteDetail.price}
																		</td>
																		<td>
																			${crmQuoteDetail.num}
																		</td>
																		<td>
																			${crmQuoteDetail.amt}
																		</td>
																		<td>
																			${crmQuoteDetail.remarks}
																		</td>
															</tr>
														</c:forEach>
													</tbody>
												</table>	
												<div class="pull-right">
													<div class="form-horizontal">
														总金额：${crmQuote.amount} ，  
														总数量：${crmQuote.num}
													</div>
												</div>
												</div>
												<%--报价单明细 结束 --%>
								 			</div>
								 		</div>
								 		<div id="tab-4" class="tab-pane">
								 			<div class="panel-body">
								 				<div class="table-responsive">
													<table id="contentTable" class="table table-bordered table-striped table-hover">
														<thead>
															<tr>
																<th width="160px">合同编号</th>
																<th width="100px" class="sort-column a.amount">总金额</th>
																<th width="100px" class="sort-column a.deal_date">签约日期</th>
																<th width="100px" class="sort-column a.deliver_date">交付时间</th>
																
																
																<th width="80px" class="sort-column a.status">状态</th>
																<th width="100px" class="sort-column a.own_by">负责人</th>
																<th width="100px" class="sort-column a.create_date">创建时间</th>
																<th width="150px">操作</th>
															</tr>
														</thead>
														<tbody>
														<c:forEach items="${omContractList}" var="omContract">
															<tr>
																<td><a href="${ctx}/om/omContract/index?id=${omContract.id}">
																	${omContract.no}
																</a></td>
																<td>
																	${omContract.amount}
																</td>
																<td>
																	<fmt:formatDate value="${omContract.dealDate}" pattern="yyyy-MM-dd"/>
																</td>
																<td>
																	<fmt:formatDate value="${omContract.deliverDate}" pattern="yyyy-MM-dd"/>
																</td>
																<td>
																	<span class="<c:if test='${omContract.status == 0}'>text-danger</c:if>">
																		${fns:getDictLabel(omContract.status, 'audit_status', '')}
																	</span>
																</td>
																<td>
																	${omContract.ownBy.name}
																</td>
																<td>
																	<fmt:formatDate value="${omContract.createDate}" pattern="yyyy-MM-dd"/>
																</td>
																<td>
																	<shiro:hasPermission name="om:omContract:view">
																		<a href="${ctx}/om/omContract/index?id=${omContract.id}" class="" title="查看">查看</a>
																	</shiro:hasPermission>
																	<c:if test="${omContract.status == 0}">
																		<shiro:hasPermission name="om:omContract:edit">
													    					<a href="${ctx}/om/omContract/form?id=${omContract.id}" class="" title="修改">修改</a>
																		</shiro:hasPermission>
																		
																		<shiro:hasPermission name="om:omContract:del">
																			<a href="${ctx}/om/omContract/delete?id=${omContract.id}" onclick="return confirmx('确认要删除该合同吗？', this.href)" class="" title="删除">删除</a> 
																		</shiro:hasPermission>
																		
																		<shiro:hasPermission name="om:omContract:audit">
																			<a href="${ctx}/om/omContract/audit?id=${omContract.id}" onclick="return confirmx('确认要审核该合同吗？', this.href)" class="" title="审核">审核</a> 
																		</shiro:hasPermission>
																		
																	</c:if>
																	<c:if test="${omContract.status == 1}">
																		<shiro:hasPermission name="om:omContract:revoke">
																			<a href="${ctx}/om/omContract/revoke?id=${omContract.id}" onclick="return confirmx('撤销合同会自动删除关联的应收款和出库单，确认要撤销该合同吗？', this.href)" class="" title="撤销">撤销</a> 
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
								 		<div id="tab-5" class="tab-pane">
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
                <h4>报价备注</h4>
                <p class="small">
                    ${crmQuote.remarks}
                </p>
                <br>
               <h4>报价附件</h4>
               <div class="row">
					<div class="col-sm-12">
						<div class="view-group">
							<div class="col-sm-10">
								<input type="hidden" id="files" value="${crmQuote.files}">
								<sys:ckfinder input="files" type="files" uploadPath="/file" selectMultiple="true" readonly="true"/>
							</div>
						</div>
					</div>
				</div>
                
                
            </div>
        </div>
    </div>
    

</body>
</html>