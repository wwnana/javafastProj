<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<jsp:useBean id="now" class="java.util.Date" />     
<fmt:formatDate value="${now}" type="both" dateStyle="long" pattern="yyyy-MM-dd" var="nowDate"/> 
<html>
<head>
	<title>主页</title>
	<meta name="decorator" content="default"/>    
    <script type="text/javascript">
    function saveCustomerStar(customerId){
    	
    	var is_star = $("#customerStar_"+customerId).hasClass("color-orange");
    	    	
    	$.ajax({
    		url:"${ctx}/crm/crmCustomerStar/saveCustomerStar",
    		type:"POST",
    		async:true,    //或false,是否异步
    		data:{customerId:customerId, isStar:is_star},
    		dataType:'json',
    		success:function(data){
    			//alert(data);
    			if(is_star == false){
    				$("#customerStar_"+customerId).addClass("color-orange");
    				$("#customerStar_"+customerId).removeClass("color-gray");
    			}else{
    				$("#customerStar_"+customerId).removeClass("color-orange");
    				$("#customerStar_"+customerId).addClass("color-gray");
    			}    				
    		},
    		error:function(){
    			//alert("出错");
    		}
    	});
    }
    </script>
    <style type="text/css">
    	.table > tbody > tr > td {
		    border-bottom: 1px solid #e7eaec;
		    border-top: 0;
		}
		.ibox-title {
			background-color: #fff;
		}
		.ibox {
			border: 0;
		}
		.ibox-content {
			border: 0;
		}
		.float-e-margins {
			min-height: 400px;
		}
    </style>
</head>

