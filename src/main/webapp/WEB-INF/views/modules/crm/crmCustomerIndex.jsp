<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>客户主页</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
    function saveCustomerStar(customerId){    	
    	var is_star = $("#customerStar").hasClass("color-orange");    	    	
    	$.ajax({
    		url:"${ctx}/crm/crmCustomerStar/saveCustomerStar",
    		type:"POST",
    		async:true,    //或false,是否异步
    		data:{customerId:customerId, isStar:is_star},
    		dataType:'json',
    		success:function(data){
    			//alert(data);
    			if(is_star == false){
    				$("#customerStar").addClass("color-orange");
    				$("#starBtn").text("已关注");
    			}else{
    				$("#customerStar").removeClass("color-orange");
    				$("#starBtn").text("未关注");
    			}    				
    		},
    		error:function(){
    			//alert("出错");
    		}
    	});
    }
    function toView(objectType, targetId){
    	//object_type对象类型    10：项目，11：任务，12:日报，13：通知，14：审批，20：客户，21：联系人，22：商机，23：报价，24：合同订单，25:沟通, 26:订单，27：退货单，30：产品：31：采购，32：入库，33：出库，34：移库，39：供应商，36：盘点，37:调拨，   50：应收款，51：应付款， 52：收款单，53：付款单
    	if(objectType == "11"){//任务
    		window.location.href = "${ctx}/oa/oaTask/view?id="+targetId;
    	}
    	if(objectType == "18"){//市场活动
    		window.location.href = "${ctx}/crm/crmMarket/index?id="+targetId;
    	}
    	if(objectType == "19"){//销售线索
    		window.location.href = "${ctx}/crm/crmClue/index?id="+targetId;
    	}
    	if(objectType == "20"){//客户
    		window.location.href = "${ctx}/crm/crmCustomer/view?id="+targetId;
    	}
    	if(objectType == "21"){
    		openDialogView("联系人", "${ctx}/crm/crmContacter/view?id="+targetId, '800px', '500px');
    	}
    	if(objectType == "22"){//商机
    		window.location.href = "${ctx}/crm/crmChance/index?id="+targetId;
    	}
    	if(objectType == "23"){//报价
    		window.location.href = "${ctx}/crm/crmQuote/view?id="+targetId;
    	}
    	if(objectType == "24"){//合同订单
    		window.location.href = "${ctx}/om/omContract/index?id="+targetId;
    	}
    	if(objectType == "25"){
    		openDialogView("跟进记录", "${ctx}/crm/crmContactRecord/view?id="+targetId, '800px', '500px');
    	}
    	if(objectType == "26"){//订单
    		window.location.href = "${ctx}/om/omOrder/index?id="+targetId;
    	}
    	if(objectType == "27"){//退货单
    		window.location.href = "${ctx}/om/omReturnorder/view?id="+targetId;
    	}
    	if(objectType == "39"){
    		openDialogView("供应商", "${ctx}/wms/wmsSupplier/view?id="+targetId, '800px', '500px');
    	}
    	if(objectType == "31"){//采购单
    		window.location.href = "${ctx}/wms/wmsPurchase/view?id="+targetId;
    	}
    	if(objectType == "32"){//入库单
    		window.location.href = "${ctx}/wms/wmsInstock/view?id="+targetId;
    	}
    	if(objectType == "33"){//出库单
    		window.location.href = "${ctx}/wms/wmsOutstock/view?id="+targetId;
    	}
    	if(objectType == "50"){//应收款
    		window.location.href = "${ctx}/fi/fiReceiveAble/index?id="+targetId;
    	}
    	if(objectType == "51"){//应付款
    		window.location.href = "${ctx}/fi/fiPaymentAble/index?id="+targetId;
    	}
    	if(objectType == "52"){
    		openDialogView("收款单", "${ctx}/fi/fiReceiveBill/view?id="+targetId, '800px', '500px');
    	}
    	if(objectType == "53"){
    		openDialogView("付款单", "${ctx}/fi/fiPaymentBill/view?id="+targetId, '800px', '500px');
    	}
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
                                    	<h3>
                                    		<img src="${ctxStatic}/weui/images/app/icon_customer.png" class="ibox-title-img">${crmCustomer.name} 
                                    		<span class="btn btn-outline btn-info btn-xs">${fns:getDictLabel(crmCustomer.customerStatus, 'customer_status', '')}</span>
                                    		
                                    	</h3>
                                    </div>
                                    <div class="pull-right">
						        		
						        		<button onclick="saveCustomerStar('${crmCustomer.id}');" class="btn btn-default btn-sm"><i id="customerStar" class="fa fa-star <c:if test='${not empty isStar}'>color-orange</c:if>"></i> <span id="starBtn"><c:if test='${empty isStar}'>未</c:if><c:if test='${not empty isStar}'>已</c:if>关注</span></button>
						        		<a href="https://www.baidu.com/s?wd=${crmCustomer.name }" class="btn btn-outline btn-default btn-sm" title="查询工商信息" target="_blank"><i class="fa fa-info"></i> 百度</a>
							       		
							       		<shiro:hasPermission name="crm:crmCustomer:edit">
											<c:if test="${crmCustomer.lockFlag==0}">
												<a href="#" onclick="openDialog('修改客户', '${ctx}/crm/crmCustomer/form?id=${crmCustomer.id}','1000px', '80%', '')" class="btn btn-default btn-sm"><i class="fa fa-pencil"></i> 编辑</a>
												<a href="${ctx}/crm/crmCustomer/lock?id=${crmCustomer.id}" onclick="return confirmx('确定要锁定吗？锁定后不可以再进行编辑删除等操作。', this.href)" class="btn btn-default btn-sm"><i class="fa fa-lock"></i> 锁定</a>
											</c:if>
											<c:if test="${crmCustomer.lockFlag==1}">
												<a href="${ctx}/crm/crmCustomer/unLock?id=${crmCustomer.id}" onclick="return confirmx('确定要解锁吗？解锁后其他相关用户也可以进行编辑作废等操作。', this.href)" class="btn btn-default btn-sm"><i class="fa fa-unlock"></i> 解锁</a>
											</c:if>
										</shiro:hasPermission>
							       		<div class="btn-group">
											<button data-toggle="dropdown" class="btn btn-default btn-sm dropdown-toggle" aria-expanded="false"><i class="fa fa-plus"></i> 新建 
						                    </button>
						                    <ul class="dropdown-menu">
						                    	<shiro:hasPermission name="crm:crmChance:add">
							    					<li><a href="#" onclick="openDialog('新建商机', '${ctx}/crm/crmChance/form?customer.id=${crmCustomer.id}&customer.name=${crmCustomer.name}','1000px', '80%')" class="" title="新建商机">商机</a></li>
												</shiro:hasPermission>
						                       <li><a href="#" onclick="openDialog('新建联系人', '${ctx}/crm/crmContacter/form?customer.id=${crmCustomer.id}','800px', '500px')" title="新建联系人" >联系人</a></li>
						                       <li><a href="${ctx}/crm/crmQuote/form?customer.id=${crmCustomer.id}" class="" title="新建报价单" >报价单</a></li>
								        	   <li><a href="${ctx}/om/omContract/form?customer.id=${crmCustomer.id}" class="" title="新建合同订单">合同订单</a></li>
								        	   <li class="divider"></li>
								        	   <li><a href="${ctx}/crm/crmService/crmServiceCustomerIndex?id=${crmCustomer.id}" class="" title="新建合同订单">服务工单</a></li>
						                    </ul>
						                </div>
										<div class="btn-group">
						                    <button data-toggle="dropdown" class="btn btn-default btn-sm dropdown-toggle" aria-expanded="false">更多 <i class="fa fa-chevron-down"></i>
						                    </button>
						                    <ul class="dropdown-menu">
												<li>
													<a href="#" onclick="openDialog('下次联系提醒', '${ctx}/crm/crmContactRecord/nextContactForm?id=${crmCustomer.id}','600px', '400px')" class="" title="下次联系提醒"> 提醒</a>
												</li>
												<li>
													<a href="#" onclick="openDialog('添加跟进记录', '${ctx}/crm/crmContactRecord/form?customer.id=${crmCustomer.id}','800px', '500px')" title="新增跟进记录" class="" > 沟通</a>
        										</li>
        										<c:if test="${crmCustomer.lockFlag==0}">
        										<li>
        											<a href="#" onclick="openDialog('指派', '${ctx}/crm/crmCustomer/shareForm?id=${crmCustomer.id}','500px', '300px')" type="button" class="" title="指派"> 指派</a>
												</li>
												<li class="divider"></li>
						                    	<c:if test="${crmCustomer.isPool == 0}">
						                    	<li>
									       			<a href="${ctx}/crm/crmCustomer/toPool?id=${crmCustomer.id}" onclick="return confirmx('确认要将该客户放入公海吗？', this.href)" class="">放入公海</a>
									       		</li>
									       		</c:if>
									       		<c:if test="${crmCustomer.isPool == 1}">
									       		<li>
									       			<a href="${ctx}/crm/crmCustomerPool/draw?id=${crmCustomer.id}" class="" title="领取">领取</a>
									       		</li>
									       		</c:if>
							       				<li class="divider"></li>
						                        <li>
						                        	<shiro:hasPermission name="crm:crmCustomer:del">
										       			<a href="${ctx}/crm/crmCustomer/delete?id=${crmCustomer.id}" onclick="return confirmx('确认要删除该客户吗？', this.href)" class="">删除</a>
										       		</shiro:hasPermission>
						                        </li>
						                        </c:if>
								        		<li class="divider"></li>
								        		<li><a href="#" onclick="openDialogView('开票信息', '${ctx}/crm/crmInvoice/list?customer.id=${crmCustomer.id}','1000px', '500px')" class="">开票信息</a></li>
						                    </ul>
						                </div>
						                
							       		
							       		<a href="${ctx}/crm/crmCustomer/index?id=${crmCustomer.id}" class="btn btn-default btn-sm" title="刷新"><i class="fa fa-refresh"></i> </a>
					        			<button id="btnCancel" class="btn btn-default btn-sm" type="button" onclick="history.go(-1)" title="返回"><i class="fa fa-rotate-left"></i> </button>
	       		
						        	</div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-sm-5">
                                <dl class="dl-horizontal">

                                    <dt>客户级别：</dt>
                                    <dd><span class="text-navy">${fns:getDictLabel(crmCustomer.customerLevel, 'customer_level', '')}</span></dd>
                                    <dt>类别：</dt>
                                    <dd>${fns:getDictLabel(crmCustomer.customerType, 'customer_type', '')}</dd>
                                    <dt>创建者：</dt>
                                    <dd>${crmCustomer.createBy.name}</dd>
                                </dl>
                            </div>
                            <div class="col-sm-7" id="cluster_info">
                                <dl class="dl-horizontal">

                                    <dt>最后更新：</dt>
                                    <dd><fmt:formatDate value="${crmCustomer.updateDate}" pattern="yyyy年 MM月dd日 HH:mm"/></dd>
                                    <dt>创建于：</dt>
                                    <dd><fmt:formatDate value="${crmCustomer.createDate}" pattern="yyyy年 MM月dd日 HH:mm"/></dd>
                                    <dt>负责人：</dt>
                                    <dd>
                                        ${crmCustomer.ownBy.name}<c:if test="${empty crmCustomer.ownBy.name}">--</c:if>
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
                                                <li><a href="#tab-1" data-toggle="tab">详情</a></li>	 		
										 		<li><a data-toggle="tab" href="#tab-3" aria-expanded="false">联系人 <span class="badge badge-info"><c:if test="${fn:length(crmContacterList)>0}">${fn:length(crmContacterList)}</c:if></span></a></li>
										 		<li><a data-toggle="tab" href="#tab-4" aria-expanded="false">商机 <span class="badge badge-info"><c:if test="${fn:length(crmChanceList)>0}">${fn:length(crmChanceList)}</c:if></span></a></li>
										 		<li><a data-toggle="tab" href="#tab-5" aria-expanded="false">报价 <span class="badge badge-info"><c:if test="${fn:length(crmQuoteList)>0}">${fn:length(crmQuoteList)}</c:if></span></a></li>
										 		<li><a data-toggle="tab" href="#tab-6" aria-expanded="false">合同 <span class="badge badge-info"><c:if test="${fn:length(omContractList)>0}">${fn:length(omContractList)}</c:if></span></a></li>
										 		<li><a data-toggle="tab" href="#tab-7" aria-expanded="false">收款 <span class="badge badge-info"><c:if test="${fn:length(fiReceiveAbleList)>0}">${fn:length(fiReceiveAbleList)}</c:if></span></a></li>
										 		<li><a data-toggle="tab" href="#tab-9" aria-expanded="false">服务 <span class="badge badge-info"><c:if test="${fn:length(crmServiceList)>0}">${fn:length(crmServiceList)}</c:if></span></a></li>
										 		<li><a data-toggle="tab" href="#tab-10" aria-expanded="false">附件 <span class="badge badge-info"><c:if test="${fn:length(crmDocumentList)>0}">${fn:length(crmDocumentList)}</c:if></span></a></li>
										 		<li><a data-toggle="tab" href="#tab-11" aria-expanded="false">操作日志 </a></li>
                                            </ul>

                                    <div class="">
                                        <div class="tab-content">
                                            <div class="tab-pane active" id="tab-0">
                                            	<div class="panel-body">
                                            	<div class="ibox">
                                            		<div class="form-horizontal">
                                            		<div class="ibox-title white-bg">
								                        <h5>数据总览</h5>
								                        <div class="ibox-tools">
								                        </div>
								                    </div>
								                    <div class="ibox-content">
								                        
								                        <div class="row  m-t-sm">
								                            <div class="col-sm-3 text-center">
								                                <div class="">商机总额</div>
								                                <div class="font-bold">¥${generalCout.totalChanceAmt}</div>
								                            </div>
								                            <div class="col-sm-3 text-center">
								                                <div class="">订单总额</div>
								                                <div class="font-bold">¥${generalCout.totalOrderAmt}</div>
								                            </div>
								                            <div class="col-sm-3 text-center">
								                                <div class="">回款总额</div>
								                                <div class="font-bold">¥${generalCout.totalReceiveAmt}</div>
								                            </div>
								                            <div class="col-sm-3 text-center">
								                                <div class="">退款总额</div>
								                                <div class="font-bold">¥${generalCout.totalRefundAmt}</div>
								                            </div>
								                        </div>
								                    </div>
								                    </div>
								                </div>
								                
												
								                <%--跟进记录开始 --%>
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
								                <%--跟进记录结束 --%>
								                </div>
                                            </div>
                                            <div class="tab-pane" id="tab-1">
                                            	<div class="panel-body">
									 				<div class="form-horizontal">				 				
														<h4 class="page-header">基本信息</h4>
														<div class="row">
															<div class="col-sm-6">
																<div class="view-group">
																	<label class="col-sm-4 control-label">客户名称：</label>
																	<div class="col-sm-8">
																		<p class="form-control-static">${crmCustomer.name }</p>
																	</div>
																</div>
															</div>
															<div class="col-sm-6">
																<div class="view-group">
																	<label class="col-sm-4 control-label">客户分类：</label>
																	<div class="col-sm-8">
																		<p class="form-control-static">${fns:getDictLabel(crmCustomer.customerType, 'customer_type', '')}</p>
																	</div>
																</div>
															</div>
														</div>
														<div class="row">
															<div class="col-sm-6">
																<div class="view-group">
																	<label class="col-sm-4 control-label">客户状态：</label>
																	<div class="col-sm-8">
																		<p class="form-control-static">${fns:getDictLabel(crmCustomer.customerStatus, 'customer_status', '')}</p>
																	</div>
																</div>
															</div>
															<div class="col-sm-6">
																<div class="view-group">
																	<label class="col-sm-4 control-label">客户级别：</label>
																	<div class="col-sm-8">
																		<p class="form-control-static">${fns:getDictLabel(crmCustomer.customerLevel, 'customer_level', '')}</p>
																	</div>
																</div>
															</div>
														</div>
														<div class="row">
															<div class="col-sm-6">
																<div class="view-group">
																	<label class="col-sm-4 control-label">客户标签：</label>
																	<div class="col-sm-8">
																		<p class="form-control-static"><c:set var="tagList" value="${fn:split(crmCustomer.tags, ',')}" />
														                	<c:forEach items="${tagList}" var="tagStr">
																				<span class="badge"><c:out value="${tagStr}" /></span>
																			</c:forEach></p>
																	</div>
																</div>
															</div>
														</div>
														
														<h4 class="page-header">详细信息</h4>
														<div class="row">
															<div class="col-sm-6">
																<div class="view-group">
																	<label class="col-sm-4 control-label">客户行业：</label>
																	<div class="col-sm-8">
																		<p class="form-control-static">${fns:getDictLabel(crmCustomer.industryType, 'industry_type', '')}</p>
																	</div>
																</div>
															</div>
															<div class="col-sm-6">
																<div class="view-group">
																	<label class="col-sm-4 control-label">客户来源：</label>
																	<div class="col-sm-8">
																		<p class="form-control-static">${fns:getDictLabel(crmCustomer.sourType, 'sour_type', '')}</p>
																	</div>
																</div>
															</div>
														</div>
														<div class="row">
															<div class="col-sm-6">
																<div class="view-group">
																	<label class="col-sm-4 control-label">公司性质：</label>
																	<div class="col-sm-8">
																		<p class="form-control-static">${fns:getDictLabel(crmCustomer.natureType, 'nature_type', '')}</p>
																	</div>
																</div>
															</div>
															<div class="col-sm-6">
																<div class="view-group">
																	<label class="col-sm-4 control-label">企业规模：</label>
																	<div class="col-sm-8">
																		<p class="form-control-static">${fns:getDictLabel(crmCustomer.scaleType, 'scale_type', '')}</p>
																	</div>
																</div>
															</div>
														</div>
														<div class="row">
															<div class="col-sm-6">
																<div class="view-group">
																	<label class="col-sm-4 control-label">公司电话：</label>
																	<div class="col-sm-8">
																		<p class="form-control-static">${crmCustomer.phone}</p>
																	</div>
																</div>
															</div>
															<div class="col-sm-6">
																<div class="view-group">
																	<label class="col-sm-4 control-label">公司传真：</label>
																	<div class="col-sm-8">
																		<p class="form-control-static">${crmCustomer.fax}</p>
																	</div>
																</div>
															</div>
														</div>
														<div class="row">
															<div class="col-sm-6">
																<div class="view-group">
																	<label class="col-sm-4 control-label">公司地址：</label>
																	<div class="col-sm-8">
																		<p class="form-control-static">${crmCustomer.province}${crmCustomer.city}${crmCustomer.dict}${crmCustomer.address}</p>
																	</div>
																</div>
															</div>
														</div>
														<div class="row">
															<div class="col-sm-6">
																<div class="view-group">
																	<label class="col-sm-4 control-label">备注：</label>
																	<div class="col-sm-8">
																		<p class="form-control-static">${crmCustomer.remarks}</p>
																	</div>
																</div>
															</div>
														</div>
														
														<h4 class="page-header">联系提醒</h4>
														<div class="row">
															<div class="col-sm-6">
																<div class="view-group">
																	<label class="col-sm-4 control-label">下次联系时间：</label>
																	<div class="col-sm-8">
																		<p class="form-control-static">
																			<fmt:formatDate value="${crmCustomer.nextcontactDate}" pattern="yyyy-MM-dd"/>
																		</p>
																	</div>
																</div>
															</div>
															<div class="col-sm-6">
																<div class="view-group">
																	<label class="col-sm-4 control-label">下次联系内容：</label>
																	<div class="col-sm-8">
																		<p class="form-control-static">
																			${crmCustomer.nextcontactNote}
																		</p>
																	</div>
																</div>
															</div>
														</div>
														<h4 class="page-header">操作信息</h4>
														
														<div class="row">
															<div class="col-sm-6">
																<div class="view-group">
																	<label class="col-sm-4 control-label">创建者：</label>
																	<div class="col-sm-8">
																		<p class="form-control-static">${crmCustomer.createBy.name}</p>
																	</div>
																</div>
															</div>
															<div class="col-sm-6">
																<div class="view-group">
																	<label class="col-sm-4 control-label">创建时间：</label>
																	<div class="col-sm-8">
																		<p class="form-control-static"><fmt:formatDate value="${crmCustomer.createDate}" pattern="yyyy-MM-dd HH:mm"/></p>
																	</div>
																</div>
															</div>
														</div>
														<div class="row">
															<div class="col-sm-6">
																<div class="view-group">
																	<label class="col-sm-4 control-label">更新者：</label>
																	<div class="col-sm-8">
																		<p class="form-control-static">${crmCustomer.updateBy.name}</p>
																	</div>
																</div>
															</div>
															<div class="col-sm-6">
																<div class="view-group">
																	<label class="col-sm-4 control-label">更新时间：</label>
																	<div class="col-sm-8">
																		<p class="form-control-static"><fmt:formatDate value="${crmCustomer.updateDate}" pattern="yyyy-MM-dd HH:mm"/></p>
																	</div>
																</div>
															</div>
														</div>
														
													</div>
									 			</div>
                                            </div>
                                           
                                            <div class="tab-pane" id="tab-3">
                                            <div class="panel-body">
                                            	<div class="row">
									 				<div class="col-sm-12 m-b-sm">
									 					<a href="#" onclick="openDialog('新建联系人', '${ctx}/crm/crmContacter/form?customer.id=${crmCustomer.id}','800px', '500px')" title="添加联系人" class="btn btn-default btn-sm"><i class="fa fa-plus"></i> 添加联系人</a>
													</div>
												</div>
                                                <table class="table table-bordered table-striped">
                                                    <thead>
                                                        <tr>
                                                            <th>姓名</th>
                                                            <th>手机</th>							
															<th>角色</th>
															<th>职务</th>
															
															<th>电话</th>
															<th>邮箱</th>							
															<th>QQ</th>
															<th>首要</th>
															<th width="150px">操作</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                    	<c:forEach items="${crmContacterList}" var="crmContacter">
															<tr>
																<td>
																	<a href="#" onclick="openDialogView('查看联系人', '${ctx}/crm/crmContacter/view?id=${crmContacter.id}','800px', '500px')">
																	${crmContacter.name}
																	</a>
																</td>
																<td>
																	${crmContacter.mobile}
																</td>
																<td>
																	${fns:getDictLabel(crmContacter.roleType, 'role_type', '')}
																</td>
																<td>
																	${crmContacter.jobType}
																</td>
																
																<td>
																	${crmContacter.tel}
																</td>
																<td>
																	${crmContacter.email}
																</td>
																<td>
																	<c:if test="${not empty crmContacter.qq}">
																		<a target="_blank" href="http://wpa.qq.com/msgrd?v=3&uin=${crmContacter.qq}&site=qq&menu=yes" title="点击打开QQ对话框">
																			${crmContacter.qq}
																		</a>
																	</c:if>
																</td>
																<td>
																	<c:if test="${crmContacter.isDefault == 1}"><i class="fa fa-check text-navy"></i></c:if>
																</td>
																<td>											
																	<shiro:hasPermission name="crm:crmContacter:edit">
												    					<a href="#" onclick="openDialog('修改联系人', '${ctx}/crm/crmContacter/form?id=${crmContacter.id}','800px', '500px')" class="" title="修改" >修改</a>
																	</shiro:hasPermission>
																	<shiro:hasPermission name="crm:crmContacter:del">
																		<a href="${ctx}/crm/crmContacter/indexDelete?id=${crmContacter.id}" onclick="return confirmx('确认要删除该联系人吗？', this.href)" class="" title="删除">删除</a> 
																	</shiro:hasPermission>
																	<shiro:hasPermission name="crm:crmContacter:edit">
																		<a href="${ctx}/crm/crmContacter/setDefault?id=${crmContacter.id}" onclick="return confirmx('确认要将${crmContacter.name}设为首要联系人吗？', this.href)" class=" " title="设为首要联系人">设为首要</a> 
																	</shiro:hasPermission>
																</td>
															</tr>
														</c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                            </div>
                                            <div id="tab-4" class="tab-pane">
									 			<div class="panel-body">
									 				<%--商机 开始 --%>
									 				<div class="row">
														<div class="col-sm-12 m-b-sm">
															<shiro:hasPermission name="crm:crmChance:add">
																<a href="#" onclick="openDialog('新建商机', '${ctx}/crm/crmChance/form?customer.id=${crmCustomer.id}&customer.name=${crmCustomer.name}','1000px', '80%')"  class="btn btn-default btn-sm" title="创建商机" ><i class="fa fa-plus"></i> 创建商机</a>
															</shiro:hasPermission>
														</div>
													</div>
									 				<div class="table-responsive">
													<table id="contentTable" class="table table-bordered table-striped">
														<thead>
															<tr>
																<th>商机名称</th>
																<th width="">销售金额(元)</th>
																<th width="">销售阶段</th>
																<th width="">赢单率</th>
																<th width="">负责人</th>
																<th width="">创建时间</th>
															</tr>
														</thead>
														<tbody>
														<c:forEach items="${crmChanceList}" var="crmChance">
															<tr>
																<%-- <td><input type="checkbox" id="${crmChance.id}" class="i-checks"></td>--%>
																<td>
																	<a href="${ctx}/crm/crmChance/index?id=${crmChance.id}" >
																		${fns:abbr(crmChance.name,50)}
																	</a>
																</td>
																
																<td>
																	${crmChance.saleAmount}
																</td>
																<td>
																	${fns:getDictLabel(crmChance.periodType, 'period_type', '')}
																</td>
																<td>
																	${fns:getDictLabel(crmChance.probability, 'probability_type', '')}
																</td>
																<td>
																	${crmChance.ownBy.name}
																</td>
																<td>
																	<fmt:formatDate value="${crmChance.createDate}" pattern="yyyy-MM-dd"/>
																</td>
															</tr>
														</c:forEach>
														</tbody>
													</table>
													</div>
													<%--商机 结束 --%>
									 			</div>
									 		</div>
									 		<div id="tab-5" class="tab-pane">
									 			<div class="panel-body">
									 				<%--报价 开始 --%>
													<div class="row">
														<div class="col-sm-12 m-b-sm">
															<a href="${ctx}/crm/crmQuote/form?customer.id=${crmCustomer.id}" class="btn btn-default btn-sm" title="添加报价单" ><i class="fa fa-plus"></i> 添加报价单</a>
														</div>
													</div>
													<div class="table-responsive">
													<table id="contentTable" class="table table-bordered table-hover">
														<thead>
															<tr>
																<th>单号</th>
																
																<th width="100px">总金额</th>
																<th width="100px">报价日期</th>
																<th width="100px">有效期至</th>
																<th width="100px">状态</th>
																<th width="100px">负责人</th>
																<th width="100px">创建时间</th>
															</tr>
														</thead>
														<tbody>
														<c:forEach items="${crmQuoteList}" var="crmQuote">
															<tr>
																<td>
																	<a href="${ctx}/crm/crmQuote/view?id=${crmQuote.id}" >
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
																
															</tr>
														</c:forEach>
														</tbody>
													</table>
													</div>
													<%--报价 结束 --%>
									 			</div>
									 		</div>
									 		<div id="tab-6" class="tab-pane">
									 			<div class="panel-body">
									 				<%--合同  开始 --%>
													<div class="row">
														<div class="col-sm-12 m-b-sm">
															<a href="${ctx}/om/omContract/form?customer.id=${crmCustomer.id}" class="btn btn-default btn-sm"> <i class="fa fa-plus"></i> 添加合同订单</a>
														</div>
													</div>
													<div class="table-responsive">
													<table id="contentTable" class="table table-bordered table-hover">
														<thead>
															<tr>
																<th width="150px">合同编号</th>
																<th>主题</th>
																<th width="100px">总金额</th>
																<th width="100px">签约日期</th>
																<th width="100px">交付时间</th>
																<th width="100px">负责人</th>
																<th width="80px">状态</th>
																<th width="100px">创建时间</th>
															</tr>
														</thead>
														<tbody>
														<c:forEach items="${omContractList}" var="omContract">
															<tr>
																<td><a href="${ctx}/om/omContract/index?id=${omContract.id}">
																	${omContract.no}
																</a></td>
																<td>
																	${fns:abbr(omContract.name,50)}
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
																	${omContract.ownBy.name}
																</td>
																<td>
																	${fns:getDictLabel(omContract.status, 'audit_status', '')}
																</td>
																<td>
																	<fmt:formatDate value="${omContract.createDate}" pattern="yyyy-MM-dd"/>
																</td>
																
															</tr>
														</c:forEach>
														</tbody>
													</table>
													</div>
													<%--合同  结束 --%>
									 			</div>
									 		</div>
									 		<div id="tab-7" class="tab-pane">
									 			<div class="panel-body">
									 				<%--应收款 开始 --%>
													<div class="table-responsive">
													<table id="contentTable" class="table table-bordered table-hover">
														<thead>
															<tr>
																<th>单号</th>
																<th width="100px">应收金额</th>
																<th width="100px">实际已收</th>
																<th width="100px">差额</th>
																<th width="100px">应收时间</th>
																
																<th width="80px">状态</th>
																<th width="100px">负责人</th>
																<th width="100px">创建时间</th>
																<th width="120px">操作</th>
															</tr>
														</thead>
														<tbody>
														<c:forEach items="${fiReceiveAbleList}" var="fiReceiveAble">
															<tr>
																<td><a href="${ctx}/fi/fiReceiveAble/index?id=${fiReceiveAble.id}">
																	${fiReceiveAble.no}
																</a></td>
																
																<td>
																	${fiReceiveAble.amount}
																</td>
																<td>
																	${fiReceiveAble.realAmt}
																</td>
																<td>
																	<c:if test="${(fiReceiveAble.amount - fiReceiveAble.realAmt) > 0}">
																		<span class="label label-warning">${fiReceiveAble.amount - fiReceiveAble.realAmt}</span>
																	</c:if>								
																</td>
																<td>
																	<fmt:formatDate value="${fiReceiveAble.ableDate}" pattern="yyyy-MM-dd"/>
																</td>
																
																<td>
																	${fns:getDictLabel(fiReceiveAble.status, 'finish_status', '')}
																</td>
																<td>
																	${fiReceiveAble.ownBy.name}
																</td>
																<td>
																	<fmt:formatDate value="${fiReceiveAble.createDate}" pattern="yyyy-MM-dd"/>
																</td>
																<td>
																	
																	<c:if test="${fiReceiveAble.status != 2}">
																	<shiro:hasPermission name="fi:fiReceiveAble:edit">
												    					<a href="#" onclick="openDialog('修改应收款', '${ctx}/fi/fiReceiveAble/editForm?id=${fiReceiveAble.id}','800px', '500px')" class="" title="修改">修改</a>
																	</shiro:hasPermission>
																	<shiro:hasPermission name="fi:fiReceiveBill:add">
												    					<a href="#" onclick="openDialog('添加收款单', '${ctx}/fi/fiReceiveBill/form?fiReceiveAble.id=${fiReceiveAble.id}&fiReceiveAble.name=${fiReceiveAble.no}&customer.id=${fiReceiveAble.customer.id}&customer.name=${fiReceiveAble.customer.name}','800px', '500px')" class="" title="添加收款单">添加收款单</a>
																	</shiro:hasPermission>
																	
																	</c:if>
																</td>
															</tr>
														</c:forEach>
														</tbody>
													</table>
													</div>
													<%--应收款 结束 --%>
									 			</div>
									 		</div>
									 		
									 		
									 		<%--服务工单 --%>
									 		<div id="tab-9" class="tab-pane">
									 			<div class="panel-body">
									 				<div class="row">
														<div class="col-sm-12 m-b-sm">
															<a href="${ctx}/crm/crmService/crmServiceCustomerIndex?id=${crmCustomer.id}" class="btn btn-default btn-sm"> <i class="fa fa-plus"></i> 创建服务工单</a>
														</div>
													</div>
													<div class="table-responsive">
														<table id="contentTable" class="table table-bordered table-striped table-hover">
															<thead>
																<tr>
																	<th width="100px" class="sort-column a.no">工单编码</th>
																	<th width="200px" class="sort-column a.name">工单主题</th>
																	<th width="100px" class="sort-column a.service_type">工单类型</th>
																	<th width="200px" class="sort-column a.order_id">订单合同</th>
																	<th width="100px" class="sort-column a.own_by">负责人</th>
																	<th width="100px" class="sort-column a.level_type">优先级</th>
																	<th width="100px" class="sort-column a.end_date">截止日期</th>
																	<th width="100px" class="sort-column a.status">处理状态</th>
																	<th width="100px" class="sort-column a.deal_date">处理日期</th>
																	<th width="100px" class="sort-column a.satisfy_type">满意度</th>
																</tr>
															</thead>
															<tbody>
															<c:forEach items="${crmServiceList}" var="crmService">
																<tr>
																	<td>
																		<a href="${ctx}/crm/crmService/index?id=${crmService.id}">
																		${crmService.no}
																		</a>
																	</td>
																	<td>
																		<a href="${ctx}/crm/crmService/index?id=${crmService.id}">${crmService.name}</a>
																	</td>
																	<td>
																		${fns:getDictLabel(crmService.serviceType, 'service_type', '')}
																	</td>
																	<td>
																		<a href="${ctx}/om/omContract/index?id=${crmService.omContract.id}" class="" title="查看">${crmService.omContract.no}</a>
																	</td>
																	<td>
																		${crmService.ownBy.name}
																	</td>
																	<td>
																		${fns:getDictLabel(crmService.levelType, 'level_type', '')}
																	</td>
																	<td>
																		<fmt:formatDate value="${crmService.endDate}" pattern="yyyy-MM-dd"/>
																	</td>
																	<td>
																		${fns:getDictLabel(crmService.status, 'finish_status', '')}
																	</td>
																	<td>
																		<fmt:formatDate value="${crmService.dealDate}" pattern="yyyy-MM-dd"/>
																	</td>
																	<td>
																		${fns:getDictLabel(crmService.satisfyType, 'satisfy_type', '')}
																	</td>
																</tr>
															</c:forEach>
															</tbody>
														</table>
														
														</div>
									 			</div>
									 		</div>
									 		<div id="tab-10" class="tab-pane">
									 			<div class="panel-body">
									 				<div class="row">
														<div class="col-sm-12 m-b-sm">
															<shiro:hasPermission name="crm:crmCustomer:add">
																<a href="#" onclick="openDialog('上传附件', '${ctx}/crm/crmDocument/form?customer.id=${crmCustomer.id}','500px', '300px')" class="btn btn-default btn-sm" title="上传"><i class="fa fa-plus"></i> 上传附件</a>
															</shiro:hasPermission>
														</div>
													</div>
													<ul class="list-unstyled project-files">
									                	<c:forEach items="${crmDocumentList}" var="crmDocument">
									                    <li><a href="${crmDocument.content}" title="点击查看" target="_blank"><i class="fa fa-file"></i> ${crmDocument.name}</a></li>
									                    </c:forEach>
									                </ul>
									 			</div>
									 		</div>
									 		<%--日志 开始 --%>
									 		<div id="tab-11" class="tab-pane">
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
       
    </div>
</body>
</html>