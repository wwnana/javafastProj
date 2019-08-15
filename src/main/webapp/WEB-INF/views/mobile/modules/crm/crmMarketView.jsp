<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
<html>
<head>
	<title>${crmMarket.name }</title>
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
			location.href = "${ctx}/mobile/crm/crmMarket";
		}, false);
	});
	function loadData(){	
		
	    $.ajax({
    		url:"${ctx}/mobile/crm/crmClue/listData?crmMarket.id=${crmMarket.id}",
    		data: {pageNo:page_no, name:$("#name").val()},
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
			
			html += "<div class=\"weui-media-box weui-media-box_text\" onclick=\"viewData('"+ data[i].id +"','"+ data[i].name +"')\" >";
			html += "<h4 class=\"weui-media-box__title\">"+ data[i].name +"</h4>";
			html += "<p class=\"weui-media-box__desc\">"+data[i].contacterName + " " + data[i].mobile +"</p>";
			html += "</div>";
		}
		$("#list-panel").append(html);
	}
	function viewData(id, name){
		window.location.href="${ctx}/mobile/crm/crmClue/index?id="+id;
	}
	</script>
</head>
<body ontouchstart>
<mobile:message content="${message}"/>
	<div class="weui-panel weui-panel_access">
        <div class="weui-panel__bd">
          <div class="weui-media-box weui-media-box_text">
            <h4 class="weui-media-box__title">
	            ${crmMarket.name } 
	            <c:if test="${not empty crmMarket.ownBy.id}">
	            	<span class="title_label_primary">${fns:getDictLabel(crmMarket.status, 'market_status', '')}</span>
	            </c:if>
	            <c:if test="${empty crmMarket.ownBy.id}">
	            	<span class="title_label_primary">公海</span>
	            </c:if>
            </h4>
            <p class="weui-media-box__desc"><c:if test="${not empty crmMarket.ownBy.id}">负责人：${crmMarket.ownBy.name}</c:if></p>
          </div>
        </div>
    </div>
    <div class="page">
	    <div class="page__bd" style="height: 100%;">
	        <div class="weui-tab">
	            <div class="weui-navbar">
	                <div class="weui-navbar__item weui-bar__item_on" onclick="changeTab('1')">
	                    	基本信息
	                </div>
	                <div class="weui-navbar__item" onclick="changeTab('2')">
	                    	线索（${crmCluePage.count}）
	                </div>
	                
	            </div>
	            <div class="weui-tab__panel">
					<div id="tab1">
						
						<div class="weui-panel weui-panel_access">
					        <div class="weui-panel__bd">
					          
					         
					          <div class="weui-media-box weui-media-box_text">
					            <h4 class="weui-media-box__title">开始日期</h4>
					            <p class="weui-media-box__desc"><fmt:formatDate value="${crmMarket.startDate}" pattern="yyyy-MM-dd"/></p>
					          </div>
					          <div class="weui-media-box weui-media-box_text">
					            <h4 class="weui-media-box__title">截止日期</h4>
					            <p class="weui-media-box__desc"><fmt:formatDate value="${crmMarket.endDate}" pattern="yyyy-MM-dd"/></p>
					          </div>	
					          <div class="weui-media-box weui-media-box_text">
					            <h4 class="weui-media-box__title">活动类型</h4>
					            <p class="weui-media-box__desc">${fns:getDictLabel(crmMarket.marketType, 'market_type', '')}</p>
					          </div>
					          <div class="weui-media-box weui-media-box_text">
					            <h4 class="weui-media-box__title">活动地点</h4>
					            <p class="weui-media-box__desc">${crmMarket.marketAddress}</p>
					          </div>
					          <div class="weui-media-box weui-media-box_text">
					            <h4 class="weui-media-box__title">预计成本</h4>
					            <p class="weui-media-box__desc">${crmMarket.estimateCost}</p>
					          </div>
					          <div class="weui-media-box weui-media-box_text">
					            <h4 class="weui-media-box__title">实际成本</h4>
					            <p class="weui-media-box__desc">${crmMarket.actualCost}</p>
					          </div>
					          <div class="weui-media-box weui-media-box_text">
					            <h4 class="weui-media-box__title">预计收入</h4>
					            <p class="weui-media-box__desc">${crmMarket.estimateAmount}</p>
					          </div>
					          <div class="weui-media-box weui-media-box_text">
					            <h4 class="weui-media-box__title">实际收入</h4>
					            <p class="weui-media-box__desc">${crmMarket.actualAmount}</p>
					          </div>
					          <div class="weui-media-box weui-media-box_text">
					            <h4 class="weui-media-box__title">邀请人数</h4>
					            <p class="weui-media-box__desc">${crmMarket.inviteNum}</p>
					          </div>
					          <div class="weui-media-box weui-media-box_text">
					            <h4 class="weui-media-box__title">实际人数</h4>
					            <p class="weui-media-box__desc">${crmMarket.actualNum}</p>
					          </div>	          
					         
					        </div>
			      		</div>
			      		
					</div>
					<div id="tab2">
						<form:form id="inputForm"  action="${ctx}/mobile/crm/crmClue/" method="post" class="weui-search-bar__form">
					      <input id="pageNo" name="pageNo" type="hidden" value=""/>
						  <input id="pageSize" name="pageSize" type="hidden" value=""/>
      					</form:form>
      					
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
					</div>
					
	            </div>
	        </div>
	    </div>
	</div>
	<script type="text/javascript">
	    $(function(){
	        $('.weui-navbar__item').on('click', function () {
	            $(this).addClass('weui-bar__item_on').siblings('.weui-bar__item_on').removeClass('weui-bar__item_on');
	        });
	    });
		changeTab(1);
		function changeTab(ltab_num) {
			for(i = 0; i <= 2; i++) {
				$("#tab" + i).hide(); //将所有的层都隐藏
			}
			$("#tab" + ltab_num).show(); //显示当前层
		}
	</script>
    
    <!--BEGIN actionSheet-->
    <div>
        <div class="weui-mask" id="operateMask" style="display: none"></div>
        <div class="weui-actionsheet" id="operateActionsheet">
            <div class="weui-actionsheet__title">
                <p class="weui-actionsheet__title-text">操作菜单</p>
            </div>
            <div class="weui-actionsheet__menu">
            	
            	<shiro:hasPermission name="crm:crmMarket:edit">
                <div class="weui-actionsheet__cell" onclick="javascript:location.href='${ctx}/mobile/crm/crmMarket/form?id=${crmMarket.id}'">编辑</div>
                </shiro:hasPermission>
                <shiro:hasPermission name="crm:crmMarket:del">
                <div class="weui-actionsheet__cell" onclick="return confirmx('确认要删除该活动吗？', '${ctx}/mobile/crm/crmMarket/delete?id=${crmCustomer.id}')">删除</div>
                </shiro:hasPermission>
                
            </div>
            <div class="weui-actionsheet__action">
                <div class="weui-actionsheet__cell" id="operateActionsheetCancel">取消</div>
            </div>
        </div>
        
        <div class="weui-mask" id="createMask" style="display: none"></div>
        <div class="weui-actionsheet" id="createActionsheet">
            <div class="weui-actionsheet__title">
                <p class="weui-actionsheet__title-text">快速创建</p>
            </div>
            <div class="weui-actionsheet__menu">
            	<div class="weui-actionsheet__cell" onclick="javascript:location.href='${ctx}/mobile/crm/crmClue/form?crmMarket.id=${crmMarket.id}'">新建线索</div>
            </div>
            <div class="weui-actionsheet__action">
                <div class="weui-actionsheet__cell" id="createActionsheetCancel">取消</div>
            </div>
        </div>
    </div>
    
    <div class="weui-tabbar">
		<a href="javascript:;" class="weui-tabbar__item weui-navbar__item" id="showOperateActionSheet">
	          <p class="">操作</p>
		</a>
		<a href="javascript:;" class="weui-tabbar__item weui-navbar__item" id="showCreateActionSheet">
	          <p class="">新建</p>
		</a>
	</div>
	<script type="text/javascript">
	    //操作菜单
	    $(function(){
	        var $operateActionsheet = $('#operateActionsheet');
	        var $operateMask = $('#operateMask');
	
	        function hideActionSheet() {
	            $operateActionsheet.removeClass('weui-actionsheet_toggle');
	            $operateMask.fadeOut(200);
	        }
	
	        $operateMask.on('click', hideActionSheet);
	        $('#operateActionsheetCancel').on('click', hideActionSheet);
	        $("#showOperateActionSheet").on("click", function(){
	            $operateActionsheet.addClass('weui-actionsheet_toggle');
	            $operateMask.fadeIn(200);
	        });
	    });
		//创建菜单
	    $(function(){
	        var $createActionsheet = $('#createActionsheet');
	        var $createMask = $('#createMask');
	
	        function hideActionSheet() {
	            $createActionsheet.removeClass('weui-actionsheet_toggle');
	            $createMask.fadeOut(200);
	        }
	
	        $createMask.on('click', hideActionSheet);
	        $('#createActionsheetCancel').on('click', hideActionSheet);
	        $("#showCreateActionSheet").on("click", function(){
	            $createActionsheet.addClass('weui-actionsheet_toggle');
	            $createMask.fadeIn(200);
	        });
	    });
	</script>
	
</body>
</html>