<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>产品主页</title>
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
                                    	<h3><img src="${ctxStatic}/weui/images/app/icon_market.png" class="ibox-title-img">${wmsProduct.name} </h3>
                                    </div>
                                    <div class="pull-right">
										
										
										<shiro:hasPermission name="wms:wmsProduct:edit">
					    					<a href="#" onclick="openDialog('修改产品', '${ctx}/wms/wmsProduct/form?id=${wmsProduct.id}','1000px', '80%')" class="btn btn-default btn-sm" title="修改"><i class="fa fa-pencil"></i> 编辑</a>
										</shiro:hasPermission>
										
										<div class="btn-group">
						                    <button data-toggle="dropdown" class="btn btn-default btn-sm dropdown-toggle" aria-expanded="false">更多 <i class="fa fa-chevron-down"></i>
						                    </button>
						                    <ul class="dropdown-menu">
						                        
						                        <li>
						                        	<shiro:hasPermission name="wms:wmsProduct:del">
														<a href="${ctx}/wms/wmsProduct/delete?id=${wmsProduct.id}" onclick="return confirmx('确认要删除该产品吗？', this.href)"  title="删除"><i class="fa fa-trash"></i> 删除</a> 
													</shiro:hasPermission>
						                        </li>
						                       
						                    </ul>
						                </div>
						                
						                <a href="${ctx}/wms/wmsProduct/view?id=${wmsProduct.id}" class="btn btn-default btn-sm" title="刷新"><i class="fa fa-refresh"></i> </a>
					        			<button id="btnCancel" class="btn btn-default btn-sm" type="button" onclick="history.go(-1)" title="返回"><i class="fa fa-rotate-left"></i> </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-5">
                                <dl class="dl-horizontal">
									<dt>产品分类：</dt>
                                    <dd>${wmsProduct.productType.name}</dd>
                                    <dt>标准价格：</dt>
                                    <dd>${wmsProduct.salePrice}</dd>
                                </dl>
                            </div>
                            <div class="col-sm-7" id="cluster_info">
                                <dl class="dl-horizontal">
									<dt>创建者：</dt>
                                    <dd>${wmsProduct.createBy.name}</dd>
                                    <dt>创建时间：</dt>
                                    <dd><fmt:formatDate value="${wmsProduct.createDate}" pattern="yyyy-MM-dd HH:mm"/></dd>
                                </dl>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="">
                	<div>    
                         <div class="row m-t-sm">
                            <div class="col-sm-12">
                            	<div class="tabs-container">
								 	<ul class="nav nav-tabs">
								 		<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">详细信息</a></li>
								 		<li class=""><a data-toggle="tab" href="#tab-2" aria-expanded="true">产品介绍</a></li>
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
																<label class="col-sm-4 control-label">产品名称：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${wmsProduct.name}
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">产品编号：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${wmsProduct.no}
																	</p>
																</div>
															</div>
														</div>
													</div>
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">基本单位：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${fns:getDictLabel(wmsProduct.unitType, 'unit_type', '')}
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">规格：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${wmsProduct.spec}
																	</p>
																</div>
															</div>
														</div>
													</div>
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">标准价格：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${wmsProduct.salePrice}
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">最低售价：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${wmsProduct.minPrice}
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
																		${wmsProduct.createBy.name}
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">创建时间：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																		<fmt:formatDate value="${wmsProduct.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
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
																		${wmsProduct.updateBy.name}
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">更新时间：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																		<fmt:formatDate value="${wmsProduct.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
																	</p>
																</div>
															</div>
														</div>
													</div>
													
													<h4 class="page-header">其他信息</h4>
													<div class="row">
														<div class="col-sm-12">
															<div class="view-group">
																<label class="col-sm-2 control-label">描述：</label>
																<div class="col-sm-10">
																	<p class="form-control-static">${wmsProduct.remarks}</p>
																</div>
															</div>
														</div>
													</div>
												</div>
								 			</div>
								 		</div>
								 		<div id="tab-2" class="tab-pane">
								 			<div class="panel-body">
								 				${wmsProduct.wmsProductData.content}
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
        
    </div>
    

</body>
</html>