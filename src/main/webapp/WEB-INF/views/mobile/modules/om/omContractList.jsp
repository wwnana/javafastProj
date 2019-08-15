<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
  <head>
  	<title>合同管理</title>
    <%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
    <script type="text/javascript">
    	function toSearch(){
    		window.location.href = "${ctx}/mobile/om/omContract/search";
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
        		url:"${ctx}/mobile/om/omContract/listData",
        		data: {pageNo:page_no, no:'${omContract.no}', status:'${omContract.status}', ownById:'${omContract.ownBy.id}'},
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
    	function setData(data){
    		var html = "";
    		for(var i=0;i<data.length;i++){
    			
    			var status = getDictLabel(data[i].status, "audit_status");
    			
    			html += "<div class=\"weui-media-box weui-media-box_text\" onclick=\"viewData('"+ data[i].id +"','"+ data[i].name +"')\" >";
    			
    			if(data[i].status==0){
    				html += "<span class=\"weui-body-box_right font-red\">"+ status +"</span>";
    			}
    			if(data[i].status==1){
    				html += "<span class=\"weui-body-box_right font-blue\">"+ status +"</span>";
    			}
    			
    			html += "<h4 class=\"weui-media-box__title\">"+ data[i].name +"</h4>";
    			
    			html += "<p class=\"weui-media-box__desc\">"+ data[i].customer.name +"</p>";
    			html += "<ul class=\"weui-media-box__info\">";
    			html += "<li class=\"weui-media-box__info__meta\">¥"+ data[i].amount +"</li>";
    			html += "<li class=\"weui-media-box__info__meta weui-media-box__info__meta_extra\">"+ data[i].ownBy.name +"</li>";
    			html += "<li class=\"weui-media-box__info__meta weui-media-box__info__meta_extra\">"+ data[i].createDate +"</li>";
    			html += "</ul>";
    			html += "</div>";
    		}
    		$("#list-panel").append(html);
    	}
    	function viewData(id, name){
    		window.location.href="${ctx}/mobile/om/omContract/index?id="+id;
    	}
    	function getDictLabel(val, type){
    		
    		if(type == "audit_status"){
    			if(val == "0"){
        			return "未审核";
        		}
        		if(val == "1"){
        			return "已审核";
        		}
    		}
    	}
    </script>
  </head>
  <body ontouchstart>
  	<div class="page">
      <div class="page__bd">
        <mobile:searchBar modelName="omContract" url="${ctx}/mobile/om/omContract"></mobile:searchBar>
    
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
     	<shiro:hasPermission name="om:omContract:add">
		<a href="${ctx}/mobile/om/omContract/form" class="weui-tabbar__item weui-navbar__item">
	          <p class="">新建合同</p>
		</a>
		</shiro:hasPermission>
		<a href="${ctx}/mobile/om/omContract/search" class="weui-tabbar__item weui-navbar__item">
	          <p class="">查询</p>
		</a>
	 </div>
  </body>
</html>
