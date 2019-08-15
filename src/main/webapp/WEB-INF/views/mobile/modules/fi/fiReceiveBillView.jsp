<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
<html>
<head>
	<title>${fiReceiveBill.no }</title>
    <script type="text/javascript">
    
	</script>
</head>
<body ontouchstart>
<mobile:message content="${message}"/>
<div class="page-content">
	<div class="weui-panel weui-panel_access">
        <div class="weui-panel__bd">
          <div class="weui-media-box weui-media-box_text">
            <h4 class="weui-media-box__title">${fiReceiveBill.no } <span class="title_label_primary">${fns:getDictLabel(fiReceiveBill.status, 'audit_status', '')}</span></h4>
            <p class="weui-media-box__desc">负责人：${fiReceiveBill.ownBy.name}</p>
          </div>
        </div>
      </div>
    
			<div class="weui-panel weui-panel_access">
        
		        <div class="weui-panel__bd">
		          
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">收款单编码</h4>
		            <p class="weui-media-box__desc">${fiReceiveBill.no}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">收款单状态</h4>
		            <p class="weui-media-box__desc">${fns:getDictLabel(fiReceiveBill.status, 'audit_status', '')}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text" onclick="javascript:window.location.href='${ctx}/mobile/crm/crmCustomer/index?id=${fiReceiveBill.customer.id}'">
		            <h4 class="weui-media-box__title">往来单位</h4>
		            <p class="weui-media-box__desc">${fiReceiveBill.customer.name}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text" onclick="javascript:window.location.href='${ctx}/mobile/om/omContract/index?id=${fiReceiveBill.order.id}'">
		            <h4 class="weui-media-box__title">订单合同</h4>
		            <p class="weui-media-box__desc">${fiReceiveBill.order.no}</p>
		          </div>
		         
		          		          
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">收款金额</h4>
		            <p class="weui-media-box__desc">${fiReceiveBill.amount }	</p>
		          </div>
		          
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">收款日期</h4>
		            <p class="weui-media-box__desc"><fmt:formatDate value="${fiReceiveBill.dealDate}" pattern="yyyy-MM-dd"/></p>
		          </div>
		          
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">备注</h4>
		            <p class="weui-body-box_desc">${fiReceiveBill.remarks }</p>
		          </div>
		         
		        </div>
		        
		        
      		</div>
      		
    		
    
     <div class="weui-tabbar">
     	
     	<c:if test="${fiReceiveBill.status == 0}">
     	<shiro:hasPermission name="fi:fiReceiveBill:edit">
		<a href="${ctx}/mobile/fi/fiReceiveBill/form?id=${fiReceiveBill.id}" class="weui-tabbar__item weui-navbar__item">
	          <p class="">编辑</p>
		</a>
		</shiro:hasPermission>
		<shiro:hasPermission name="fi:fiReceiveBill:del">
			<a class="weui-tabbar__item weui-navbar__item" href="javascript:" onclick="return confirmx('确认要删除该收款单吗？', '${ctx}/fi/fiReceiveBill/delete?id=${fiReceiveBill.id}')" >删除</a> 
		</shiro:hasPermission>
											
		<shiro:hasPermission name="fi:fiReceiveBill:audit">
		<div onclick="return confirmx('确认要审核该收款单吗？', '${ctx}/mobile/fi/fiReceiveBill/audit?id=${fiReceiveBill.id}')" class="weui-tabbar__item weui-navbar__item">
	    	<p class="">审核</p>
		</div>
		</shiro:hasPermission>
		</c:if>
		
	 </div>
</div>
</body>
</html>