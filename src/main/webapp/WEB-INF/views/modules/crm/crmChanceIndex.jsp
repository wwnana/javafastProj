<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>商机主页</title>
	<meta name="decorator" content="default"/>
	<style>
		.ui-scrollbar .ui-scrollbar.scroll-content {
    border: none!important;
    box-sizing: content-box!important;
    height: auto;
    left: 0!important;
    margin: 0;
    padding: 0;
    position: relative!important;
    top: 0!important;
    width: auto!important;
}

.crm-comp-salesflow-banner li:first-child {
    width: 15%;
    margin-left: 20px;
}
.crm-comp-salesflow-banner .ban-click {
    color: #10c14d;
}
.crm-comp-salesflow-banner .ban-current {
    color: #10c14d;
}

.crm-comp-salesflow-banner li {
    font-size: 12px;
    position: relative;
    display: inline-block;
    width: 15%;
    height: 36px;
    margin: 0 0 20px 4px;
    cursor: pointer;
}
.crm-comp-salesflow-banner .ban-click .ban-cover {
    background-color: #e1f2e7;
    border-left: 2px solid #10c14d;
}
.crm-comp-salesflow-banner .ban-current .ban-cover, .crm-comp-salesflow-banner .ban-current .trans {
    border: 2px solid #10c14d;
}

.crm-comp-salesflow-banner .ban-cover-left {
    left: -20px;
}
.crm-comp-salesflow-banner .ban-cover {
    position: absolute;
    top: 0;
    width: 36px;
    height: 100%;
    border-radius: 50%;
    box-sizing: border-box;
}
.crm-comp-salesflow-banner li:first-child .trans {
    border-left: none;
}
.crm-comp-salesflow-banner .ban-click .trans {
    background-color: #e1f2e7;
    border: 2px solid #10c14d;
}
.crm-comp-salesflow-banner .ban-current .ban-cover, .crm-comp-salesflow-banner .ban-current .trans {
    border: 2px solid #10c14d;
}
.crm-comp-salesflow-banner .trans-top {
    border-bottom: none!important;
    transform: skew(30deg);
}
.crm-comp-salesflow-banner .trans {
    background-color: #fff;
    height: 18px;
    box-sizing: border-box;
}
.crm-comp-salesflow-banner li:first-child .trans {
    border-left: none;
}

.crm-comp-salesflow-banner .ban-click .trans {
    background-color: #e1f2e7;
    border: 2px solid #10c14d;
}
.crm-comp-salesflow-banner .ban-current .ban-cover, .crm-comp-salesflow-banner .ban-current .trans {
    border: 2px solid #10c14d;
}
.crm-comp-salesflow-banner .trans-bottom {
    border-top: none!important;
    transform: skew(-30deg);
}
.crm-comp-salesflow-banner .trans {
    background-color: #fff;
    height: 18px;
    box-sizing: border-box;
}
.crm-comp-salesflow-banner li:first-child .ban-text {
    left: -12px;
}
.crm-comp-salesflow-banner .ban-text {
    position: absolute;
    top: 50%;
    right: 8px;
    left: 8px;
    margin-top: -10px;
    height: 20px;
    line-height: 20px;
    text-align: center;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    font-size: 12px;
}
.ui-scrollbar .scroll-element, .ui-scrollbar .scroll-element div {
    box-sizing: content-box;
    border: none;
    margin: 0;
    padding: 0;
    position: absolute;
    z-index: 700;
}
.crm-comp-salesflow-banner .ban-uncompleted {
    color: #666;
}
.crm-comp-salesflow-banner li {
    font-size: 12px;
    position: relative;
    display: inline-block;
    width: 15%;
    height: 36px;
    margin: 0 0 20px 4px;
    cursor: pointer;
}
.crm-comp-salesflow-banner .ban-text {
    position: absolute;
    top: 50%;
    right: 8px;
    left: 8px;
    margin-top: -10px;
    height: 20px;
    line-height: 20px;
    text-align: center;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    font-size:12px;
}
.crm-comp-salesflow-banner .ban-click {
    color: #10c14d;
}
.crm-comp-salesflow-banner .ban-current {
    color: #10c14d;
}
.crm-comp-salesflow-banner .ban-uncompleted .ban-cover-left, .crm-comp-salesflow-banner .ban-uncompleted .ban-cover-right, .crm-comp-salesflow-banner .ban-uncompleted .trans {
    background-color: #ebebeb;
}

