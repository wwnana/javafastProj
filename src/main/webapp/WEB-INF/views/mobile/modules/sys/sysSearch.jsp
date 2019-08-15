<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
  <head>
  	<title>搜索</title>
    <%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
    <script type="text/javascript">

	
    	function toSearch(){
    		window.location.href = "${ctx}/mobile/sys/sysSearch";
    	}
    	var page_no = 1;//当前页
    	var is_all = false;//已加载全部
    	$(document).ready(function() {
    		
    		$("#searchInput").click();
    		$(".weui-loadmore").hide();
    		
    		//监听手机输入键盘的搜索事件
            $("#searchInput").on('keypress', function(e) {
            	
            	var keycode = e.keyCode;
            	var searchContent = $(this).val();
            	if (keycode == '13') {
            		e.preventDefault();
            		if (searchContent == '') {
            			alertMsgBox('请输入检索内容！');
            		}else{
            			
            			$("#list-panel").empty();
            			loadData();
            		}
            	}
            });
    		
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
    			location.href = "${ctx}/mobile/index";
    		}, false);
    	});
    	
    	function loadData(){	
    		$(".weui-loadmore").show();
    		var searchInput = $("#searchInput").val();
    		
    	    $.ajax({
        		url:"${ctx}/mobile/sys/sysSearch/listData",
        		data: {pageNo:page_no, keyWords:searchInput},
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
    			
    			
    			
    			html += "<div class=\"weui-media-box weui-media-box_text\" onclick=\"viewData('"+ data[i].id +"','"+ data[i].type +"')\" >";
    			html += "<h4 class=\"weui-media-box__title\">"+ data[i].name +"</h4>";
    			
    			html += "</div>";
    		}
    		$("#list-panel").append(html);
    	}
    	function viewData(id, type){
    		if(type == 20){//客户
    			window.location.href="${ctx}/mobile/crm/crmCustomer/index?id="+id;
    		}
    		if(type == 21){//联系人
    			window.location.href="${ctx}/mobile/crm/crmContacter/index?id="+id;
    		}
    		if(type == 22){//商机
    			window.location.href="${ctx}/mobile/crm/crmChance/index?id="+id;
    		}
    		if(type == 24){//合同
    			window.location.href="${ctx}/mobile/om/omContract/index?id="+id;
    		}
    		if(type == 19){//线索
    			window.location.href="${ctx}/mobile/crm/crmClue/index?id="+id;
    		}
    	}
    </script>
  </head>
  <body ontouchstart>
  
  <div class="page">
  	<div class="page__bd">
        <!--<a href="javascript:;" class="weui-btn weui-btn_primary">点击展现searchBar</a>-->
        <div class="weui-search-bar" id="searchBar">
            <form class="weui-search-bar__form">
                <div class="weui-search-bar__box">
                    <i class="weui-icon-search"></i>
                    <input type="search" class="weui-search-bar__input" id="searchInput" placeholder="搜索" required/>
                    <a href="javascript:" class="weui-icon-clear" id="searchClear"></a>
                </div>
                <label class="weui-search-bar__label" id="searchText">
                    <i class="weui-icon-search"></i>
                    <span>搜索</span>
                </label>
            </form>
            <a href="javascript:" class="weui-search-bar__cancel-btn" id="searchCancel">取消</a>
        </div>
        
    </div>
    <div class="page__bd">
    
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
