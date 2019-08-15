<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>主页</title>
	<meta name="decorator" content="default"/>    
	<link href="${ctxStatic}/hplus/css/calendar.css" rel="stylesheet">
    <script type="text/javascript">
    </script>
</head>

<body class="gray-bg">
	
    <div class="wrapper-content">
		<sys:message content="${message}"/>
        <div class="row">
        	<div class="col-sm-2">
                <div class="ibox float-e-margins">
                    <div class="ibox-title">                        
                        <h5>总览</h5>
                    </div>
                    <div class="ibox-content">
                    	
                    	<div class="form-group">
                    		 <button type="button" class="btn btn-info btn-circle m-r-sm" onclick="javascript:window.location.href='${ctx}/wms/wmsPurchase/list?status=0'"><i class="fa fa-file-text"></i></button>
		                     	${wmsPurchasePage.count } 个待审核采购单
                    	</div>
                    	<div class="form-group">
                    		<button type="button" class="btn btn-success btn-circle m-r-sm" onclick="javascript:window.location.href='${ctx}/wms/wmsInstock/list?status=0'"><i class="fa fa-file-o"></i></button>
		                        ${wmsInstockPage.count } 个待审核入库单
                    	</div>
                    	<div class="form-group">
                    		 <button type="button" class="btn btn-success btn-circle m-r-sm" onclick="javascript:window.location.href='${ctx}/wms/wmsOutstock/list?status=0'"><i class="fa fa-file-o"></i></button>
		                    	${wmsOutstockPage.count }个待审核出库单
                    	</div>
		                <div class="form-group">
                    		 <button type="button" class="btn btn-danger btn-circle m-r-sm" onclick="javascript:window.location.href='${ctx}/wms/wmsStock/'"><i class="fa fa-file-text"></i></button>
		                      	${wmsStockPage.count } 个产品预警
                    	</div>     
                    </div>
                </div>
            </div>
            <div class="col-sm-7">
	        	<div class="ibox float-e-margins">
	            	<div class="ibox-title">                        
	                	<h5>待入库单</h5>
	                	<div class="ibox-tools">
                            <a href="${ctx}/wms/wmsInstock/list?status=0" target="mainFrame">
                                <i class="fa fa-chevron-right"></i>
                            </a>
                    	</div>
	           		</div>
	            	<div class="ibox-content">
							
                        <div>
                            <div class="chat-activity-list">

								<c:forEach items="${wmsInstockPage.list }" var="wmsInstock"> 
								<div class="chat-element">
                                    
                                    <div class="media-body ">
                                    	<span class="pull-right">
                                        	<shiro:hasPermission name="wms:wmsInstock:view">
												<a href="${ctx}/wms/wmsInstock/view?id=${wmsInstock.id}" class="btn btn-info btn-sm" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
											</shiro:hasPermission>
											<shiro:hasPermission name="wms:wmsInstock:edit">
						    					<a href="${ctx}/wms/wmsInstock/form?id=${wmsInstock.id}" class="btn btn-success btn-sm" title="入库"><i class="fa fa-edit"></i> 入库</a>
											</shiro:hasPermission>
											<c:if test="${wmsInstock.num == wmsInstock.realNum}">	
											<shiro:hasPermission name="wms:wmsInstock:audit">	
												<a href="${ctx}/wms/wmsInstock/audit?id=${wmsInstock.id}" onclick="return confirmx('确认要审核该入库单吗？', this.href)" class="btn btn-success btn-sm" title="审核"><i class="fa fa-check"></i> 审核</a>
											</shiro:hasPermission>
											</c:if>
                                        </span>
                                        <strong>单号：${wmsInstock.no}</strong>，数量：${wmsInstock.num}</i>
                                        <p class="m-b-xs">
                                            已入：${wmsInstock.realNum}</i>，&nbsp;&nbsp;<i>差异：${wmsInstock.num - wmsInstock.realNum}</i>，&nbsp;&nbsp;
                                            	业务日期：<fmt:formatDate value="${wmsInstock.dealDate}" pattern="yyyy-MM-dd"/>，&nbsp;&nbsp;
											负责人：${wmsInstock.dealBy.name}
                                        </p>
                                        <small class="text-muted">创建于：<fmt:formatDate value="${wmsInstock.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>&nbsp;&nbsp;创建人：${wmsInstock.createBy.name}</small>
                                    </div>
                                </div>                     	
		                        </c:forEach>
		                        <br/>
	                            <table:page page="${wmsInstockPage}"></table:page>
	                            <br/>
                            </div>
                        </div>
                    </div>
	       		</div>
				<div class="ibox float-e-margins">
	            	<div class="ibox-title">                        
	                	<h5>待出库单</h5>
	                	<div class="ibox-tools">
                            <a href="${ctx}/wms/wmsOutstock/list?status=0" target="mainFrame">
                                <i class="fa fa-chevron-right"></i>
                            </a>
                    	</div>
	           		</div>
	            	<div class="ibox-content">
							
                        <div>
                            <div class="chat-activity-list">

								<c:forEach items="${wmsOutstockPage.list }" var="wmsOutstock"> 
								<div class="chat-element">
                                    
                                    <div class="media-body">
                                    	<span class="pull-right">
                                        	<shiro:hasPermission name="wms:wmsOutstock:view">
												<a href="${ctx}/wms/wmsOutstock/view?id=${wmsOutstock.id}" class="btn btn-info btn-sm" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
											</shiro:hasPermission>
											
											<shiro:hasPermission name="wms:wmsOutstock:edit">
						    					<a href="${ctx}/wms/wmsOutstock/form?id=${wmsOutstock.id}" class="btn btn-success btn-sm" title="出库"><i class="fa fa-edit"></i> 出库</a>
											</shiro:hasPermission>
											<c:if test="${wmsOutstock.num == wmsOutstock.realNum}">
											<shiro:hasPermission name="wms:wmsOutstock:audit">
												<a href="${ctx}/wms/wmsOutstock/audit?id=${wmsOutstock.id}" onclick="return confirmx('确认要审核该出库单吗？', this.href)" class="btn btn-success btn-sm" title="审核"><i class="fa fa-check"></i> 审核</a> 
											</shiro:hasPermission>
											</c:if>
                                        </span>
                                        <strong>单号：${wmsOutstock.no}</strong>，数量：${wmsOutstock.num}
                                        <p class="m-b-xs">
                                            <i>已出：${wmsOutstock.realNum}</i>，&nbsp;&nbsp;<i>差异：${wmsOutstock.num - wmsOutstock.realNum}</i>，&nbsp;&nbsp;业务日期：<fmt:formatDate value="${wmsOutstock.dealDate}" pattern="yyyy-MM-dd"/>，&nbsp;&nbsp;
											负责人：${wmsOutstock.dealBy.name}
                                        </p>
                                        <small class="text-muted">创建于：<fmt:formatDate value="${wmsOutstock.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>&nbsp;&nbsp;创建人：${wmsOutstock.createBy.name}</small>
                                    </div>
                                </div>                     	
		                        </c:forEach>
		                        <br/>
	                            <table:page page="${wmsOutstockPage}"></table:page>
	                            <br/>
                            </div>
                        </div>
                    </div>
	       		</div>
	        	
            </div>
            <div class="col-sm-3">
                
               <div class="ibox float-e-margins">
                    <div class="ibox-title">
                        <h5>待核采购单</h5>
                        <div class="ibox-tools">
                            <a href="${ctx}/wms/wmsPurchase/list?status=0" target="mainFrame">
                                <i class="fa fa-chevron-right"></i>
                            </a>
                    	</div>
                    </div>                    
                   <div class="ibox-content no-padding">
                   		<ul class="list-group">
                    	<c:forEach items="${wmsPurchasePage.list }" var="wmsPurchase">                   	
							<li class="list-group-item">
								 <div class="agile-detail">
                                	<a href="${ctx}/wms/wmsPurchase/view?id=${wmsPurchase.id}" class="block-link">${wmsPurchase.no}</a>                                	
                                	 <a href="#" class="pull-right btn btn-xs btn-white"><fmt:formatDate value="${wmsPurchase.dealDate}" pattern="yyyy-MM-dd"/></a>  
                                </div>
							</li>	
                        </c:forEach>
                        </ul>
                    </div>
                </div>
                               
                <div class="ibox float-e-margins">
                    <div class="ibox-title">
                        <h5>库存预警</h5>
                        <div class="ibox-tools">
                            <a href="${ctx}/wms/wmsStock/" target="mainFrame">
                                <i class="fa fa-chevron-right"></i>
                            </a>
                    	</div>
                    </div>                    
                   <div class="ibox-content no-padding">
                   		<ul class="list-group">
                    	<c:forEach items="${wmsStockPage.list }" var="wmsStock">                   	
							<li class="list-group-item">
								 <div class="agile-detail">
                                	<a href="#" onclick="openDialogView('查看产品库存', '${ctx}/wms/wmsStock/view?id=${wmsStock.id}','800px', '500px')" class="block-link">${wmsStock.product.name}</a>                                	
                                	 <a href="#" class="pull-right btn btn-xs btn-danger">剩余${wmsStock.stockNum}</a>  
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