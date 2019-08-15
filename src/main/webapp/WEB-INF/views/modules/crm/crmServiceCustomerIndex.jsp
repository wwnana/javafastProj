<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>新建工单</title>
   	<meta name="decorator" content="default"/>
   
	<script type="text/javascript">
		var validateForm;
		function doSubmit(){//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
		  if(validateForm.form()){
			  $("#inputForm").submit();
			  return true;
		  }
	
		  return false;
		}
		$(document).ready(function() {
			//$("#name").focus();
			validateForm=$("#inputForm").validate({
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
</head>
<body class="gray-bg">
<div class="wrapper-content">
    <sys:message content="${message}"/>
	<div class="row ">
		<div class="col-sm-6">
			<div class="ibox">
				<div class="ibox-title">
					<h5>创建工单</h5>
				</div>
				<div class="ibox-content " >
					<form:form id="inputForm" modelAttribute="crmService" action="${ctx}/crm/crmService/save" method="post" class="form-horizontal">
					<form:hidden path="no"/>
					<form:hidden path="customer.id"/>
						<div class="row">
							<div class="col-sm-6">
								<div class="form-group">
									<label class="col-sm-4 control-label"><font color="red">*</font> 工单主题：</label>
									<div class="col-sm-8">
										<form:input path="name" htmlEscape="false" maxlength="50" class="form-control required"/>
									</div>
								</div>
							</div>
							<div class="col-sm-6">
								<div class="form-group">
									<label class="col-sm-4 control-label"> 工单类型：</label>
									<div class="col-sm-8">
										<form:select path="serviceType" cssClass="form-control">
											<form:options items="${fns:getDictList('service_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
										</form:select>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-6">
								<div class="form-group">
									<label class="col-sm-4 control-label"> 订单合同：</label>
									<div class="col-sm-8">
										<sys:tableselect id="omContract" name="omContract.id" value="${crmService.omContract.id}" labelName="omContract.name" labelValue="${crmService.omContract.name}" 
										title="订单" url="${ctx}/om/omContract/selectList?customer.id=${crmService.customer.id}" cssClass="form-control"  allowClear="false" allowInput="false"/>
							
									</div>
								</div>
							</div>
							<div class="col-sm-6">
								<div class="form-group">
									<label class="col-sm-4 control-label"> 负责人：</label>
									<div class="col-sm-8">
										<sys:treeselect id="ownBy" name="ownBy.id" value="${crmService.ownBy.id}" labelName="ownBy.name" labelValue="${crmService.ownBy.name}"
											title="用户" url="/sys/office/treeData?type=3" cssClass="form-control" allowClear="true" notAllowSelectParent="true"/>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-6">
								<div class="form-group">
									<label class="col-sm-4 control-label"> 优先级：</label>
									<div class="col-sm-8">
										<form:select path="levelType" cssClass="form-control">
											<form:options items="${fns:getDictList('level_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
										</form:select>
									</div>
								</div>
							</div>
							<div class="col-sm-6">
								<div class="form-group">
									<label class="col-sm-4 control-label"> 截止日期：</label>
									<div class="col-sm-8">
										<div class="input-group date datepicker">
							                 <input name="endDate" type="text" readonly="readonly" class="form-control" 
							                 value="<fmt:formatDate value="${crmService.endDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
							                 <span class="input-group-addon">
							                      <span class="fa fa-calendar"></span>
							                 </span>
										</div>
									</div>
								</div>
							</div>
						</div>
						
						<div class="row">
							<div class="col-sm-12">
								<div class="form-group">
									<label class="col-sm-2 control-label"><font color="red">*</font> 工单内容：</label>
									<div class="col-sm-10">
										<form:textarea path="content" htmlEscape="false" rows="10" maxlength="500" class="form-control required"/>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-sm-12">
								<div class="form-group">
									<label class="col-sm-2 control-label"> 期望结果：</label>
									<div class="col-sm-10">
										<form:textarea path="expecte" htmlEscape="false" rows="2" maxlength="200" class="form-control "/>
									</div>
								</div>
							</div>
						</div>
						
						<div class="hr-line-dashed"></div>
						<div class="row">
							<div class="col-sm-12">
								<div class="form-group">
									<div class="col-sm-offset-2 col-sm-10">
										<button id="btnSubmit" class="btn btn-success" type="submit">提交</button>&nbsp;
										<button id="btnCancel" class="btn btn-white" type="button" onclick="history.go(-1)">返回</button>
									</div>
								</div>
							</div>
						</div>
					
					</form:form>
				</div>
			</div>
		</div>
		<div class="col-sm-6">
			<div class="ibox">
				<div class="ibox-title">
					<h5>客户信息</h5>
				</div>
				<div class="ibox-content ">
					<div class="row">
                            <div class="col-sm-12">
                                <div class="m-b-md">
                                    
                                    
                                    <div class="pull-left">
                                    	<h2><span class="btn btn-info"><i class="fa fa-building"></i></span> ${crmCustomer.name} 
                                    		
                                    		
                                    	</h2>
                                    </div>
                                    <div class="pull-right">
						        		
						        		
							       		<a href="${ctx}/crm/crmService/crmServiceCustomerIndex?id=${crmCustomer.id}" class="btn btn-default btn-sm" title="刷新"><i class="fa fa-refresh"></i> </a>
					        			<button id="btnCancel" class="btn btn-default btn-sm" type="button" onclick="history.go(-1)" title="返回"><i class="fa fa-close"></i> </button>
	       		
						        	</div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-sm-5">
                                <dl class="dl-horizontal">

                                    <dt>客户级别：</dt>
                                    <dd><span class="text-navy">${fns:getDictLabel(crmCustomer.customerLevel, 'customer_level', '')}</span></dd>
                                    <dt>客户类别：</dt>
                                    <dd>${fns:getDictLabel(crmCustomer.customerType, 'customer_type', '')}</dd>
                                    <dt>客户状态：</dt>
                                    <dd>${fns:getDictLabel(crmCustomer.customerStatus, 'customer_status', '')}</dd>
                                </dl>
                            </div>
                            <div class="col-sm-7" id="cluster_info">
                                <dl class="dl-horizontal">

                                    <dt>创建人：</dt>
                                    <dd>${crmCustomer.createBy.name}</dd>
                                    <dt>创建于：</dt>
                                    <dd><fmt:formatDate value="${crmCustomer.createDate}" pattern="yyyy年 MM月dd日 HH:mm"/></dd>
                                    <dt>负责人：</dt>
                                    <dd class="">
                                       ${crmCustomer.ownBy.name}
                                    </dd>
                                </dl>
                            </div>
                        </div>
					<div class="panel blank-panel">
                                    <div class="panel-heading">
                                        <div class="panel-options">
                                            <ul class="nav nav-tabs">
                                                <li class="active"><a data-toggle="tab" href="#tab-0" aria-expanded="true"><i class="fa fa-laptop"></i> 概况</a></li>		
                                                <li><a href="#tab-1" data-toggle="tab">详情</a></li>	 		
										 		<li><a data-toggle="tab" href="#tab-3" aria-expanded="false">联系人 <span class="badge badge-info"><c:if test="${fn:length(crmContacterList)>0}">${fn:length(crmContacterList)}</c:if></span></a></li>
										 		<li><a data-toggle="tab" href="#tab-6" aria-expanded="false">合同 <span class="badge badge-info"><c:if test="${fn:length(omContractList)>0}">${fn:length(omContractList)}</c:if></span></a></li>
										 		<li><a data-toggle="tab" href="#tab-7" aria-expanded="false">收款 <span class="badge badge-info"><c:if test="${fn:length(fiReceiveAbleList)>0}">${fn:length(fiReceiveAbleList)}</c:if></span></a></li>
                                            </ul>
                                        </div>
                                    </div>

                                    <div class="panel-body">
                                        <div class="tab-content">
                                            <div class="tab-pane active" id="tab-0">
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
								                <div class="ibox">
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
													crmServiceCustomerIndex.jsp
								                	<div class="ibox-title white-bg">
								                        <h5>新建跟进记录</h5>
								                        <div class="ibox-tools">
								                        </div>
								                    </div>
							                    	<div class="ibox-content no-padding" style="height:130px;">
							                    		<form:textarea path="content" htmlEscape="false" style="margin-top: 10px;height: 80px;width: 100%;border:0;" maxlength="500" class="form-control required"  placeholder="发布一条跟进记录..."/>
								                    	<div class="">
									                    	&nbsp;&nbsp;&nbsp;记录类型：
									                    	<form:select path="contactType" class="form-control required input-small">
																<form:options items="${fns:getDictList('contact_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
															</form:select>
															<button class="btn btn-default"> 发  布 </button>
														</div>
								                    </div>
								                    </form:form>
								                </div>
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
								                
                                            </div>
                                            <div class="tab-pane" id="tab-1">
                                            	<div class="panel-body">
									 				<div class="form-horizontal">				 				
														<h4 class="page-header">客户信息</h4>
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
																		<p class="form-control-static">${crmCustomer.province}${crmCustomer.city}${crmCustomer.dict}</p>
																	</div>
																</div>
															</div>
															<div class="col-sm-6">
																<div class="view-group">
																	<label class="col-sm-4 control-label">详细地址：</label>
																	<div class="col-sm-8">
																		<p class="form-control-static">${crmCustomer.address}</p>
																	</div>
																</div>
															</div>
														</div>
														
														
														<h4 class="page-header">备注信息</h4>
														<div class="row">
															<div class="col-sm-12">
																<div class="view-group">
																	<label class="col-sm-2 control-label">备注：</label>
																	<div class="col-sm-10">
																		<p class="form-control-static">${crmCustomer.remarks}</p>
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
                                            	
                                                <table class="table table-striped">
                                                    <thead>
                                                        <tr>
                                                            <th>姓名</th>							
															<th>职务</th>
															<th>手机</th>
															<th>电话</th>
															<th>邮箱</th>							
															<th>QQ</th>
															<th>首要</th>
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
																	${crmContacter.jobType}
																</td>
																<td>
																	${crmContacter.mobile}
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
																
															</tr>
														</c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                           
									 		<div id="tab-6" class="tab-pane">
									 			<div class="panel-body">
									 				<%--合同  开始 --%>
													
													<div class="table-responsive">
													<table id="contentTable" class="table table-bordered table-hover">
														<thead>
															<tr>
																<th width="150px">合同编号</th>
																<th>主题</th>
																<th width="">总金额</th>
																<th width="">签约日期</th>
																<th width="">交付时间</th>
																<th width="">负责人</th>
																<th width="">状态</th>
																<th width="">创建时间</th>
															</tr>
														</thead>
														<tbody>
														<c:forEach items="${omContractList}" var="omContract">
															<tr>
																<td><a href="${ctx}/om/omContract/index?id=${omContract.id}">
																	${omContract.no}
																</a></td>
																<td>
																	${fns:abbr(omContract.name,30)}
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
																<th width="">应收金额</th>
																<th width="">实际已收</th>
																<th width="">差额</th>
																<th width="">应收时间</th>
																
																<th width="">状态</th>
																<th width="">负责人</th>
																<th width="">创建时间</th>
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
																
															</tr>
														</c:forEach>
														</tbody>
													</table>
													</div>
													<%--应收款 结束 --%>
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
</body></html>