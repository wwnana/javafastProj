<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
  <head>
  	<title>工单管理</title>
    <%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
    <script type="text/javascript">
    	function toSearch(){
    		window.location.href = "${ctx}/mobile/crm/crmService/search";
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
    			location.href = "${ctx}/mobile/menu";
    		}, false);
    	});
    	function loadData(){	
    		
    	    $.ajax({
        		url:"${ctx}/mobile/crm/crmService/listData",
        		data: {pageNo:page_no, name:'${crmService.name}', status:'${crmService.status}', ownById:'${crmService.ownBy.id}'},
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
    	var serviceTypeDictList = getDictList("service_type");
    	var statusDictList = getDictList("finish_status");
    	function setData(data){
    		var html = "";
    		for(var i=0;i<data.length;i++){
    			
    			var serviceType = getDictLabel(serviceTypeDictList, data[i].serviceType);
    			var status = getDictLabel(statusDictList, data[i].status);
    			
    			var customerName = "";
    			if(data[i].customer.name != null){
    				customerName = data[i].customer.name;
    			}
    			
    			var ownByName = data[i].ownBy.name;
    			if(ownByName == null){
    				ownByName = "";
    			}
    			
    			html += "<div class=\"weui-media-box weui-media-box_text\" onclick=\"viewData('"+ data[i].id +"','"+ data[i].name +"')\" >";
    			
    			if(data[i].status==0){
    				html += "<span class=\"weui-body-box_right font-red\">"+ status +"</span>";
    			}
    			if(data[i].status==1){
    				html += "<span class=\"weui-body-box_right font-green\">"+ status +"</span>";
    			}
    			if(data[i].status==2){
    				html += "<span class=\"weui-body-box_right font-blue\">"+ status +"</span>";
    			}
    			
    			
    			html += "<h4 class=\"weui-media-box__title\">"+ data[i].name +"</h4>";
    			html += "<p class=\"weui-media-box__desc\">"+ customerName +"</p>";
    			html += "<ul class=\"weui-media-box__info\">";
    			html += "<li class=\"weui-media-box__info__meta\">"+ ownByName +"</li>";
    			html += "<li class=\"weui-media-box__info__meta weui-media-box__info__meta_extra\">"+ serviceType +"</li>";
    			html += "<li class=\"weui-media-box__info__meta weui-media-box__info__meta_extra\">"+ data[i].createDate +"</li>";
    			html += "</ul>";
    			html += "</div>";
    		}
    		$("#list-panel").append(html);
    	}
    	function viewData(id, name){
    		window.location.href="${ctx}/mobile/crm/crmService/view?id="+id;
    	}
    	
    </script>
  </head>
  <body ontouchstart>
  	<mobile:message content="${message}"/>
  	<div class="page">
      <div class="page__bd">
        <mobile:searchBar modelName="crmService" url="${ctx}/mobile/crm/crmService"></mobile:searchBar>
    
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
    
    
     
      <div class="weui-tabbar">
     	<shiro:hasPermission name="crm:crmService:add">
		
		<a href="${ctx}/mobile/crm/crmService/form" class="weui-tabbar__item weui-navbar__item">
	          <p class="">新建工单</p>
		</a>
		
		</shiro:hasPermission>
		<a href="${ctx}/mobile/crm/crmService/search" class="weui-tabbar__item weui-navbar__item">
	          <p class="">查询</p>
		</a>
	 </div>
  </body>
</html>
