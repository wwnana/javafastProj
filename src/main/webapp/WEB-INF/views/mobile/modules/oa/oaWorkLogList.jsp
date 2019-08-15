<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
  <head>
  	<title>发送给我的工作报告</title>
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
    			location.href = "${ctx}/mobile/menu";
    		}, false);
    	});
    	function loadData(){	
    		
    	    $.ajax({
        		url:"${ctx}/mobile/oa/oaWorkLog/listData",
        		data: {pageNo:page_no,createId:$("#createId").val()},
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
    			var obj = eval('(' + data[i].createBy + ')');
    			
    			var log_type = getDictLabel(data[i].workLogType, "log_type");
    			
    			html += "<div class=\"weui-media-box weui-media-box_text\" onclick=\"viewData('"+ data[i].id +"','"+ data[i].name +"')\" >";
    			html += "<h4 class=\"weui-media-box__title\">["+ log_type +"] "+data[i].title +"</h4>";
    			html += "<p class=\"weui-media-box__desc\">"+data[i].createName +"</p>";
    			html += "</div>";
    		}
    		$("#list-panel").append(html);
    	}
    	function viewData(id, name){
    		window.location.href="${ctx}/mobile/oa/oaWorkLog/view?id="+id;
    	}
    	function toSearch(){
    		window.location.href = "${ctx}/mobile/oa/oaWorkLog/search";
    	}
    	
		function getDictLabel(val, type){
    		
    		if(type == "log_type"){
    			if(val == "0"){
        			return "日报";
        		}
        		if(val == "1"){
        			return "周报";
        		}
        		if(val == "2"){
        			return "月报";
        		}
    		}
    	}
    </script>
  </head>
  <body ontouchstart>
  
  <div class="page">
  	
      <div class="page__bd">
      	
        <mobile:searchBar modelName="oaWorkLog" url="${ctx}/mobile/oa/oaWorkLog"></mobile:searchBar>
	    <div class="weui-tab">
		      <div class="weui-navbar">
		        <a class="weui-navbar__item weui-bar__item_on" href="${ctx}/mobile/oa/oaWorkLog/self">
		          	汇报给我
		        </a>        
		        <a class="weui-navbar__item" href="${ctx}/mobile/oa/oaWorkLog/list">
		          	我的报告
		        </a>
		    </div>
			
	     </div>
	     
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
    
     
     <div class="weui-tabbar">
		<a href="${ctx}/mobile/oa/oaWorkLog/form" class="weui-tabbar__item weui-navbar__item">
	          <p class="">新建汇报</p>
		</a>
		
	 </div>
  </body>
</html>
