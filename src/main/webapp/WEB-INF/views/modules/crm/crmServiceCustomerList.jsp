<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>全局搜索</title>
   	<meta name="decorator" content="default"/>
</head>
<body class="gray-bg">
    <div class="wrapper wrapper-content animated fadeInRight">
        <div class="" style="padding-top: 100px;">
        <div class="row">
            <div class="col-sm-3">
            
            </div>
            <div class="col-sm-6">
                <div class="float-e-margins">
                    <div class=" gray-bg">
                    
                    	<div class="text-center">
                    		<button class="btn btn-info btn-circle btn-lg" type="button"><i class="fa fa-headphones"></i>
                            </button>
                            <h2>输入客户名称进行检索</h2>
                        </div>
                    	
                    	
                    	
                        
                        <div class="search-form">
                            <form action="${ctx }/crm/crmService/customerList" method="post">
                                <div class="input-group">
                                    <input id="name" name="name" type="text" placeholder="请输入客户名称" name="search" class="form-control" value="${crmCustomer.name }">
                                    <div class="input-group-btn">
                                        <button class="btn btn-sm btn-info" type="submit">
                                            	搜索一下
                                        </button>
                                    </div>
                                </div>
								<span class="help-inline">支持搜索客户名称</span>
                            </form>
                        </div>
                        
                    </div>
                    <br>
                    
                    <c:if test="${not empty page}">
                       
                    <div class="ibox-content">
                    	 <h2>
                              	为您找到相关结果约${fn:length(page.list)}个： <span class="text-navy">“${crmCustomer.name }”</span>
                        </h2>
                        
                   		 <c:forEach items="${page.list }" var="crmCustomer">
                        	<div class="hr-line-dashed"></div>
	                        <div class="search-result">
	                            <p style="font-size: 16px;">
	                            	<a href="${ctx}/crm/crmService/crmServiceCustomerIndex?id=${crmCustomer.id}">${crmCustomer.name}</a>
	                            </p>	
	                            <p>${fns:getDictLabel(crmCustomer.customerStatus, 'customer_status', '')} | ${fns:getDictLabel(crmCustomer.customerLevel, 'customer_level', '')}</p>
	                        </div>
                        </c:forEach>
                        
                        <br>
                        <c:if test="${page != null && page.list!=null && fn:length(page.list) > 0}">
                        	<table:page page="${page}"></table:page>
                        </c:if>
                        
                        <br><br>
                    </div>
                    </c:if>
                </div>
            </div>
            <div class="col-sm-3">
            	<div class="float-e-margins hide">
                    <div class="ibox-content">
                    	<h2>最近工单</h2>
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
    </div>
</html>