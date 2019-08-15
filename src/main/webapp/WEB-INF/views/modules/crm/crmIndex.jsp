<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>客户主页</title>
	<meta name="decorator" content="default"/>
	
    <script type="text/javascript">
    function saveCustomerStar(customerId){    	
    	var is_star = $("#customerStar").hasClass("color-orange");    	    	
    	$.ajax({
    		url:"${ctx}/crm/crmCustomerStar/saveCustomerStar",
    		type:"POST",
    		async:true,    //或false,是否异步
    		data:{customerId:customerId, isStar:is_star},
    		dataType:'json',
    		success:function(data){
    			//alert(data);
    			if(is_star == false){
    				$("#customerStar").addClass("color-orange");
    			}else{
    				$("#customerStar").removeClass("color-orange");
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
	<div class="row border-bottom white-bg dashboard-header">
        <div class="col-sm-12">
            <div class="pull-left">
				<div style="font-size: 18px;font-weight: 500;">                        
		        	${fns:abbr(crmCustomer.name,50)}
		        </div>
            </div>
            <div class="pull-right">
				<a href="#" onclick="saveCustomerStar('${crmCustomer.id}');" class="btn btn-default btn-sm" title="关注"><i id="customerStar" class="fa fa-star <c:if test='${not empty isStar}'>color-orange</c:if>"></i> 关注</a>
				<button onclick="openDialog('指派', '${ctx}/crm/crmCustomer/shareForm?id=${crmCustomer.id}','500px', '300px')" type="button" class="btn btn-default btn-sm" title="指派"><i class="fa fa-share"></i> 指派</button>
				
				<div class="btn-group">
	                <button data-toggle="dropdown" class="btn btn-default btn-sm dropdown-toggle" title="更多操作"> 快捷操作 <span class="caret"></span>
	                </button>
	                <ul class="dropdown-menu">
	                	<li>
	                		
				       		<c:if test="${fns:getUser().id == crmCustomer.ownBy.id}">
				       			<a href="${ctx}/crm/crmCustomer/toPool?id=${crmCustomer.id}" onclick="return confirmx('确认要将该客户放入公海吗？', this.href)"><i class="fa fa-recycle"></i> 放入公海</a>
				       		</c:if>
				       		
				       		<shiro:hasPermission name="crm:crmCustomer:edit">
								<a href="${ctx}/crm/crmCustomer/editForm?id=${crmCustomer.id}" ><i class="fa fa-edit"></i> 修改</a>
							</shiro:hasPermission>
				
				       		<shiro:hasPermission name="crm:crmCustomer:del">
				       			<a href="${ctx}/crm/crmCustomer/delete?id=${crmCustomer.id}" onclick="return confirmx('确认要删除该客户吗？', this.href)"><i class="fa fa-trash"></i> 删除</a>
				       		</shiro:hasPermission>
	                    </li>
	                	<li class="divider"></li>
	                    <li><a href="${ctx}/crm/crmContacter/form?customer.id=${crmCustomer.id}&customer.name=${crmCustomer.name}"><i class="fa fa-users"></i> 添加联系人</a>
	                    </li>
	                    <li><a href="${ctx}/crm/crmContactRecord/form?customer.id=${crmCustomer.id}&customer.name=${crmCustomer.name}"><i class="fa fa-file-text-o"></i> 添加跟进记录</a>
	                    </li>
	                    <li><a href="${ctx}/crm/crmChance/form?customer.id=${crmCustomer.id}&customer.name=${crmCustomer.name}"><i class="fa fa-location-arrow"></i> 添加商机</a>
	                    </li>
	                    <li>
	                    	<a href="${ctx}/crm/crmQuote/form?customer.id=${crmCustomer.id}&customer.name=${crmCustomer.name}"><i class="fa fa-file-o"></i> 添加报价</a>
	                    </li>
	                    <li>
	                    	<a href="${ctx}/om/omContract/form?customer.id=${crmCustomer.id}&customer.name=${crmCustomer.name}"><i class="fa fa-file-text"></i> 添加合同订单</a>
	                    </li>
	                    <li>
	                    	<a href="${ctx}/oa/oaTask/form?relationType=0&relationId=${crmCustomer.id}&relationName=${crmCustomer.name}"><i class="fa fa-bell-o"></i> 添加任务</a>
	                    </li>
	                    <%-- 
	                    <li>
	                   		<a href="#" onclick="openDialog('添加日程', '${ctx}/iim/myCalendar/form?customerId=${crmCustomer.id}&title=${crmCustomer.name}&adllDay=1','500px', '300px')"><i class="fa fa-calendar-check-o"></i> 添加日程</a>
	                    </li>
	                    --%>
	                </ul>
	            </div>
	            <a href="${ctx}/crm/crmCustomer/index?id=${crmCustomer.id}" class="btn btn-default btn-sm" title="刷新"><i class="fa fa-refresh"></i> 刷新</a>
	            <a href="${ctx}/crm/crmCustomer/" class="btn btn-default btn-sm" title="返回列表"><i class="fa fa-repeat"></i> 返回</a>				
            </div>
        </div>
    </div>
    

    <div class="wrapper-content">

        <div class="row ">
        	<div class="col-sm-2">
                <div class="ibox float-e-margins">
                    <div class="ibox-title">                        
                        <h5>快捷菜单</h5>
                    </div>
                    <div class="ibox-content">
                    	
                    	<ul class="nav">
                            <li>
                            	<a href="${ctx}/crm/crmCustomer/view?id=${crmCustomer.id}" target="crmContent">
									<i class="fa fa-reorder"></i> <span class="nav-label">基本信息</span>
								</a>
                            </li>
                            <li>
                            	<a href="${ctx}/crm/crmContacter/indexContacterList?customer.id=${crmCustomer.id}&customer.name=${crmCustomer.name}" target="crmContent">
                            		<i class="fa fa-users"></i> <span class="nav-label">联系人 </span>
                            		<c:if test="${contacterCount>0}"><span class="badge badge-info pull-right">${contacterCount }</span></c:if>
                            	</a>
                            </li>
                            <li>
                            	<a href="${ctx}/crm/crmContactRecord/indexContactRecordList?customer.id=${crmCustomer.id}&customer.name=${crmCustomer.name}" target="crmContent">
                            		<i class="fa fa-file-text-o"></i> <span class="nav-label">跟进记录 </span>
                            		<c:if test="${contactRecordCount>0}"><span class="badge badge-info pull-right">${contactRecordCount}</span></c:if>
                            	</a>
                            </li>
                            <li>
                            	<a href="${ctx}/crm/crmChance/indexChanceList?customer.id=${crmCustomer.id}&customer.name=${crmCustomer.name}" target="crmContent">
                            		<i class="fa fa-location-arrow"></i> <span class="nav-label">商机 </span>
                            		<c:if test="${chanceCount>0}"><span class="badge badge-info pull-right">${chanceCount }</span></c:if>
                            	</a>
                            </li>
                            <li>
                            	<a href="${ctx}/crm/crmQuote/indexQuoteList?customer.id=${crmCustomer.id}&customer.name=${crmCustomer.name}" target="crmContent">
                            		<i class="fa fa-file-o"></i> <span class="nav-label">报价单 </span>
                            		<c:if test="${quoteCount>0}"><span class="badge badge-info pull-right">${quoteCount }</span></c:if>
                            	</a>
                            </li>
                            <li>
                            	<a href="${ctx}/om/omContract/indexContractList?customer.id=${crmCustomer.id}&customer.name=${crmCustomer.name}" target="crmContent">
                            		<i class="fa fa-file-text"></i> <span class="nav-label">订单合同 </span>
                            		<c:if test="${contactCount>0}"><span class="badge badge-info pull-right">${contactCount }</span></c:if>
                            	</a>
                            </li>
                            <li>
                            	<a href="${ctx}/fi/fiReceiveAble/indexReceiveAbleList?customer.id=${crmCustomer.id}&customer.name=${crmCustomer.name}" target="crmContent">
                            		<i class="fa fa-strikethrough"></i> <span class="nav-label">应收款 </span>
                            		<c:if test="${receiveAbleCount>0}"><span class="badge badge-info pull-right">${receiveAbleCount }</span></c:if>
                            	</a>
                            </li>
                            <li>
                            	<a href="${ctx}/oa/oaTask/indexTaskList?relationId=${crmCustomer.id}&relationName=${crmCustomer.name}" target="crmContent">
                            		<i class="fa fa-bell-o"></i> <span class="nav-label">任务 </span>
                            		<c:if test="${taskCount>0}"><span class="badge badge-info pull-right">${taskCount }</span></c:if>
                            	</a>
                            </li>
                            <%-- 
                            <li>
                            	<a href="${ctx}/iim/myCalendar/myCalendarList?customerId=${crmCustomer.id}" target="crmContent">
                            		<i class="fa fa-calendar-check-o"></i> <span class="nav-label">日程 </span>
                            		<c:if test="${calendarCount>0}"><span class="badge badge-info pull-right">${calendarCount }</span></c:if>
                            	</a>
                            </li>
                            --%>
                            <li>
                            	<a href="${ctx}/crm/crmDocument/indexDocumentList?customer.id=${crmCustomer.id}" target="crmContent">
                            		<i class="fa fa-file-o"></i> <span class="nav-label">附件 </span>
                            		<c:if test="${docmentCount>0}"><span class="badge badge-info pull-right">${docmentCount }</span></c:if>
                            	</a>
                            </li>
                        </ul>
                    </div>
                </div>
            	
                <div class="ibox float-e-margins hide">
                    <div class="ibox-title">                        
                        <h5>客户标签</h5>
                    </div>
                    <div class="ibox-content">
                    	<textarea rows="" cols="" class="form-control" style="height:80px;width: 100%"></textarea>
                    </div>
                </div>
                
            </div>
        	<div class="col-sm-10">
        		<div class="" style="height:800px">
		        	<iframe id="crmContent" name="crmContent" src="${ctx}/crm/crmCustomer/view?id=${crmCustomer.id}" width="100%" height="100%" frameborder="0"></iframe> 
		        </div>
            </div>
        </div>
    </div>
   
   
</body>
</html>