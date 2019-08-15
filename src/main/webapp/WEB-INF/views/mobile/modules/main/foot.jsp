<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
  <head>
      <title>${fns:getSysAccount().systemName}</title>
      <%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
      <style type="text/css">
      	.weui-grid {
		    position: relative;
		    float: left;
		    padding: 20px 10px;
		    width: 25%;
		    box-sizing: border-box;
		}
		
      </style>
  </head>
  <body>
	
		<div class="weui-tabbar">
            <a href="${ctx}/mobile/index" class="weui-tabbar__item <c:if test='${nav == 2}'>weui-bar__item_on</c:if>">
                <img src="${ctxStatic}/weui/demos/images/foot_home<c:if test='${nav == 2}'>_fill</c:if>.png" class="weui-tabbar__icon">
                <p class="weui-tabbar__label">首页</p>
            </a>
            <a href="${ctx}/mobile/menu" class="weui-tabbar__item <c:if test='${nav == 0}'>weui-bar__item_on</c:if>">
                <img src="${ctxStatic}/weui/demos/images/foot_manage<c:if test='${nav == 0}'>_fill</c:if>.png" class="weui-tabbar__icon">
                <p class="weui-tabbar__label">CRM</p>
            </a>
            <a href="javascript:void(0)" id="showIOSActionSheet" class="weui-tabbar__item <c:if test='${nav == 5}'>weui-bar__item_on</c:if>">
                <img src="${ctxStatic}/weui/demos/images/foot_addition_fill.png" class="weui-tabbar__icon">
                <p class="weui-tabbar__label">快递创建</p>
            </a>
            <a href="${ctx}/mobile/find" class="weui-tabbar__item <c:if test='${nav == 3}'>weui-bar__item_on</c:if>">
                <span style="display: inline-block;position: relative;">
                    <img src="${ctxStatic}/weui/demos/images/foot_remind<c:if test='${nav == 3}'>_fill</c:if>.png" class="weui-tabbar__icon">
                    <span class="weui-badge weui-badge_dot" style="position: absolute;top: 0;right: -6px;"></span>
                </span>
                <p class="weui-tabbar__label">待办</p>
            </a>
            <a href="${ctx}/mobile/more" class="weui-tabbar__item <c:if test='${nav == 4}'>weui-bar__item_on</c:if>">
                <img src="${ctxStatic}/weui/demos/images/foot_set<c:if test='${nav == 4}'>_fill</c:if>.png" class="weui-tabbar__icon">
                <p class="weui-tabbar__label">我的</p>
            </a>
        </div>
            
           
            
    
 	
 	<div>
        <div class="weui-mask" id="iosMask" style="display: none"></div>
        <div class="weui-actionsheet" id="iosActionsheet">
            <div class="weui-actionsheet__title">
                <p class="weui-actionsheet__title-text">快速创建</p>
            </div>
            <div class="weui-grids">
		          <shiro:hasPermission name="crm:crmMarket:add">
		          <a href="${ctx}/mobile/crm/crmMarket/form" class="weui-grid js_grid">
			        <div class="weui-grid__icon">
			          <img src="${ctxStatic}/weui/images/app/icon_market.png" alt="">
			        </div>
			        <p class="weui-grid__label">
			          	活动
			        </p>
			      </a>
			      </shiro:hasPermission>
			      <shiro:hasPermission name="crm:crmClue:add">
			      <a href="${ctx}/mobile/crm/crmClue/form" class="weui-grid js_grid">
			        <div class="weui-grid__icon">
			          <img src="${ctxStatic}/weui/images/app/icon_clue.png" alt="">
			        </div>
			        <p class="weui-grid__label">
			          	线索
			        </p>
			    </a>
			    </shiro:hasPermission>
			    <shiro:hasPermission name="crm:crmCustomer:add">
		        <a href="${ctx}/mobile/crm/crmCustomer/form" class="weui-grid">
		            <div class="weui-grid__icon">
		                <img src="${ctxStatic}/weui/images/app/icon_customer.png" alt="">
		            </div>
		            <p class="weui-grid__label">客户</p>
		        </a>
		        
		        <a href="${ctx}/mobile/crm/crmContacter/form" class="weui-grid">
		            <div class="weui-grid__icon">
		                <img src="${ctxStatic}/weui/images/app/icon_contacter.png" alt="">
		            </div>
		            <p class="weui-grid__label">联系人</p>
		        </a>
		        <a href="${ctx}/mobile/crm/crmContactRecord/form" class="weui-grid">
		            <div class="weui-grid__icon">
		                <img src="${ctxStatic}/weui/images/app/icon_msg.png" alt="">
		            </div>
		            <p class="weui-grid__label">沟通</p>
		        </a>
		        </shiro:hasPermission>
		        <shiro:hasPermission name="crm:crmChance:add">
		        <a href="${ctx}/mobile/crm/crmChance/form" class="weui-grid">
		            <div class="weui-grid__icon">
		                <img src="${ctxStatic}/weui/images/app/icon_chance2.png" alt="">
		            </div>
		            <p class="weui-grid__label">商机</p>
		        </a>
		        </shiro:hasPermission>
		        <shiro:hasPermission name="om:omContract:add">
		        <a href="${ctx}/mobile/om/omContract/form" class="weui-grid js_grid">
			        <div class="weui-grid__icon">
			          <img src="${ctxStatic}/weui/images/app/icon_contract.png" alt="">
			        </div>
			        <p class="weui-grid__label">
			         	 合同
			        </p>
			    </a>
			    
			    <a href="${ctx}/mobile/om/omOrder/form" class="weui-grid">
		            <div class="weui-grid__icon">
		                <img src="${ctxStatic}/weui/images/app/icon_order.png" alt="">
		            </div>
		            <p class="weui-grid__label">订单</p>
		        </a>
		        </shiro:hasPermission>
		         <shiro:hasPermission name="fi:fiReceiveAble:list">
			      <a href="${ctx}/mobile/fi/fiReceiveAble/list" class="weui-grid js_grid">
			        <div class="weui-grid__icon">
			          <img src="${ctxStatic}/weui/images/app/icon_able_receive.png" alt="">
			        </div>
			        <p class="weui-grid__label">
			         	 回款
			        </p>
			      </a>
			      </shiro:hasPermission>
			      <shiro:hasPermission name="crm:crmService:add">
			      <a href="${ctx}/mobile/crm/crmService/form" class="weui-grid js_grid">
			        <div class="weui-grid__icon">
			          <img src="${ctxStatic}/weui/images/app/icon_service.png" alt="">
			        </div>
			        <p class="weui-grid__label">
			          	工单
			        </p>
			      </a>
			      </shiro:hasPermission>
			      <shiro:hasPermission name="wms:wmsProduct:add">
			      <a href="${ctx}/mobile/wms/wmsProduct/form" class="weui-grid js_grid">
			        <div class="weui-grid__icon">
			          <img src="${ctxStatic}/weui/images/app/icon_product.png" alt="">
			        </div>
			        <p class="weui-grid__label">
			         	 产品
			        </p>
			      </a>
			      </shiro:hasPermission>
			      
			      <a href="${ctx}/mobile/oa/oaWorkLog/form" class="weui-grid js_grid">
			        <div class="weui-grid__icon">
			          <img src="${ctxStatic}/weui/images/app/icon_worklog.png" alt="">
			        </div>
			        <p class="weui-grid__label">
			          	汇报
			        </p>
			      </a>
            </div>
            <%-- 
            <div class="weui-actionsheet__menu">
                <div class="weui-actionsheet__cell">示例菜单</div>
                <div class="weui-actionsheet__cell">示例菜单</div>
                <div class="weui-actionsheet__cell">示例菜单</div>
                <div class="weui-actionsheet__cell">示例菜单</div>
            </div>
            --%>
            <div class="weui-actionsheet__action">
            	<%--<div class="weui-actionsheet__cell" id="iosActionsheetCancel"><img src="${ctxStatic}/weui/demos/images/foot_delete_fill.png" alt="" style="width:45px;height:45px;"></div>--%>
                 <div class="weui-actionsheet__cell" id="iosActionsheetCancel">取消</div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
    // ios
    $(function(){
        var $iosActionsheet = $('#iosActionsheet');
        var $iosMask = $('#iosMask');

        function hideActionSheet() {
            $iosActionsheet.removeClass('weui-actionsheet_toggle');
            $iosMask.fadeOut(200);
        }

        $iosMask.on('click', hideActionSheet);
        $('#iosActionsheetCancel').on('click', hideActionSheet);
        $("#showIOSActionSheet").on("click", function(){
            $iosActionsheet.addClass('weui-actionsheet_toggle');
            $iosMask.fadeIn(200);
        });
    });

    
</script>
  </body>
</html>
