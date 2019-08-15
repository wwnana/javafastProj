<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>用户主页</title>
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
                                    	<h3><img src="${ctxStatic}/weui/images/app/icon_contacter.png" class="ibox-title-img">${user.name} </h3>
                                    </div>
                                    <div class="pull-right">
										
										<c:if test="${user.loginName != 'sysadmin' && user.loginName != 'admin'}">
										<shiro:hasPermission name="sys:user:edit">
					    					<a href="#" onclick="openDialog('修改用户', '${ctx}/sys/user/form?id=${user.id}','1000px', '80%')" class="btn btn-default btn-sm" title="修改"><i class="fa fa-pencil"></i> 编辑</a>
										</shiro:hasPermission>
										
										<div class="btn-group">
						                    <button data-toggle="dropdown" class="btn btn-default btn-sm dropdown-toggle" aria-expanded="false">更多 <i class="fa fa-chevron-down"></i>
						                    </button>
						                    <ul class="dropdown-menu">
						                        <li>
						                        	<shiro:hasPermission name="sys:user:del">
														<a href="${ctx}/sys/user/delete?id=${user.id}" onclick="return confirmx('确认要删除该用户吗？', this.href)"  title="删除"><i class="fa fa-trash"></i> 删除</a> 
													</shiro:hasPermission>
						                        </li>
						                        <c:if test="${user.loginFlag == 0}">
						                       	<li>
						                        	<shiro:hasPermission name="sys:user:edit">
														<a href="${ctx}/sys/user/useAll?ids=${user.id}" onclick="return confirmx('确认要启用该用户吗？', this.href)"  title="启用"><i class="fa fa-check"></i> 启用</a> 
													</shiro:hasPermission>
						                        </li>
						                        </c:if>
						                        <c:if test="${user.loginFlag == 1}">
						                        <li>
						                        	<shiro:hasPermission name="sys:user:edit">
														<a href="${ctx}/sys/user/unUseAll?ids=${user.id}" onclick="return confirmx('确认要禁用该用户吗？', this.href)"  title="禁用"><i class="fa fa-ban"></i> 禁用</a> 
													</shiro:hasPermission>
						                        </li>
						                        </c:if>
						                        <li>
							                        <shiro:hasPermission name="sys:user:edit">
														<a href="#" onclick="openDialog('工作交接', '${ctx}/sys/user/overForm?id=${user.id}','500px', '350px')" class="" title="工作交接"><i class="fa fa-share"></i> 交接</a>
													</shiro:hasPermission>
												</li>
						                    </ul>
						                </div>
						                </c:if>
						                <a href="${ctx}/sys/user/view?id=${user.id}" class="btn btn-default btn-sm" title="刷新"><i class="fa fa-refresh"></i> </a>
					        			<button id="btnCancel" class="btn btn-default btn-sm" type="button" onclick="history.go(-1)" title="返回"><i class="fa fa-rotate-left"></i> </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-5">
                                <dl class="dl-horizontal">
									<dt>用户状态：</dt>
                                    <dd><c:if test="${user.loginFlag == 1}"><span class="text-success">激活</span></c:if>
										<c:if test="${user.loginFlag == 0}"><span class="text-danger">冻结</span></c:if>
									</dd>
                                </dl>
                            </div>
                            <div class="col-sm-7" id="cluster_info">
                                <dl class="dl-horizontal">
                                    <dt>创建时间：</dt>
                                    <dd><fmt:formatDate value="${user.createDate}" pattern="yyyy-MM-dd HH:mm"/></dd>
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
								 	</ul>
								 	<div class="tab-content">
								 		<div class="tab-pane active" id="tab-1">
                                            
								 			<div class="panel-body">
								 				<div class="form-horizontal">				 				
													<h4 class="page-header">基本信息</h4>
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">登录名：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${user.loginName}
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">手机：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${user.mobile}
																	</p>
																</div>
															</div>
														</div>
													</div>
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">公司：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${user.company.name}
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">部门：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${user.office.name}
																	</p>
																</div>
															</div>
														</div>
													</div>
													
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">姓名：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${user.name}
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">编号：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${user.no}
																	</p>
																</div>
															</div>
														</div>
													</div>
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">邮箱：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${user.email}
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">电话：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${user.phone}
																	</p>
																</div>
															</div>
														</div>
													</div>
													
													
													
													<h4 class="page-header">操作信息</h4>
													<div class="row">
														<div class="col-sm-6">
															<div class="form-group">
												            	<label class="col-sm-4 control-label">创建时间</label>
																<div class="col-sm-8">
																<p class="form-control-static"><fmt:formatDate value="${user.createDate}" pattern="yyyy-MM-dd hh:mm"/></p>
																</div>
												            </div>
											            </div>
											            <div class="col-sm-6">
															<div class="form-group">
												            	<label class="col-sm-4 control-label">更新时间</label>
												            	<div class="col-sm-8">
																	<p class="form-control-static"><fmt:formatDate value="${user.updateDate}" pattern="yyyy-MM-dd hh:mm"/></p>
																</div>
												            </div>
											            </div>
											        </div>
											        <div class="row">
														<div class="col-sm-6">
															<div class="form-group">
												            	<label class="col-sm-4 control-label">最后登陆IP</label>
																<div class="col-sm-8">
																<p class="form-control-static">${user.loginIp}</p>
																</div>
												            </div>
											            </div>
											            <div class="col-sm-6">
															<div class="form-group">
												            	<label class="col-sm-4 control-label">最后登陆时间</label>
												            	<div class="col-sm-8">
																	<p class="form-control-static"><fmt:formatDate value="${user.loginDate}" type="both" dateStyle="full"/></p>
																</div>
												            </div>
											            </div>
											        </div>
											        <h4 class="page-header">角色信息</h4>
													<div class="row">
														<div class="col-sm-6">
															<div class="form-group">
												            	<label class="col-sm-4 control-label">授权角色</label>
																<div class="col-sm-8">
																<p class="form-control-static">
																	<c:forEach items="${roleList }" var="role">
																	<c:forEach var="age" items="${user.roleIdList}">
																	<c:if test="${role.id eq age}">
																		<span class="badge">${role.name }</span>
																	</c:if>
																	</c:forEach>
																	</c:forEach>
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
																	<p class="form-control-static">${user.remarks}</p>
																</div>
															</div>
														</div>
													</div>
												</div>
								 			</div>
								 		</div>
								 		
								 		
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