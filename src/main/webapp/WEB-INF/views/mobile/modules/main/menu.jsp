<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
  <head>
      <title>${fns:getSysAccount().systemName}</title>
      <style type="text/css">
      </style>
      <%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
      <script type="text/javascript">
		$(function() {
			
			//监听返回事件
			pushHistory();
			window.addEventListener("popstate", function(e) {
				//不处理
			}, false);
			function pushHistory() {
				var state = {
					title : "title",
					url : "#"
				};
				window.history.pushState(state, "title", "#");
			}
		});
	</script>
  </head>
  <body>
	<div class="page-content">
	
	<%--
    <header class='demos-header'>
      <h2 class="demos-title">${fns:getSysAccount().systemName}</h2>
      <p class='demos-sub-title'>集成企业微信，更高效智能</p>
    </header>
	 --%>
    <div class="weui-cells__title">市场营销</div>
    <div class="weui-grids">
      <shiro:hasPermission name="crm:crmMarket:list">
      <a href="${ctx}/mobile/crm/crmMarket" class="weui-grid js_grid">
        <div class="weui-grid__icon">
          <img src="${ctxStatic}/weui/images/app/icon_market.png" alt="">
        </div>
        <p class="weui-grid__label">
          	活动
        </p>
      </a>
      </shiro:hasPermission>
      
      <shiro:hasPermission name="crm:crmClue:list">
      <a href="${ctx}/mobile/crm/crmClue" class="weui-grid js_grid">
        <div class="weui-grid__icon">
          <img src="${ctxStatic}/weui/images/app/icon_clue.png" alt="">
        </div>
        <p class="weui-grid__label">
          	线索
        </p>
      </a>
      </shiro:hasPermission>
      <shiro:hasPermission name="crm:crmClue:list">
      <a href="${ctx}/mobile/crm/crmCluePool/" class="weui-grid js_grid">
        <div class="weui-grid__icon">
          <img src="${ctxStatic}/weui/images/app/icon_clue_pool.png" alt="">
        </div>
        <p class="weui-grid__label">
         	 线索池
        </p>
      </a>
      </shiro:hasPermission>
      <a href="${ctx}/wechat/hd/list" class="weui-grid js_grid">
        <div class="weui-grid__icon">
          <img src="${ctxStatic}/weui/images/app/icon_share.png" alt="">
        </div>
        <p class="weui-grid__label">
         	 推广
        </p>
      </a>
    </div>
    
    <div class="weui-cells__title">销售管理</div>
    <div class="weui-grids">
      <shiro:hasPermission name="crm:crmCustomer:list">
      <a href="${ctx}/mobile/crm/crmCustomer" class="weui-grid js_grid">
        <div class="weui-grid__icon">
          <img src="${ctxStatic}/weui/images/app/icon_customer.png" alt="">
        </div>
        <p class="weui-grid__label">
          	客户
        </p>
      </a>
      <a href="${ctx}/mobile/crm/crmCustomerPool/" class="weui-grid js_grid">
        <div class="weui-grid__icon">
          <img src="${ctxStatic}/weui/images/app/icon_customer_pool.png" alt="">
        </div>
        <p class="weui-grid__label">
         	 公海
        </p>
      </a>
      <a href="${ctx}/mobile/crm/crmContacter" class="weui-grid js_grid">
        <div class="weui-grid__icon">
          <img src="${ctxStatic}/weui/images/app/icon_contacter.png" alt="">
        </div>
        <p class="weui-grid__label">
          	联系人
        </p>
      </a>
      <a href="${ctx}/mobile/crm/crmContactRecord/" class="weui-grid js_grid">
        <div class="weui-grid__icon">
          <img src="${ctxStatic}/weui/images/app/icon_msg.png" alt="">
        </div>
        <p class="weui-grid__label">
         	 沟通
        </p>
      </a>
      </shiro:hasPermission>
      
      <shiro:hasPermission name="crm:crmChance:list">
      <a href="${ctx}/mobile/crm/crmChance" class="weui-grid js_grid">
        <div class="weui-grid__icon">
          <img src="${ctxStatic}/weui/images/app/icon_chance2.png" alt="">
        </div>
        <p class="weui-grid__label">
          	商机
        </p>
      </a>
      </shiro:hasPermission>
      
      <%-- 
      <a href="${ctx}/mobile/crm/crmQuote" class="weui-grid js_grid">
        <div class="weui-grid__icon">
          <img src="${ctxStatic}/weui/images/app/app_task_check.png" alt="">
        </div>
        <p class="weui-grid__label">
          	报价
        </p>
      </a>
      --%>
      <shiro:hasPermission name="om:omContract:list">
      <a href="${ctx}/mobile/om/omContract" class="weui-grid js_grid">
        <div class="weui-grid__icon">
          <img src="${ctxStatic}/weui/images/app/icon_contract.png" alt="">
        </div>
        <p class="weui-grid__label">
         	 合同
        </p>
      </a>
      <a href="${ctx}/mobile/om/omOrder" class="weui-grid js_grid">
        <div class="weui-grid__icon">
          <img src="${ctxStatic}/weui/images/app/icon_order.png" alt="">
        </div>
        <p class="weui-grid__label">
         	 订单
        </p>
      </a>
      </shiro:hasPermission>
      <shiro:hasPermission name="fi:fiReceiveAble:list">
      <a href="${ctx}/mobile/fi/fiReceiveAble" class="weui-grid js_grid">
        <div class="weui-grid__icon">
          <img src="${ctxStatic}/weui/images/app/icon_able_receive.png" alt="">
        </div>
        <p class="weui-grid__label">
          	回款
        </p>
      </a>
      </shiro:hasPermission>
    </div>
    
    <div class="weui-cells__title">销售支持</div>
    <div class="weui-grids">
      <shiro:hasPermission name="crm:crmService:list">
      <a href="${ctx}/mobile/crm/crmService" class="weui-grid js_grid">
        <div class="weui-grid__icon">
          <img src="${ctxStatic}/weui/images/app/icon_service.png" alt="">
        </div>
        <p class="weui-grid__label">
          	工单
        </p>
      </a>
      </shiro:hasPermission>
      
      <shiro:hasPermission name="wms:wmsProduct:list">
      <a href="${ctx}/mobile/wms/wmsProduct" class="weui-grid js_grid">
        <div class="weui-grid__icon">
          <img src="${ctxStatic}/weui/images/app/icon_product.png" alt="">
        </div>
        <p class="weui-grid__label">
         	 产品
        </p>
      </a>
      </shiro:hasPermission>
      
      <a href="${ctx}/mobile/scm/scmProblem" class="weui-grid js_grid">
        <div class="weui-grid__icon">
          <img src="${ctxStatic}/weui/images/app/icon_book.png" alt="">
        </div>
        <p class="weui-grid__label">
         	 知识
        </p>
      </a>
      <a href="${ctx}/mobile/oa/oaWorkLog/self" class="weui-grid js_grid">
        <div class="weui-grid__icon">
          <img src="${ctxStatic}/weui/images/app/icon_worklog.png" alt="">
        </div>
        <p class="weui-grid__label">
          	汇报
        </p>
      </a>
    </div>
    <%-- 
    <div class="weui-cells__title">工作审批</div>
    <div class="weui-grids">
      <a href="${ctx}/mobile/oa/oaCommonAudit/list" class="weui-grid js_grid">
        <div class="weui-grid__icon">
          <img src="${ctxStatic}/weui/images/app/app_audit.png" alt="">
        </div>
        <p class="weui-grid__label">
          	审批
        </p>
      </a>
      
      <a href="${ctx}/mobile/oa/oaNotify/list" class="weui-grid js_grid">
        <div class="weui-grid__icon">
          <img src="${ctxStatic}/weui/images/app/app_message.png" alt="">
        </div>
        <p class="weui-grid__label">
          	公告
        </p>
      </a>
      
      <a href="${ctx}/mobile/oa/oaWorkLog/self" class="weui-grid js_grid">
        <div class="weui-grid__icon">
          <img src="${ctxStatic}/weui/images/app/app_checked.png" alt="">
        </div>
        <p class="weui-grid__label">
          	汇报
        </p>
      </a>
      --%>
      <%-- 
      <a href="" class="weui-grid js_grid">
        <div class="weui-grid__icon">
          <img src="${ctxStatic}/images/icon_nav_city.png" alt="">
        </div>
        <p class="weui-grid__label">
         	 写说说
        </p>
      </a>
      --%>
    </div>
	<div class="weui-cells__title"></div>
    </div>
    
 	<c:set value="0" var="nav"></c:set>
 	<%@ include file="foot.jsp"%>
  </body>
</html>