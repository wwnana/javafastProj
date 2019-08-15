<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
  <head>
  	<title>审批流程管理</title>
    <%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
    <script type="text/javascript">
    	function toSearch(){
    		window.location.href = "${ctx}/mobile/oa/oaCommonAudit/search";
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
        		url:"${ctx}/mobile/oa/oaCommonAudit/listData",
        		data: {pageNo:page_no,createId:$("#createId").val(),status:$("#status").val()},
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
    			 			
    			var audit_status = getDictLabel(data[i].status, "common_audit_status");

    			html += "<div class=\"weui-media-box weui-media-box_text\" onclick=\"viewData('"+ data[i].id +"','"+ data[i].name +"')\" >";
    			html += "<h4 class=\"weui-media-box__title\">"+ data[i].title +"</h4>";
    			html += "<p class=\"weui-media-box__desc\">"+ data[i].createDate + " " + audit_status +"</p>";
    			html += "</div>";
    		}
    		$("#list-panel").append(html);
    	}
    	function viewData(id, name){
    		window.location.href="${ctx}/mobile/oa/oaCommonAudit/view?id="+id;
    	}
    	function getDictLabel(val, type){
    		
    		if(type == "common_audit_status"){
    			if(val == "0"){
        			return "未提交";
        		}
        		if(val == "1"){
        			return "审核中";
        		}
        		if(val == "2"){
        			return "已通过";
        		}
        		if(val == "3"){
        			return "不通过";
        		}
    		}
    	}
    </script>
  </head>
  <body ontouchstart>
  	<div class="weui-search-bar" id="searchBar" onclick="toSearch()">
      <form:form id="inputForm" modelAttribute="oaCommonAudit" action="${ctx}/mobile/oa/oaCommonAudit/" method="post" class="weui-search-bar__form">
      <input id="pageNo" name="pageNo" type="hidden" value=""/>
	  <input id="pageSize" name="pageSize" type="hidden" value=""/>
		<form:hidden path="status" />
		<form:hidden path="createId" />
        <div class="weui-search-bar__box">
          <i class="weui-icon-search"></i>
          <input type="search" class="weui-search-bar__input" id="searchInput" placeholder="搜索" required="">
          <a href="javascript:" class="weui-icon-clear" id="searchClear"></a>
        </div>
        <label class="weui-search-bar__label" id="searchText" style="transform-origin: 0px 0px 0px; opacity: 1; transform: scale(1, 1);">
          <i class="weui-icon-search"></i>
          <span>搜索</span>
        </label>
      </form:form>
      <a href="javascript:" class="weui-search-bar__cancel-btn" id="searchCancel">取消</a>
    </div>
    
      
      <div class="page-content page__bd">
		<div class="weui-panel weui-panel_access" id="list-panel">
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
		
	 </div>
  </body>
</html>
