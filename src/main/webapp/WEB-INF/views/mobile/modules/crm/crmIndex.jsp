<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
<html>
<head>
	<title>${crmCustomer.name }</title>
	<style type="text/css">
	.color-orange{
		color: #f8ac59;
	}
	.weui-grid_label {
		text-align: center;
		color: #4C84C4;
	}
	.weui-grid {
		width:25%;
		border: 0 !important;
	}
	.weui-cell__bd {
		font-size: 13px;
	}
	.weui-grid:before{
		border-right: 0;
	}
	.weui-grid:after{
		border-bottom: 0;
	}
	</style>
    <script type="text/javascript">
    $(function(){ 
    	//监听返回事件
		pushHistory();
		window.addEventListener("popstate", function(e) {
			location.href = "${ctx}/mobile/crm/crmCustomer";
		}, false);
    });
    //关注
     function saveCustomerStar(customerId){    	
    	var is_star = $("#label_star").hasClass("color-orange");    	    	
    	$.ajax({
    		url:"${ctx}/crm/crmCustomerStar/saveCustomerStar",
    		type:"POST",
    		async:true,    //或false,是否异步
    		data:{customerId:customerId, isStar:is_star},
    		dataType:'json',
    		success:function(data){
    			//alert(data);
    			if(is_star == false){
    				$("#label_star").addClass("color-orange");
    				$("#img_star").attr("src", "${ctxStatic}/weui/demos/images/foot_collection_fill.png");
    				alertMsgBox("关注成功");
    			}else{
    				$("#label_star").removeClass("color-orange");
    				$("#img_star").attr("src", "${ctxStatic}/weui/demos/images/foot_collection.png");
    				alertMsgBox("已取消关注");
    			}    				
    		},
    		error:function(){
    			//alert("出错");
    		}
    	});
    }
	</script>
