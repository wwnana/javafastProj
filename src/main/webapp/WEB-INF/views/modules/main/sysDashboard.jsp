<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<jsp:useBean id="now" class="java.util.Date" />
<html>
<head>
	<title>主页</title>
	<meta name="decorator" content="default"/>    
	<link href="${ctxStatic}/hplus/css/calendar.css" rel="stylesheet">	
    <script type="text/javascript">
    $(document).ready(function() {
   	 	setInterval(function(){$("#currentTime").html(current)},1000);
   		getNotepaper();
    });
    function getNotepaper(){	    	
	    $.ajax({
    		url:"${ctx}/oa/oaNote/getNote",
    		type:"POST",
    		async:true,    //或false,是否异步
    		dataType:'json',
    		success:function(data){	    			
    			if(data != null && data != "false" && data.notes != null){	    				
    				$("#notepaper").val(data.notes);
    			}
    		},
    		error:function(){
    			//alert("出错");
    		}
    	});
    }
    function saveNotepaper(){
    	var notepaper = $("#notepaper").val();
    	$.ajax({
    		url:"${ctx}/oa/oaNote/saveNote",
    		type:"POST",
    		async:true,    //或false,是否异步
    		data:{notes:notepaper},
    		dataType:'json',
    		success:function(data){
    			//alert(data);
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
        		
				<c:if test="${fn:contains(userPanels, '-20-')}">
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
                </c:if>
                
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
                
                <c:if test="${fn:contains(userPanels, '-1-')}">
                <div class="ibox float-e-margins">
                    <div class="ibox-title">
                        <h5>待办提醒</h5>
                        <div class="ibox-tools">
	                        <a class="collapse-link">
	                            <i class="fa fa-chevron-up"></i>
	                        </a>
	                        <a href="#" onclick="openDialog('新建待办提醒', '${ctx}/iim/myCalendar/form','500px', '450px')">
	                            <i class="fa fa-plus"></i>
	                        </a>
	                    </div>
                    </div>                    
                   <div class="ibox-content">
                   		<c:if test="${fn:length(calenderPage.list) == 0}">
                   			<p>对不起，没有任何数据噢！<a href="#" onclick="openDialog('新建待办提醒', '${ctx}/iim/myCalendar/form','500px', '350px')">创建提醒</a></p>
                   		</c:if>
                   		<c:forEach items="${calenderPage.list }" var="myCalendar" varStatus="status">
                   		<div class="search-result">
                   			<div class="row">
		                   		<div class="col-sm-9">
		                            <h4>${myCalendar.title }</h4>
		                            <div class="forum-sub-title">
		                                	提醒时间：${myCalendar.start}<c:if test="${not empty myCalendar.end}"> 至 </c:if>${myCalendar.end}
		                            </div>
		                        </div>
		                        <div class="col-sm-3 text-right">
		                           <a href="${ctx}/iim/myCalendar/delete?id=${myCalendar.id}" onclick="return confirmx('确认要删除该日程吗？', this.href)" class="btn btn-xs btn-danger"><i class="fa fa-remove"></i></a>
		                        </div>
	                        </div>
                        </div>
                        <c:if test="${fn:length(calenderPage.list) != status.index+1}">
                        <div class="hr-line-dashed"></div>
                        </c:if>
                        </c:forEach>
                    </div>
                </div>
                </c:if>
                
                <c:if test="${fn:contains(userPanels, '-5-')}">
                <div class="ibox float-e-margins">
                    <div class="ibox-title">
                        <h5><a href="${ctx}/oa/oaCommonAudit" class="h5">待办审批</a></h5>
                        <div class="ibox-tools">
	                        <a class="collapse-link">
	                            <i class="fa fa-chevron-up"></i>
	                        </a>
	                        <a class="" href="${ctx}/oa/oaCommonAudit/add">
	                            <i class="fa fa-plus"></i>
	                        </a>
	                    </div>
                    </div>                    
                   <div class="ibox-content">
                   		<c:if test="${fn:length(oaCommonAuditPage.list) == 0}">
                   			<p>对不起，没有任何数据噢！<a class="" href="${ctx}/oa/oaCommonAudit/add">创建审批</a></p>
                   		</c:if>
                   		<c:forEach items="${oaCommonAuditPage.list}" var="oaAudit" varStatus="status">
                   		<div class="search-result">
                   			<div class="row">
		                   		<div class="col-sm-9">
		                            <h4><a href="${ctx}/oa/oaCommonAudit/view?id=${oaAudit.id}">${oaAudit.title }</a></h4>
		                            <p class="forum-sub-title">
		                                	${oaAudit.content }
		                            </p>
		                            <div class="forum-sub-title">申请日期：<fmt:formatDate value="${oaAudit.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/></div>
		                        </div>
		                        <div class="col-sm-3 text-right">
		                        <c:if test="${fns:getUser().id == oaAudit.currentBy.id && oaAudit.status == 1}">
		                            <a href="${ctx}/oa/oaCommonAudit/view?id=${oaAudit.id}" class="btn btn-success btn-xs" title="审批">待我审批</a>
		                        </c:if>
		                        
		                        <c:if test="${fns:getUser().id == oaAudit.createBy.id}">
		                        	<a href="${ctx}/oa/oaCommonAudit/view?id=${oaAudit.id}" class="btn btn-info btn-xs" title="审批">我申请的</a>
		                        </c:if>
		                        </div>
	                        </div>
                        </div>
                        <c:if test="${fn:length(oaCommonAuditPage.list) != status.index+1}">
                        <div class="hr-line-dashed"></div>
                        </c:if>
                        </c:forEach>
                    </div>
                </div>
                </c:if>
                
                <c:if test="${fn:contains(userPanels, '-11-')}">
                <div class="ibox float-e-margins">
                    <div class="ibox-title">
                        <h5><a href="${ctx}/oa/oaProject" class="h5">待办项目</a></h5>
                        <div class="ibox-tools">
	                        <a class="collapse-link">
	                            <i class="fa fa-chevron-up"></i>
	                        </a>
	                        <a class="" href="${ctx}/oa/oaProject/form">
	                            <i class="fa fa-plus"></i>
	                        </a>
	                    </div>
                   </div>                    
                   <div class="ibox-content">
                   		<c:if test="${fn:length(projectPage.list) == 0}">
                   			<p>对不起，没有任何数据噢！<a class="" href="${ctx}/oa/oaProject/form">创建项目</a></p>
                   		</c:if>
                   		<c:forEach items="${projectPage.list }" var="project" varStatus="status">
                   		<div class="search-result">
	                   		<div class="row">
		                   		<div class="col-sm-9">
		                            <h4><a href="${ctx}/oa/oaProject/view?id=${project.id}">${project.name }</a></h4>
		                            <p>
		                               
		                            </p>
		                            <div class="forum-sub-title">
		                            	截止日期：<fmt:formatDate value="${project.endDate}" pattern="yyyy-MM-dd"/>
		                            	
		                            	   
										<fmt:formatDate value="${now}" type="both" dateStyle="long" pattern="yyyy-MM-dd" var="nowDate"/>
										<fmt:formatDate value="${project.endDate}" type="both" dateStyle="long" pattern="yyyy-MM-dd" var="trainDate"/>   
										<c:if test="${nowDate gt trainDate}" var="rs">
											<span class="badge badge-danger">超期</span>  
										</c:if>  
										<c:if test="${nowDate == trainDate}">
											<span class="badge badge-warning">今日到期</span>  
										</c:if>
		                            	
		                            </div>
		                        </div>
		                        <div class="col-sm-3 text-right">
		                            <a href="${ctx}/oa/oaProject/form?id=${project.id}" class="btn btn-xs btn-warning">延期</a>
		                            <a href="${ctx}/oa/oaProject/form?id=${project.id}" class="btn btn-xs btn-info">完成</a>
		                            <a href="${ctx}/oa/oaProject/delete?id=${project.id}" onclick="return confirmx('确认要删除该项目吗？', this.href)" class="btn btn-xs btn-danger"><i class="fa fa-remove"></i></a>
		                        </div>
	                        </div>
                        </div>
                        <c:if test="${fn:length(projectPage.list) != status.index+1}">
                        <div class="hr-line-dashed"></div>
                        </c:if>
                        </c:forEach>
                    </div>
                </div>
                </c:if>
                
                <c:if test="${fn:contains(userPanels, '-12-')}">
                <div class="ibox float-e-margins">
                    <div class="ibox-title">
                        <h5><a href="${ctx}/oa/oaTask" class="h5">待办任务</a></h5>
                        <div class="ibox-tools">
	                        <a class="collapse-link">
	                            <i class="fa fa-chevron-up"></i>
	                        </a>
	                        <a class="" href="${ctx}/oa/oaTask/form">
	                            <i class="fa fa-plus"></i>
	                        </a>
	                    </div>
                   </div>                    
                   <div class="ibox-content">
                   		<c:if test="${fn:length(taskPage.list) == 0}">
                   			<p>对不起，没有任何数据噢！<a class="" href="${ctx}/oa/oaTask/form">创建任务</a></p>
                   		</c:if>
                   		<c:forEach items="${taskPage.list }" var="task" varStatus="status">
                   		<div class="search-result">
	                   		<div class="row">
		                   		<div class="col-sm-9">
		                            <h4><a href="${ctx}/oa/oaTask/view?id=${task.id}">${task.name }</a></h4>
		                            <p>
		                               ${fns:abbr(task.content,200)}
		                            </p>
		                            <div class="forum-sub-title">
		                            	截止日期：<fmt:formatDate value="${task.endDate}" pattern="yyyy-MM-dd"/>
		                            	
										<fmt:formatDate value="${now}" type="both" dateStyle="long" pattern="yyyy-MM-dd" var="nowDate"/>
										<fmt:formatDate value="${task.endDate}" type="both" dateStyle="long" pattern="yyyy-MM-dd" var="trainDate"/>   
										<c:if test="${nowDate gt trainDate}" var="rs">
											<span class="badge badge-danger">超期</span>  
										</c:if>  
										<c:if test="${nowDate == trainDate}">
											<span class="badge badge-warning">今日到期</span>  
										</c:if>
		                            	
		                            </div>
		                        </div>
		                        <div class="col-sm-3 text-right">
		                            <a href="${ctx}/oa/oaTask/form?id=${task.id}" class="btn btn-xs btn-warning">延期</a>
		                            <a href="${ctx}/oa/oaTask/form?id=${task.id}" class="btn btn-xs btn-info">完成</a>
		                            <a href="${ctx}/oa/oaTask/delete?id=${task.id}" onclick="return confirmx('确认要删除该任务吗？', this.href)" class="btn btn-xs btn-danger"><i class="fa fa-remove"></i></a>
		                        </div>
	                        </div>
                        </div>
                        <c:if test="${fn:length(taskPage.list) != status.index+1}">
                        <div class="hr-line-dashed"></div>
                        </c:if>
                        </c:forEach>
                    </div>
                </div>
                </c:if>
                
                <c:if test="${fn:contains(userPanels, '-23-')}">
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
                </c:if>
            			
            </div>
            <div class="col-sm-3">
            	
            	
                <div class="ibox float-e-margins hide">
                    <div class="ibox-title">
                        <h5>我的日程</h5>
                        <div class="ibox-tools">
                            <a href="${ctx}/iim/myCalendar" target="mainFrame"><i class="fa fa-chevron-right"></i></a>
                    	</div>
                    </div>                    
                    <div class="ibox-content no-padding" style="height: 350px;">
                    	<iframe class="J_iframe" name="iframe2" id="iframe2" width="100%" height="100%" src="${ctx}/iim/myCalendar/myCalendarView" frameborder="0" data-id="${ctx}/home" seamless></iframe>
                    </div>
                </div>
                
                <c:if test="${fn:contains(userPanels, '-2-')}">
                <div class="ibox float-e-margins">
                    <div class="ibox-title">
                        <h5>我的便笺</h5>
                    </div>
                    <div class="ibox-content no-padding">
                    	<textarea id="notepaper" name="notepaper" maxlength="50" rows="4" cols="" class="form-control" style="border: 0" onblur="saveNotepaper()" placeholder="便签中的内容会存储在本地，这样即便你关掉了浏览器，在下次打开时，依然会读取到上一次的记录。是一个非常方便的备忘小工具。"></textarea>
                    </div>
                </div>
                </c:if>
                
                <c:if test="${fn:contains(userPanels, '-21-')}">
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
                </c:if>
                
                <c:if test="${fn:contains(userPanels, '-22-')}">
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
                                <a href="${ctx}/crm/crmContactRecord??contactDate=${fns:getDate('yyyy-MM-dd')}" class="badge <c:if test='${myCrmReport.dayContactCustomerNum > 0}'>badge-warning</c:if> ">${myCrmReport.dayContactCustomerNum }</a> 今日已联系
                            </li>
                            <li class="list-group-item">
                                <a href="${ctx}/crm/crmCustomer/list?beginCreateDate=${fns:getDate('yyyy-MM-dd')}&endCreateDate=${fns:getDayAfter(1)}" class="badge <c:if test='${myCrmReport.dayCreateCustomerNum > 0}'>badge-warning</c:if> ">${myCrmReport.dayCreateCustomerNum }</a> 今日创建
                            </li>
                        </ul>
                    </div>
                </div>
                </c:if>
                
                <div class="ibox float-e-margins hide">
                    <div class="ibox-title">                        
                        <h5>审批提醒</h5>
                        <div class="ibox-tools">
                            <a href="" target="mainFrame"><i class="fa fa-chevron-right"></i></a>
                    	</div>
                    </div>
                    <div class="ibox-content no-padding">
                        <ul class="list-group">
                            <li class="list-group-item">
                                <span class="badge badge-danger">1</span> 待我审批
                            </li>
                            <li class="list-group-item ">
                                <span class="badge badge-info">6</span> 抄送给我
                            </li>
                            <li class="list-group-item">
                                <span class="badge badge-warning">50</span> 我申请的
                            </li>
                        </ul>
                    </div>
                </div>
                
                
                <div class="ibox float-e-margins hide">
                    <div class="ibox-title">                        
                        <h5>任务提醒</h5>
                        <div class="ibox-tools">
                            <a href="" target="mainFrame"><i class="fa fa-chevron-right"></i></a>
                    	</div>
                    </div>
                    <div class="ibox-content no-padding">
                        <ul class="list-group">
                            <li class="list-group-item">
                                <span class="badge badge-primary">2</span> 我负责的
                            </li>
                            <li class="list-group-item ">
                                <span class="badge badge-success">3</span> 我参与的
                            </li>
                            <li class="list-group-item">
                                <span class="badge badge-info">1</span> 即将到期的
                            </li>
                            <li class="list-group-item">
                                <span class="badge badge-warning">1</span> 已经超期的
                            </li>
                        </ul>
                    </div>
                </div>
                
                <c:if test="${fn:contains(userPanels, '-28-')}">
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
                </c:if>
                
            </div>
            
        </div>
    </div>
</body>
</html>