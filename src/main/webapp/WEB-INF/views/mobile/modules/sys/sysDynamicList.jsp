<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
  <head>
  	<title>团队动态</title>
    <%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
    <script type="text/javascript">
    	function toSearch(){
    		window.location.href = "${ctx}/mobile/sys/sysDynamic/search";
    	}
    	var page_no = 1;//当前页
    	var is_all = false;//已加载全部
    	$(document).ready(function() {
    		loadData();
    		//滚动条到底自动加载下一页
    		$(window).scroll(function() {
    			if ($(document).scrollTop() >= $(document).height() - $(window).height()) {
    				if(is_all == false){
    					loadData();
    				}                    
                }
    		});
    		
    		//监听返回事件
    		pushHistory();
    		window.addEventListener("popstate", function(e) {
    			location.href = "${ctx}/mobile/more";
    		}, false);
    	});
    	
    	function loadData(){	
    		
    	    $.ajax({
        		url:"${ctx}/mobile/sys/sysDynamic/listData",
        		data: {pageNo:page_no},
        		type:"POST",
        		async:true,    //或false,是否异步
        		dataType:'json',
        		success:function(data){	    			
        			if(data != null){	    				
        				setData(data.list);
        				
        				if(data.count == 0){
        					$(".weui-loadmore").hide();
        					$("#loadmore-panel").append("<div class=\"weui-loadmore weui-loadmore_line\"><span class=\"weui-loadmore__tips\">未查询到任何数据</span></div>");
        					is_all = true;
        				}
        				if(data.count >0 && data.count <= page_no*20){
        					$(".weui-loadmore").hide();
        					$("#loadmore-panel").append("<div class=\"weui-loadmore weui-loadmore_line\"><span class=\"weui-loadmore__tips\">已加载全部</span></div>");
        					is_all = true;
        				}
        				page_no++;
        			}
        		},
        		error:function(){
        			alert("服务器未响应");
        		}
        	});
        }
    	
    	var actionTypeDictList = getDictList("action_type");
    	var objectTypeDictList = getDictList("object_type");
    	
    	function setData(data){
    		
    		var html = "";
    		for(var i=0;i<data.length;i++){

    			var actionType = getDictLabel(actionTypeDictList, data[i].actionType);
    			var objectType = getDictLabel(objectTypeDictList, data[i].objectType);
    			
    			html += "<a href=\"javascript:void(0);\" class=\"weui-media-box weui-media-box_appmsg\" onclick=\"toView("+data[i].objectType+",'"+data[i].targetId+"');\">";
    			html += "<div class=\"weui-media-box__hd\">";
    			html += "<img class=\"weui-media-box__thumb\" src=\""+data[i].userPhoto+"\" onerror=\"this.src='${ctxStatic}/images/user.jpg'\">";
    			html += "</div>";
    			html += "<div class=\"weui-media-box__bd\">";
    			html += "<h4 class=\"weui-media-box__title\">"+ data[i].userName +" <i>"+ actionType+"了</i> "+objectType+"</h4>";
    			html += "<p class=\"weui-media-box__desc\">"+data[i].targetName+"</p>";
    			html += "<ul class=\"weui-media-box__info\">";
    			html += "<li class=\"weui-media-box__info__meta\">"+data[i].createDate+"</li>";
    			html += "</div>";
    			html += "</div>";
    			html += "</a>";
    		}
    		$("#list-panel").append(html);
    	}
    	
    	function toView(objectType, targetId){
    		
	    	//object_type对象类型    10：项目，11：任务，12:日报，13：通知，14：审批，20：客户，21：联系人，22：商机，23：报价，24：合同订单，25:沟通, 26:订单，27：退货单，30：产品：31：采购，32：入库，33：出库，34：移库，39：供应商，36：盘点，37:调拨，   50：应收款，51：应付款， 52：收款单，53：付款单
	    	if(objectType == "11"){//任务
	    		window.location.href = "${ctx}/mobile/oa/oaTask/view?id="+targetId;
	    	}
	    	if(objectType == "20"){//客户
	    		window.location.href = "${ctx}/mobile/crm/crmCustomer/index?id="+targetId;
	    	}
	    	if(objectType == "18"){//市场活动
	    		window.location.href = "${ctx}/mobile/crm/crmMarket/view?id="+targetId;
	    	}
	    	if(objectType == "19"){//销售线索
	    		window.location.href = "${ctx}/mobile/crm/crmClue/index?id="+targetId;
	    	}
	    	if(objectType == "21"){//联系人
	    		window.location.href = "${ctx}/mobile/crm/crmContacter/index?id="+targetId;
	    	}
	    	if(objectType == "22"){//商机
	    		window.location.href = "${ctx}/mobile/crm/crmChance/index?id="+targetId;
	    	}
	    	if(objectType == "23"){//报价
	    		window.location.href = "${ctx}/mobile/crm/crmQuote/view?id="+targetId;
	    	}
	    	if(objectType == "24"){//合同订单
	    		window.location.href = "${ctx}/mobile/om/omContract/index?id="+targetId;
	    	}
	    	if(objectType == "25"){//沟通
	    		window.location.href = "${ctx}/mobile/crm/crmContactRecord/view?id="+targetId;
	    	}
	    	if(objectType == "26"){//订单
	    		window.location.href = "${ctx}/mobile/om/omOrder/index?id="+targetId;
	    	}
	    	if(objectType == "28"){//工单
	    		window.location.href = "${ctx}/mobile/crm/crmService/view?id="+targetId;
	    	}
	    	if(objectType == "27"){//退货单
	    		window.location.href = "${ctx}/mobile/om/omReturnorder/view?id="+targetId;
	    	}
	    	if(objectType == "39"){
	    		openDialogView("供应商", "${ctx}/mobile/wms/wmsSupplier/view?id="+targetId, '800px', '500px');
	    	}
	    	if(objectType == "31"){//采购单
	    		window.location.href = "${ctx}/mobile/wms/wmsPurchase/view?id="+targetId;
	    	}
	    	if(objectType == "32"){//入库单
	    		window.location.href = "${ctx}/mobile/wms/wmsInstock/view?id="+targetId;
	    	}
	    	if(objectType == "33"){//出库单
	    		window.location.href = "${ctx}/mobile/wms/wmsOutstock/view?id="+targetId;
	    	}
	    	if(objectType == "50"){//应收款
	    		window.location.href = "${ctx}/mobile/fi/fiReceiveAble/view?id="+targetId;
	    	}
	    	if(objectType == "51"){//应付款
	    		window.location.href = "${ctx}/mobile/fi/fiPaymentAble/index?id="+targetId;
	    	}
	    	if(objectType == "52"){
	    		window.location.href = "${ctx}/mobile/fi/fiReceiveBill/view?id="+targetId;
	    	}
	    	if(objectType == "53"){
	    		window.location.href = "${ctx}/mobile/fi/fiPaymentBill/view?id="+targetId;
	    	}
	    }
    </script>
  </head>
  <body ontouchstart>
  	
  	<div class="page">
      <div class="page__bd">
        <mobile:searchBar modelName="sysDynamic" url="${ctx}/mobile/sys/sysDynamic"></mobile:searchBar>
    
		<div class="weui-panel weui-panel_access margin-top0" id="list-panel">
	        <div class="weui-panel__bd">
	        </div>
	    </div>
	    <div id="loadmore-panel"></div>
	    <div class="weui-loadmore">
	      <i class="weui-loading"></i>
	      <span class="weui-loadmore__tips">正在加载</span>
	    </div>
     </div>
    </div> 
    
  </body>
</html>
