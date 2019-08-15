<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>动态</title>
	<meta name="decorator" content="default"/>    
    <script type="text/javascript">
	    
	    function toView(objectType, targetId){
	    	//object_type对象类型    10：项目，11：任务，12:日报，13：通知，14：审批，20：客户，21：联系人，22：商机，23：报价，24：合同订单，25:沟通, 26:订单，27：退货单，30：产品：31：采购，32：入库，33：出库，34：移库，39：供应商，36：盘点，37:调拨，   50：应收款，51：应付款， 52：收款单，53：付款单
	    	if(objectType == "11"){//任务
	    		window.location.href = "${ctx}/oa/oaTask/view?id="+targetId;
	    	}
	    	if(objectType == "20"){//客户
	    		window.location.href = "${ctx}/crm/crmCustomer/index?id="+targetId;
	    	}
	    	if(objectType == "21"){
	    		openDialogView("联系人", "${ctx}/crm/crmContacter/view?id="+targetId, '800px', '500px');
	    	}
	    	if(objectType == "22"){//商机
	    		window.location.href = "${ctx}/crm/crmChance/index?id="+targetId;
	    	}
	    	if(objectType == "23"){//报价
	    		window.location.href = "${ctx}/crm/crmQuote/view?id="+targetId;
	    	}
	    	if(objectType == "24"){//合同订单
	    		window.location.href = "${ctx}/om/omContract/index?id="+targetId;
	    	}
	    	if(objectType == "25"){
	    		openDialogView("跟进记录", "${ctx}/crm/crmContactRecord/view?id="+targetId, '800px', '500px');
	    	}
	    	if(objectType == "26"){//订单
	    		window.location.href = "${ctx}/om/omOrder/index?id="+targetId;
	    	}
	    	if(objectType == "27"){//退货单
	    		window.location.href = "${ctx}/om/omReturnorder/view?id="+targetId;
	    	}
	    	if(objectType == "39"){
	    		openDialogView("供应商", "${ctx}/wms/wmsSupplier/view?id="+targetId, '800px', '500px');
	    	}
	    	if(objectType == "31"){//采购单
	    		window.location.href = "${ctx}/wms/wmsPurchase/view?id="+targetId;
	    	}
	    	if(objectType == "32"){//入库单
	    		window.location.href = "${ctx}/wms/wmsInstock/view?id="+targetId;
	    	}
	    	if(objectType == "33"){//出库单
	    		window.location.href = "${ctx}/wms/wmsOutstock/view?id="+targetId;
	    	}
	    	if(objectType == "50"){//应收款
	    		window.location.href = "${ctx}/fi/fiReceiveAble/index?id="+targetId;
	    	}
	    	if(objectType == "51"){//应付款
	    		window.location.href = "${ctx}/fi/fiPaymentAble/index?id="+targetId;
	    	}
	    	if(objectType == "52"){
	    		openDialogView("收款单", "${ctx}/fi/fiReceiveBill/view?id="+targetId, '800px', '500px');
	    	}
	    	if(objectType == "53"){
	    		openDialogView("付款单", "${ctx}/fi/fiPaymentBill/view?id="+targetId, '800px', '500px');
	    	}
	    }
    </script>
</head>

<body class="gray-bg">
	
    <div class="wrapper-content">
		<sys:message content="${message}"/>
        <div class="row">
        	
            <div class="col-sm-12">
	        	<div class="ibox float-e-margins">
	            	<div class="ibox-title">                        
	                	<h5>团队动态</h5>
	                	<div class="ibox-tools">
                            <a href="${ctx}/sys/sysDynamic" target="mainFrame">
                                <i class="fa fa-chevron-right"></i>
                            </a>
                    	</div>
	           		</div>
	            	<div class="ibox-content">
						<form:form id="searchForm" modelAttribute="sysDynamic" action="${ctx}/home" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
						</form:form>	
                        <div>
                            <div class="chat-activity-list">

								<c:forEach items="${sysDynamicPage.list }" var="sysDynamic"> 
								<div class="chat-element">
                                    <a href="#" onclick="openDialogView('查看用户信息', '${ctx}/sys/user/view?id=${sysDynamic.createBy.id}','800px', '500px')" class="pull-left">
                                        <img alt="${sysDynamic.createBy.name}" class="img-circle" src="${sysDynamic.createBy.photo}">
                                    </a>
                                    <div class="media-body ">
                                        <small class="pull-right hide"><fmt:formatDate value="${sysDynamic.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/></small>
                                        <strong>${sysDynamic.createBy.name}</strong>&nbsp;&nbsp;<i>${fns:getDictLabel(sysDynamic.actionType, 'action_type', '')}了</i>&nbsp;&nbsp;${fns:getDictLabel(sysDynamic.objectType, 'object_type', '')}
                                        <p class="m-b-xs well">
                                            
											<a href="#" onclick="toView('${sysDynamic.objectType}','${sysDynamic.targetId}');">${sysDynamic.targetName}</a>
                                        </p>
                                        <small class="text-muted">${fns:getTimeDiffer(sysDynamic.createDate)}</small>
                                    </div>
                                </div>                     	
		                        </c:forEach>
		                        
                            </div>
                            <br>
                            <table:page page="${sysDynamicPage}"></table:page>
                            <br><br>
                        </div>
                    </div>
	       		</div>

            </div>
 
            
        </div>
    </div>
   
   
</body>
</html>