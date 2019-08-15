<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>主页</title>
	<meta name="decorator" content="default"/>    
	
	<style type="text/css">
		.ibox {
			
			min-height:110px;
		}
		.ibox-title {
			
		}
		.widget-text-box2 {
		    padding: 20px;
		    border-top: 1px solid #e7eaec;
		    background: #ffffff;
		}
		button {min-width:160px;}
		button span{
		}
		.panel-body{
			min-height: 400px;
		}
		.ibox-content {
			min-height: 400px;
		}
		.mt80{
			margin-top: 80px;
		}
	</style>
    <script type="text/javascript">
	    $(document).ready(function() {
	    	
	    	
	    	//setInterval(function(){$("#currentTime").html(current)},1000);
	    	getNotepaper();
	    });
	    
	    function current(){
		    var d=new Date(),str='';
		    $("#currentDate").html(d.getFullYear()+"/"+d.getMonth()+1+"/"+d.getDate());		    
		    str +=d.getHours()+':';
		    str +=d.getMinutes()+':';
		    str +=d.getSeconds()+'';
		    return str; 
	    }
	   
	    function getNotepaper(){	    	
		    $.ajax({
	    		url:"${ctx}/oa/oaNote/getNote",
	    		type:"POST",
	    		async:true,    //或false,是否异步
	    		dataType:'json',
	    		success:function(data){	    			
	    			if(data != null && data != "false" && data.notes != null){	    				
	    				$("#notepaper").val(data.notes);
	    			}
	    		},
	    		error:function(){
	    			//alert("出错");
	    		}
	    	});
	    }
	    function saveNotepaper(){
	    	var notepaper = $("#notepaper").val();
	    	$.ajax({
	    		url:"${ctx}/oa/oaNote/saveNote",
	    		type:"POST",
	    		async:true,    //或false,是否异步
	    		data:{notes:notepaper},
	    		dataType:'json',
	    		success:function(data){
	    			//alert(data);
	    		},
	    		error:function(){
	    			//alert("出错");
	    		}
	    	});
	    }
	    function toView(objectType, targetId){
	    	//object_type对象类型    10：项目，11：任务，12:日报，13：通知，14：审批，20：客户，21：联系人，22：商机，23：报价，24：合同订单，25:沟通, 26:订单，27：退货单，30：产品：31：采购，32：入库，33：出库，34：移库，39：供应商，36：盘点，37:调拨，   50：应收款，51：应付款， 52：收款单，53：付款单
	    	if(objectType == "11"){//任务
	    		window.location.href = "${ctx}/oa/oaTask/view?id="+targetId;
	    	}
	    	if(objectType == "20"){//客户
	    		window.location.href = "${ctx}/crm/crmCustomer/index?id="+targetId;
	    	}
	    	if(objectType == "18"){//市场活动
	    		window.location.href = "${ctx}/crm/crmMarket/index?id="+targetId;
	    	}
	    	if(objectType == "19"){//销售线索
	    		window.location.href = "${ctx}/crm/crmClue/index?id="+targetId;
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
	    	if(objectType == "28"){//工单
	    		window.location.href = "${ctx}/crm/crmService/index?id="+targetId;
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
		
		
		<div class="row" style="padding-bottom: 10px;">
			<div class="col-sm-1">
			</div>
			<div class="col-sm-6">
							<div class="btn-group">
                                <button data-toggle="dropdown" class="btn btn-default btn-sm dropdown-toggle">
                                	<span class="pull-left">
	                                	<c:if test="${userType==0}">
	                                		<img alt="image" class="img-circle" src="${fns:getUser().photo}" style="width: 20px;height: 20px;" onerror="this.src='${ctxStatic}/images/user.jpg'" /> ${fns:getUser().name} 
	                                	</c:if>
	                                	<c:if test="${userType==1}">
	                                		<img alt="image" class="img-circle" src="${ctxStatic}/images/user.jpg" style="width: 20px;height: 20px;" /> 全公司
	                                	</c:if>
                                	</span>
                                	<span class="caret pull-right" style="margin-top: 8px;"></span>
                                </button>
                                <ul class="dropdown-menu">
                                    <li><a href="${ctx}/home?userType=0&dateType=${dateType}"><img alt="image" class="img-circle" src="${fns:getUser().photo}" style="width: 20px;height: 20px;" onerror="this.src='${ctxStatic}/images/user.jpg'" /> ${fns:getUser().name}</a>
                                    </li>
                                    
                                    <li><a href="${ctx}/home?userType=1&dateType=${dateType}"><img alt="image" class="img-circle" src="${ctxStatic}/images/user.jpg" style="width: 20px;height: 20px;" /> 全公司</a>
                                    </li>
                                </ul>
                            </div>
                            <div class="btn-group">
                                <button data-toggle="dropdown" class="btn btn-default btn-sm dropdown-toggle">
                                <span class="pull-left" style="height: 20px">
                                	
                                	<c:if test="${dateType=='C'}">今天</c:if>
                                	<c:if test="${dateType=='W'}">本周</c:if>
                                	<c:if test="${dateType=='LW'}">上周</c:if>
                                	<c:if test="${dateType=='M'}">本月</c:if>
                                	<c:if test="${dateType=='LM'}">上月</c:if>
                                	<c:if test="${dateType=='Q'}">本季度</c:if>
                                	<c:if test="${dateType=='Y'}">本年度</c:if>
                                </span>
                                <span class="caret pull-right" style="margin-top: 8px;"></span>
                                </button>
                                <ul class="dropdown-menu">
                                    <li><a href="${ctx}/home?userType=${userType}&dateType=C">今天</a></li>
                                    <li class="divider"></li>
                                    <li><a href="${ctx}/home?userType=${userType}&dateType=W">本周</a></li>
                                   
                                    <li><a href="${ctx}/home?userType=${userType}&dateType=LW">上周</a></li>
                                    <li class="divider"></li>
                                    <li><a href="${ctx}/home?userType=${userType}&dateType=M">本月</a></li>
                                    
                                    <li><a href="${ctx}/home?userType=${userType}&dateType=LM">上月</a></li>
                                    <li class="divider"></li>
                                    <li><a href="${ctx}/home?userType=${userType}&dateType=Q">本季度</a></li>
                                    
                                    <li><a href="${ctx}/home?userType=${userType}&dateType=Y">本年度</a></li>
                                </ul>
                            </div>
			</div>
			<div class="col-sm-6 text-right">
				
			</div>
		</div>
		
		<div class="row">
			<div class="col-sm-1">
			</div>
			<div class="col-sm-5">
				<div class="ibox">
					<div class="ibox-title">
						<h5>销售简报</h5>
						<div class="ibox-tools">
	                    	<span class="label"><c:if test="${userType==0}">${fns:getUser().name}</c:if><c:if test="${userType==1}">本公司</c:if></span>
	                    	<span class="label"><c:if test="${dateType=='C'}">今天</c:if><c:if test="${dateType=='W'}">本周</c:if><c:if test="${dateType=='LW'}">上周</c:if><c:if test="${dateType=='M'}">本月</c:if><c:if test="${dateType=='LM'}">上月</c:if><c:if test="${dateType=='Q'}">本季度</c:if><c:if test="${dateType=='Y'}">本年度</c:if></span>
	                    </div>
					</div>
                    <div class="ibox-content">
                    	<div class="row">
                    		<div class="col-sm-6">
                    			<div class="alert alert-info">
		                           	 创建客户数 <span class="pull-right">${crmSimpleReport.createNum}</span>
		                        </div>
                    		</div>
                    		<div class="col-sm-6">
                    			<div class="alert alert-info">
		                           	 负责客户数 <span class="pull-right">${crmSimpleReport.ownNum}</span>
		                        </div>
                    		</div>
                    		<div class="col-sm-6">
                    			<div class="alert alert-info">
		                           	 创建商机数<span class="pull-right">${crmSimpleReport.createChangeNum}</span>
		                        </div>
                    		</div>
                    		<div class="col-sm-6">
                    			<div class="alert alert-info">
		                           	 负责商机数<span class="pull-right">${crmSimpleReport.ownChangeNum}</span>
		                        </div>
                    		</div>
                    		<div class="col-sm-6">
                    			<div class="alert alert-info">
		                           	 订单总额 <span class="pull-right">${crmSimpleReport.createOrderAmt}</span>
		                        </div>
                    		</div>
                    		<div class="col-sm-6">
                    			<div class="alert alert-info">
		                           	 回款总额 <span class="pull-right">${crmSimpleReport.recOrderAmt}</span>
		                        </div>
                    		</div>
                    	</div>
                        
                    </div>
                </div>
                <div class="ibox">
					<div class="ibox-title">
						<h5>销售漏斗</h5>
						<div class="ibox-tools">
	                    	<span class="label"><c:if test="${userType==0}">${fns:getUser().name}</c:if><c:if test="${userType==1}">本公司</c:if></span>
	                    	<span class="label"><c:if test="${dateType=='C'}">今天</c:if><c:if test="${dateType=='W'}">本周</c:if><c:if test="${dateType=='LW'}">上周</c:if><c:if test="${dateType=='M'}">本月</c:if><c:if test="${dateType=='LM'}">上月</c:if><c:if test="${dateType=='Q'}">本季度</c:if><c:if test="${dateType=='Y'}">本年度</c:if></span>
	                    </div>
					</div>
                    <div class="ibox-content">
                    	<%@ include file="/WEB-INF/views/include/echarts.jsp"%>
						<div id="funnel"  class="main000"></div>
						<echarts:funnel
						    id="funnel"
							title="销售漏斗" 
							subtitle="（商机金额）"
							orientData="${orientData}"/>
							
                    </div>
                </div>
                <div class="ibox">
					<div class="ibox-title">
						<h5>线索转化</h5>
						<div class="ibox-tools">
	                    	<span class="label"><c:if test="${userType==0}">${fns:getUser().name}</c:if><c:if test="${userType==1}">本公司</c:if></span>
	                    	<span class="label"><c:if test="${dateType=='C'}">今天</c:if><c:if test="${dateType=='W'}">本周</c:if><c:if test="${dateType=='LW'}">上周</c:if><c:if test="${dateType=='M'}">本月</c:if><c:if test="${dateType=='LM'}">上月</c:if><c:if test="${dateType=='Q'}">本季度</c:if><c:if test="${dateType=='Y'}">本年度</c:if></span>
	                    </div>
					</div>
                    <div class="ibox-content forum-container">

                            <div class="forum-title">
                                <div class="pull-right forum-desc">
                                    <samll>线索总数： ${crmClueReport.totalClueNum }</samll>
                                </div>
                                <h3>线索</h3>
                            </div>

                            <div class="forum-item active">
                                <div class="row">
                                    <div class="col-sm-10">
                                        <div class="forum-icon">
                                            <i class="fa fa-shield"></i>
                                        </div>
                                        <a href="#" class="forum-item-title">转化为客户</a>
                                        <div class="forum-sub-title">转化为客户的线索数/转化率</div>
                                    </div>
                                    <div class="col-sm-1 forum-info">
                                        <span class="views-number">
                                            ${crmClueReport.toCustomerNum }
                                        </span>
                                        <div>
                                            <small>客户</small>
                                        </div>
                                    </div>
                                    <div class="col-sm-1 forum-info">
                                        <span class="views-number">
                                        	<c:if test="${crmClueReport.totalClueNum == 0}">0%</c:if>
                                        	<c:if test="${crmClueReport.totalClueNum != 0}">
                                        		<fmt:formatNumber type="number" value="${crmClueReport.toCustomerNum*100/crmClueReport.totalClueNum}" pattern="#"/>%
                                        	</c:if>
                                        </span>
                                        <div>
                                            <small>转化率</small>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="forum-item active">
                                <div class="row">
                                    <div class="col-sm-10">
                                        <div class="forum-icon">
                                            <i class="fa fa-bolt"></i>
                                        </div>
                                        <a href="#" class="forum-item-title">转化为商机</a>
                                        <div class="forum-sub-title">转化为商机的线索数/转化率</div>
                                    </div>
                                    <div class="col-sm-1 forum-info">
                                        <span class="views-number">
                                            ${crmClueReport.toChanceNum }
                                        </span>
                                        <div>
                                            <small>商机</small>
                                        </div>
                                    </div>
                                    <div class="col-sm-1 forum-info">
                                        <span class="views-number">
                                        	<c:if test="${crmClueReport.totalClueNum == 0}">0%</c:if>
                                        	<c:if test="${crmClueReport.totalClueNum != 0}">
                                            	<fmt:formatNumber type="number" value="${crmClueReport.toChanceNum*100/crmClueReport.totalClueNum}" pattern="#"/>%
                                            </c:if>
                                        </span>
                                        <div>
                                            <small>转化率</small>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="forum-item active">
                                <div class="row">
                                    <div class="col-sm-10">
                                        <div class="forum-icon">
                                            <i class="fa fa-bookmark"></i>
                                        </div>
                                        <a href="#" class="forum-item-title">转化为订单</a>
                                        <div class="forum-sub-title">转化为订单的线索数/转化率</div>
                                    </div>
                                    <div class="col-sm-1 forum-info">
                                        <span class="views-number">
                                            ${crmClueReport.toOrderNum }
                                        </span>
                                        <div>
                                            <small>订单</small>
                                        </div>
                                    </div>
                                    <div class="col-sm-1 forum-info">
                                        <span class="views-number">
                                        	<c:if test="${crmClueReport.totalClueNum == 0}">0%</c:if>
                                        	<c:if test="${crmClueReport.totalClueNum != 0}">
                                           		<fmt:formatNumber type="number" value="${crmClueReport.toOrderNum*100/crmClueReport.totalClueNum}" pattern="#"/>%
                                           	</c:if>
                                        </span>
                                        <div>
                                            <small>转化率</small>
                                        </div>
                                    </div>
                                </div>
                            </div>


                        </div>
                        
                </div>
                <div class="ibox">
					<div class="ibox-title">
						<h5>销售排行（已确认的销售额前5名）</h5>
						<div class="ibox-tools">
	                    	<span class="label">全公司</span>
	                    	<span class="label"><c:if test="${dateType=='C'}">今天</c:if><c:if test="${dateType=='W'}">本周</c:if><c:if test="${dateType=='M'}">本月</c:if><c:if test="${dateType=='Q'}">本季度</c:if><c:if test="${dateType=='Y'}">本年度</c:if></span>
	                    </div>
					</div>
                    <div class="ibox-content">
                    	<c:forEach items="${crmReportRankList}" var="crmReport" varStatus="status" begin="0" end="4">
                    		<div>
                                      <span>${status.index+1}.${crmReport.userName}</span>
                                      <small class="pull-right">${crmReport.createOrderAmt }</small>
                            </div>
                            
							<div class="progress progress-small">
                            	<div style="width: <c:if test='${not empty crmReport.createOrderAmt && not empty firstCrmReport.createOrderAmt && crmReport.createOrderAmt!=0 && firstCrmReport.createOrderAmt!=0}'>${crmReport.createOrderAmt*100/firstCrmReport.createOrderAmt}%</c:if>;" class="progress-bar"></div>
                            </div>
                    	</c:forEach>
                    </div>
                </div>
                <%--
                <div class="ibox float-e-margins">
                    <div class="ibox-title">                        
                        <h5>实时分析</h5>
                    </div>
                    <div class="ibox-content">
                    	
                    	<iframe src="${ctx}/gen/genReport/report?id=5789942713371268318" style="width:100%;height:380px;border:0;overflow-y : hidden;" ></iframe>
            
                    	
                    </div>
                </div>
                 --%>
				
	       		
	       		
	       		
	       		
                
			</div>
			<div class="col-sm-5">
				<div class="ibox float-e-margins hide">
					
	                <div class="widget-head-color-box white-bg p-lg text-center" style="padding-top: -10px;margin-top: 0;">
	                    <div class="mt10">
		                    <a href="${ctx }/sys/sysAccount/set" target="mainFrame">
		      					<img src="${fns:getSysAccount().logo}" alt="${fns:getSysAccount().name}" class=" m-b-md"  onerror="this.src='${ctxStatic}/images/user.jpg'" style="width: 100px;height:100px;">
		                    </a>
	                    </div>
	                    <div>
	                        <span>${fns:getSysAccount().name}</span>
	                    </div>
	                </div>
	                <div class="widget-text-box2">
	                    <p>当前版本</p>
	                    <p><c:if test="${sysAccount.payStatus != 1}">免费版</c:if><c:if test="${sysAccount.payStatus == 1}">付费版</c:if></p>
	                    <br>
	                    <p>授权信息</p>
	                    <div>
                             <span>用户数</span>
                             <small class="pull-right">${fns:getSysAccount().nowUserNum}/${fns:getSysAccount().maxUserNum} 个</small>
                         </div>
                         <div class="progress progress-small">
                             <div style="width: ${fns:getSysAccount().nowUserNum*100 / fns:getSysAccount().maxUserNum}%;" class="progress-bar"></div>
                         </div>
	                </div>
	            </div>
	            <div class="ibox float-e-margins hide">
	                <div class="widget-text-box2">
	                    <h4 class="media-heading">${fns:getUser().name}</h4>
	                    <p>${fns:getUser().company.name} - ${fns:getUser().office.name}</p>
	                    <p>上次登录：<fmt:formatDate value="${fns:getUser().oldLoginDate}" pattern="yyyy-MM-dd HH:mm"/></p>
	                    <div class="text-right hide">
	                        <a class="btn btn-xs btn-white"><i class="fa fa-thumbs-up"></i> 我的任务 </a>
	                        <a class="btn btn-xs btn-white"><i class="fa fa-heart"></i> 我的日程</a>
	                    </div>
	                </div>
	            </div>
	            <div class="ibox float-e-margins hide">
                    <div class="ibox-title">                        
                        <h5>通知公告</h5>
                        <div class="ibox-tools">
                            <a href="${ctx}/oa/oaNotify/self" target="mainFrame"><i class="fa fa-chevron-right"></i></a>
                    	</div>
                    </div>
                    <div class="ibox-content no-padding">
                    	<c:if test="${fn:length(newNotifyPage.list) == 0}">
                   			<p>暂无公告！<a href="${ctx}/oa/oaNotify/form">创建公告</a></p>
                   		</c:if>
                   		<ul class="list-group">
                    	<c:forEach items="${newNotifyPage.list }" var="newNotify" begin="0" end="5">
                    		 <li class="list-group-item" >
                    		 		<a href="${ctx}/oa/oaNotify/view?id=${newNotify.id}">${fns:abbr(newNotify.title,50)}</a>
                    		 </li>
                    	</c:forEach> 
                    	</ul>                   	
                    </div>
                </div>
                <div class="ibox float-e-margins hide">
                    <div class="ibox-title">
                        <h5>我的便笺</h5>
                    </div>
                    <div class="ibox-content no-padding">
                    	<textarea id="notepaper" name="notepaper" rows="" cols="" class="form-control" style="height: 100px;width: 100%;border:0;" onblur="saveNotepaper()" placeholder="便签中的内容会存储在本地，这样即便你关掉了浏览器，在下次打开时，依然会读取到上一次的记录。是一个非常方便的备忘小工具。"></textarea>
                    </div>
                </div>
                <div class="tabs-container">
                    <ul class="nav nav-tabs">
                        <li class="active">
                        	<a data-toggle="tab" href="#tab-1" aria-expanded="true"> 待办订单 <c:if test="${omContractPage.count > 0}"><span class="badge badge-danger">${omContractPage.count}</span></c:if></a>
                        </li>
                        <li class="">
                        	<a data-toggle="tab" href="#tab-2" aria-expanded="false">待办应收 <c:if test="${fiReceiveAblePage.count > 0}"><span class="badge badge-danger">${fiReceiveAblePage.count}</span></c:if></a>
                        </li>
                        <li class="">
                        	<a data-toggle="tab" href="#tab-3" aria-expanded="false">待办工单 <c:if test="${crmServicePage.count > 0}"><span class="badge badge-danger">${crmServicePage.count}</span></c:if></a>
                        </li>
                        <li class="">
                        	<a data-toggle="tab" href="#tab-4" aria-expanded="false">待联系客户 <c:if test="${contactCustomerPage.count > 0}"><span class="badge badge-danger">${contactCustomerPage.count}</span></c:if></a>
                        </li>
                    </ul>
                    <div class="tab-content">
                        <div id="tab-1" class="tab-pane active">
                            <div class="panel-body">
                                <c:if test="${omContractPage.count == 0}">
									<p class="text-center text-muted mt80">暂无数据</p>
								</c:if>
								<c:if test="${omContractPage.count > 0}">
								<div class="table-responsive">
								<table id="contentTable" class="table table-bordered table-striped table-hover ">
									<thead>
										<tr>
											<th>订单名称</th>
											<th width="100px">订单金额</th>
											<th width="100px">负责人</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach items="${omContractPage.list }" var="omContract" varStatus="status">
											<tr>
												<td>
													<a href="${ctx}/om/omContract/index?id=${omContract.id}" title="查看">
														${omContract.name}
												</td>
												<td>
													${omContract.amount}
												</td>
												<td>
													${omContract.ownBy.name}
												</td>
											</tr>
										</c:forEach>
									</tbody>
								</table>
								</div>
								</c:if>
							
                            </div>
                        </div>
                        <div id="tab-2" class="tab-pane">
                            <div class="panel-body">
                                <strong></strong>
                            	<c:if test="${fiReceiveAblePage.count == 0}">
									<p class="text-center text-muted mt80">暂无数据</p>
								</c:if>
								<c:if test="${fiReceiveAblePage.count > 0}">
								<div class="table-responsive">
								<table id="contentTable" class="table table-bordered table-striped table-hover ">
									<thead>
										<tr>
											<th>应收金额</th>
											<th width="100px">应收日期</th>
											<th width="100px">负责人</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach items="${fiReceiveAblePage.list }" var="fiReceiveAble" varStatus="status">
											<tr>
												<td>
													<a href="${ctx}/fi/fiReceiveAble/index?id=${fiReceiveAble.id}" title="查看">
														${fiReceiveAble.amount}
												</td>
												<td>
													<fmt:formatDate value="${fiReceiveAble.ableDate}" pattern="yyyy-MM-dd"/> 
												</td>
												<td>
													${fiReceiveAble.ownBy.name}
												</td>
											</tr>
										</c:forEach>
									</tbody>
								</table>
								</div>
								</c:if>
                            </div>
                        </div>
                        <div id="tab-3" class="tab-pane">
                            <div class="panel-body">
                                <strong></strong>
                            	<c:if test="${crmServicePage.count == 0}">
									<p class="text-center text-muted mt80">暂无数据</p>
								</c:if>
								<c:if test="${crmServicePage.count > 0}">
								<div class="table-responsive">
								<table id="contentTable" class="table table-bordered table-striped table-hover ">
									<thead>
										<tr>
											<th>工单编号</th>
											<th width="100px">截止日期</th>
											<th width="100px">负责人</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach items="${crmServicePage.list }" var="crmService" varStatus="status">
											<tr>
												<td>
													<a href="${ctx}/crm/crmService/index?id=${crmService.id}" title="查看">
														${crmService.no}
												</td>
												<td>
													<fmt:formatDate value="${crmService.endDate}" pattern="yyyy-MM-dd"/>
												</td>
												<td>
													${crmService.ownBy.name}
												</td>
											</tr>
										</c:forEach>
									</tbody>
								</table>
								</div>
								</c:if>
                            </div>
                        </div>
                        <div id="tab-4" class="tab-pane">
                            <div class="panel-body">
                                <strong></strong>
                            	<p></p>
                                <c:if test="${contactCustomerPage.count == 0}">
									<p class="text-center text-muted mt80">暂无数据</p>
								</c:if>
								<c:if test="${contactCustomerPage.count > 0}">
								<div class="table-responsive">
								<table id="contentTable" class="table table-bordered table-striped table-hover ">
									<thead>
										<tr>
											<th>客户名称</th>
											<th width="100px">联系日期</th>
											<th width="100px">负责人</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach items="${contactCustomerPage.list }" var="crmCustomer" varStatus="status">
											<tr>
												<td>
													<a href="${ctx}/crm/crmCustomer/index?id=${crmCustomer.id}" title="查看">
														${crmCustomer.name}
												</td>
												<td>
													<fmt:formatDate value="${crmCustomer.nextcontactDate}" pattern="yyyy-MM-dd"/> 
												</td>
												<td>
													${crmCustomer.ownBy.name}
												</td>
											</tr>
										</c:forEach>
									</tbody>
								</table>
								</div>
								</c:if>
                            </div>
                        </div>
                    </div>


                </div>
		                
                
                
                
                <shiro:hasPermission name="om:omContract:list">
                <div class="ibox float-e-margins hide">
						<div class="ibox-title">
							<h5>待办订单 <c:if test="${omContractPage.count > 0}"><span class="badge badge-danger">${omContractPage.count}</span></c:if></h5>
							<div class="ibox-tools">
		                        <a class="" href="${ctx}/om/omContract?status=0">
		                            <i class="fa fa-chevron-right"></i>
		                        </a>
		                    </div>
						</div>
						<div class="ibox-content  ">
							<c:if test="${omContractPage.count == 0}">
								暂无数据
							</c:if>
							<c:if test="${omContractPage.count > 0}">
							<div class="table-responsive">
							<table id="contentTable" class="table ">
								<thead>
									<tr>
										<th>订单名称</th>
										<th width="100px">订单金额</th>
										<th width="100px">负责人</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${omContractPage.list }" var="omContract" varStatus="status">
										<tr>
											<td>
												<a href="${ctx}/om/omContract/index?id=${omContract.id}" title="查看">
													${omContract.name}
											</td>
											<td>
												${omContract.amount}
											</td>
											<td>
												${omContract.ownBy.name}
											</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
							</div>
							</c:if>
						</div>
				</div>
				</shiro:hasPermission>
				<shiro:hasPermission name="fi:fiPaymentAble:list">
				<div class="ibox float-e-margins hide">
						<div class="ibox-title">
							<h5>待办应收 <c:if test="${fiReceiveAblePage.count > 0}"><span class="badge badge-danger">${fiReceiveAblePage.count}</span></c:if></h5>
							<div class="ibox-tools">
		                        <a class="" href="${ctx}/fi/fiReceiveAble?status=0&ownBy.id=${fns:getUser().id}">
		                            <i class="fa fa-chevron-right"></i>
		                        </a>
		                    </div>
						</div>
						<div class="ibox-content  ">
							<c:if test="${fiReceiveAblePage.count == 0}">
								暂无数据
							</c:if>
							<c:if test="${fiReceiveAblePage.count > 0}">
							<div class="table-responsive">
							<table id="contentTable" class="table ">
								<thead>
									<tr>
										<th>应收金额</th>
										<th width="100px">应收日期</th>
										<th width="100px">负责人</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${fiReceiveAblePage.list }" var="fiReceiveAble" varStatus="status">
										<tr>
											<td>
												<a href="${ctx}/fi/fiReceiveAble/index?id=${fiReceiveAble.id}" title="查看">
													${fiReceiveAble.amount}
											</td>
											<td>
												<fmt:formatDate value="${fiReceiveAble.ableDate}" pattern="yyyy-MM-dd"/> 
											</td>
											<td>
												${fiReceiveAble.ownBy.name}
											</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
							</div>
							</c:if>
						</div>
				</div>
				</shiro:hasPermission>
				<shiro:hasPermission name="crm:crmService:list">
				<div class="ibox float-e-margins hide">
						<div class="ibox-title">
							<h5>待办工单 <c:if test="${crmServicePage.count > 0}"><span class="badge badge-danger">${crmServicePage.count}</span></c:if></h5>
							<div class="ibox-tools">
		                        <a class="" href="${ctx}/crm/crmService/list?status=0">
		                            <i class="fa fa-chevron-right"></i>
		                        </a>
		                    </div>
						</div>
						<div class="ibox-content  ">
							<c:if test="${crmServicePage.count == 0}">
								暂无数据
							</c:if>
							<c:if test="${crmServicePage.count > 0}">
							<div class="table-responsive">
							<table id="contentTable" class="table ">
								<thead>
									<tr>
										<th>工单编号</th>
										<th width="100px">截止日期</th>
										<th width="100px">负责人</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${crmServicePage.list }" var="crmService" varStatus="status">
										<tr>
											<td>
												<a href="${ctx}/crm/crmService/index?id=${crmService.id}" title="查看">
													${crmService.no}
											</td>
											<td>
												<fmt:formatDate value="${crmService.endDate}" pattern="yyyy-MM-dd"/>
											</td>
											<td>
												${crmService.ownBy.name}
											</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
							</div>
							</c:if>
						</div>
					</div>	
				</shiro:hasPermission>
				
                <div class="ibox float-e-margins hide">
                    <div class="ibox-title">
                        <h5>我的足迹</h5>
                        <div class="ibox-tools">
                            
                    	</div>
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
                
	            
	            <div class="ibox float-e-margins hide">    
	                <div class="ibox-content">
                         <div>
                             <span>空间</span>
                             <small class="pull-right">10/200 GB</small>
                         </div>
                         <div class="progress progress-small">
                             <div style="width: 60%;" class="progress-bar"></div>
                         </div>

                         <div>
                             <span>带宽</span>
                             <small class="pull-right">20 GB</small>
                         </div>
                         <div class="progress progress-small">
                             <div style="width: 50%;" class="progress-bar"></div>
                         </div>

                         <div>
                             <span>占用</span>
                             <small class="pull-right">73%</small>
                         </div>
                         <div class="progress progress-small">
                             <div style="width: 40%;" class="progress-bar"></div>
                         </div>

                         <div>
                             <span>FTP</span>
                             <small class="pull-right">400 GB</small>
                         </div>
                         <div class="progress progress-small">
                             <div style="width: 20%;" class="progress-bar progress-bar-danger"></div>
                         </div>
                     </div>
               </div>
               
               <div class="ibox float-e-margins" style="margin-top: 10px;">
	            	<div class="ibox-title">                        
	                	<h5>团队动态</h5>
	                	<div class="ibox-tools hide">
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
                                        <img alt="${sysDynamic.createBy.name}" class="img-circle" src="${sysDynamic.createBy.photo}" onerror="this.src='${ctxStatic}/images/user.jpg'">
                                    </a>
                                    <div class="media-body ">
                                        <small class="pull-right"><small class="text-muted">${fns:getTimeDiffer(sysDynamic.createDate)}</small></small>
                                        <strong><fmt:formatDate value="${sysDynamic.createDate}" pattern="MM/dd HH:mm"/> ${sysDynamic.createBy.name}</strong>&nbsp;&nbsp;<i>${fns:getDictLabel(sysDynamic.actionType, 'action_type', '')}了</i>&nbsp;&nbsp;${fns:getDictLabel(sysDynamic.objectType, 'object_type', '')}
                                        <p style="padding-top: 10px;">
                                            
											<c:if test="${sysDynamic.objectType != 20}">
												
												<a href="#" onclick="toView('${sysDynamic.objectType}','${sysDynamic.targetId}');">${sysDynamic.targetName}</a>
												
												<c:if test="${not empty sysDynamic.customerId}">（客户：<a href="${ctx}/crm/crmCustomer/index?id=${sysDynamic.customerId}">${sysDynamic.customerName}</a>）</c:if>
												 
											</c:if>
											<c:if test="${sysDynamic.objectType == 20}">
												<a href="#" onclick="toView('${sysDynamic.objectType}','${sysDynamic.targetId}');">${sysDynamic.targetName}</a>
											</c:if>
                                        </p>
                                        
                                    </div>
                                </div>                     	
		                        </c:forEach>
		                        
                            </div>
                           
                            <a href="${ctx}/sys/sysDynamic" class="btn btn-white btn-block m"><i class="fa fa-arrow-down"></i> 查看更多</a>
                            
                        </div>
                    </div>
	       		</div>
	            
			</div>
			
		</div>
		<div class="row">
			<div class="col-sm-3">
				
	            
	            
               
			</div>
			<div class="col-sm-6">
				
	       		
			</div>
			<div class="col-sm-3">
				
                
			</div>
		</div>
		
		
    </div>
   
   
</body>
</html>