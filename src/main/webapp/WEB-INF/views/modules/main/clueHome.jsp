<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<jsp:useBean id="now" class="java.util.Date" />     
<fmt:formatDate value="${now}" type="both" dateStyle="long" pattern="yyyy-MM-dd" var="nowDate"/> 
<html>
<head>
	<title>线索主页</title>
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
							<h5>市场活动及线索简报</h5>
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
					                        <h5>活动数量</h5>
					                        <h1 class="no-margins text-success">${crmMarketPage.count}&nbsp;</h1>
					                        <div class="stat-percent font-bold text-danger"></div>
					                        <small>（个）</small>
					                    </div>
					                </div>
					            </div>
					            <div class="col-sm-6">
					                <div class="ibox">
					                    <div class="ibox-content gray-bg">
					                        <h5>待转化线索数量</h5>
					                        <h1 class="no-margins text-info">${crmCluePage.count}&nbsp;</h1>
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
	                        <h3>活动</h3>
	                        <p class="small"><i class="fa fa-hand-o-up"></i> 近期市场活动</p>
	                        <ul class="sortable-list connectList agile-list ui-sortable">
	                            <c:forEach items="${crmMarketPage.list}" var="crmMarket">
	                            <li onclick="location='${ctx}/crm/crmMarket/index?id=${crmMarket.id}'" class="success-element">
	                               ${crmMarket.name }
	                                <div class="agile-detail">
	                                    <a href="${ctx}/crm/crmMarket/index?id=${crmMarket.id}" class="pull-right btn btn-xs btn-white">${fns:getDictLabel(crmMarket.marketType, 'market_type', '')}</a>
	                                    <i class="fa fa-clock-o"></i> <fmt:formatDate value="${crmMarket.createDate}" pattern="yyyy-MM-dd"/>
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
	                        <h3>线索</h3>
	                        <p class="small"><i class="fa fa-hand-o-up"></i> 待转化线索</p>
	                        <ul class="sortable-list connectList agile-list ui-sortable">
	                            <c:forEach items="${crmCluePage.list}" var="crmClue">
	                            <li onclick="location='${ctx}/crm/crmClue/index?id=${crmClue.id}'" class="success-element">
	                               ${crmClue.name }
	                                <div class="agile-detail">
	                                    <a href="${ctx}/crm/crmClue/index?id=${crmClue.id}" class="pull-right btn btn-xs btn-white">${fns:getDictLabel(crmClue.sourType, 'sour_type', '')}</a>
	                                    <i class="fa fa-clock-o"></i> <fmt:formatDate value="${crmClue.createDate}" pattern="yyyy-MM-dd"/>
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