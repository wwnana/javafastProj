<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
<html>
<head>
	<title>沟通内容详情</title>
    <script type="text/javascript">
    
	</script>
</head>
<body ontouchstart>
<div class="page-content">
	<div class="weui-panel weui-panel_access">
        <div class="weui-panel__bd">
          <div class="weui-media-box weui-media-box_text" onclick="javascript:window.location.href='${ctx}/mobile/crm/crmCustomer/index?id=${crmContactRecord.targetId}'">
            <h4 class="weui-media-box__title">[${fns:getDictLabel(crmContactRecord.targetType, 'object_type', '')}] ${crmContactRecord.targetName}</h4>
            <p class="weui-media-box__desc">${crmContactRecord.createBy.name} <fmt:formatDate value="${crmContactRecord.contactDate}" pattern="yyyy-MM-dd"/></p>
          </div>
        </div>
      </div>
    
			<div class="weui-panel weui-panel_access">
        
		        <div class="weui-panel__bd">
				   
		          
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">沟通主题</h4>
		            <p class="weui-media-box__desc">${fns:getDictLabel(crmContactRecord.contactType, 'contact_type', '')}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">沟通内容</h4>
		            <p class="weui-body-box_desc">${crmContactRecord.content}</p>
		          </div>
		         
		         
		          
		        </div>
      		</div>
    
    
     <div class="weui-tabbar">
     	<c:if test="${fns:getUser().id == crmContactRecord.createBy.id || fns:getUser().id == crmContactRecord.createBy.id}">
		<a href="${ctx}/mobile/crm/crmContactRecord/form?id=${crmContactRecord.id}" class="weui-tabbar__item weui-navbar__item">
	          <p class="">编辑</p>
		</a>
		</c:if>
		
	 </div>
</div>
</body>
</html>