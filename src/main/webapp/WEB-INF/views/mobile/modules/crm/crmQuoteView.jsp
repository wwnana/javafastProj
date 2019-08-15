<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
<html>
<head>
	<title>${crmQuote.name }</title>
    <script type="text/javascript">
    $(function(){ 
    	//监听返回事件
		pushHistory();
		window.addEventListener("popstate", function(e) {
			location.href = "${ctx}/mobile/crm/crmQuote";
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
            <h4 class="weui-media-box__title">${crmQuote.amount } <span class="title_label_primary">${fns:getDictLabel(crmQuote.status, 'audit_status', '')}</span></h4>
            <p class="weui-media-box__desc">负责人：${crmQuote.ownBy.name}</p>
          </div>
        </div>
      </div>
    
			<div class="weui-panel weui-panel_access">
        
		        <div class="weui-panel__bd">
		          
		          <div class="weui-media-box weui-media-box_text" onclick="javascript:window.location.href='${ctx}/mobile/crm/crmCustomer/index?id=${crmQuote.customer.id}'">
		            <h4 class="weui-media-box__title">客户</h4>
		            <p class="weui-media-box__desc">${crmQuote.customer.name}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text" onclick="javascript:window.location.href='${ctx}/mobile/crm/crmChance/index?id=${crmQuote.chance.id}'">
		            <h4 class="weui-media-box__title">来源商机</h4>
		            <p class="weui-media-box__desc">${crmQuote.chance.name}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">报价总额(元)</h4>
		            <p class="weui-media-box__desc">${crmQuote.amount}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">报价日期</h4>
		            <p class="weui-media-box__desc"><fmt:formatDate value="${crmQuote.startdate}" pattern="yyyy-MM-dd"/></p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">有效期至</h4>
		            <p class="weui-media-box__desc"><fmt:formatDate value="${crmQuote.enddate}" pattern="yyyy-MM-dd"/></p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">报价单状态</h4>
		            <p class="weui-media-box__desc">${fns:getDictLabel(crmQuote.status, 'audit_status', '')}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">描述</h4>
		            <p class="weui-body-box_desc">${crmQuote.remarks}</p>
		          </div>
		          
		        </div>
      		</div>
    	
    	
    	<div class="weui-panel weui-panel_access">
        <div class="weui-panel__bd">
          <div class="weui-media-box weui-media-box_text">
            <h4 class="weui-media-box__title">报价单明细</h4>
          </div>
          <c:forEach items="${crmQuote.crmQuoteDetailList}" var="crmQuoteDetail" varStatus="sta">
          		  <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">${crmQuoteDetail.product.name}</h4>
		            <p class="weui-media-box__desc">规格：${crmQuoteDetail.product.spec}，单位：${crmQuoteDetail.unitType}，单价：${crmQuoteDetail.price}，数量：${crmQuoteDetail.num}，金额：${crmQuoteDetail.amt}</p>
		          </div>
          </c:forEach>
          
      			   <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">合计</h4>
		            <p class="weui-media-box__desc">总数量：${crmQuote.num}，总计：${crmQuote.amount}</p>
		          </div>
			</div>				
		</div>	
     <div class="weui-tabbar">
		
	 </div>
</div>
</body>
</html>