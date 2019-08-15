<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
  <head>
  	<title>商机管理</title>
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
    			location.href = "${ctx}/mobile/menu";
    		}, false);
    	});
    	function loadData(){	
    		
    	    $.ajax({
        		url:"${ctx}/mobile/crm/crmChance/listData",
        		data: {pageNo:page_no, name:'${crmChance.name}', periodType:'${crmChance.periodType}', ownById:'${crmChance.ownBy.id}'},
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
    			
    			if(data[i].periodType<6){
    				html += "<span class=\"weui-body-box_right font-green\">"+ periodType +"</span>";
    			}
    			if(data[i].periodType==6){
    				html += "<span class=\"weui-body-box_right font-red\">"+ periodType +"</span>";
    			}
    			
    			html += "<h4 class=\"weui-media-box__title\">"+ data[i].name +"</h4>";
    			html += "<p class=\"weui-media-box__desc\">"+ data[i].customer.name +"</p>";
    			html += "<ul class=\"weui-media-box__info\">";
    			html += "<li class=\"weui-media-box__info__meta\">预计金额："+ data[i].saleAmount +"</li>";
    			html += "<li class=\"weui-media-box__info__meta weui-media-box__info__meta_extra\">预计赢单率："+ probability +"%</li>";
    			html += "<li class=\"weui-media-box__info__meta weui-media-box__info__meta_extra\">负责人："+ data[i].ownBy.name +"</li>";
    			html += "</ul>";
    			html += "</div>";
    		}
    		$("#list-panel").append(html);
    	}
    	function viewData(id, name){
    		window.location.href="${ctx}/mobile/crm/crmChance/index?id="+id;
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
     
      <div class="weui-tabbar">
     	<shiro:hasPermission name="crm:crmChance:add">
		<a href="${ctx}/mobile/crm/crmChance/form" class="weui-tabbar__item weui-navbar__item">
	          <p class="">新建商机</p>
		</a>
		</shiro:hasPermission>
		<a href="${ctx}/mobile/crm/crmChance/search" class="weui-tabbar__item weui-navbar__item">
	          <p class="">高级查询</p>
		</a>
	 </div>
	 
  </body>
</html>
