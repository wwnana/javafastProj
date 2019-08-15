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
                        <h5>待办总览</h5>
                    </div>
                    <div class="ibox-content">
                    	
                    	
                    	<div class="form-group">
                    		<button type="button" class="btn btn-success btn-circle m-r-sm" onclick="javascript:window.location.href='${ctx}/fi/fiReceiveAble/list?status=0'"><i class="fa fa-send-o"></i></button>
		                        ${fiReceiveAblePage.count } 个应收款
                    	</div>
                    	<div class="form-group">
                    		 <button type="button" class="btn btn-success btn-circle m-r-sm" onclick="javascript:window.location.href='${ctx}/fi/fiPaymentAble/list?status=0'"><i class="fa fa-file-o"></i></button>
		                    	${fiPaymentAblePage.count } 个应付款
                    	</div>
		                    
                    </div>
                </div>
            </div>
            <div class="col-sm-7">
	        	<div class="ibox float-e-margins">
	            	<div class="ibox-title">                        
	                	<h5>待办应收款</h5>
	                	<div class="ibox-tools">
                            <a href="${ctx}/fi/fiReceiveAble/" target="mainFrame">
                                <i class="fa fa-chevron-right"></i>
                            </a>
                    	</div>
	           		</div>
	            	<div class="ibox-content">
							
                        <div>
                            <div class="chat-activity-list">

								<c:forEach items="${fiReceiveAblePage.list }" var="fiReceiveAble"> 
								<div class="chat-element">
                                    
                                    <div class="media-body ">
                                        
                                        <span class="pull-right">
                                        	<shiro:hasPermission name="fi:fiReceiveAble:view">
                                            <a href="${ctx}/fi/fiReceiveAble/index?id=${fiReceiveAble.id}" class="btn btn-info btn-sm"><i class="fa fa-search-plus"></i> 查看 </a>
                                        	</shiro:hasPermission>
                                        	<shiro:hasPermission name="fi:fiReceiveBill:add">
						    					<a href="#" onclick="openDialog('添加收款单', '${ctx}/fi/fiReceiveBill/form?fiReceiveAble.id=${fiReceiveAble.id}&fiReceiveAble.name=${fiReceiveAble.no}&customer.id=${fiReceiveAble.customer.id}&customer.name=${fiReceiveAble.customer.name}','800px', '500px')" 
						    					class="btn btn-success btn-sm" title="添加收款单"><i class="fa fa-plus"></i> 添加收款单</a>
											</shiro:hasPermission>
                                        </span>
                                        <strong>单号：${fiReceiveAble.no}</strong>，客户：${fiReceiveAble.customer.name}
                                        <p class="m-b-xs">
                                            <i>应收：${fiReceiveAble.amount}</i>，&nbsp;&nbsp;<i>实收：${fiReceiveAble.realAmt}</i>，&nbsp;&nbsp;待收：${fiReceiveAble.amount-fiReceiveAble.realAmt}</i>，&nbsp;&nbsp;
                                            	应收时间：<fmt:formatDate value="${fiReceiveAble.ableDate}" pattern="yyyy-MM-dd"/>，&nbsp;&nbsp;负责人：${fiReceiveAble.ownBy.name}
                                        </p>
                                        <small class="text-muted">创建于：<fmt:formatDate value="${fiReceiveAble.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>&nbsp;&nbsp;创建人：${fiReceiveAble.createBy.name}</small>
                                    	
                                    </div>
                                </div>                     	
		                        </c:forEach>
		                        <br/>
	                            <table:page page="${fiReceiveAblePage}"></table:page>
	                            <br/>
                            </div>
                        </div>
                    </div>
	       		</div>
				<div class="ibox float-e-margins">
	            	<div class="ibox-title">                        
	                	<h5>待办应付款</h5>
	                	<div class="ibox-tools">
                            <a href="${ctx}/fi/fiPaymentAble/" target="mainFrame">
                                <i class="fa fa-chevron-right"></i>
                            </a>
                    	</div>
	           		</div>
	            	<div class="ibox-content">
							
                        <div>
                            <div class="chat-activity-list">

								<c:forEach items="${fiPaymentAblePage.list }" var="fiPaymentAble"> 
								<div class="chat-element">
                                    
                                    <div class="media-body ">
                                        <span class="pull-right">
                                        	<shiro:hasPermission name="fi:fiPaymentAble:view">
                                            	<a href="${ctx}/fi/fiPaymentAble/index?id=${fiPaymentAble.id}" class="btn btn-info btn-sm"><i class="fa fa-search-plus"></i> 查看 </a>
                                        	</shiro:hasPermission>
                                        	<shiro:hasPermission name="fi:fiPaymentBill:add">
						    					<a href="#" onclick="openDialog('添加付款单', '${ctx}/fi/fiPaymentBill/form?fiPaymentAble.id=${fiPaymentAble.id}&fiPaymentAble.name=${fiPaymentAble.no}&supplier.id=${fiPaymentAble.supplier.id}&supplier.name=${fiPaymentAble.supplier.name}','800px', '500px')" 
						    					class="btn btn-success btn-sm" title="添加付款单"><i class="fa fa-plus"></i> 添加付款单</a>
											</shiro:hasPermission>
                                        </span>
                                        <strong>单号：${fiPaymentAble.no}</strong>，供应商：${fiPaymentAble.supplier.name}
                                        <p class="m-b-xs">
                                            <i>应付：${fiPaymentAble.amount}</i>，&nbsp;&nbsp;<i>实付：${fiPaymentAble.realAmt}</i>，&nbsp;&nbsp;待付：${fiPaymentAble.amount-fiPaymentAble.realAmt}</i>，&nbsp;&nbsp;
                                            	应收时间：<fmt:formatDate value="${fiPaymentAble.ableDate}" pattern="yyyy-MM-dd"/>，&nbsp;&nbsp;负责人：${fiPaymentAble.ownBy.name}
                                        </p>
                                        <small class="text-muted">创建于：<fmt:formatDate value="${fiPaymentAble.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>&nbsp;&nbsp;创建人：${fiPaymentAble.createBy.name}</small>
                                    </div>
                                </div>                     	
		                        </c:forEach>
		                        <br/>
	                            <table:page page="${fiPaymentAblePage}"></table:page>
	                            <br/>
                            </div>
                        </div>
                    </div>
	       		</div>
            	
            </div>
            <div class="col-sm-3">
				<div class="ibox float-e-margins">
                    <div class="ibox-title">
                        <h5>待审核收款单</h5>
                        <div class="ibox-tools">
                            <a href="${ctx}/fi/fiReceiveBill/" target="mainFrame">
                                <i class="fa fa-chevron-right"></i>
                            </a>
                    	</div>
                    </div>                    
                   <div class="ibox-content no-padding">
                   		<ul class="list-group">
                    	<c:forEach items="${fiReceiveBillPage.list }" var="fiReceiveBill">                   	
							<li class="list-group-item">
								 <div class="agile-detail">
                                	<a href="#" onclick="openDialogView('查看收款单', '${ctx}/fi/fiReceiveBill/view?id=${fiReceiveBill.id}','800px', '500px')" class="block-link">${fiReceiveBill.no}</a>                                	
                                	 <a href="#" class="pull-right btn btn-xs btn-success">${fiReceiveBill.amount}元</a>  
                                </div>
							</li>	
                        </c:forEach>
                        </ul>
                    </div>
                </div>
                
                <div class="ibox float-e-margins">
                    <div class="ibox-title">
                        <h5>待审核付款单</h5>
                        <div class="ibox-tools">
                            <a href="${ctx}/fi/fiPaymentBill/" target="mainFrame">
                                <i class="fa fa-chevron-right"></i>
                            </a>
                    	</div>
                    </div>                    
                    <div class="ibox-content no-padding">
                   		<ul class="list-group">
                    	<c:forEach items="${fiPaymentBillPage.list }" var="fiPaymentBill">                   	
							<li class="list-group-item">
								 <div class="agile-detail">
                                	<a href="#" onclick="openDialogView('查看付款单', '${ctx}/fi/fiPaymentBill/view?id=${fiPaymentBill.id}','800px', '500px')" class="block-link">${fiPaymentBill.no}</a>                                	
                                	 <a href="#" class="pull-right btn btn-xs btn-success">${fiPaymentBill.amount}元</a>  
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