<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<jsp:useBean id="now" class="java.util.Date" />  
<html>
<head>
	<title>主页</title>
	<meta name="decorator" content="default"/>    
	<link href="${ctxStatic}/hplus/css/calendar.css" rel="stylesheet">
    <script type="text/javascript">
	    function toView(relationType, targetId){
	    	
	    	if(relationType == "0"){//客户    		
	    		window.location.href = "${ctx}/crm/crmCustomer/index?id="+targetId;
	    	}
	    	if(relationType == "1"){
	    		openDialogView("联系人", "${ctx}/crm/crmContacter/view?id="+targetId, '800px', '500px');
	    	}
	    	if(relationType == "3"){
	    		openDialogView("商机", "${ctx}/crm/crmChance/index?id="+targetId, '800px', '500px');
	    	}
	    	if(relationType == "4"){//报价
	    		window.location.href = "${ctx}/crm/crmQuote/view?id="+targetId;
	    	}
	    	if(relationType == "5"){//订单
	    		window.location.href = "${ctx}/om/omContract/index?id="+targetId;
	    	}
	    	if(relationType == "11"){//采购单
	    		window.location.href = "${ctx}/wms/wmsPurchase/view?id="+targetId;
	    	}
	    	if(relationType == "12"){//入库单
	    		window.location.href = "${ctx}/wms/wmsInstock/view?id="+targetId;
	    	}
	    	if(relationType == "13"){//出库单
	    		window.location.href = "${ctx}/wms/wmsOutstock/view?id="+targetId;
	    	}
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
		                                ${task.content }
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
                
                
                
                
        	
            	
            </div>
            <div class="col-sm-3">
                
                <div class="ibox float-e-margins">
                    <div class="ibox-title">                        
                        <h5>项目总览</h5>
                        <div class="ibox-tools">
                            <span class="label label-primary pull-right">个人</span>
                    	</div>
                    </div>
                    <div class="ibox-content">
                    	
                    	<div class="form-group">
                    		<button type="button" class="btn btn-danger btn-circle m-r-sm">${projectCount }</button>
		                    	  总项目数
                    	</div>
                    	<div class="form-group">
                    		<button type="button" class="btn btn-success btn-circle m-r-sm">${ownProjectCount}</button>
		                    	 我负责的
                    	</div>
                    	<div class="form-group">
                    		<button type="button" class="btn btn-info btn-circle m-r-sm">${projectCount - ownProjectCount}</button>
		                    	 我参与的
                    	</div>
                    </div>
                </div>
                <div class="ibox float-e-margins">
                    <div class="ibox-title">                        
                        <h5>任务总览</h5>
                        <div class="ibox-tools">
                            <span class="label label-primary pull-right">个人</span>
                    	</div>
                    </div>
                    <div class="ibox-content">
                    	
                    	<div class="form-group">
                    		<button type="button" class="btn btn-danger btn-circle m-r-sm">${taskCount }</button>
		                    	  总任务数
                    	</div>
                    	<div class="form-group">
                    		<button type="button" class="btn btn-success btn-circle m-r-sm">${ownTaskCount}</button>
		                    	 我负责的
                    	</div>
                    	<div class="form-group">
                    		<button type="button" class="btn btn-info btn-circle m-r-sm">${joinTaskCount }</button>
		                    	 我参与的
                    	</div>
                    </div>
                </div>
            </div>
           
        </div>
    </div>
   
   
</body>
</html>