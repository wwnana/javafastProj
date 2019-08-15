<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
<html>
<head>
	<title>${crmCustomer.name }</title>
    <script type="text/javascript">
    $(function(){ 
    	//监听返回事件
		pushHistory();
		window.addEventListener("popstate", function(e) {
			location.href = "${ctx}/mobile/crm/crmCustomer";
		}, false);
    });
	</script>

</head>
<body ontouchstart>
	<div class="weui-panel weui-panel_access">
        <div class="weui-panel__bd">
          <div class="weui-media-box weui-media-box_text">
            <h4 class="weui-media-box__title">
	            ${crmCustomer.name } 
	            <c:if test="${not empty crmCustomer.ownBy.id}">
	            	<span class="title_label_primary">${fns:getDictLabel(crmCustomer.customerStatus, 'customer_status', '')}</span>
	            </c:if>
	            <c:if test="${empty crmCustomer.ownBy.id}">
	            	<span class="title_label_primary">公海</span>
	            </c:if>
            </h4>
            <p class="weui-media-box__desc"><c:if test="${not empty crmCustomer.ownBy.id}">负责人：${crmCustomer.ownBy.name}</c:if></p>
          </div>
        </div>
      </div>
    <div class="weui-tab">
      <div class="weui-navbar">
        <a class="weui-navbar__item" href="${ctx}/mobile/crm/crmCustomer/index?id=${crmCustomer.id}">
          	概况
        </a>        
        <a class="weui-navbar__item" href="${ctx}/mobile/crm/crmCustomer/indexContacterList?id=${crmCustomer.id}">
          	联系人
        </a>
        <a class="weui-navbar__item weui-bar__item_on" href="${ctx}/mobile/crm/crmCustomer/indexContactRecordList?id=${crmCustomer.id}">
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
          	
          	<div class="weui-panel weui-panel_access">
        
		        <div class="weui-panel__bd">
				  <c:forEach items="${list}" var="crmContactRecord">	
		          <div class="weui-media-box weui-media-box_text" onclick="javascript:window.location.href='${ctx}/mobile/crm/crmContactRecord/view?id=${crmContactRecord.id}'">
		            <h4 class="weui-media-box__title"><fmt:formatDate value="${crmContactRecord.contactDate}" pattern="yyyy-MM-dd"/> ${fns:getDictLabel(crmContactRecord.contactType, 'contact_type', '')} ${crmContactRecord.contacter.name}</h4>
		            <p class="weui-media-box__desc">${crmContactRecord.content}</p>
		          </div>
		          </c:forEach>
		        </div>
      		</div>
      
      
          </div>
          
        </div>
       </div>
      
      
    </div>
    <div class="weui-tabbar">
		<a href="${ctx}/mobile/crm/crmContactRecord/form?customer.id=${crmCustomer.id}" class="weui-tabbar__item weui-navbar__item">
	          <p class="">新建沟通</p>
		</a>
		
	</div>
</body>
</html>