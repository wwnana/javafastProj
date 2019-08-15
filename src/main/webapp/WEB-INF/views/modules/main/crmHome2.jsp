<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<jsp:useBean id="now" class="java.util.Date" />
<html>
<head>
	<title>主页</title>
	<meta name="decorator" content="default"/>    
	<link href="${ctxStatic}/hplus/css/calendar.css" rel="stylesheet">
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
</head>

<body class="gray-bg">
	
    <div class="wrapper-content">
		<sys:message content="${message}"/>
        <div class="row">
        	
            <div class="col-sm-9">
            
            	<div class="ibox float-e-margins">
                    <div class="ibox-title">                        
                        <h5>本月个人业绩（${fn:substring(fns:getBeginDayOfMonthStr(),0,10)} ~ ${fn:substring(fns:getEndDayOfMonthStr(),0,10)}）</h5>
                        <span class="label label-primary pull-right">当月</span>
                    </div>
                    <div class="ibox-content">
                    	<div class="row text-center">
	                    	<div class="col-sm-2">
	                    		 <button type="button" class="btn btn-info btn-circle m-r-sm" onclick="javascript:window.location.href='${ctx}/crm/crmCustomer/list?createBy.id=${fns:getUser().id}&beginEntryDate=${fns:getBeginDayOfMonthStr()}&endEntryDate=${fns:getEndDayOfMonthStr()}&status=0'"><i class="fa fa-user"></i></button>
			                     	<br>添加客户数：${myCrmReport.createNum }
	                    	</div>
	                    	<div class="col-sm-2">
	                    		<button type="button" class="btn btn-success btn-circle m-r-sm" onclick="javascript:window.location.href='${ctx}/crm/crmCustomer/list?ownBy.id=${fns:getUser().id}&beginEntryDate=${fns:getBeginDayOfMonthStr()}&endEntryDate=${fns:getEndDayOfMonthStr()}&status=0'"><i class="fa fa-send-o"></i></button>
			                       	 <br>负责客户数：${myCrmReport.ownNum }
	                    	</div>
	                    	<div class="col-sm-2">
	                    		 <button type="button" class="btn btn-success btn-circle m-r-sm" onclick="javascript:window.location.href='${ctx}/crm/crmChance/list?createBy.id=${fns:getUser().id}&beginRegularDate=${fns:getBeginDayOfMonthStr()}&endRegularDate=${fns:getEndDayOfMonthStr()}&regularStatus=1&status=0'"><i class="fa fa-file-o"></i></button>
			                    	<br>添加商机数：${myCrmReport.createChangeNum }
	                    	</div>
			                <div class="col-sm-2">
	                    		 <button type="button" class="btn btn-danger btn-circle m-r-sm" onclick="javascript:window.location.href='${ctx}/crm/crmChance/list?ownBy.id=${fns:getUser().id}&beginContractEndDate=${fns:getBeginDayOfMonthStr()}&endContractEndDate=${fns:getEndDayOfMonthStr()}'"><i class="fa fa-check"></i></button>
			                      	<br>负责商机数：${myCrmReport.ownChangeNum }
	                    	</div>     
			                <div class="col-sm-2">
	                    		 <button type="button" class="btn btn-success btn-circle m-r-sm" onclick="javascript:window.location.href='${ctx}/om/omContract/list?ownBy.id=${fns:getUser().id}&status=2&beginChangeDate=${fns:getBeginDayOfMonthStr()}&endChangeDate=${fns:getEndDayOfMonthStr()}'"><i class="fa fa-strikethrough"></i></button>
			                     	<br>签单总额：$${myCrmReport.createOrderAmt }
	                    	</div>
	                    	<div class="col-sm-2">
	                    		 <button type="button" class="btn btn-warning btn-circle m-r-sm" onclick="javascript:window.location.href='${ctx}/om/omOrder/list?ownBy.id=${fns:getUser().id}&status=2&beginQuitDate=${fns:getBeginDayOfMonthStr()}&endQuitDate=${fns:getEndDayOfMonthStr()}'"><i class="fa fa-fire"></i></button>
			                     	<br>回款总额：$${myCrmReport.recOrderAmt }
	                    	</div>    
                    	</div>
                    </div>
                </div>
	        	
	        	<div class="ibox float-e-margins hide">
                    <div class="ibox-title">
                        <h5>数据总览(个人)</h5>
                        <span class="label label-primary pull-right">当月</span>
                    </div>
                    <div class="ibox-content">
                    	<div class="row row-sm text-center">
                            <div class="col-xs-2">
                                <div class="panel padder-v item ">
                                    <div class="h3 text-info font-thin h1">${myCrmReport.createNum }</div>
                                    <span class="text-xs">添加客户数</span>
                                    <%-- <i class="fa fa-level-up text-info"></i>--%>
                                </div>
                            </div>
                            <div class="col-xs-2">
                                <div class="panel padder-v item ">
                                    <div class="h3 text-info font-thin h1">${myCrmReport.ownNum }</div>
                                    <span class="text-xs">负责客户数</span>
                                </div>
                            </div>
                            <div class="col-xs-2">
                                <div class="panel padder-v item ">
                                    <div class="h3 text-info font-thin h1">${myCrmReport.createChangeNum }</div>
                                    <span class="text-xs">添加商机数</span>
                                </div>
                            </div>
                            <div class="col-xs-2">
                                <div class="panel padder-v item ">
                                    <div class="h3 text-info font-thin h1">${myCrmReport.ownChangeNum }</div>
                                    <span class="text-xs">负责商机数</span>
                                </div>
                            </div>
                            <div class="col-xs-2">
                                <div class="panel padder-v item ">
                                    <div class="h3 text-info font-thin h1">$${myCrmReport.createOrderAmt }</div>
                                    <span class="text-xs">签单总额</span>
                                </div>
                            </div>
                            <div class="col-xs-2">
                                <div class="panel padder-v item">
                                    <div class="text-info font-thin h3">$${myCrmReport.recOrderAmt }</div>
                                    <span class="text-xs">回款总额</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
        		<div class="ibox float-e-margins">
                    <div class="ibox-title">
                        <h5><a href="${ctx}/crm/crmContactRecord/?status=0" class="h5">待办拜访</a></h5>
                        <div class="ibox-tools">
	                        <a class="collapse-link">
	                            <i class="fa fa-chevron-up"></i>
	                        </a>
	                        <a class="" href="${ctx}/crm/crmContactRecord/form" title="添加待办拜访">
	                            <i class="fa fa-plus"></i>
	                        </a>
	                    </div>
                    </div>                    
                   <div class="ibox-content">
                   		<c:if test="${fn:length(crmContactRecordList.list) == 0}">
                   			<p>对不起，没有任何数据噢！<a class="" href="${ctx}/crm/crmContactRecord/form">创建拜访提醒</a></p>
                   		</c:if>
                   		<c:forEach items="${crmContactRecordList.list }" var="crmContactRecord" varStatus="status">
                   		<div class="search-result">
	                   		<div class="row">
		                   		<div class="col-sm-9">
		                            <h4><a href="${ctx}/crm/crmContactRecord/form?id=${crmContactRecord.id}">${crmContactRecord.content}</a></h4>
		                            <p>
		                                <a href="${ctx}/crm/crmCustomer/index?id=${crmContactRecord.customer.id}">${crmContactRecord.customer.name}</a>
		                            </p>
		                            <div class="forum-sub-title">
		                            	拜访日期：<fmt:formatDate value="${crmContactRecord.contactDate}" pattern="yyyy-MM-dd"/>
		                            	
		                            	     
										<fmt:formatDate value="${now}" type="both" dateStyle="long" pattern="yyyy-MM-dd" var="nowDate"/>
		                            	<fmt:formatDate value="${crmContactRecord.contactDate}" type="both" dateStyle="long" pattern="yyyy-MM-dd" var="contactDate"/>   
										<c:if test="${nowDate gt contactDate}" var="rs">
											<span class="badge badge-danger">超期</span>  
										</c:if>  
										<c:if test="${nowDate == contactDate}">
											<span class="badge badge-warning">今日到期</span>  
										</c:if>
		                            </div>
		                        </div>
		                        <div class="col-sm-3 text-right">
		                            <a href="${ctx}/crm/crmContactRecord/form?id=${crmContactRecord.id}" class="btn btn-xs btn-warning">延期</a>
		                            <a href="${ctx}/crm/crmContactRecord/form?id=${crmContactRecord.id}" class="btn btn-xs btn-info">完成</a>
		                            <a href="${ctx}/crm/crmContactRecord/delete?id=${crmContactRecord.id}" onclick="return confirmx('确认要删除该跟进记录吗？', this.href)" class="btn btn-xs btn-danger"><i class="fa fa-remove"></i></a>
		                        </div>
	                        </div>
                        </div>
                        <c:if test="${fn:length(crmContactRecordList.list) != status.index+1}">
                        <div class="hr-line-dashed"></div>
                        </c:if>
                        </c:forEach>
                    </div>
                </div>
                
                <div class="ibox float-e-margins">
                    <div class="ibox-title">
                        <h5><a href="${ctx}/crm/crmQuote/?status=0" class="h5">待办报价单</a></h5>
                        <div class="ibox-tools">
	                        <a class="collapse-link">
	                            <i class="fa fa-chevron-up"></i>
	                        </a>
	                        <a class="" href="${ctx}/crm/crmQuote/form" title="添加报价单">
	                            <i class="fa fa-plus"></i>
	                        </a>
	                    </div>
                    </div>                    
                   <div class="ibox-content">
                   		<c:if test="${fn:length(crmQuotePage.list) == 0}">
                   			<p>对不起，没有任何数据噢！<a class="" href="${ctx}/crm/crmQuote/form">创建报价单</a></p>
                   		</c:if>
                   		<c:forEach items="${crmQuotePage.list }" var="crmQuote" varStatus="status">
                   		<div class="search-result">
	                   		<div class="row">
		                   		<div class="col-sm-9">
		                            <h4><a href="${ctx}/crm/crmQuote/form?id=${crmQuote.id}">单号：${crmQuote.no}，总额：${crmQuote.amount}</a></h4>
		                            <p>
		                                <a href="${ctx}/crm/crmCustomer/index?id=${crmQuote.customer.id}">${crmQuote.customer.name}</a>
		                            </p>
		                            <div class="forum-sub-title">
		                            	报价日期：<fmt:formatDate value="${crmQuote.startdate}" pattern="yyyy-MM-dd"/>，
		                            	销售负责人：${crmQuote.ownBy.name }，
		                            	截止日期：<fmt:formatDate value="${crmQuote.enddate}" pattern="yyyy-MM-dd"/>
		                            	<fmt:formatDate value="${now}" type="both" dateStyle="long" pattern="yyyy-MM-dd" var="nowDate"/>
		                            	<fmt:formatDate value="${crmQuote.enddate}" type="both" dateStyle="long" pattern="yyyy-MM-dd" var="endQuoteDate"/>   
										<c:if test="${nowDate gt endQuoteDate}" var="rs2">
											<span class="badge badge-danger">超期</span>  
										</c:if>  
										<c:if test="${nowDate == endQuoteDate}">
											<span class="badge badge-warning">今日到期</span>  
										</c:if>
		                            </div>
		                        </div>
		                        <div class="col-sm-3 text-right">
		                            <a href="${ctx}/crm/crmQuote/form?id=${crmQuote.id}" class="btn btn-xs btn-warning">延期</a>
		                            <a href="${ctx}/crm/crmQuote/form?id=${crmQuote.id}" class="btn btn-xs btn-info">完成</a>
		                            <a href="${ctx}/crm/crmQuote/delete?id=${crmQuote.id}" onclick="return confirmx('确认要删除该报价单吗？', this.href)" class="btn btn-xs btn-danger"><i class="fa fa-remove"></i></a>
		                        </div>
	                        </div>
                        </div>
                        <c:if test="${fn:length(crmQuotePage.list) != status.index+1}">
                        <div class="hr-line-dashed"></div>
                        </c:if>
                        </c:forEach>
                    </div>
                </div>
                
                <div class="ibox float-e-margins">
                    <div class="ibox-title">
                        <h5><a href="${ctx}/om/omContract/?status=0" class="h5">待办合同订单</a></h5>
                        <div class="ibox-tools">
	                        <a class="collapse-link">
	                            <i class="fa fa-chevron-up"></i>
	                        </a>
	                        <a class="" href="${ctx}/om/omContract/form" title="添加合同订单">
	                            <i class="fa fa-plus"></i>
	                        </a>
	                    </div>
                    </div>                    
                   <div class="ibox-content">
                   		<c:if test="${fn:length(omContractPage.list) == 0}">
                   			<p>对不起，没有任何数据噢！<a class="" href="${ctx}/om/omContract/form">创建合同订单</a></p>
                   		</c:if>
                   		<c:forEach items="${omContractPage.list }" var="omContract" varStatus="status">
                   		<div class="search-result">
	                   		<div class="row">
		                   		<div class="col-sm-9">
		                            <h4><a href="${ctx}/om/omContract/form?id=${omContract.id}">单号：${omContract.no}，标题：${omContract.name}，总额：${omContract.amount}</a></h4>
		                            <p>
		                                <a href="${ctx}/crm/crmCustomer/index?id=${omContract.customer.id}">${omContract.customer.name}</a>
		                            </p>
		                            <div class="forum-sub-title">
		                            	业务日期：<fmt:formatDate value="${omContract.dealDate}" pattern="yyyy-MM-dd"/>，
		                            	销售负责人：${omContract.ownBy.name }
		                            </div>
		                        </div>
		                        <div class="col-sm-3 text-right">
		                            <a href="${ctx}/om/omContract/form?id=${omContract.id}" class="btn btn-xs btn-warning">延期</a>
		                            <a href="${ctx}/om/omContract/form?id=${omContract.id}" class="btn btn-xs btn-info">完成</a>
		                            <a href="${ctx}/om/omContract/delete?id=${omContract.id}" onclick="return confirmx('确认要删除该报价单吗？', this.href)" class="btn btn-xs btn-danger"><i class="fa fa-remove"></i></a>
		                        </div>
	                        </div>
                        </div>
                        <c:if test="${fn:length(omContractPage.list) != status.index+1}">
                        <div class="hr-line-dashed"></div>
                        </c:if>
                        </c:forEach>
                    </div>
                </div>

            	
            </div>
            
            <div class="col-sm-3">
                <div class="ibox float-e-margins">
                    <div class="ibox-title">                        
                        <h5>业务总览(个人)</h5>
                    </div>
                    <div class="ibox-content">
                    	
                    	<div class="form-group">
                    		 <button type="button" class="btn btn-info btn-circle m-r-sm" onclick="javascript:window.location.href='${ctx}/crm/crmCustomer/list?ownBy.id=${fns:getUser().id}'"><i class="fa fa-user"></i></button>
		                     	我负责 ${customerCount } 个客户
                    	</div>
                    	<div class="form-group">
                    		<button type="button" class="btn btn-success btn-circle m-r-sm" onclick="javascript:window.location.href='${ctx}/crm/crmChance/list?ownBy.id=${fns:getUser().id}'"><i class="fa fa-send-o"></i></button>
		                    	 我负责${chanceCount } 个商机
                    	</div>
                    	<div class="form-group">
                    		 <button type="button" class="btn btn-success btn-circle m-r-sm" onclick="javascript:window.location.href='${ctx }/crm/crmQuote/list?ownBy.id=${fns:getUser().id}'"><i class="fa fa-file-o"></i></button>
		                    	我负责${quoteCount } 个报价单
                    	</div>
		                <div class="form-group">
                    		 <button type="button" class="btn btn-danger btn-circle m-r-sm" onclick="javascript:window.location.href='${ctx }/om/omContract/list?ownBy.id=${fns:getUser().id}'"><i class="fa fa-file-text"></i></button>
		                      	我负责${contractCount } 个订单
                    	</div>     
		                <div class="form-group">
                    		 <button type="button" class="btn btn-success btn-circle m-r-sm" onclick="javascript:window.location.href='${ctx}/fi/fiReceiveAble/list?ownBy.id=${fns:getUser().id}'"><i class="fa fa-strikethrough"></i></button>
		                     	我负责${receiveAbleCount } 个应收款
                    	</div>    
                    </div>
                </div>
                <div class="ibox float-e-margins">
                    <div class="ibox-title">                        
                        <h5><a href="${ctx}/crm/crmChance" class="h5">阶段分析(个人)</a></h5>
                        <div class="ibox-tools">
                            <span class="label label-primary pull-right">当月</span>
                    	</div>
                    </div>
                    <div class="ibox-content no-padding">
                        <ul class="list-group">
                            <li class="list-group-item">
                                <a href="${ctx}/crm/crmChance?periodType=1" class="badge <c:if test='${myCrmReport.purposeCustomerNum > 0}'>badge-warning</c:if> ">${myCrmReport.purposeCustomerNum }</a> 初步恰接
                            </li>
                            <li class="list-group-item ">
                                <a href="${ctx}/crm/crmChance?periodType=2" class="badge <c:if test='${myCrmReport.demandCustomerNum > 0}'>badge-warning</c:if> ">${myCrmReport.demandCustomerNum }</a> 需求确定
                            </li>
                            <li class="list-group-item">
                                <a href="${ctx}/crm/crmChance?periodType=3" class="badge <c:if test='${myCrmReport.quoteCustomerNum > 0}'>badge-warning</c:if> ">${myCrmReport.quoteCustomerNum }</a> 方案报价
                            </li>
                            <li class="list-group-item">
                                <a href="${ctx}/crm/crmChance?periodType=4" class="badge <c:if test='${myCrmReport.dealOrderNum > 0}'>badge-warning</c:if> ">${myCrmReport.dealOrderNum }</a> 签定合同
                            </li>
                            <li class="list-group-item">
                                <a href="${ctx}/crm/crmChance?periodType=5" class="badge <c:if test='${myCrmReport.completeOrderNum > 0}'>badge-warning</c:if> ">${myCrmReport.completeOrderNum }</a> 销售回款
                            </li>
                        </ul>
                    </div>
                </div>
                <div class="ibox float-e-margins">
                    <div class="ibox-title">                        
                        <h5>客户提醒(个人)</h5>
                        <div class="ibox-tools">
                            <span class="label label-primary pull-right">当日</span>
                    	</div>
                    </div>
                    <div class="ibox-content no-padding">
                        <ul class="list-group">
                           
                            <li class="list-group-item ">
                                <a href="${ctx}/crm/crmContactRecord??contactDate=${fns:getDate('yyyy-MM-dd')}" class="badge <c:if test='${myCrmReport.dayContactCustomerNum > 0}'>badge-warning</c:if> ">${myCrmReport.dayContactCustomerNum }</a> 今日联系
                            </li>
                            <li class="list-group-item">
                                <a href="${ctx}/crm/crmCustomer/list?beginCreateDate=${fns:getDate('yyyy-MM-dd')}&endCreateDate=${fns:getDayAfter(1)}" class="badge <c:if test='${myCrmReport.dayCreateCustomerNum > 0}'>badge-warning</c:if> ">${myCrmReport.dayCreateCustomerNum }</a> 今日创建
                            </li>
                        </ul>
                    </div>
                </div>
                
                
             
               <div class="ibox float-e-margins">
                    <div class="ibox-title">
                        <h5>最近浏览</h5>
                        <div class="ibox-tools">
                            
                    	</div>
                    </div>                    
                   <div class="ibox-content no-padding">
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