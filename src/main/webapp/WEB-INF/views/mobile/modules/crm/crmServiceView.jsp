<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
<html>
<head>
	<title>${crmService.name }</title>
    <script type="text/javascript">
    $(function(){ 
    	//监听返回事件
		pushHistory();
		window.addEventListener("popstate", function(e) {
			location.href = "${ctx}/mobile/crm/crmService";
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
            <h4 class="weui-media-box__title">${crmService.name } <span class="title_label_primary">${fns:getDictLabel(crmService.status, 'finish_status', '')}</span></h4>
            <p class="weui-media-box__desc">负责人：${crmService.ownBy.name}</p>
          </div>
        </div>
      </div>
    
			<div class="weui-panel weui-panel_access">
        
		        <div class="weui-panel__bd">
		          
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">工单编码</h4>
		            <p class="weui-media-box__desc">${crmService.no}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">工单类型</h4>
		            <p class="weui-media-box__desc">${fns:getDictLabel(crmService.serviceType, 'service_type', '')}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text" onclick="javascript:window.location.href='${ctx}/mobile/crm/crmCustomer/index?id=${crmService.customer.id}'">
		            <h4 class="weui-media-box__title">客户</h4>
		            <p class="weui-media-box__desc">${crmService.customer.name}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">订单合同</h4>
		            <p class="weui-media-box__desc">${crmService.omContract.no}</p>
		          </div>
		          
		          		          
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">优先级</h4>
		            <p class="weui-media-box__desc">${fns:getDictLabel(crmService.levelType, 'level_type', '')}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">截止日期</h4>
		            <p class="weui-media-box__desc"><fmt:formatDate value="${crmService.endDate}" pattern="yyyy-MM-dd"/></p>
		          </div>
		          
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">工单内容</h4>
		            <p class="weui-body-box_desc">${crmService.content}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">期望结果</h4>
		            <p class="weui-media-box__desc">${crmService.expecte}</p>
		          </div>
		          
		        </div>
		        
		        
      		</div>
      		<div class="weui-panel weui-panel_access">
      			<div class="weui-panel__bd">
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">处理状态</h4>
		            <p class="weui-media-box__desc">${fns:getDictLabel(crmService.status, 'finish_status', '')}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">处理日期</h4>
		            <p class="weui-media-box__desc"><fmt:formatDate value="${crmService.dealDate}" pattern="yyyy-MM-dd"/></p>
		          </div>
		        </div>
    		</div>
    		<div class="weui-panel weui-panel_access">
      			<div class="weui-panel__bd">
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">满意度</h4>
		            <p class="weui-media-box__desc">${fns:getDictLabel(crmService.satisfyType, 'satisfy_type', '')}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">审核人</h4>
		            <p class="weui-media-box__desc">${crmService.auditBy.name}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">审核日期</h4>
		            <p class="weui-media-box__desc"><fmt:formatDate value="${crmService.auditDate}" pattern="yyyy-MM-dd HH:mm:ss"/></p>
		          </div>
		        </div>
    		</div>
    
     <div class="weui-tabbar">
     	<shiro:hasPermission name="crm:crmService:edit">
		<a href="${ctx}/mobile/crm/crmService/form?id=${crmService.id}" class="weui-tabbar__item weui-navbar__item">
	          <p class="">编辑</p>
		</a>
		</shiro:hasPermission>
		<c:if test="${fns:getUser().id == crmService.ownBy.id && crmService.status != 2}">
			<a href="${ctx}/mobile/crm/crmService/deal?id=${crmService.id}" onclick="return confirmx('确认要工单已经完成了吗？', this.href)" class="weui-tabbar__item weui-navbar__item"> 我已完成</a>
		</c:if>
	 </div>
</div>
</body>
</html>