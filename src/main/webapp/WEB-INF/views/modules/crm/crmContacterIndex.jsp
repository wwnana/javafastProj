<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>联系人主页</title>
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
                                    	<h3><img src="${ctxStatic}/weui/images/app/icon_service.png" class="ibox-title-img">${crmContacter.name} </h3>
                                    </div>
                                    <div class="pull-right">
										
										<shiro:hasPermission name="crm:crmContacter:edit">
					    					<a href="#" onclick="openDialog('修改服务联系人', '${ctx}/crm/crmContacter/form?id=${crmContacter.id}','800px', '500px')" class="btn btn-default btn-sm" title="修改"><i class="fa fa-edit"></i> 修改</a>
										</shiro:hasPermission>
										
					    				
										<div class="btn-group">
						                    <button data-toggle="dropdown" class="btn btn-default btn-sm dropdown-toggle" aria-expanded="false">更多 <i class="fa fa-chevron-down"></i>
						                    </button>
						                    <ul class="dropdown-menu">
						                        <li>
						                        	<shiro:hasPermission name="crm:crmContacter:del">
														<a href="${ctx}/crm/crmContacter/delete?id=${crmContacter.id}" onclick="return confirmx('确认要删除该服务联系人吗？', this.href)" class="" title="删除"><i class="fa fa-trash"></i> 删除</a> 
													</shiro:hasPermission>
						                        </li>
						                       
						                    </ul>
						                </div>
						                
						                <a href="${ctx}/crm/crmContacter/index?id=${crmContacter.id}" class="btn btn-default btn-sm" title="刷新"><i class="fa fa-refresh"></i> </a>
					        			<button id="btnCancel" class="btn btn-default btn-sm" type="button" onclick="history.go(-1)" title="返回"><i class="fa fa-rotate-left"></i> </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-5">
                                <dl class="dl-horizontal">
									<dt>职务：</dt>
                                    <dd>${crmContacter.jobType}</dd>
                                    <dt>手机：</dt>
                                    <dd>${crmContacter.mobile}</dd>
                                    <dt>角色：</dt>
                                    <dd>
                                    	${fns:getDictLabel(crmContacter.roleType, 'role_type', '')}
                                    </dd>
                                    
                                </dl>
                            </div>
                            <div class="col-sm-7" id="cluster_info">
                                <dl class="dl-horizontal">
									<dt>所属客户：</dt>
									<dd><a href="${ctx}/crm/crmCustomer/index?id=${crmContacter.customer.id}">${crmContacter.customer.name}</a></dd>
									<dt>创建日期：</dt>
                                    <dd><fmt:formatDate value="${crmContacter.createDate}" pattern="yyyy-MM-dd"/></dd>
                                    <dt>创建者：</dt>
                                    <dd>${crmContacter.createBy.name}</dd>
                                    <dt>负责人：</dt>
                                    <dd class="">${crmContacter.ownBy.name}</dd>
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
								 		<li class=""><a data-toggle="tab" href="#tab-1" aria-expanded="true"> 详细信息</a></li>
								 		<li><a data-toggle="tab" href="#tab-4" aria-expanded="false">操作日志 <span class="badge badge-info"><c:if test="${fn:length(sysDynamicList)>0}">${fn:length(sysDynamicList)}</c:if></span></a></li>
								 	</ul>
								 	<div class="tab-content">
								 		<div class="tab-pane active" id="tab-0">
								                
								                <%--跟进记录开始 --%>
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
																<label class="col-sm-4 control-label">姓名：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${crmContacter.name}
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">性别：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${fns:getDictLabel(crmContacter.sex, 'sex', '')}
																	</p>
																</div>
															</div>
														</div>
													</div>
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">职务：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${crmContacter.jobType}
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">手机：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${crmContacter.mobile}
																	</p>
																</div>
															</div>
														</div>
													</div>
													
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">电话：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${crmContacter.tel}
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">邮箱：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${crmContacter.email}
																	</p>
																</div>
															</div>
														</div>
													</div>
													
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">微信：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${crmContacter.wx}
																	</p>
																</div>
															</div>
														</div>
													
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">QQ：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${crmContacter.qq}
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
																	${crmContacter.remarks}
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
																	${crmContacter.updateBy.name}
																	</p>
																</div>
															</div>
														</div>
													
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">更新时间：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	<fmt:formatDate value="${crmContacter.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
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
																	${crmContacter.createBy.name}
																	</p>
																</div>
															</div>
														</div>
													
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">创建时间：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	<fmt:formatDate value="${crmContacter.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
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
        <div class="col-sm-2 hide">
        	<div class="wrapper wrapper-content project-manager">
                <h4>联系人描述</h4>
                <p class="small">
                    ${crmContacter.remarks}
                </p>
               
                
            </div>
        </div>
    </div>
    
</body>
</html>