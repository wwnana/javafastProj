<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
<html>
<head>
	<title>${crmContacter.name }</title>
    <script type="text/javascript">
    $(function(){ 
    	//监听返回事件
		pushHistory();
		window.addEventListener("popstate", function(e) {
			location.href = "${ctx}/mobile/crm/crmContacter";
		}, false);
    });
	</script>
</head>
<body ontouchstart>
<mobile:message content="${message}"/>
<div class="page-content">
	<div class="weui-panel weui-panel_access">
        <div class="weui-panel__bd">
          <div class="weui-media-box weui-media-box_text" onclick="javascript:window.location.href='${ctx}/mobile/crm/crmCustomer/index?id=${crmContacter.customer.id}'">
            <h4 class="weui-media-box__title">${crmContacter.name }</h4>
            <p class="weui-media-box__desc">所属客户：${crmContacter.customer.name}</p>
          </div>
        </div>
      </div>
    
			<div class="weui-panel weui-panel_access">
        
		        <div class="weui-panel__bd">
		          
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">职务</h4>
		            <p class="weui-media-box__desc">${crmContacter.jobType}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">性别</h4>
		            <p class="weui-media-box__desc">${fns:getDictLabel(crmContacter.sex, 'sex', '')}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">手机号码</h4>
		            <p class="weui-media-box__desc">${crmContacter.mobile}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">电子邮箱</h4>
		            <p class="weui-media-box__desc">${crmContacter.email}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">微信</h4>
		            <p class="weui-media-box__desc">${crmContacter.wx}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">QQ</h4>
		            <p class="weui-media-box__desc">${crmContacter.qq}</p>
		          </div>
		          
		        </div>
      		</div>
    
    
     <div class="weui-tabbar">
     	<shiro:hasPermission name="crm:crmContacter:edit">
     	<a href="${ctx}/mobile/crm/crmContacter/form?id=${crmContacter.id}" class="weui-tabbar__item weui-navbar__item">
	          <p class="">编辑</p>
		</a>
		</shiro:hasPermission>
		
	 </div>
</div>
</body>
</html>