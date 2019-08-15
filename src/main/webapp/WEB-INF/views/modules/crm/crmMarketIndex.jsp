<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>活动主页</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
    	function showHdUrl(url){
    		
    		layer.open({
    		  title:'活动链接（请复制活动链接进行推广）'
    		  ,type: 1
    		  ,closeBtn: false
    		  ,area: '400px;'
    		  ,shade: 0.8
    		  ,id: 'LAY_layuipro' //设定一个id，防止重复弹出
    		  ,resize: false
    		  ,btn: ['打开','关闭']
    		  ,btnAlign: 'c'
    		  ,moveType: 1 //拖拽模式，0或者1
    		  ,content: '<div style="padding: 50px; line-height: 22px; font-weight: 300;">'+url+'</div>'
    		  ,success: function(layero){
    		    var btn = layero.find('.layui-layer-btn');
    		    btn.find('.layui-layer-btn0').attr({
    		      href: url
    		      ,target: '_blank'
    		    });
    		  }
    		});
    		
    	}
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
                                    	<h3><img src="${ctxStatic}/weui/images/app/icon_market.png" class="ibox-title-img">${crmMarket.name} </h3>
                                    </div>
                                    <div class="pull-right">
										
										<shiro:hasPermission name="crm:crmMarket:add">
					    					<a href="#" onclick="openDialog('新建线索', '${ctx}/crm/crmClue/form?crmMarket.id=${crmMarket.id}&crmMarket.name=${crmMarket.name}','1000px', '80%')" class="btn btn-default btn-sm" title="新建线索"><i class="fa fa-plus"></i> 新建线索</a>
										</shiro:hasPermission>
													
										<shiro:hasPermission name="crm:crmMarket:edit">
					    					<a href="#" onclick="openDialog('修改市场活动', '${ctx}/crm/crmMarket/form?id=${crmMarket.id}','1000px', '80%')" class="btn btn-default btn-sm" title="修改"><i class="fa fa-pencil"></i> 编辑</a>
										</shiro:hasPermission>
										
										<shiro:hasPermission name="crm:crmMarket:edit">
					    					<a href="${ctx}/crm/crmMarketData/form?id=${crmMarket.id}" class="btn btn-default btn-sm" title="编辑推广文案"><i class="fa fa-pencil"></i> 推广文案</a>
										</shiro:hasPermission>
								
										<a href="#" onclick="showHdUrl('${ctx}/wechat/hd/form?id=${crmMarket.id}');" title="活动推广链接" class="btn btn-default btn-sm" ><i class="fa fa-share"></i> 推广链接</a> 
										
										<div class="btn-group">
						                    <button data-toggle="dropdown" class="btn btn-default btn-sm dropdown-toggle" aria-expanded="false">更多 <i class="fa fa-chevron-down"></i>
						                    </button>
						                    <ul class="dropdown-menu">
						                        
						                        <li>
						                        	<shiro:hasPermission name="crm:crmMarket:del">
														<a href="${ctx}/crm/crmMarket/delete?id=${crmMarket.id}" onclick="return confirmx('确认要删除该市场活动吗？', this.href)"  title="删除"><i class="fa fa-trash"></i> 删除</a> 
													</shiro:hasPermission>
						                        </li>
						                       
						                    </ul>
						                </div>
						                
						                <a href="${ctx}/crm/crmMarket/index?id=${crmMarket.id}" class="btn btn-default btn-sm" title="刷新"><i class="fa fa-refresh"></i> </a>
					        			<button id="btnCancel" class="btn btn-default btn-sm" type="button" onclick="history.go(-1)" title="返回"><i class="fa fa-rotate-left"></i> </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-5">
                                <dl class="dl-horizontal">
									<dt>开始日期：</dt>
                                    <dd><fmt:formatDate value="${crmMarket.startDate}" pattern="yyyy-MM-dd"/></dd>
                                    <dt>活动状态：</dt>
                                    <dd>
                                    	<span class="<c:if test='${crmMarket.status == 0}'>text-warning</c:if> <c:if test='${crmMarket.status == 1}'>text-success</c:if> <c:if test='${crmMarket.status == 2}'>text-muted</c:if> ">
											${fns:getDictLabel(crmMarket.status, 'market_status', '')}
										</span>
                                    </dd>
                                    <dt>创建者：</dt>
                                    <dd>${crmMarket.createBy.name}</dd>
                                </dl>
                            </div>
                            <div class="col-sm-7" id="cluster_info">
                                <dl class="dl-horizontal">
									<dt>结束日期：</dt>
                                    <dd><fmt:formatDate value="${crmMarket.endDate}" pattern="yyyy-MM-dd"/></dd>
                                    <dt>活动类型：</dt>
                                    <dd>${fns:getDictLabel(crmMarket.marketType, 'market_type', '')}</dd>
                                    <dt>负责人：</dt>
                                    <dd>${crmMarket.ownBy.name}</dd>
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
								 		<li><a data-toggle="tab" href="#tab-3" aria-expanded="false">销售线索 <span class="badge badge-info"><c:if test="${crmCluePage.count>0}">${crmCluePage.count}</c:if></span></a></li>
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
																<label class="col-sm-4 control-label">开始日期：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	<fmt:formatDate value="${crmMarket.startDate}" pattern="yyyy-MM-dd"/>
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">截止日期：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	<fmt:formatDate value="${crmMarket.endDate}" pattern="yyyy-MM-dd"/>
																	</p>
																</div>
															</div>
														</div>
													</div>
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">活动类型：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${fns:getDictLabel(crmMarket.marketType, 'market_type', '')}
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">活动地点：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${crmMarket.marketAddress}
																	</p>
																</div>
															</div>
														</div>
													</div>
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">预计成本：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${crmMarket.estimateCost}
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">实际成本：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${crmMarket.actualCost}
																	</p>
																</div>
															</div>
														</div>
													</div>
													<div class="row">
													
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">预计收入：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${crmMarket.estimateAmount}
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">实际收入：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${crmMarket.actualAmount}
																	</p>
																</div>
															</div>
														</div>
													</div>
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">邀请人数：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${crmMarket.inviteNum}
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">实际人数：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${crmMarket.actualNum}
																	</p>
																</div>
															</div>
														</div>
													</div>
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">活动状态：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${fns:getDictLabel(crmMarket.status, 'market_status', '')}
																	</p>
																</div>
															</div>
														</div>
														
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">负责人：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																	${crmMarket.ownBy.name}
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
																		${crmMarket.createBy.name}
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">创建时间：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																		<fmt:formatDate value="${crmMarket.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
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
																		${crmMarket.updateBy.name}
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">更新时间：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																		<fmt:formatDate value="${crmMarket.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
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
																	<p class="form-control-static">${crmMarket.remarks}</p>
																</div>
															</div>
														</div>
													</div>
												</div>
								 			</div>
								 		</div>
								 		<div id="tab-3" class="tab-pane">
								 			<div class="panel-body">
								 				<%--沟通 开始 --%>
								 				<div class="row">
									 				<div class="col-sm-12 m-b-sm">
										 				<shiro:hasPermission name="crm:crmClue:edit">
														    <table:addRow url="${ctx}/crm/crmClue/form?crmMarket.id=${crmMarket.id }&crmMarket.name=${crmMarket.name }" title="销售线索" pageModel="" width="1000px" height="80%" label="新建销售线索"></table:addRow><!-- 编辑按钮 -->
														</shiro:hasPermission>
													</div>
												</div>
												<br>
												<!-- 销售线索表格 -->
												<div class="table-responsive">
												<table id="contentTable" class="table table-bordered table-striped table-hover">
													<thead>
														<tr>
															<th>公司</th>
															<th width="">姓名</th>
															<%--
															<th width="">手机</th>
															<th width="">职务</th>
															--%>
															<th width="">所有者</th>
															<%-- 
															<th width="" class="sort-column a.create_by">创建者</th>
															<th width="" class="sort-column a.create_date">创建时间</th>
															--%>
															<th>状态</th>
															<th width="">操作</th>
														</tr>
													</thead>
													<tbody>
													<c:forEach items="${crmCluePage.list}" var="clue">
														<tr>
															<td>
																<a href="${ctx}/crm/crmClue/index?id=${clue.id}" title="查看">
																${clue.name}
															</a></td>
															<td>
																${clue.contacterName}
															</td>
															<%--
															<td>
																${clue.mobile}
															</td>
															<td>
																${clue.jobType}
															</td>
															--%>
															<td>
																${clue.ownBy.name}
															</td>
															<%--
															<td>
																${clue.createBy.name}
															</td>
															<td>
																<fmt:formatDate value="${clue.createDate}" pattern="yyyy-MM-dd"/>
															</td>
															--%>
															<td>
																<c:if test="${empty clue.crmCustomer.id}">
																	待跟进
																</c:if>
																<c:if test="${not empty clue.crmCustomer.id}">
																	<a href="${ctx}/crm/crmCustomer/index?id=${clue.crmCustomer.id}" title="${clue.crmCustomer.name}">已转化</a>
																</c:if>
															</td>
															
															<td>
																
																<shiro:hasPermission name="crm:crmClue:edit">
											    					<a href="#" onclick="openDialog('修改销售线索', '${ctx}/crm/crmClue/form?id=${clue.id}','1000px', '80%')" class="" title="修改">修改</a>
																</shiro:hasPermission>
																
																<shiro:hasPermission name="crm:crmClue:del">
																	<a href="${ctx}/crm/crmClue/delete?id=${clue.id}" onclick="return confirmx('确认要删除该销售线索吗？', this.href)" class="" title="删除">删除</a> 
																</shiro:hasPermission>
																
																<c:if test="${empty clue.crmCustomer.id}">
																<shiro:hasPermission name="crm:crmClue:edit">
											    					<a href="#" onclick="openDialog('转为客户', '${ctx}/crm/crmClue/toCustomerform?id=${crmClue.id}','1000px', '80%')" class="" title="转为客户">转为客户</a>
																</shiro:hasPermission>
																</c:if>
																
															</td>
														</tr>
													</c:forEach>
													</tbody>
												</table>
												<div>
													共${crmCluePage.count }条记录，<a href="${ctx}/crm/crmClue/list?crmMarket.id=${crmMarket.id}">查看更多 <i class="fa fa-angle-double-right"></i></a>
												</div>
												
												</div>
                                                
												
								               <%--销售线索 结束 --%>
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