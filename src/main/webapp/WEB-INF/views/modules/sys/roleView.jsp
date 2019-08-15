<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>角色主页</title>
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
                                    	<h3><img src="${ctxStatic}/weui/images/app/icon_contacter.png" class="ibox-title-img">${role.name} </h3>
                                    </div>
                                    <div class="pull-right">
										<c:if test="${role.id != 'admin'}">
										<shiro:hasPermission name="sys:role:edit">
					    					<a href="#" onclick="openDialog('修改角色', '${ctx}/sys/role/form?id=${role.id}','800px', '500px')" class="btn btn-default btn-sm" title="修改"><i class="fa fa-pencil"></i> 编辑</a>
										</shiro:hasPermission>
										<shiro:hasPermission name="sys:role:assign"> 
											<a href="#" onclick="openDialog('权限设置', '${ctx}/sys/role/auth?id=${role.id}','500px', '80%')" class="btn btn-default btn-sm" title="权限设置"><i class="fa fa-lock"></i> 权限设置</a> 
										</shiro:hasPermission>
										</c:if>
													
										<div class="btn-group">
						                    <button data-toggle="dropdown" class="btn btn-default btn-sm dropdown-toggle" aria-expanded="false">更多 <i class="fa fa-chevron-down"></i>
						                    </button>
						                    <ul class="dropdown-menu">
						                        <li>
													<shiro:hasPermission name="sys:role:assign"> 
													<a href="#" onclick="openDialogView('分配用户', '${ctx}/sys/role/assign?id=${role.id}','800px', '80%')" class="" title="分配用户">分配用户</a>
													</shiro:hasPermission>
												</li>
												<c:if test="${role.id != 'admin'}">
												<c:if test="${userList== null || fn:length(userList)==0}">
												<li>
						                        	<shiro:hasPermission name="sys:role:del"> 
													<a href="${ctx}/sys/role/delete?id=${role.id}" onclick="return confirmx('确认要删除该角色吗？', this.href)" class="" title="删除">删除</a>
													</shiro:hasPermission>
						                        </li>
						                        </c:if>
						                        </c:if>
						                    </ul>
						                </div>										
						                
						                <a href="${ctx}/sys/role/view?id=${role.id}" class="btn btn-default btn-sm" title="刷新"><i class="fa fa-refresh"></i> </a>
					        			<button id="btnCancel" class="btn btn-default btn-sm" type="button" onclick="history.go(-1)" title="返回"><i class="fa fa-rotate-left"></i> </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-5">
                                <dl class="dl-horizontal">
									<dt>数据范围：</dt>
                                    <dd>${fns:getDictLabel(role.dataScope, 'sys_data_scope', '')}
									</dd>
                                </dl>
                            </div>
                            <div class="col-sm-7" id="cluster_info">
                                <dl class="dl-horizontal">
                                    <dt></dt>
                                    <dd></dd>
                                </dl>
                            </div>
                        </div>
                    </div>
                    <c:if test="${role.id eq 'admin'}">
                    <div class="row">
                    	<div class="col-sm-12">
                    		<div class="wrapper ">
                    		<div class="alert alert-warning">
	                            	企业管理员不可编辑和删除，默认拥有系统所有权限
	                        </div>
	                        </div>
                    	</div>
                    </div>
                    </c:if>
                </div>
                <div class="">
                	<div>    
                         <div class="row m-t-sm">
                            <div class="col-sm-12">
                            	<div class="tabs-container">
								 	<ul class="nav nav-tabs">
								 		<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">角色用户</a></li>
								 	</ul>
								 	<div class="tab-content">
								 		<div class="tab-pane active" id="tab-1">
								 			<div class="panel-body">
								 				<div class="breadcrumb">
													<form id="assignRoleForm" action="${ctx}/sys/role/assignrole" method="post" class="hide">
														<input type="hidden" name="id" value="${role.id}"/>
														<input id="idsArr" type="hidden" name="idsArr" value=""/>
													</form>
													<button id="assignButton" type="submit"  class="btn btn-success btn-sm" title="添加人员"><i class="fa fa-plus"></i> 添加人员</button>
													<script type="text/javascript">
														$("#assignButton").click(function(){
															
															top.layer.open({
															    type: 2, 
															    area: ['800px', '500px'],
															    title:"选择用户",
														        maxmin: true, //开启最大化最小化按钮
															    content: "${ctx}/sys/role/usertorole?id=${role.id}",
															    btn: ['确定', '关闭'],
															    yes: function(index, layero){
													    	       var pre_ids = layero.find("iframe")[0].contentWindow.pre_ids;
																	var ids = layero.find("iframe")[0].contentWindow.ids;
																	if(ids[0]==''){
																			ids.shift();
																			pre_ids.shift();
																		}
																		if(pre_ids.sort().toString() == ids.sort().toString()){
																			top.$.jBox.tip("未给角色【${role.name}】分配新成员！", 'info');
																			return false;
																		};
																    	// 执行保存
																    	loading('正在提交，请稍等...');
																    	var idsArr = "";
																    	for (var i = 0; i<ids.length; i++) {
																    		idsArr = (idsArr + ids[i]) + (((i + 1)== ids.length) ? '':',');
																    	}
																    	$('#idsArr').val(idsArr);
																    	$('#assignRoleForm').submit();
																	    top.layer.close(index);
																  },
																  cancel: function(index){ 
													    	       }
															}); 
														});
													</script>
												</div>
												<div class="table-responsive">
								 				<br>
												<table id="contentTable" class="table table-bordered table-hover">
													<thead>
														<tr>
															<th>姓名</th>
															<th>归属公司</th>
															<th>归属部门</th>
															<shiro:hasPermission name="sys:user:edit"><th>操作</th></shiro:hasPermission>
														</tr>
													</thead>
													<tbody>
													<c:forEach items="${userList}" var="user">
														<tr>
															<td><a href="${ctx}/sys/user/view?id=${user.id}">${user.name}</a></td>
															<td>${user.company.name}</td>
															<td>${user.office.name}</td>
															<shiro:hasPermission name="sys:role:edit"><td>
																<a href="${ctx}/sys/role/outrole?userId=${user.id}&roleId=${role.id}" 
																	onclick="return confirmx('确认要将用户<b>[${user.name}]</b>从<b>[${role.name}]</b>角色中移除吗？', this.href)">移除</a>
															</td></shiro:hasPermission>
														</tr>
													</c:forEach>
													</tbody>
												</table>
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