.crm-comp-salesflow-banner .trans-top {
    border-bottom: none!important;
    transform: skew(30deg);
}
.crm-comp-salesflow-banner .trans {
    background-color: #fff;
    height: 18px;
    box-sizing: border-box;
}
.crm-comp-salesflow-banner .ban-uncompleted .ban-cover-left, .crm-comp-salesflow-banner .ban-uncompleted .ban-cover-right, .crm-comp-salesflow-banner .ban-uncompleted .trans {
    background-color: #ebebeb;
}
.crm-comp-salesflow-banner .ban-cover-right {
    right: -16px;
    background-color: #f0f0f0;
}
.crm-comp-salesflow-banner .ban-cover {
    position: absolute;
    top: 0;
    width: 36px;
    height: 100%;
    border-radius: 50%;
    box-sizing: border-box;
}
.crm-comp-salesflow-banner .ban-uncompleted {
    color: #666;
}
.crm-comp-salesflow-banner .ban-lose .ban-cover-right, .crm-comp-salesflow-banner .ban-lose .trans {
    background-color: #f57a62;
    border-color: #f57a62;
}
.crm-comp-salesflow-banner .ban-win {
    color: #fff;
}
.crm-comp-salesflow-banner .ban-lose {
    color: #fff;
}
.crm-comp-salesflow-banner .ban-win .ban-cover-right, .crm-comp-salesflow-banner .ban-win .trans {
    background-color: #10c14d;
}
.crm-comp-salesflow-banner .ban-completed-invalid .ban-cover, .crm-comp-salesflow-banner .ban-completed-invalid .trans {
    background-color: #b3e0c2;
}
.crm-comp-salesflow-banner .ban-completed-invalid {
    color: #fff;
}
	</style>
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
                                		
                                    	<h3>
                                    		<img src="${ctxStatic}/weui/images/app/icon_chance2.png" class="ibox-title-img">${crmChance.name} 
                                    		
                                    	</h3>
                                    </div>
                                    <div class="pull-right">
                                    	
					        		
										<shiro:hasPermission name="crm:crmChance:edit">
									   		<a href="#" onclick="openDialog('修改商机', '${ctx}/crm/crmChance/form?id=${crmChance.id}','1000px', '650px')" class="btn btn-default btn-sm" title="修改"><i class="fa fa-pencil"></i> 编辑</a>
										</shiro:hasPermission>
										
										<div class="btn-group">
											<button data-toggle="dropdown" class="btn btn-default btn-sm dropdown-toggle" aria-expanded="false"><i class="fa fa-plus"></i> 创建
						                    </button>
						                    <ul class="dropdown-menu">
						                        <li>
						                        	 <shiro:hasPermission name="crm:crmQuote:edit">
									   					<a href="${ctx}/crm/crmQuote/form?chance.id=${crmChance.id}&chance.name=${crmChance.name}&customer.id=${crmChance.customer.id}&customer.name=${crmChance.customer.name}" class="btn btn-default btn-sm" title="创建报价单">
															<span class="hidden-xs">创建报价单</span></a>
													</shiro:hasPermission>
						                        </li>
						                        <li>
						                        	<shiro:hasPermission name="om:omContract:add">
									   					<a href="${ctx}/om/omContract/form?chance.id=${crmChance.id}&chance.name=${crmChance.name}&customer.id=${crmChance.customer.id}&customer.name=${crmChance.customer.name}" class="btn btn-default btn-sm" title="创建合同订单">
															<span class="hidden-xs">创建合同订单</span></a>
													</shiro:hasPermission>
						                        </li>
						                       
						                    </ul>
						                </div>
						                <div class="btn-group">
						                    <button data-toggle="dropdown" class="btn btn-default btn-sm dropdown-toggle" aria-expanded="false">更多 <i class="fa fa-chevron-down"></i>
						                    </button>
						                    <ul class="dropdown-menu">
						                        
						                        <li>
						                        	<shiro:hasPermission name="crm:crmChance:del">
														<a href="${ctx}/crm/crmChance/delete?id=${crmChance.id}" onclick="return confirmx('确认要删除该商机吗？', this.href)" class="  " title="删除"><span class="hidden-xs">删除</span></a> 
													</shiro:hasPermission>
						                        </li>
						                       
						                    </ul>
						                </div>
						                <a href="${ctx}/crm/crmChance/index?id=${crmChance.id}" class="btn btn-default btn-sm" title="刷新"><i class="fa fa-refresh"></i> </a>
					        			<button id="btnCancel" class="btn btn-default btn-sm" type="button" onclick="history.go(-1)" title="返回"><i class="fa fa-rotate-left"></i> </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-sm-5">
                                <dl class="dl-horizontal">

                                    <dt>预计金额：</dt>
                                    <dd>${crmChance.saleAmount}元</dd>
                                    <dt>客户名称：</dt>
                                    <dd><a href="${ctx}/crm/crmCustomer/index?id=${crmChance.customer.id}">${crmChance.customer.name}</a></dd>
                                    <dt>创建者：</dt>
                                    <dd>${crmChance.createBy.name}</dd>
                                </dl>
                            </div>
                            <div class="col-sm-7" id="cluster_info">
                                <dl class="dl-horizontal">

                                    <dt>最后更新：</dt>
                                    <dd><fmt:formatDate value="${crmChance.updateDate}" pattern="yyyy年 MM月dd日 HH:mm"/></dd>
                                    <dt>创建于：</dt>
                                    <dd><fmt:formatDate value="${crmChance.createDate}" pattern="yyyy年 MM月dd日 HH:mm"/></dd>
                                    <dt>负责人：</dt>
                                    <dd>${crmChance.ownBy.name}</dd>
                                </dl>
                            </div>
                        </div>
                        <div class="row hide">
                            <div class="col-sm-12">
                            	
                                <dl class="dl-horizontal">
                                    <dt>当前进度</dt>
                                    <dd>
                                        <div class="progress progress-striped active m-b-sm">
                                            <div style="width: 60%;" class="progress-bar"></div>
                                        </div>
                                        <small>当前已完成项目总进度的 <strong>60%</strong></small>
                                    </dd>
                                </dl>
                            </div>
                        </div>
                        
                        			<script type="text/javascript">
										function updateChancePeriod(type){
											
											if(type < 5){
												window.location="${ctx}/crm/crmChance/updateChancePeriod?id=${crmChance.id}&periodType="+type;
											}
											if(type == 5){
												
												layer.confirm('确定将当前商机设为赢单吗?', {
													  btn: ['确定','取消']
													}, function(){
														window.location="${ctx}/crm/crmChance/updateChancePeriod?id=${crmChance.id}&periodType="+type;
													}, function(){
													  
												});
											}
											if(type == 6){
												
												openDialog('输单原因', '${ctx}/crm/crmChance/loseForm?id=${crmChance.id}','500px', '350px')
											}
										}
										function updateChancePeriodNext(type){
											if(type<6){
												updateChancePeriod(type+1);
											}
										}
									</script>
                        <div class="row">
                        	<div class="col-sm-12">
                        		<h4 class="page-header">销售流程（点击进入下一阶段）</h4>
                        		<div class="table-responsive">
                        			<div class="col-sm-10">
                        				<div class="crm-comp-salesflow-banner">
                        					<div class="scroll-wrapper banner-wrap ui-scrollbar" style="position: relative;">
	                        				<ul class="banner-wrap ui-scrollbar scroll-content scroll-scrollx_visible" style="margin-bottom: 0px; margin-right: 0px;">
		                        				<c:forEach items="${fns:getDictList('period_type')}" var="dict" varStatus="status">
												<li onclick="updateChancePeriod(${dict.value})" data-status="${dict.value}" class="j-banner-item <c:if test='${crmChance.periodType==dict.value && dict.value==5}'>ban-win</c:if> <c:if test='${crmChance.periodType==dict.value && dict.value==6}'>ban-lose</c:if> <c:if test='${crmChance.periodType > dict.value}'>ban-completed-invalid</c:if> <c:if test='${crmChance.periodType < dict.value}'>ban-uncompleted</c:if> <c:if test='${crmChance.periodType == dict.value}'>ban-current</c:if> <c:if test='${crmChance.periodType == dict.value}'>ban-click</c:if> ">
													<c:if test="${status.index == 0}"><div class="ban-cover ban-cover-left"></div></c:if>
													<div class="trans trans-top"></div>
													<div class="trans trans-bottom"></div>
													<p class="ban-text">
														<c:if test='${crmChance.periodType==dict.value && dict.value<5}'><i class="fa fa-check"></i></c:if>
														<c:if test='${crmChance.periodType==dict.value && dict.value==5}'><i class="fa fa-check-circle"></i></c:if>
														<c:if test='${crmChance.periodType==dict.value && dict.value==6}'><i class="fa fa-times-circle"></i></c:if>
														 <span>${dict.label}</span></p>
													
													<c:if test='${dict.value==6}'>
													<div class="ban-cover ban-cover-right"></div>
													</c:if>
													
												</li>
												</c:forEach>
	                        				</ul>
                        					</div>
                        				</div>
                        			</div>
                        			<div class="col-sm-2 text-center">
	                        			<c:if test='${crmChance.periodType < 5}'>
	                        				<div class="btn btn-success btn-sm btn-rounded" onclick="updateChancePeriodNext(${crmChance.periodType})">进入下一阶段</div>
	                        			</c:if>
	                        		</div>
                        		</div>
                        		
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
								 		<li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true"><i class="fa fa-laptop"></i> 概况</a></li>
								 		<li class=""><a data-toggle="tab" href="#tab-2" aria-expanded="false">详细信息</a></li>
								 		<li><a data-toggle="tab" href="#tab-4" aria-expanded="false">报价 <span class="badge badge-info"><c:if test="${fn:length(quoteList)>0}">${fn:length(quoteList)}</c:if></span></a></li>
								 		<li><a data-toggle="tab" href="#tab-5" aria-expanded="false">合同 <span class="badge badge-info"><c:if test="${fn:length(omContractList)>0}">${fn:length(omContractList)}</c:if></span></a></li>
								 		<li><a data-toggle="tab" href="#tab-6" aria-expanded="false">操作日志 <span class="badge badge-info"><c:if test="${fn:length(sysDynamicList)>0}">${fn:length(sysDynamicList)}</c:if></span></a></li>
								 	</ul>
								 	<div class="tab-content">
								 		<div class="tab-pane active" id="tab-1">
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
								 		<div id="tab-2" class="tab-pane">
								 			<div class="panel-body">
								 				<div class="form-horizontal">				 				
													<h4 class="page-header">基本信息</h4>
													
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">商机名称：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																		${crmChance.name}
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">客户：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																		<a href="${ctx}/crm/crmCustomer/index?id=${crmChance.customer.id}">${crmChance.customer.name}</a>
																	</p>
																</div>
															</div>
														</div>
													</div>
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">销售金额：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																		${crmChance.saleAmount}元
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">赢单率：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																		${fns:getDictLabel(crmChance.probability, 'probability_type', '')}
																	</p>
																</div>
															</div>
														</div>
													</div>
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">销售阶段：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																		${fns:getDictLabel(crmChance.periodType, 'period_type', '')}
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">负责人：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																		${crmChance.ownBy.name}
																	</p>
																</div>
															</div>
														</div>
													</div>
													<%-- 
													<div class="row">
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">商机类型：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																		${fns:getDictLabel(crmChance.changeType, 'change_type', '')}
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">商机来源：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																		${fns:getDictLabel(crmChance.sourType, 'sour_type', '')}
																	</p>
																</div>
															</div>
														</div>
													</div>
													--%>
													
													<c:if test='${crmChance.periodType == 6}'>
													<div class="row">
														<div class="col-sm-12">
															<div class="view-group">
																<label class="col-sm-2 control-label">输单原因：</label>
																<div class="col-sm-10">
																	<p class="form-control-static">
																		${crmChance.loseReasons}
																	</p>
																</div>
															</div>
														</div>
													</div>
													</c:if>
													
													<h4 class="page-header">联系提醒</h4>
														<div class="row">
															<div class="col-sm-6">
																<div class="view-group">
																	<label class="col-sm-4 control-label">下次联系时间：</label>
																	<div class="col-sm-8">
																		<p class="form-control-static">
																			<fmt:formatDate value="${crmChance.nextcontactDate}" pattern="yyyy-MM-dd"/>
																		</p>
																	</div>
																</div>
															</div>
															<div class="col-sm-6">
																<div class="view-group">
																	<label class="col-sm-4 control-label">下次联系内容：</label>
																	<div class="col-sm-8">
																		<p class="form-control-static">
																			${crmChance.nextcontactNote}
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
																		${crmChance.createBy.name}
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">创建时间：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																		<fmt:formatDate value="${crmChance.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
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
																		${crmChance.updateBy.name}
																	</p>
																</div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="view-group">
																<label class="col-sm-4 control-label">更新时间：</label>
																<div class="col-sm-8">
																	<p class="form-control-static">
																		<fmt:formatDate value="${crmChance.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
																	</p>
																</div>
															</div>
														</div>
													</div>
													
													<h4 class="page-header">其他信息</h4>
													<div class="row">
														<div class="col-sm-12">
															<div class="view-group">
																<label class="col-sm-2 control-label">商机描述：</label>
																<div class="col-sm-10">
																	<p class="form-control-static">${crmChance.remarks}</p>
																</div>
															</div>
														</div>
													</div>
												</div>
								 			</div>
								 		</div>
								 		
								 		<div id="tab-4" class="tab-pane">
								 			<div class="panel-body">
								 				<%--报价单 开始 --%>
								 				<div class="row">
									 				<div class="col-sm-12 m-b-sm">
									 					<shiro:hasPermission name="crm:crmQuote:edit">
										   					<a href="${ctx}/crm/crmQuote/form?chance.id=${crmChance.id}&chance.name=${crmChance.name}&customer.id=${crmChance.customer.id}" class="btn btn-white btn-sm" title="创建报价单"><i class="fa fa-plus"></i>
																<span class="hidden-xs">创建报价单</span></a>
														</shiro:hasPermission>
													</div>
												</div>
												<div class="table-responsive">
								 				<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed">
													<thead>
														<tr>
															<th>单号</th>
															<th width="100px">总金额</th>
															<th width="100px">报价日期</th>
															<th width="100px">有效期至</th>
															<th width="100px">状态</th>
															<th width="100px">负责人</th>
															<th width="100px">创建时间</th>
															<th width="120px">操作</th>
														</tr>
													</thead>
													<tbody>
													<c:forEach items="${quoteList}" var="crmQuote">
														<tr>
															<td>
																<a href="${ctx}/crm/crmQuote/view?id=${crmQuote.id}">
																	${crmQuote.no}
																</a>
															</td>
															<td>
																${crmQuote.amount}
															</td>
															<td>
																<fmt:formatDate value="${crmQuote.startdate}" pattern="yyyy-MM-dd"/>
															</td>
															<td>
																<fmt:formatDate value="${crmQuote.enddate}" pattern="yyyy-MM-dd"/>
															</td>
															<td>
																${fns:getDictLabel(crmQuote.status, 'audit_status', '')}
															</td>
															<td>
																${crmQuote.ownBy.name}
															</td>
															<td>
																<fmt:formatDate value="${crmQuote.createDate}" pattern="yyyy-MM-dd"/>
															</td>
															<td>
																
																<c:if test="${crmQuote.status == 0}">
																<shiro:hasPermission name="crm:crmQuote:edit">
											    					<a href="${ctx}/crm/crmQuote/form?id=${crmQuote.id}" class="" title="修改">修改</a>
																</shiro:hasPermission>
																<shiro:hasPermission name="crm:crmQuote:del">
																	<a href="${ctx}/crm/crmQuote/delete?id=${crmQuote.id}" onclick="return confirmx('确认要删除该报价单吗？', this.href)" class="" title="删除">删除</a> 
																</shiro:hasPermission>
																<shiro:hasPermission name="crm:crmQuote:audit">
																	<a href="${ctx}/crm/crmQuote/audit?id=${crmQuote.id}" onclick="return confirmx('确认要审核该报价单吗？', this.href)" class="" title="审核">审核</a> 
																</shiro:hasPermission>
																</c:if>
																<c:if test="${crmQuote.status == 1}">
																<shiro:hasPermission name="om:omContract:edit">
											    					<a href="${ctx}/om/omContract/quoteToForm?quote.id=${crmQuote.id}" class="" title="生成订单">生成订单</a>
																</shiro:hasPermission>
																</c:if>
															</td>
														</tr>
													</c:forEach>
													</tbody>
												</table>
												</div>
												<%--报价单 结束 --%>
								 			</div>
								 		</div>
								 		<div id="tab-5" class="tab-pane">
								 			<div class="panel-body">
								 				<%--合同 开始 --%>
								 				<div class="row">
									 				<div class="col-sm-12 m-b-sm">
										 				<shiro:hasPermission name="om:omContract:add">
										   					<a href="${ctx}/om/omContract/form?chance.id=${crmChance.id}&chance.name=${crmChance.name}&customer.id=${crmChance.customer.id}" class="btn btn-white btn-sm" title="创建合同订单"><i class="fa fa-plus"></i>
																<span class="hidden-xs">创建合同订单</span></a>
														</shiro:hasPermission>
													</div>
												</div>
												<div class="table-responsive">
													<table id="contentTable2" class="table table-striped table-bordered table-hover table-condensed">
														<thead>
															<tr>
																<th width="150px">合同编号</th>
																<th>主题</th>
																<th width="100px">总金额</th>
																<th width="100px">签约日期</th>
																<th width="100px">交付时间</th>
																
																<th width="100px">状态</th>
																<th width="100px">销售负责人</th>
																<th width="100px">创建时间</th>
																<th width="120px">操作</th>
															</tr>
														</thead>
														<tbody>
														<c:forEach items="${omContractList}" var="omContract">
															<tr>
																<td><a href="${ctx}/om/omContract/index?id=${omContract.id}">
																	${omContract.no}
																</a></td>
																<td>
																	${omContract.name}
																</td>
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
																	${fns:getDictLabel(omContract.status, 'audit_status', '')}
																</td>
																<td>
																	${omContract.ownBy.name}
																</td>
																<td>
																	<fmt:formatDate value="${omContract.createDate}" pattern="yyyy-MM-dd"/>
																</td>
																<td>
																	
																	<c:if test="${omContract.status == 0}">
																		<shiro:hasPermission name="om:omContract:edit">
													    					<a href="${ctx}/om/omContract/form?id=${omContract.id}" class="" title="修改"><span class="hidden-xs">修改</span></a>
																		</shiro:hasPermission>
																		
																		<shiro:hasPermission name="om:omContract:del">
																			<a href="${ctx}/om/omContract/delete?id=${omContract.id}" onclick="return confirmx('确认要删除该合同吗？', this.href)" class="" title="删除"><span class="hidden-xs">删除</span></a> 
																		</shiro:hasPermission>
																		
																		<shiro:hasPermission name="om:omContract:audit">
																			<a href="${ctx}/om/omContract/audit?id=${omContract.id}" onclick="return confirmx('确认要审核该合同吗？', this.href)" class="" title="审核"><span class="hidden-xs">审核</span></a> 
																		</shiro:hasPermission>
																	</c:if>
																	<c:if test="${omContract.status == 1}">
																	
																	</c:if>
																</td>
															</tr>
														</c:forEach>
														</tbody>
													</table>
												</div>
								               <%--合同 结束 --%>
								 			</div>
								 		</div>
								 		<%--日志 开始 --%>
								 		<div id="tab-6" class="tab-pane">
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
                <h4>商机描述</h4>
                <p class="small">
                    ${crmChance.remarks}
                </p>
                <p class="small font-bold hide">
                    <span><i class="fa fa-circle text-warning"></i> 高优先级</span>
                </p>
                <br>
                
                <h4>联系提醒</h4>
                <p class="small">
                   	 联系时间：<fmt:formatDate value="${crmChance.nextcontactDate}" pattern="yyyy-MM-dd"/>
                		<c:if test="${not empty diffDay && diffDay == 0}">
                    		<span class="badge badge-warning">今日</span>
                    	</c:if>
                    	<c:if test="${not empty diffDay && diffDay > 0}">
                    		<span class="badge badge-info">${diffDay}天后</span>
                    	</c:if>
                </p>
                <p class="small">
                	联系内容：${crmChance.nextcontactNote}
                </p>
                
            </div>
        </div>
    </div>
    
    
    
    
</body>
</html>