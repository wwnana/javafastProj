<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
  <head>
  	<title>跟进记录</title>
    <%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
    <script type="text/javascript">
    	function toSearch(){
    		window.location.href = "${ctx}/mobile/crm/crmContactRecord/search";
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
        		url:"${ctx}/mobile/crm/crmContactRecord/listData",
        		data: {pageNo:page_no, contactType:'${crmContactRecord.contactType}', contactDate:'${crmContactRecord.contactDate}', createById:'${crmContactRecord.createBy.id}'},
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
        			alertMsgBox("服务器未响应");
        		}
        	});
        }
    	
    	var contactTypeDictList = getDictList("contact_type");
    	var objectTypeDictList = getDictList("object_type");
    	function setData(data){
    		var html = "";
    		for(var i=0;i<data.length;i++){
    			
    			var contactType = getDictLabel(contactTypeDictList, data[i].contactType);
    			var targetType = getDictLabel(objectTypeDictList, data[i].targetType);
    			var createByName = "";
    			if(data[i].createBy != null){
    				createByName = data[i].createBy.name;
    			}
    			
    			html += "<div class=\"weui-media-box weui-media-box_text\" onclick=\"viewData('"+ data[i].id +"','"+ data[i].targetName +"')\" >";
    			html += "<h4 class=\"weui-media-box__title\">["+ targetType +"] "+ data[i].targetName +"</h4>";
    			html += "<p class=\"weui-media-box__desc\">"+data[i].content +"</p>";
    			html += "<ul class=\"weui-media-box__info\">";
    			html += "<li class=\"weui-media-box__info__meta\">"+ contactType +"</li>";
    			html += "<li class=\"weui-media-box__info__meta weui-media-box__info__meta_extra\">"+ createByName +"</li>";
    			html += "<li class=\"weui-media-box__info__meta weui-media-box__info__meta_extra\">"+ data[i].createDate +"</li>";
    			html += "</ul>";
    			html += "</div>";
    		}
    		$("#list-panel").append(html);
    	}
    	function viewData(id, name){
    		window.location.href="${ctx}/mobile/crm/crmContactRecord/view?id="+id;
    	}
    	
    </script>
  </head>
  <body ontouchstart>
  	<div class="page">
      <div class="page__bd">
        <mobile:searchBar modelName="crmContactRecord" url="${ctx}/mobile/crm/crmContactRecord"></mobile:searchBar>
    
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
     	<shiro:hasPermission name="crm:crmContactRecord:add">
		<a href="${ctx}/mobile/crm/crmContactRecord/form" class="weui-tabbar__item weui-navbar__item">
	          <p class="">新建跟进记录</p>
		</a>
		</shiro:hasPermission>
		<a href="${ctx}/mobile/crm/crmContactRecord/search" class="weui-tabbar__item weui-navbar__item">
	          <p class="">高级查询</p>
		</a>
	 </div>
	 
  </body>
</html>
