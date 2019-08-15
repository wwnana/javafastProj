<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<jsp:useBean id="now" class="java.util.Date" />     
<fmt:formatDate value="${now}" type="both" dateStyle="long" pattern="yyyy-MM-dd" var="nowDate"/> 
<html>
<head>
	<title>服务主页</title>
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
			<div class="col-sm-8">
				
				<div class="col-sm-12">
					<div class="ibox">
						<div class="ibox-title">
							<h5>工单简报</h5>
							<div class="ibox-tools">
		                    	<span class="label">${fns:getUser().name}</span>
		                    	<span class="label">个人累计</span>
		                    </div>
						</div>
	                    <div class="ibox-content">
	                        <div class="row">
	                        	<div class="col-sm-6">
					                <div class="ibox ">
					                    <div class="ibox-content gray-bg">
					                        <h5>待处理工单</h5>
					                        <h1 class="no-margins text-success">${unCrmServicePage.count}&nbsp;</h1>
					                        <div class="stat-percent font-bold text-danger"></div>
					                        <small>（个）</small>
					                    </div>
					                </div>
					            </div>
					            <div class="col-sm-6">
					                <div class="ibox">
					                    <div class="ibox-content gray-bg">
					                        <h5>已完成工单</h5>
					                        <h1 class="no-margins text-info">${completedCrmServicePage.count}&nbsp;</h1>
					                        <div class="stat-percent font-bold text-danger"></div>
					                        <small>（个）</small>
					                    </div>
					                </div>
					            </div>
					            
	                        	
	                        </div>
	                    </div>
	                </div>
				</div>
				
            	<div class="col-sm-6">
	        		<div class="ibox">
	                    <div class="ibox-content">
	                        <h3>待处理</h3>
	                        <p class="small"><i class="fa fa-hand-o-up"></i> 待处理的工单</p>
	                        <ul class="sortable-list connectList agile-list ui-sortable">
	                            <c:forEach items="${unCrmServicePage.list}" var="crmService">
	                            <li onclick="location='${ctx}/crm/crmService/index?id=${crmService.id}'" class="<c:if test='${crmService.levelType==0}'>success-element</c:if><c:if test='${crmService.levelType==1}'>warning-element</c:if><c:if test='${crmService.levelType==2}'>danger-element</c:if> ">
	                               ${crmService.name }
	                                <div class="agile-detail">
	                                    <a href="${ctx}/crm/crmService/index?id=${crmService.id}" class="pull-right btn btn-xs btn-white">${fns:getDictLabel(crmService.serviceType, 'service_type', '')}</a>
	                                    <i class="fa fa-clock-o"></i> <fmt:formatDate value="${crmService.createDate}" pattern="yyyy-MM-dd"/>
	                                </div>
	                            </li>
	                            
	                            </c:forEach>
	                           
	                        </ul>
	                    </div>
	                </div>
				</div>
				<div class="col-sm-6">
					<div class="ibox">
	                    <div class="ibox-content">
	                        <h3>已完成</h3>
	                        <p class="small"><i class="fa fa-hand-o-up"></i> 已完成的工单</p>
	                        <ul class="sortable-list connectList agile-list ui-sortable">
	                            <c:forEach items="${completedCrmServicePage.list}" var="crmService">
	                            <li onclick="location='${ctx}/crm/crmService/index?id=${crmService.id}'" class="<c:if test='${crmService.levelType==0}'>success-element</c:if><c:if test='${crmService.levelType==1}'>warning-element</c:if><c:if test='${crmService.levelType==2}'>danger-element</c:if> ">
	                               ${crmService.name }
	                                <div class="agile-detail">
	                                    <a href="${ctx}/crm/crmService/index?id=${crmService.id}" class="pull-right btn btn-xs btn-white">${fns:getDictLabel(crmService.serviceType, 'service_type', '')}</a>
	                                    <i class="fa fa-clock-o"></i> <fmt:formatDate value="${crmService.createDate}" pattern="yyyy-MM-dd"/>
	                                </div>
	                            </li>
	                            
	                            </c:forEach>
	                           
	                        </ul>
	                    </div>
	                </div>
				</div>
				
			</div>
			<div class="col-sm-2">
				
			</div>
		</div>
		
       

        
        
    </div>
</body>
</html>