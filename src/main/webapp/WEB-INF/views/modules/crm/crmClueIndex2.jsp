<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>销售线索主页</title>
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
                                    	<h3><img src="${ctxStatic}/weui/images/app/icon_clue.png" class="ibox-title-img">${crmClue.name} </h3>
                                    </div>
                                    <div class="pull-right">
                                    	<a href="https://www.baidu.com/s?wd=${crmClue.name }" class="btn btn-default btn-sm" title="百度查" target="_blank">百度查</a>
										
										
										
										
										<shiro:hasPermission name="crm:crmClue:edit">
						   					<a href="#" onclick="openDialog('修改销售线索', '${ctx}/crm/crmClue/form?id=${crmClue.id}','1000px', '80%')" class="btn btn-default btn-sm" title="修改"><i class="fa fa-pencil"></i> 编辑</a>
										</shiro:hasPermission>
										
										<c:if test="${empty crmClue.crmCustomer.id}">
											<shiro:hasPermission name="crm:crmClue:edit">
						    					<a href="#" onclick="openDialog('转为客户', '${ctx}/crm/crmClue/toCustomerform?id=${crmClue.id}','1000px', '80%')" class="btn btn-default btn-sm" title="转为客户"><i class="fa fa-share"></i> 转为客户</a>
											</shiro:hasPermission>
										</c:if>
										<div class="btn-group">
						                    <button data-toggle="dropdown" class="btn btn-default btn-sm dropdown-toggle" aria-expanded="false">更多 <i class="fa fa-chevron-down"></i>
						                    </button>
						                    <ul class="dropdown-menu">
						                        <li>
						                        	 
						                        </li>
						                        <li>
						                        	<shiro:hasPermission name="crm:crmClue:del">
														<a href="${ctx}/crm/crmClue/delete?id=${crmClue.id}" onclick="return confirmx('确认要删除该销售线索吗？', this.href)" class="  " title="删除"><span class="hidden-xs">删除</span></a> 
													</shiro:hasPermission>
						                        </li>
						                       
						                    </ul>
						                </div>
						                
						                <a href="${ctx}/crm/crmClue/index?id=${crmClue.id}" class="btn btn-default btn-sm" title="刷新"><i class="fa fa-refresh"></i> </a>
					        			<button id="btnCancel" class="btn btn-default btn-sm" type="button" onclick="history.go(-1)" title="返回"><i class="fa fa-rotate-left"></i> </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-5">
                                <dl class="dl-horizontal">

                                    <dt>状态：</dt>
                                    <dd><c:if test="${empty crmClue.crmCustomer.id}"><span class="text-danger">未转化</span></c:if><c:if test="${not empty crmClue.crmCustomer.id}"><span class="text-success">已转化</span></c:if></dd>
                                    <dt>客户：</dt>
                                    <dd>
                                    	<c:if test="${empty crmClue.crmCustomer.name}">--</c:if>
                                    	<a href="${ctx}/crm/crmCustomer/index?id=${crmClue.crmCustomer.id}">${crmClue.crmCustomer.name}</a></dd>
                                    <dt>创建者：</dt>
                                    <dd>${crmClue.createBy.name}</dd>
                                </dl>
                            </div>
                            <div class="col-sm-7" id="cluster_info">
                                <dl class="dl-horizontal">

                                    <dt>最后更新：</dt>
                                    <dd><fmt:formatDate value="${crmClue.updateDate}" pattern="yyyy年 MM月dd日 HH:mm"/></dd>
                                    <dt>创建于：</dt>
                                    <dd><fmt:formatDate value="${crmClue.createDate}" pattern="yyyy年 MM月dd日 HH:mm"/></dd>
                                    <dt>负责人：</dt>
                                    <dd class="">${crmClue.ownBy.name}</dd>
                                </dl>
                            </div>
                        </div>
                         <div class="row m-t-sm">
                            <div class="col-sm-12">
                            	<div class="tabs-container">
								 	<ul class="nav nav-tabs">
								 		<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true"><i class="fa fa-laptop"></i> 概况</a></li>
								 		<li class=""><a data-toggle="tab" href="#tab-2" aria-expanded="false">详细信息</a></li>
								 		<li><a data-toggle="tab" href="#tab-4" aria-expanded="false">操作日志 <span class="badge badge-info"><c:if test="${fn:length(sysDynamicList)>0}">${fn:length(sysDynamicList)}</c:if></span></a></li>
								 	</ul>
								 	<div class="tab-content">
								 		<div class="tab-pane active" id="tab-1">
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
								 		<div id="tab-2" class="tab-pane">
								 			<div class="panel-body">
								 				<div class="form-horizontal">				 				
													<h4 class="page-header">基本信息</h4>
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">公司：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${crmClue.name}
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">姓名：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${crmClue.contacterName}
																	</p>
																</div>
															</div>
														</div>
													</div>
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">性别：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${fns:getDictLabel(crmClue.sex, 'sex', '')}
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">职务：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${crmClue.jobType}
																	</p>
																</div>
															</div>
														</div>
													</div>
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">手机：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${crmClue.mobile}
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">邮箱：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${crmClue.email}
																	</p>
																</div>
															</div>
														</div>
														
													</div>
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">线索来源：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${fns:getDictLabel(crmClue.sourType, 'sour_type', '')}
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">所属行业：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${fns:getDictLabel(crmClue.industryType, 'industry_type', '')}
																	</p>
																</div>
															</div>
														</div>
													</div>
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">企业性质：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${fns:getDictLabel(crmClue.natureType, 'nature_type', '')}
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">企业规模：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${fns:getDictLabel(crmClue.scaleType, 'scale_type', '')}
																	</p>
																</div>
															</div>
														</div>
													</div>
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">详细地址：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${fns:getDictLabel(crmClue.province, '', '')}${fns:getDictLabel(crmClue.city, '', '')}${fns:getDictLabel(crmClue.dict, '', '')}${crmClue.address}
																	</p>
																</div>
															</div>
														</div>
													</div>
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">市场活动：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${crmClue.crmMarket.name}
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">所有者：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${crmClue.ownBy.name}
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
																		${crmClue.createBy.name}
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">创建时间：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																		<fmt:formatDate value="${crmClue.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
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
																		${crmClue.updateBy.name}
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">更新时间：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																		<fmt:formatDate value="${crmClue.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
																	</p>
																</div>
															</div>
														</div>
													</div>
													
													<h4 class="page-header">其他信息</h4>
													<div class="row">
														<div class="col-sm-12">
															<div class="view-group">
																<label class="col-sm-2 control-label">销售线索描述：</label>
																<div class="col-sm-10">
																	<p class="form-control-static">${crmClue.remarks}</p>
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
                <h4>销售线索描述</h4>
                <p class="small">
                    ${crmClue.remarks}
                </p>
                <p class="small font-bold hide">
                    <span><i class="fa fa-circle text-warning"></i> 高优先级</span>
                </p>
                <br>
                
                <h4>联系提醒</h4>
                <p class="small">
                   	 联系时间：<fmt:formatDate value="${crmClue.nextcontactDate}" pattern="yyyy-MM-dd"/>
								                		<c:if test="${not empty diffDay && diffDay == 0}">
								                    		<span class="badge badge-warning">今日</span>
								                    	</c:if>
								                    	<c:if test="${not empty diffDay && diffDay > 0}">
								                    		<span class="badge badge-info">${diffDay}天后</span>
								                    	</c:if>
                </p>
                <p class="small">
                	联系内容：${crmClue.nextcontactNote}
                </p>
                
            </div>
        </div>
    </div>
    

</body>
</html>