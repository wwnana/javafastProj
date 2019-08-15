<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
<html>
<head>
	<title>${crmChance.name }</title>
    <script type="text/javascript">
    $(function(){ 
    	//监听返回事件
		pushHistory();
		window.addEventListener("popstate", function(e) {
			location.href = "${ctx}/mobile/crm/crmChance";
		}, false);
    });
	</script>
</head>
<body ontouchstart>
<mobile:message content="${message}"/>
<div class="page-content">
	<div class="weui-panel weui-panel_access">
        <div class="weui-panel__bd">
          <div class="weui-media-box weui-media-box_text">
            <h4 class="weui-media-box__title">${crmChance.name } <span class="title_label_primary">${fns:getDictLabel(crmChance.periodType, 'period_type', '')}</span></h4>
            <p class="weui-media-box__desc">负责人：${crmChance.ownBy.name}</p>
          </div>
        </div>
      </div>
    
			<div class="weui-panel weui-panel_access">
        
		        <div class="weui-panel__bd">
		          
		          <div class="weui-media-box weui-media-box_text" onclick="javascript:window.location.href='${ctx}/mobile/crm/crmCustomer/index?id=${crmChance.customer.id}'">
		            <h4 class="weui-media-box__title">客户</h4>
		            <p class="weui-media-box__desc">${crmChance.customer.name}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">销售阶段</h4>
		            <p class="weui-media-box__desc">${fns:getDictLabel(crmChance.periodType, 'period_type', '')}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">预计销售金额(元)</h4>
		            <p class="weui-media-box__desc">${crmChance.saleAmount}</p>
		          </div>		          
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">商机类型</h4>
		            <p class="weui-media-box__desc">${fns:getDictLabel(crmChance.changeType, 'change_type', '')}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">商机来源</h4>
		            <p class="weui-media-box__desc">${fns:getDictLabel(crmChance.sourType, 'sour_type', '')}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">预计赢单率</h4>
		            <p class="weui-media-box__desc">${fns:getDictLabel(crmChance.probability, 'probability_type', '')}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">商机描述</h4>
		            <p class="weui-body-box_desc">${crmChance.remarks}</p>
		          </div>
		          
		        </div>
		        
		        
      		</div>
      		<div class="weui-panel weui-panel_access">
      			<div class="weui-panel__bd">
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">下次联系时间</h4>
		            <p class="weui-media-box__desc"><fmt:formatDate value="${crmChance.nextcontactDate}" pattern="yyyy-MM-dd"/></p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">下次联系内容</h4>
		            <p class="weui-media-box__desc">${crmChance.nextcontactNote}</p>
		          </div>
		        </div>
    		</div>
    
     <div class="weui-tabbar">
     	<shiro:hasPermission name="crm:crmChance:edit">
		<a href="${ctx}/mobile/crm/crmChance/form?id=${crmChance.id}" class="weui-tabbar__item weui-navbar__item">
	          <p class="">编辑</p>
		</a>
		</shiro:hasPermission>
		
	 </div>
</div>
</body>
</html>