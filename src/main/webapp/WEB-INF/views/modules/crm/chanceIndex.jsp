<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>商机主页</title>
	<meta name="decorator" content="default"/>
	<style type="text/css">
		.color-orange{color:orange;}
	</style>
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
		<div class="row">
			<div class="col-sm-12">
				 <div class="float-e-margins">
					
                    <div class="ibox-content" style="padding: 20px 20px 10px 20px;">
                    	
						<a href="${ctx}/crm/crmCustomer/" class="btn btn-default btn-sm"><i class="fa fa-repeat"></i> 返回列表</a>
						<a href="${ctx}/crm/crmCustomer/index?id=${crmCustomer.id}" class="btn btn-default btn-sm"><i class="fa fa-refresh"></i> 刷新</a>
						<a href="#" onclick="saveCustomerStar('${crmCustomer.id}');" class="btn btn-default btn-sm"><i id="customerStar" class="fa fa-star <c:if test='${not empty isStar}'>color-orange</c:if>"></i> 关注</a>
						
						<button onclick="openDialog('指派', '${ctx}/crm/crmCustomer/shareForm?id=${crmCustomer.id}','800px', '500px')" type="button" class="btn btn-default btn-sm"><i class="fa fa-share"></i> 指派</button>
						
						<button onclick="openDialog('添加联系人', '${ctx}/crm/crmContacter/form?customer.id=${crmCustomer.id}&customer.name=${crmCustomer.name}','800px', '500px')" type="button" class="btn btn-default btn-sm"><i class="fa fa-users"></i> 添加联系人</button>
                    	<button onclick="openDialog('添加跟进记录', '${ctx}/crm/crmContactRecord/form?customer.id=${crmCustomer.id}&customer.name=${crmCustomer.name}','800px', '500px')" type="button" class="btn btn-default btn-sm"><i class="fa fa-file-text-o"></i> 添加跟进记录</button>
                    	<button onclick="openDialog('添加商机', '${ctx}/crm/crmChance/form?customer.id=${crmCustomer.id}&customer.name=${crmCustomer.name}','800px', '500px')" type="button" class="btn btn-default btn-sm"><i class="fa fa-location-arrow"></i> 添加商机</button>
                    	<button onclick="openDialog('添加报价单', '${ctx}/crm/crmQuote/form?customer.id=${crmCustomer.id}&customer.name=${crmCustomer.name}','1200px', '80%')" type="button" class="btn btn-default btn-sm"><i class="fa fa-file-o"></i> 添加报价</button>
                    	<button onclick="openDialog('添加订单合同', '${ctx}/om/omContract/form?customer.id=${crmCustomer.id}&customer.name=${crmCustomer.name}','1200px', '80%')" type="button" class="btn btn-default btn-sm"><i class="fa fa-file-text"></i> 添加订单</button>
                    	<button onclick="openDialog('添加任务', '${ctx}/oa/oaTask/form?relationType=0&relationId=${crmCustomer.id}&relationName=${crmCustomer.name}','800px', '500px')" type="button" class="btn btn-default btn-sm"><i class="fa fa-bell-o"></i> 添加任务</button>
                    	<button onclick="openDialog('添加日程', '${ctx}/iim/myCalendar/form?customerId=${crmCustomer.id}&title=${crmCustomer.name}&adllDay=1','800px', '500px')" type="button" class="btn btn-default btn-sm"><i class="fa fa-calendar-check-o"></i> 添加日程</button>
                    	
                    	
                    	<div class="pull-right">
                    		<%-- 
                    		<button class="btn btn-default btn-sm " type="button"><i class="fa fa-map-marker"></i>&nbsp;&nbsp;客户地图</button>
                    		--%>
                    		<button class="btn btn-default btn-sm " type="button"><i class="fa fa-recycle"></i>&nbsp;&nbsp;回收站</button>
                    	</div>
					</div>
				</div>
			</div>
		</div>
    <div class="wrapper-content">

        <div class="row ">
        	<div class="col-sm-2" style="padding-right: 0px;">
                <div class="ibox float-e-margins">
                    <div class="ibox-title">                        
                        <h5>${chance.name}</h5>
                    </div>
                    <div class="ibox-content">
                    	
                    	<ul class="nav">
                            <li>
                            	<a href="${ctx}/crm/crmCustomer/view?id=${crmCustomer.id}" target="crmContent">
									<i class="fa fa-reorder"></i> <span class="nav-label">基本信息</span>
								</a>
                            </li>
                            <li>
                            	<a href="${ctx}/crm/crmContacter/list?customer.id=${crmCustomer.id}&customer.name=${crmCustomer.name}" target="crmContent">
                            		<i class="fa fa-users"></i> <span class="nav-label">联系人 </span><span class="badge badge-info pull-right">${contacterCount }</span>
                            	</a>
                            </li>
                            <li>
                            	<a href="${ctx}/crm/crmContactRecord/list?customer.id=${crmCustomer.id}&customer.name=${crmCustomer.name}" target="crmContent">
                            		<i class="fa fa-file-text-o"></i> <span class="nav-label">跟进记录 </span><span class="badge badge-info pull-right">${contactRecordCount}</span>
                            	</a>
                            </li>
                            <li>
                            	<a href="${ctx}/crm/crmChance/list?customer.id=${crmCustomer.id}&customer.name=${crmCustomer.name}" target="crmContent">
                            		<i class="fa fa-location-arrow"></i> <span class="nav-label">商机 </span><span class="badge badge-info pull-right">${chanceCount }</span>
                            	</a>
                            </li>
                            <li>
                            	<a href="${ctx}/crm/crmQuote/list?customer.id=${crmCustomer.id}&customer.name=${crmCustomer.name}" target="crmContent">
                            		<i class="fa fa-file-o"></i> <span class="nav-label">报价单 </span><span class="badge badge-info pull-right">${quoteCount }</span>
                            	</a>
                            </li>
                            <li>
                            	<a href="${ctx}/om/omContract/list?customer.id=${crmCustomer.id}&customer.name=${crmCustomer.name}" target="crmContent">
                            		<i class="fa fa-file-text"></i> <span class="nav-label">订单合同 </span><span class="badge badge-info pull-right">${contactCount }</span>
                            	</a>
                            </li>
                            <li>
                            	<a href="${ctx}/fi/fiReceiveAble/list?customer.id=${crmCustomer.id}&customer.name=${crmCustomer.name}" target="crmContent">
                            		<i class="fa fa-strikethrough"></i> <span class="nav-label">应收款 </span><span class="badge badge-info pull-right">${receiveAbleCount }</span>
                            	</a>
                            </li>
                            <li>
                            	<a href="${ctx}/oa/oaTask/list?relationId=${crmCustomer.id}&relationName=${crmCustomer.name}" target="crmContent">
                            		<i class="fa fa-bell-o"></i> <span class="nav-label">任务 </span><span class="badge badge-info pull-right">${taskCount }</span>
                            	</a>
                            </li>
                            <li>
                            	<a href="${ctx}/iim/myCalendar/myCalendarList?customerId=${crmCustomer.id}" target="crmContent">
                            		<i class="fa fa-calendar-check-o"></i> <span class="nav-label">日程 </span><span class="badge badge-info pull-right">${calendarCount }</span>
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
        	<div class="col-sm-10" style="padding-left:0;margin-top: -20px;">
        		<div class="" style="height:800px">
		        	<iframe id="crmContent" name="crmContent" src="${ctx}/crm/crmCustomer/view?id=${crmCustomer.id}" width="100%" height="100%" frameborder="0"></iframe> 
		        </div>
            </div>
        </div>
    </div>
   
   
</body>
</html>