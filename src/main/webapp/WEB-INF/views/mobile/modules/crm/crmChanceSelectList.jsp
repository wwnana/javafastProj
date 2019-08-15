<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
  <head>
  	<title>商机选择器</title>
    <%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
    <script type="text/javascript">

	
    	function toSearch(){
    		window.location.href = "${ctx}/mobile/crm/crmChance/search";
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
        		url:"${ctx}/mobile/crm/crmChance/listData?customer.id=${crmChance.customer.id}",
        		data: {pageNo:page_no, name:'${crmChance.name}', periodType:'${crmChance.periodType}'},
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
    	
    	var periodTypeDictList = getDictList("period_type");
    	function setData(data){
    		var html = "";
    		for(var i=0;i<data.length;i++){
    			
    			var periodType = getDictLabel(periodTypeDictList, data[i].periodType);
    			var probability = data[i].probability;
    			if(probability == null){
    				probability = "";
    			}
    			
    			html += "<div class=\"weui-media-box weui-media-box_text\" onclick=\"viewData('"+ data[i].id +"','"+ data[i].name +"')\" >";
    			html += "<span class=\"weui-body-box_right\"><i class=\"weui-icon-circle\"></i></span>";
    			html += "<h4 class=\"weui-media-box__title\">"+ data[i].name +"</h4>";
    			html += "<p class=\"weui-media-box__desc\">"+ data[i].customer.name +"</p>";
    			html += "<ul class=\"weui-media-box__info\">";
    			
    			html += "<li class=\"weui-media-box__info__meta\">"+ periodType +"</li>";
    			html += "<li class=\"weui-media-box__info__meta\">"+ probability +"0%(预计赢单率)</li>";
    			html += "<li class=\"weui-media-box__info__meta\">"+ data[i].ownBy.name +"</li>";
    			html += "</ul>";
    			html += "</div>";
    		}
    		$("#list-panel").append(html);
    	}
    	function viewData(id, name){
    		window.parent.$('#chanceId').val(id);
    		window.parent.$('#chanceName').val(name);
    		top.layer.closeAll();
    	}
		
		
		
    </script>
  </head>
  <body ontouchstart>
  	<div class="page">
    <div class="page__bd">
        <mobile:searchBar modelName="crmChance" url="${ctx}/mobile/crm/crmChance"></mobile:searchBar>
    
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