</head>
<body ontouchstart>
<mobile:message content="${message}"/>
	<div class="weui-panel weui-panel_access">
        <div class="weui-panel__bd">
          <div class="weui-media-box weui-media-box_text">
            <h4 class="weui-media-box__title">
	            ${crmCustomer.name } 
	            <c:if test="${not empty crmCustomer.ownBy.id}">
	            	<span class="title_label_primary">${fns:getDictLabel(crmCustomer.customerStatus, 'customer_status', '')}</span>
	            </c:if>
	            <c:if test="${empty crmCustomer.ownBy.id}">
	            	<span class="title_label_success" >公海</span>
	            </c:if>
            </h4>
            <p class="weui-media-box__desc"><c:if test="${not empty crmCustomer.ownBy.id}">负责人：${crmCustomer.ownBy.name}</c:if></p>
          </div>
        </div>
    </div>
    <div class="weui-tab">
      <div class="weui-navbar">
        <a class="weui-navbar__item weui-bar__item_on" href="${ctx}/mobile/crm/crmCustomer/index?id=${crmCustomer.id}">
          	概况
        </a>        
        <a class="weui-navbar__item" href="${ctx}/mobile/crm/crmCustomer/indexContacterList?id=${crmCustomer.id}">
          	联系人
        </a>
        <a class="weui-navbar__item" href="${ctx}/mobile/crm/crmCustomer/indexContactRecordList?id=${crmCustomer.id}">
          	沟通
        </a>
        <a class="weui-navbar__item" href="${ctx}/mobile/crm/crmCustomer/indexChanceList?id=${crmCustomer.id}">
          	商机
        </a>
        <a class="weui-navbar__item" href="${ctx}/mobile/crm/crmCustomer/indexQuoteList?id=${crmCustomer.id}">
          	报价
        </a>
        <a class="weui-navbar__item" href="${ctx}/mobile/crm/crmCustomer/indexContractList?id=${crmCustomer.id}">
          	合同
        </a>
        <a class="weui-navbar__item" href="${ctx}/mobile/crm/crmCustomer/indexDocumentList?id=${crmCustomer.id}">
          	附件
        </a>
        
      </div>
      <div class="weui-tab__bd">
        <div id="tab1" class="weui-tab__bd-item weui-tab__bd-item--active infinite">
          <h1 class="doc-head">&nbsp;</h1>
          <div class="content-padded">
          	
          	<div class="weui-grids">
				<div class="weui-grid js_grid">
					<div class="weui-grid_label">¥${generalCout.totalChanceAmt}</div>
					<p class="weui-grid__label">
						<span class="weui-media-box__desc">商机总额</span>
					</p>
				</div>
				<div class="weui-grid js_grid">
					<div class="weui-grid_label">¥${generalCout.totalOrderAmt}</div>
					<p class="weui-grid__label">
						<span class="weui-media-box__desc">订单总额</span>
					</p>
				</div>
				<div class="weui-grid js_grid">
					<div class="weui-grid_label">¥${generalCout.totalReceiveAmt}</div>
					<p class="weui-grid__label">
						<span class="weui-media-box__desc">回款总额</span>
					</p>
				</div>
				<div class="weui-grid js_grid">
					<div class="weui-grid_label">¥${generalCout.totalRefundAmt}</div>
					<p class="weui-grid__label">
						<span class="weui-media-box__desc">退款总额</span>
					</p>
				</div>
			</div>
          	
        	
          	<div class="weui-panel weui-panel_access">
        
		        <div class="weui-panel__bd">
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">客户分类</h4>
		            <p class="weui-media-box__desc">${fns:getDictLabel(crmCustomer.customerType, 'customer_type', '')}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">客户级别</h4>
		            <p class="weui-media-box__desc">${fns:getDictLabel(crmCustomer.customerLevel, 'customer_level', '')}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">客户行业</h4>
		            <p class="weui-media-box__desc">${fns:getDictLabel(crmCustomer.industryType, 'industry_type', '')}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">客户来源</h4>
		            <p class="weui-media-box__desc">${fns:getDictLabel(crmCustomer.sourType, 'sour_type', '')}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">公司性质</h4>
		            <p class="weui-media-box__desc">${fns:getDictLabel(crmCustomer.sourType, 'sour_type', '')}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">企业规模</h4>
		            <p class="weui-media-box__desc">${fns:getDictLabel(crmCustomer.scaleType, 'scale_type', '')}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">客户地址</h4>
		            <p class="weui-body-box_desc">${crmCustomer.province}${crmCustomer.city}${crmCustomer.dict}${crmCustomer.address}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">客户描述</h4>
		            <p class="weui-body-box_desc">${crmCustomer.remarks}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">客户标签</h4>
		            <p class="weui-body-box_desc">${crmCustomer.tags}</p>
		          </div>
		        </div>
      		</div>
      
      
          </div>
          
        </div>
       </div>
      
      
    </div>
    
    <!--BEGIN actionSheet-->
    <div>
        <div class="weui-mask" id="operateMask" style="display: none"></div>
        <div class="weui-actionsheet" id="operateActionsheet">
            <div class="weui-actionsheet__title">
                <p class="weui-actionsheet__title-text">操作菜单</p>
            </div>
            <div class="weui-actionsheet__menu">
            	<c:if test="${crmCustomer.lockFlag==0}">
            	<shiro:hasPermission name="crm:crmCustomer:edit">
                <div class="weui-actionsheet__cell" onclick="javascript:location.href='${ctx}/mobile/crm/crmCustomer/form?id=${crmCustomer.id}'">编辑客户</div>
                </shiro:hasPermission>
                
                <c:if test="${empty crmCustomer.ownBy.id}">
                <div class="weui-actionsheet__cell" onclick="javascript:location.href='${ctx}/mobile/crm/crmCustomer/receipt?id=${crmCustomer.id}'">领取客户</div>
                </c:if>
                <c:if test="${crmCustomer.isPool == 0}">
                <div class="weui-actionsheet__cell" onclick="return confirmx('确认要将该客户放入公海吗？', '${ctx}/crm/crmCustomer/toPool?id=${crmCustomer.id}')">放入公海</div>
                </c:if>
                <shiro:hasPermission name="crm:crmCustomer:del">
                <div class="weui-actionsheet__cell" onclick="return confirmx('确认要删除该客户吗？', '${ctx}/crm/crmCustomer/delete?id=${crmCustomer.id}')">删除客户</div>
                </shiro:hasPermission>
                </c:if>
                
                
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
            	<div class="weui-actionsheet__cell" onclick="javascript:location.href='${ctx}/mobile/crm/crmContacter/form?customer.id=${crmCustomer.id}'">新建联系人</div>
                <div class="weui-actionsheet__cell" onclick="javascript:location.href='${ctx}/mobile/crm/crmChance/form?customer.id=${crmCustomer.id}'">新建商机</div>
                <div class="weui-actionsheet__cell" onclick="javascript:location.href='${ctx}/mobile/crm/crmChance/form?customer.id=${crmCustomer.id}'" style="display: none">新建合同订单</div>
                <div class="weui-actionsheet__cell" onclick="javascript:location.href='${ctx}/mobile/crm/crmContactRecord/form?customer.id=${crmCustomer.id}'">新建沟通</div>
                
            </div>
            <div class="weui-actionsheet__action">
                <div class="weui-actionsheet__cell" id="createActionsheetCancel">取消</div>
            </div>
        </div>
    </div>
    
    
	<div class="weui-tabbar">
                <a href="${ctx}/mobile/crm/crmContactRecord/form?customer.id=${crmCustomer.id}" class="weui-tabbar__item weui-bar__item_on">
                    <span style="display: inline-block;position: relative;">
                        <img src="${ctxStatic}/weui/demos/images/foot_editor.png" alt="" class="weui-tabbar__icon">
                        <span class="weui-badge" style="position: absolute;top: -2px;right: -13px;">8</span>
                    </span>
                    <p class="weui-tabbar__label">沟通</p>
                </a>
                <a href="javascript:;" class="weui-tabbar__item" onclick="saveCustomerStar('${crmCustomer.id}')">
                    <img src="${ctxStatic}/weui/demos/images/foot_collection<c:if test='${not empty isStar}'>_fill</c:if>.png" alt="" class="weui-tabbar__icon" id="img_star">
                    <p class="weui-tabbar__label <c:if test='${not empty isStar}'>color-orange</c:if>" id="label_star">关注</p>
                </a>
                <a href="javascript:;" class="weui-tabbar__item" id="showCreateActionSheet">
                    <span style="display: inline-block;position: relative;">
                        <img src="${ctxStatic}/weui/demos/images/foot_addition_fill.png" alt="" class="weui-tabbar__icon">
                        <span class="weui-badge weui-badge_dot" style="position: absolute;top: 0;right: -6px;"></span>
                    </span>
                    <p class="weui-tabbar__label">新建</p>
                </a>
                <a href="javascript:;" class="weui-tabbar__item" id="showOperateActionSheet">
                    <img src="${ctxStatic}/weui/demos/images/foot_set.png" alt="" class="weui-tabbar__icon">
                    <p class="weui-tabbar__label">操作</p>
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