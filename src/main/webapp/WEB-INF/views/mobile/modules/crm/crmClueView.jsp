<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
<html>
<head>
	<title>${crmClue.name }</title>
    <script type="text/javascript">
    $(function(){ 
    	//监听返回事件
		pushHistory();
		window.addEventListener("popstate", function(e) {
			location.href = "${ctx}/mobile/crm/crmClue";
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
            <h4 class="weui-media-box__title">${crmClue.name } <span class="title_label_primary"><c:if test="${empty crmClue.crmCustomer.id}">未转化</c:if><c:if test="${not empty crmClue.crmCustomer.id}">已转化</c:if></span></h4>
            <p class="weui-media-box__desc">负责人：${crmClue.ownBy.name}</p>
          </div>
        </div>
      </div>
    
			<div class="weui-panel weui-panel_access">
        
		        <div class="weui-panel__bd">
		          
		          <div class="weui-media-box weui-media-box_text" onclick="javascript:window.location.href='${ctx}/mobile/crm/crmMarket/view?id=${crmClue.crmMarket.id}'">
		            <h4 class="weui-media-box__title">所属市场活动</h4>
		            <p class="weui-media-box__desc">${crmClue.crmMarket.name}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">公司</h4>
		            <p class="weui-media-box__desc">${crmClue.name}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">姓名</h4>
		            <p class="weui-media-box__desc">${crmClue.contacterName}</p>
		          </div>		          
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">职务</h4>
		            <p class="weui-media-box__desc">${crmClue.jobType}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">手机</h4>
		            <p class="weui-media-box__desc">${crmClue.mobile}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">线索来源</h4>
		            <p class="weui-media-box__desc">${fns:getDictLabel(crmClue.sourType, 'sour_type', '')}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">所属行业</h4>
		            <p class="weui-media-box__desc">${fns:getDictLabel(crmClue.industryType, 'industry_type', '')}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">线索描述</h4>
		            <p class="weui-body-box_desc">${crmClue.remarks}</p>
		          </div>
		          
		        </div>
		        
		        
      		</div>
      		<div class="weui-panel weui-panel_access">
      			<div class="weui-panel__bd">
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">下次联系时间</h4>
		            <p class="weui-media-box__desc"><fmt:formatDate value="${crmClue.nextcontactDate}" pattern="yyyy-MM-dd"/></p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">下次联系内容</h4>
		            <p class="weui-media-box__desc">${crmClue.nextcontactNote}</p>
		          </div>
		        </div>
    		</div>
    
     <div class="weui-tabbar">
     	<shiro:hasPermission name="crm:crmClue:edit">
		<a href="${ctx}/mobile/crm/crmClue/form?id=${crmClue.id}" class="weui-tabbar__item weui-navbar__item">
	          <p class="">编辑</p>
		</a>
		</shiro:hasPermission>
		
	 </div>
</div>
</body>
</html>