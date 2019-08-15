<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
  <head>
  	<title>产品选择器</title>
    <%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
    <script type="text/javascript">

	
    	function toSearch(){
    		window.location.href = "${ctx}/mobile/wms/wmsProduct/search";
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
    			top.layer.closeAll();
    		}, false);
    	});
    	
    	function loadData(){	
    		
    	    $.ajax({
        		url:"${ctx}/mobile/wms/wmsProduct/listData",
        		data: {pageNo:page_no, name:$("#name").val(), customerType:$("#customerType").val(), customerStatus:$("#customerStatus").val(), customerLevel:$("#customerLevel").val()},
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
    			
    			html += "<div class=\"weui-media-box weui-media-box_text\" onclick=\"viewData('"+ data[i].id +"','"+ data[i].name +"','"+ data[i].salePrice +"')\" >";
    			html += "<span class=\"weui-body-box_right\"><i class=\"weui-icon-circle\"></i></span>";
    			html += "<h4 class=\"weui-media-box__title\">"+ data[i].name +"</h4>";
    			html += "<p class=\"weui-media-box__desc\">"+data[i].salePrice +"</p>";
    			html += "</div>";
    		}
    		$("#list-panel").append(html);
    	}
    	function viewData(id, name, price){
    		window.parent.$('#productId').val(id);
    		window.parent.$('#productName').val(name);
    		window.parent.$('#price').val(price);
    		window.parent.$('#num').val(1);
    		window.parent.comInput();
    		top.layer.closeAll();
    	}
    	
    </script>
  </head>
  <body ontouchstart>
  	<div class="page">
    <div class="page__bd">
        <mobile:searchBar modelName="wmsProduct" url="${ctx}/mobile/wms/wmsProduct"></mobile:searchBar>
    
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
