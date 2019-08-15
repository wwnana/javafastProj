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
                    <div class="gray-bg">
                    	<div class="text-center">
                    		<button class="btn btn-info btn-circle btn-lg" type="button"><i class="fa fa-headphones"></i>
                            </button>
                            <h2>全局搜索</h2>
                        </div>
                        
                    	
                    	
                        <div class="search-form">
                            <form action="${ctx }/search" method="post">
                                <div class="input-group">
                                    <input id="keyWords" name="keyWords" type="text" placeholder="请输入关键字进行搜索" name="search" class="form-control" value="${keyWords }">
                                    <div class="input-group-btn">
                                        <button class="btn btn-sm btn-info" type="submit">
                                            	搜索一下
                                        </button>
                                    </div>
                                </div>
								<span class="help-inline">支持搜索客户、联系人、商机、合同、项目、任务</span>
                            </form>
                        </div>
                   </div>
                   <br>
                   <c:if test="${not empty page}">
                       
                    	<div class="ibox-content">
                        <c:if test="${not empty keyWords}">
                        <h2>
                                	为您找到相关结果约${fn:length(page.list)}个： <span class="text-navy">“${keyWords }”</span>
                        </h2>
						</c:if>
                        <c:forEach items="${page.list }" var="sysSearch">
                        	<div class="hr-line-dashed"></div>
	                        <div class="search-result">
	                            <p style="font-size: 16px;">
	                            
	                            	<c:if test="${sysSearch.type == 20}">[客户]</c:if>
	                            	<c:if test="${sysSearch.type == 21}">[联系人]</c:if>
	                            	<c:if test="${sysSearch.type == 22}">[商机]</c:if>
	                            	<c:if test="${sysSearch.type == 24}">[合同]</c:if>
	                            	<c:if test="${sysSearch.type == 10}">[项目]</c:if>
	                            	<c:if test="${sysSearch.type == 11}">[任务]</c:if> 
	                            	
	                            	<c:if test="${sysSearch.type == 20}"><a href="${ctx}/crm/crmCustomer/index?id=${sysSearch.id}">${sysSearch.name}</a></c:if>
	                            	<c:if test="${sysSearch.type == 21}"><a href="#" onclick="openDialogView('查看联系人', '${ctx}/crm/crmContacter/view?id=${sysSearch.id}','800px', '500px')">${sysSearch.name}</a></h3></c:if>
	                            	<c:if test="${sysSearch.type == 22}"><a href="${ctx}/crm/crmChance/index?id=${sysSearch.id}">${sysSearch.name}</a></c:if>
	                            	<c:if test="${sysSearch.type == 24}"><a href="${ctx}/om/omContract/index?id=${sysSearch.id}">${sysSearch.name}</a></c:if>
	                            	<c:if test="${sysSearch.type == 10}"><a href="${ctx}/oa/oaProject/view?id=${sysSearch.id}">${sysSearch.name}</a></c:if>
	                            	<c:if test="${sysSearch.type == 11}"><a href="${ctx}/oa/oaTask/view?id=${sysSearch.id}">${sysSearch.name}</a></c:if>
	                            </p>	
	                            
	                        </div>
                        </c:forEach>
                        
                        <br>
                        <c:if test="${page != null && page.list!=null && fn:length(page.list) > 0}">
                        	<table:page page="${page}"></table:page>
                        </c:if>
                        
                        </div>
                   </c:if>
                        
                        <br><br>
                    
                </div>
            </div>
            <div class="col-sm-3">
            	<div class="float-e-margins hide">
                    <div class="ibox-content">
                    	<h2>最近浏览足迹</h2>
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