<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<jsp:useBean id="now" class="java.util.Date" />
<html>
<head>
	<title>HR主页</title>
	<meta name="decorator" content="default"/>    
	<link href="${ctxStatic}/hplus/css/calendar.css" rel="stylesheet">
    <script type="text/javascript">

    </script>
</head>

<body class="gray-bg">
	
    <div class="wrapper-content">
		<sys:message content="${message}"/>
        <div class="row">
        	
            <div class="col-sm-9">
	        	
	        	<div class="ibox float-e-margins">
                    <div class="ibox-title">                        
                        <h5>本月（${fn:substring(fns:getBeginDayOfMonthStr(),0,10)} ~ ${fn:substring(fns:getEndDayOfMonthStr(),0,10)}）</h5>
                        <span class="label label-primary pull-right">当月</span>
                    </div>
                    <div class="ibox-content">
                    	<div class="row">
	                    	<div class="col-sm-2">
	                    		 <button type="button" class="btn btn-info btn-circle m-r-sm" onclick="javascript:window.location.href='${ctx}/hr/hrEmployee/list?status=0'"><i class="fa fa-user"></i></button>
			                     	在职：${hrReport.jobNum }
	                    	</div>
	                    	<div class="col-sm-2">
	                    		<button type="button" class="btn btn-success btn-circle m-r-sm" onclick="javascript:window.location.href='${ctx}/hr/hrEmployee/list?beginEntryDate=${fns:getBeginDayOfMonthStr()}&endEntryDate=${fns:getEndDayOfMonthStr()}&status=0'"><i class="fa fa-send-o"></i></button>
			                       	 入职：${hrReport.entryNum }
	                    	</div>
	                    	<div class="col-sm-2">
	                    		 <button type="button" class="btn btn-success btn-circle m-r-sm" onclick="javascript:window.location.href='${ctx}/hr/hrEmployee/list?beginRegularDate=${fns:getBeginDayOfMonthStr()}&endRegularDate=${fns:getEndDayOfMonthStr()}&regularStatus=1&status=0'"><i class="fa fa-file-o"></i></button>
			                    	转正：${hrReport.regularNum }
	                    	</div>
			                <div class="col-sm-2">
	                    		 <button type="button" class="btn btn-danger btn-circle m-r-sm" onclick="javascript:window.location.href='${ctx}/hr/hrEmployee/list?beginContractEndDate=${fns:getBeginDayOfMonthStr()}&endContractEndDate=${fns:getEndDayOfMonthStr()}'"><i class="fa fa-file-text"></i></button>
			                      	到期：${hrReport.expireNum }
	                    	</div>     
			                <div class="col-sm-2">
	                    		 <button type="button" class="btn btn-success btn-circle m-r-sm" onclick="javascript:window.location.href='${ctx}/hr/hrPositionChange/list?beginChangeDate=${fns:getBeginDayOfMonthStr()}&endChangeDate=${fns:getEndDayOfMonthStr()}'"><i class="fa fa-share-alt"></i></button>
			                     	调岗：${hrReport.changeNum }
	                    	</div>
	                    	<div class="col-sm-2">
	                    		 <button type="button" class="btn btn-warning btn-circle m-r-sm" onclick="javascript:window.location.href='${ctx}/hr/hrQuit/list?beginQuitDate=${fns:getBeginDayOfMonthStr()}&endQuitDate=${fns:getEndDayOfMonthStr()}&status=1'"><i class="fa fa-user-times"></i></button>
			                     	离职：${hrReport.quitNum }
	                    	</div>    
                    	</div>
                    </div>
                </div>
                
        		<div class="ibox float-e-margins">
                    <div class="ibox-title">
                        <h5><a href="${ctx}/hr/hrResume/list?currentNode=1" class="h5">本周面试安排</a></h5>
                        <div class="ibox-tools">
	                        <a class="collapse-link">
	                            <i class="fa fa-chevron-up"></i>
	                        </a>
	                        <a class="" href="${ctx}/hr/hrResume/list" title="添加面试">
	                            <i class="fa fa-plus"></i>
	                        </a>
	                    </div>
                    </div>                    
                   <div class="ibox-content">
                   		<c:if test="${fn:length(hrInterviewPage.list) == 0}">
                   			<p>对不起，没有任何数据噢！<a class="" href="${ctx}/hr/hrResume/list">创建面试安排</a></p>
                   		</c:if>
                   		<c:forEach items="${hrInterviewPage.list }" var="hrInterview" varStatus="status">
                   		<div class="search-result">
	                   		<div class="row">
		                   		<div class="col-sm-9">
		                            <h4><a href="${ctx}/hr/hrResume/index?id=${hrInterview.hrResume.id}">${hrInterview.hrResume.name}/${hrInterview.hrResume.mobile}</a></h4>
		                            <p>
		                                <a href="${ctx}/hr/hrResume/index?id=${hrInterview.hrResume.id}">应聘岗位：${hrInterview.position}， 面试官：${hrInterview.interviewBy.name}</a>
		                            </p>
		                            <div class="forum-sub-title">
		                            	
		                            	<c:if test="${hrInterview.status == 0}">未反馈</c:if><c:if test="${hrInterview.status == 1}">已反馈</c:if> | 
		                            	${fns:getDictLabel(hrInterview.inviteStatus, 'invite_status', '')} | 
		                            	
		                            	面试时间：<fmt:formatDate value="${hrInterview.interviewDate}" pattern="yyyy-MM-dd HH:mm"/>
		                            	     
										<fmt:formatDate value="${now}" type="both" dateStyle="long" pattern="yyyy-MM-dd" var="nowDate"/>
		                            	<fmt:formatDate value="${hrInterview.interviewDate}" type="both" dateStyle="long" pattern="yyyy-MM-dd" var="interviewDate"/>   
										<c:if test="${nowDate gt interviewDate}" var="rs">
											<span class="badge badge-danger">超期</span>  
										</c:if>  
										<c:if test="${nowDate == interviewDate}">
											<span class="badge badge-warning">今日</span>  
										</c:if>
		                            </div>
		                        </div>
		                        <div class="col-sm-3 text-right"><br><br>
		                            <a href="${ctx}/hr/hrInterview/form?id=${hrInterview.id}&hrResume.id=${hrInterview.hrResume.id}" class="btn btn-xs btn-warning">变更</a>
		                            <a href="${ctx}/hr/hrInterview/form?id=${hrInterview.id}" class="btn btn-xs btn-info">反馈</a>
		                            <a href="${ctx}/hr/hrInterview/delete?id=${crmContactRecord.id}" onclick="return confirmx('确认要撤销该面试吗？', this.href)" class="btn btn-xs btn-danger"><i class="fa fa-remove"></i></a>
		                        </div>
	                        </div>
                        </div>
                        <c:if test="${fn:length(hrInterviewPage.list) != status.index+1}">
                        <div class="hr-line-dashed"></div>
                        </c:if>
                        </c:forEach>
                    </div>
                </div>
                
                <div class="ibox float-e-margins">
                    <div class="ibox-title">
                        <h5><a href="${ctx}/hr/hrResume/list?currentNode=2" class="h5">本周入职OFFER</a></h5>
                        <div class="ibox-tools">
	                        <a class="collapse-link">
	                            <i class="fa fa-chevron-up"></i>
	                        </a>
	                        <a class="" href="${ctx}/hr/hrResume/list" title="创建新入职">
	                            <i class="fa fa-plus"></i>
	                        </a>
	                    </div>
                    </div>                    
                   <div class="ibox-content">
                   		<c:if test="${fn:length(hrOfferPage.list) == 0}">
                   			<p>对不起，没有任何数据噢！<a class="" href="${ctx}/hr/hrResume/list">创建新OFFER</a></p>
                   		</c:if>
                   		<c:forEach items="${hrOfferPage.list }" var="hrOffer" varStatus="status">
                   		<div class="search-result">
	                   		<div class="row">
		                   		<div class="col-sm-9">
		                            <h4><a href="${ctx}/hr/hrResume/index?id=${hrOffer.hrResume.id}">${hrOffer.hrResume.name}/${hrOffer.hrResume.mobile}</a></h4>
		                            <p>
		                                <a href="${ctx}/hr/hrResume/index?id=${hrOffer.hrResume.id}">入职部门：${hrOffer.department} ，聘用岗位：${hrOffer.position}</a>
		                            </p>
		                            <div class="forum-sub-title">
		                            	${fns:getDictLabel(hrOffer.status, 'invite_status', '')} | 
		                            	报到时间：<fmt:formatDate value="${hrOffer.reportDate}" pattern="yyyy-MM-dd"/>
		                            	     
										<fmt:formatDate value="${now}" type="both" dateStyle="long" pattern="yyyy-MM-dd" var="nowDate"/>
		                            	<fmt:formatDate value="${hrOffer.reportDate}" type="both" dateStyle="long" pattern="yyyy-MM-dd" var="interviewDate"/>   
										<c:if test="${nowDate gt reportDate}" var="rs">
											<span class="badge badge-danger">超期</span>  
										</c:if>  
										<c:if test="${nowDate == reportDate}">
											<span class="badge badge-warning">今日到期</span>  
										</c:if>
		                            </div>
		                        </div>
		                        <div class="col-sm-3 text-right"><br><br>
		                            <a href="${ctx}/hr/hrOffer/form?id=${hrOffer.id}&hrResume.id=${hrOffer.hrResume.id}" class="btn btn-xs btn-warning">重发</a>
		                            <a href="${ctx}/hr/hrEmployee/entryForm?hrResume.id=${hrOffer.hrResume.id}" class="btn btn-xs btn-info">入职</a>
		                            <a href="${ctx}/hr/hrOffer/delete?id=${hrOffer.id}" onclick="return confirmx('确认要撤销该OFFER吗？', this.href)" class="btn btn-xs btn-danger"><i class="fa fa-remove"></i></a>
		                        </div>
	                        </div>
                        </div>
                        <c:if test="${fn:length(hrOfferPage.list) != status.index+1}">
                        <div class="hr-line-dashed"></div>
                        </c:if>
                        </c:forEach>
                    </div>
                </div>
                

            	
            </div>
            
            <div class="col-sm-3">
                
                <div class="ibox float-e-margins">
                    <div class="ibox-title">                        
                        <h5><a href="${ctx}/crm/crmChance" class="h5">最近入职员工</a></h5>
                        <div class="ibox-tools">
                            <span class="label label-primary pull-right">本月</span>
                    	</div>
                    </div>
                    <div class="ibox-content no-padding">
                        <ul class="list-group">
                        	<c:forEach items="${hrEmployeePage.list }" var="hrEmployee" varStatus="status">
                            <li class="list-group-item">
                               	${hrEmployee.name }
                            </li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>
                <div class="ibox float-e-margins">
                    <div class="ibox-title">                        
                        <h5>合同到期提醒</h5>
                        <div class="ibox-tools">
                            <span class="label label-primary pull-right">本月</span>
                    	</div>
                    </div>
                    <div class="ibox-content no-padding">
                        <ul class="list-group">
                            <c:forEach items="${contractExpireEmployeePage.list }" var="hrEmployee" varStatus="status">
                            <li class="list-group-item">
                               	${hrEmployee.name }
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