<body class="gray-bg">
    <div class="wrapper-content">
		<sys:message content="${message}"/>
		<div class="row">
			<div class="col-sm-10">
				
				<div class="col-sm-12">
					<div class="ibox">
						<div class="ibox-title">
							<h5>销售简报</h5>
							<div class="ibox-tools">
		                    	<span class="label">${fns:getUser().name}</span>
		                    	<span class="label">个人累计</span>
		                    </div>
						</div>
	                    <div class="ibox-content">
	                        <div class="row">
	                        	<div class="col-sm-3">
					                <div class="ibox ">
					                    <div class="ibox-content gray-bg">
					                        <h5>负责客户</h5>
					                        <h1 class="no-margins text-success">${myCrmReport.ownNum}&nbsp;</h1>
					                        <div class="stat-percent font-bold text-danger"></div>
					                        <small>（个）</small>
					                    </div>
					                </div>
					            </div>
					            <div class="col-sm-3">
					                <div class="ibox">
					                    <div class="ibox-content gray-bg">
					                        <h5>商机</h5>
					                        <h1 class="no-margins text-info">${myCrmReport.ownChangeNum }&nbsp;</h1>
					                        <div class="stat-percent font-bold text-danger"></div>
					                        <small>（个）</small>
					                    </div>
					                </div>
					            </div>
					            <div class="col-sm-3">
					                <div class="ibox">
					                    <div class="ibox-content gray-bg">
					                        <h5>订单总额</h5>
					                        <h1 class="no-margins text-warning">${myCrmReport.createOrderAmt}&nbsp;</h1>
					                        <div class="stat-percent font-bold text-navy">
					                        	
					                        </div>
					                        <small>（元）</small>
					                    </div>
					                </div>
					            </div>
					            <div class="col-sm-3">
					                <div class="ibox">
					                    <div class="ibox-content gray-bg">
					                        <h5>回款总额</h5>
					                        <h1 class="no-margins text-danger">${myCrmReport.recOrderAmt}&nbsp;</h1>
					                         <div class="stat-percent font-bold text-navy">
					                        </div>
					                        <small>（元）</small>
					                    </div>
					                </div>
					            </div>
	                        	
	                        </div>
	                    </div>
	                </div>
				</div>
				
            	<div class="col-sm-6">
	        		<div class="ibox float-e-margins">
						<div class="ibox-title">
							<h5>待联系客户</h5>
							<div class="ibox-tools">
		                        <a class="" href="${ctx}/crm/crmCustomer">
		                            <i class="fa fa-chevron-right"></i>
		                        </a>
		                    </div>
						</div>
						<div class="ibox-content  ">
							<div class="table-responsive">
							<table id="contentTable" class="table">
								<thead>
									<tr>
										<th>客户名称</th>
										<th width="100px">状态</th>
										<th width="100px">联系日期</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${contactCustomerPage.list }" var="crmCustomer" varStatus="status">
										<tr>
											<td>
												<a href="${ctx}/crm/crmCustomer/index?id=${crmCustomer.id}" title="查看">
													${crmCustomer.name}
											</td>
											<td>
												<span class="<c:if test='${crmCustomer.customerStatus == 1}'>text-success</c:if><c:if test='${crmCustomer.customerStatus == 2}'>text-info</c:if><c:if test='${crmCustomer.customerStatus == 3}'>text-danger</c:if>">
													${fns:getDictLabel(crmCustomer.customerStatus, 'customer_status', '')}
												</span>
											</td>
											<td>
												<fmt:formatDate value="${crmCustomer.nextcontactDate}" type="both" dateStyle="long" pattern="yyyy-MM-dd" var="trainDate"/>   
												<c:if test="${not empty crmCustomer.nextcontactDate && nowDate == trainDate}" var="rs">  
													<span class="text-danger"><fmt:formatDate value="${crmCustomer.nextcontactDate}" pattern="yyyy-MM-dd"/></span>  
												</c:if>  
												<c:if test="${!rs}">  
													<fmt:formatDate value="${crmCustomer.nextcontactDate}" pattern="yyyy-MM-dd"/> 
												</c:if>
											</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
							</div>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="ibox float-e-margins">
						<div class="ibox-title">
							<h5>待联系商机</h5>
							<div class="ibox-tools">
		                        <a class="" href="${ctx}/crm/crmChance">
		                            <i class="fa fa-chevron-right"></i>
		                        </a>
		                    </div>
						</div>
						<div class="ibox-content  ">
							<div class="table-responsive">
							<table id="contentTable" class="table ">
								<thead>
									<tr>
										<th>商机名称</th>
										<th width="100px">销售阶段</th>
										<th width="100px">联系日期</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${contactChancePage.list }" var="crmChance" varStatus="status">
										<tr>
											<td>
												<a href="${ctx}/crm/crmChance/index?id=${crmChance.id}" title="查看">
													${crmChance.name}
											</td>
											<td>
												${fns:getDictLabel(crmChance.periodType, 'period_type', '')}
											</td>
											<td>
												<fmt:formatDate value="${crmChance.nextcontactDate}" type="both" dateStyle="long" pattern="yyyy-MM-dd" var="trainDate"/>   
												<c:if test="${not empty crmChance.nextcontactDate && nowDate == trainDate}" var="rs">  
													<span class="text-danger"><fmt:formatDate value="${crmChance.nextcontactDate}" pattern="yyyy-MM-dd"/></span>  
												</c:if>  
												<c:if test="${!rs}">  
													<fmt:formatDate value="${crmChance.nextcontactDate}" pattern="yyyy-MM-dd"/> 
												</c:if>
											</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
							</div>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="ibox float-e-margins">
						<div class="ibox-title">
							<h5>待办订单</h5>
							<div class="ibox-tools">
		                        <a class="" href="${ctx}/om/omContract?status=0">
		                            <i class="fa fa-chevron-right"></i>
		                        </a>
		                    </div>
						</div>
						<div class="ibox-content  ">
							<div class="table-responsive">
							<table id="contentTable" class="table ">
								<thead>
									<tr>
										<th>订单名称</th>
										<th width="100px">订单金额</th>
										<th width="100px">负责人</th>
										<th width="100px">状态</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${omContractPage.list }" var="omContract" varStatus="status">
										<tr>
											<td>
												<a href="${ctx}/om/omContract/index?id=${omContract.id}" title="查看">
													${omContract.name}
											</td>
											<td>
												${omContract.amount}
											</td>
											<td>
												${omContract.ownBy.name}
											</td>
											<td>
												<span class="<c:if test='${omContract.status == 0}'>text-danger</c:if>">
													${fns:getDictLabel(omContract.status, 'audit_status', '')}
												</span>
											</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
							</div>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="ibox float-e-margins">
						<div class="ibox-title">
							<h5>待办应收</h5>
							<div class="ibox-tools">
		                        <a class="" href="${ctx}/fi/fiReceiveAble?status=0&ownBy.id=${fns:getUser().id}">
		                            <i class="fa fa-chevron-right"></i>
		                        </a>
		                    </div>
						</div>
						<div class="ibox-content  ">
							<div class="table-responsive">
							<table id="contentTable" class="table ">
								<thead>
									<tr>
										<th>应收金额</th>
										<th width="100px">应收日期</th>
										<th width="100px">负责人</th>
										<th width="100px">状态</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${fiReceiveAblePage.list }" var="fiReceiveAble" varStatus="status">
										<tr>
											<td>
												<a href="${ctx}/fi/fiReceiveAble/index?id=${fiReceiveAble.id}" title="查看">
													${fiReceiveAble.amount}
											</td>
											<td>
												<fmt:formatDate value="${fiReceiveAble.ableDate}" pattern="yyyy-MM-dd"/> 
											</td>
											<td>
												${fiReceiveAble.ownBy.name}
											</td>
											<td>
												${fns:getDictLabel(fiReceiveAble.status, 'finish_status', '')}
											</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="col-sm-2">
				<div class="ibox float-e-margins">
                    <div class="ibox-title">
                        <h5>最近浏览</h5>
                        <div class="ibox-tools">
                            
                    	</div>
                    </div>                    
                   <div class="ibox-content nopadding">
                   		<ul class="list-group">
                    	    <c:forEach items="${browseLogPage.list }" var="browseLog">   
                    		<li class="list-group-item" >                                	
                                <div class="agile-detail">
                                	<a href="${ctx}/crm/crmCustomer/index?id=${browseLog.targetId}" class="block-link">${browseLog.targetName }</a>                                  	
                                </div>
                            </li>
                            </c:forEach>                 	
                        </ul>
                    </div>
                </div>
			</div>
		</div>
		
       

        
        
    </div>
</body>
</html>