<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>应收款主页</title>
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
                                    	<h3><img src="${ctxStatic}/weui/images/app/icon_able_receive.png" class="ibox-title-img">${fiReceiveAble.no }</h3>
                                    </div>
                                    <div class="pull-right">
										
										<c:if test="${fiReceiveAble.status != 2}">
											<shiro:hasPermission name="fi:fiReceiveBill:add">
						   						<a href="#" onclick="openDialog('添加收款单', '${ctx}/fi/fiReceiveBill/form?fiReceiveAble.id=${fiReceiveAble.id}&fiReceiveAble.name=${fiReceiveAble.no}&customer.id=${fiReceiveAble.customer.id}&customer.name=${fiReceiveAble.customer.name}','800px', '500px')" class="btn btn-success btn-sm" title="添加收款单"><i class="fa fa-plus"></i>
												<span class="hidden-xs">添加收款单</span></a>
											</shiro:hasPermission>
										
											<shiro:hasPermission name="fi:fiReceiveAble:edit">
						    					<a href="#" onclick="openDialog('修改应收时间', '${ctx}/fi/fiReceiveAble/editForm?id=${fiReceiveAble.id}','800px', '500px')" class="btn btn-default btn-sm" title="修改应收时间">修改应收时间</a>
											</shiro:hasPermission>
										</c:if>
					
										<c:if test="${fiReceiveAble.status == 0}">
										<div class="btn-group">
						                    <button data-toggle="dropdown" class="btn btn-default btn-sm dropdown-toggle" aria-expanded="false">更多 <i class="fa fa-chevron-down"></i>
						                    </button>
						                    <ul class="dropdown-menu">
						                        <li>
						                        	<shiro:hasPermission name="fi:fiReceiveAble:edit">
								    					<a href="#" onclick="openDialog('修改应收款', '${ctx}/fi/fiReceiveAble/editForm?id=${fiReceiveAble.id}','800px', '500px')" class="" title="修改"><i class="fa fa-edit"></i> 修改</a>
													</shiro:hasPermission>
						                        </li>
						                        <li>
						                        	<shiro:hasPermission name="fi:fiReceiveAble:del">
														<a href="${ctx}/fi/fiReceiveAble/delete?id=${fiReceiveAble.id}" onclick="return confirmx('确认要删除该应收款吗？', this.href)" class="" title="删除"><i class="fa fa-trash"></i> 删除</a> 
													</shiro:hasPermission>
						                        </li>
						                       
						                    </ul>
						                </div>
						                </c:if>
						                <a href="${ctx}/fi/fiReceiveAble/index?id=${fiReceiveAble.id}" class="btn btn-default btn-sm" title="刷新"><i class="fa fa-refresh"></i> </a>
					        			<button id="btnCancel" class="btn btn-default btn-sm" type="button" onclick="history.go(-1)" title="返回"><i class="fa fa-rotate-left"></i> </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-5">
                                <dl class="dl-horizontal">
									<dt>应收金额：</dt>
                                    <dd>${fiReceiveAble.amount }</dd>
                                    <dt>客户名称：</dt>
                                    <dd><a href="${ctx}/crm/crmCustomer/index?id=${fiReceiveAble.customer.id}">${fiReceiveAble.customer.name }</a></dd>
                                    <dt>状态：</dt>
                                    <dd><span class="text-navy">${fns:getDictLabel(fiReceiveAble.status, 'finish_status', '')}</span></dd>
                                    <dt>创建者：</dt>
                                    <dd>${fiReceiveAble.createBy.name}</dd>
                                </dl>
                            </div>
                            <div class="col-sm-7" id="cluster_info">
                                <dl class="dl-horizontal">
									<dt>实际已收：</dt>
                                    <dd>
                                    	${fiReceiveAble.realAmt }
                                    	<c:if test="${(fiReceiveAble.amount - fiReceiveAble.realAmt) > 0}">
											（差额：<span class="text-warning">${fiReceiveAble.amount - fiReceiveAble.realAmt}</span>）
										</c:if>
                                    </dd>
                                    <dt>合同订单：</dt>
                                    <dd><a href="${ctx}/om/omContract/index?id=${fiReceiveAble.order.id}">${fiReceiveAble.order.no}</a></dd>
                                    <dt>应收时间：</dt>
                                    <dd><fmt:formatDate value="${fiReceiveAble.ableDate}" pattern="yyyy-MM-dd"/></dd>
                                    <dt>负责人：</dt>
                                    <dd class="">
                                        ${fiReceiveAble.ownBy.name}
                                    </dd>
                                </dl>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="">
                	<div class="">
                         <div class="row m-t-sm">
                            <div class="col-sm-12">
                            	<div class="tabs-container">
								 	<ul class="nav nav-tabs">
								 		<li class="active"><a data-toggle="tab" href="#tab-0" aria-expanded="true">概况</a></li>
								 		<li class=""><a data-toggle="tab" href="#tab-1" aria-expanded="true">详细信息</a></li>
								 		<li><a data-toggle="tab" href="#tab-3" aria-expanded="false">收款单 <span class="badge badge-info"><c:if test="${fn:length(fiReceiveAble.fiReceiveBillList)>0}">${fn:length(fiReceiveAble.fiReceiveBillList)}</c:if></span></a></li>
								 		<li><a data-toggle="tab" href="#tab-4" aria-expanded="false">操作日志 <span class="badge badge-info"><c:if test="${fn:length(sysDynamicList)>0}">${fn:length(sysDynamicList)}</c:if></span></a></li>
								 	</ul>
								 	<div class="tab-content">
								 		<div class="tab-pane active" id="tab-0">
								               <div class="panel-body">
								 				<div class="social-feed-box">
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
								 					<form:form id="recordInputForm" modelAttribute="crmContactRecord" action="${ctx}/crm/crmContactRecord/save" method="post" style="margin:10px;">
													<form:hidden path="targetType"/>
													<form:hidden path="targetId"/>
													<form:hidden path="targetName"/>
								 					<form:textarea path="content" htmlEscape="false" style="margin-top: 10px;height: 80px;width: 100%;border:0;" maxlength="500" class="form-control required"  placeholder="发布一条跟进记录..."/>
								 					记录类型：
									                    	<form:select path="contactType" class="form-control required input-small">
																<form:options items="${fns:getDictList('contact_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
															</form:select>
															<button class="btn btn-info btn-bx"> 发  布 </button>
								 					</form:form>
								 				</div>
								 				
								 				<c:forEach items="${crmContactRecordList}" var="crmContactRecord">
								 				<div class="social-feed-box">
								                    <div class="pull-right social-action dropdown">
								                        <button data-toggle="dropdown" class="dropdown-toggle btn-white">
								                            <i class="fa fa-angle-down"></i>
								                        </button>
								                        <ul class="dropdown-menu m-t-xs">
								                            <li>
						                                    	<a href="#" onclick="openDialog('修改跟进记录', '${ctx}/crm/crmContactRecord/form?id=${crmContactRecord.id}','800px', '500px')"  title="修改" >修改</a>
	                       									</li>
	                       									<li>
	                       										<a href="${ctx}/crm/crmContactRecord/indexDelete?id=${crmContactRecord.id}" onclick="return confirmx('确认要删除该跟进记录吗？', this.href)"  title="删除">删除</a> 
						                                    </li>
								                        </ul>
								                    </div>
								                    <div class="social-avatar">
								                        <a href="" class="pull-left">
								                            <img alt="image" src="${crmContactRecord.createBy.photo}" onerror="this.src='${ctxStatic}/images/user.jpg'">
								                        </a>
								                        <div class="media-body">
								                            <a href="#">${crmContactRecord.createBy.name}</a>
								                            <small class="text-muted">${fns:getDictLabel(crmContactRecord.contactType, 'contact_type', '')} | <fmt:formatDate value="${crmContactRecord.createDate}" pattern="yyyy-MM-dd hh:mm"/> | ${fns:getTimeDiffer(crmContactRecord.contactDate)}</small>
								                        </div>
								                    </div>
								                    <div class="social-body">
								                        <p>${crmContactRecord.content}</p>
								                    </div>
								                </div>
								                </c:forEach>
								                
								                <%--跟进记录开始 --%>
								                <div class="row hide">
								                	<div class="col-lg-12">
								                		
								                		<div class="ibox float-e-margins">
										                    <c:forEach items="${crmContactRecordList}" var="crmContactRecord">
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
										                    <div class="hr-line-dashed"></div>
										                    </c:forEach>
										                </div>
										                
								                	</div>
								                </div>
								                <%--跟进记录结束 --%>
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
																<label class="col-sm-4 control-label">单号：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${fiReceiveAble.no }
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">状态：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${fns:getDictLabel(fiReceiveAble.status, 'finish_status', '')}
																	</p>
																</div>
															</div>
														</div>
													</div>
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">合同订单：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	<a href="${ctx}/om/omContract/index?id=${fiReceiveAble.order.id}">${fiReceiveAble.order.no}</a>
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">客户名称：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${fiReceiveAble.customer.name } 
																	</p>
																</div>
															</div>
														</div>
													</div>
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">应收金额：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${fiReceiveAble.amount }	
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">实际已收：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${fiReceiveAble.realAmt }
																	</p>
																</div>
															</div>
														</div>
													</div>
													<div class="row">
													
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">应收时间：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	<fmt:formatDate value="${fiReceiveAble.ableDate}" pattern="yyyy-MM-dd"/>
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">负责人：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${fiReceiveAble.ownBy.name}
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
																		${fiReceiveAble.createBy.name}
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">创建时间：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																		<fmt:formatDate value="${fiReceiveAble.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
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
																		${fiReceiveAble.updateBy.name}
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">更新时间：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																		<fmt:formatDate value="${fiReceiveAble.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
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
																	<p class="form-control-static">${fiReceiveAble.remarks}</p>
																</div>
															</div>
														</div>
													</div>
												</div>
								 			</div>
								 		</div>
								 		<div id="tab-3" class="tab-pane">
								 			<div class="panel-body">
								 				<c:if test="${fiReceiveAble.status != 2}">
													<shiro:hasPermission name="fi:fiReceiveBill:add">
								   						<a href="#" onclick="openDialog('添加收款单', '${ctx}/fi/fiReceiveBill/form?fiReceiveAble.id=${fiReceiveAble.id}&fiReceiveAble.name=${fiReceiveAble.no}&customer.id=${fiReceiveAble.customer.id}&customer.name=${fiReceiveAble.customer.name}','800px', '500px')" class="btn btn-success btn-sm" title="添加收款单"><i class="fa fa-plus"></i>
														<span class="hidden-xs">添加收款单</span></a>
														<br><br>
													</shiro:hasPermission>
												</c:if>
												
								 				<div class="table-responsive">
								 				<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed">
													<thead>
														<tr>
															<th class="hide"></th>
															<th style="min-width:100px;width:100px;">单号</th>
															<th style="min-width:250px;">客户</th>
															<th style="min-width:100px;width:100px;">收款金额</th>
															<th style="min-width:100px;width:100px;">收款时间</th>
															<th style="min-width:100px;">收款账户</th>
															<th style="min-width:100px;width:100px;">收款人</th>
															<th style="min-width:100px;width:100px;">是否开票</th>
															<th style="min-width:100px;width:100px;">开票金额</th>
															<th style="min-width:100px;width:100px;">状态</th>
															<th style="min-width:100px;">备注</th>
															<th style="min-width:150px;width:150px;">操作</th>
														</tr>
													</thead>
													<tbody>
														<c:forEach items="${fiReceiveAble.fiReceiveBillList}" var="fiReceiveBill">
															<tr>
																<td>
																	<a href="#" onclick="openDialogView('查看收款单', '${ctx}/fi/fiReceiveBill/view?id=${fiReceiveBill.id}','800px', '500px')">${fiReceiveBill.no}</a>
																</td>
																<td>
																	${fiReceiveBill.customer.name}
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
																<td>
								
																	<a href="#" onclick="openDialogView('查看收款单', '${ctx}/fi/fiReceiveBill/view?id=${fiReceiveBill.id}','800px', '500px')" class="" title="查看">查看</a>
																	
																	<c:if test="${fiReceiveBill.status == 0}">
																	<shiro:hasPermission name="fi:fiReceiveBill:edit">
												    					<a href="#" onclick="openDialog('修改收款单', '${ctx}/fi/fiReceiveBill/form?id=${fiReceiveBill.id}','800px', '500px')" class="" title="修改">修改</a>
																	</shiro:hasPermission>
																	<shiro:hasPermission name="fi:fiReceiveBill:del">
																		<a href="${ctx}/fi/fiReceiveBill/delete?id=${fiReceiveBill.id}" onclick="return confirmx('确认要删除该收款单吗？', this.href)" class="" title="删除">删除</a> 
																	</shiro:hasPermission>
																	<shiro:hasPermission name="fi:fiReceiveBill:audit">
																		<a href="${ctx}/fi/fiReceiveBill/audit?id=${fiReceiveBill.id}" onclick="return confirmx('确认要审核该收款单吗？', this.href)" class="" title="审核">审核</a> 
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
                <h4>应收款描述</h4>
                <p class="small">
                    ${fiReceiveAble.remarks}
                </p>
               
                
            </div>
        </div>
    </div>
    

</body>
</html>