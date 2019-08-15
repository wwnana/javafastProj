<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
  <head>
  	<title>即将到期客户（到期后自动回收）</title>
    <%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
    <script type="text/javascript">

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
        		url:"${ctx}/mobile/crm/crmCustomerRemind/listData",
        		data: {pageNo:page_no, name:'${crmCustomer.name}', customerType:'${crmCustomer.customerType}', customerStatus:'${crmCustomer.customerStatus}', customerLevel:'${crmCustomer.customerLevel}'},
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
    	
    	var customerStatusDictList = getDictList("customer_status");
    	var customerLevelDictList = getDictList("customer_level");
    	
    	function setData(data){
    		var html = "";
    		for(var i=0;i<data.length;i++){
    			
    			var customerStatus = getDictLabel(customerStatusDictList, data[i].customerStatus);
    			var customerLevel = getDictLabel(customerLevelDictList, data[i].customerLevel);
    			
    			var ownByName = data[i].ownBy.name;
    			if(ownByName==null || ownByName == "null"){
    				ownByName = "";
    			}else{
    				ownByName = " | "+data[i].ownBy.name;
    			}
    			
    			var date2 = new Date();
    			var date1 = new Date(data[i].updateDate);
    			var s1 = date1.getTime(),s2 = date2.getTime();
    			var total = (s2 - s1)/1000;
    			 
    			 
    			var day = parseInt(total / (24*60*60));//计算整数天数
    			var diffDay = 30 - day;
    			
    			html += "<div class=\"weui-media-box weui-media-box_text\" onclick=\"viewData('"+ data[i].id +"','"+ data[i].name +"')\" >";
    			html += "<span class=\"weui-body-box_right font-red\">"+ diffDay +"天后回收</span>";
    			html += "<h4 class=\"weui-media-box__title\">"+ data[i].name +"</h4>";
    			html += "<p class=\"weui-media-box__desc\">"+customerStatus +" | "+ customerLevel + ownByName +"</p>";
    			html += "<ul class=\"weui-media-box__info\">";
    			html += "<li class=\"weui-media-box__info__meta\">最后更新："+ data[i].updateDate +"</li>";
    			html += "<li class=\"weui-media-box__info__meta weui-media-box__info__meta_extra\">"+ day +"天未跟进</li>";
    			html += "</ul>";
    			html += "</div>";
    		}
    		$("#list-panel").append(html);
    	}
    	function viewData(id, name){
    		window.location.href="${ctx}/mobile/crm/crmCustomer/index?id="+id;
    	}
    </script>
  </head>
  <body ontouchstart>
  
  <div class="page">
    <div class="page__bd">
        <mobile:searchBar modelName="crmCustomer" url="${ctx}/mobile/crm/crmCustomerRemind"></mobile:searchBar>
    
		<div class="weui-panel weui-panel_access margin-top0" id="list-panel">
	        <div class="weui-panel__bd">
	        </div>
	    </div>
	    
     </div>
     <div id="loadmore-panel"></div>
	 <div class="weui-loadmore">
	      <i class="weui-loading"></i>
	      <span class="weui-loadmore__tips">正在加载</span>
	 </div>
  </div>
	
     <div class="weui-tabbar">
     	
	 </div>
  </body>
</html>
