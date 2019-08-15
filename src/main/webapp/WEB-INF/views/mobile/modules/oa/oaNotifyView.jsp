<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
<html>
<head>
	<title>${oaNotify.title }</title>
    <script type="text/javascript">
    $(function(){ 
    	//监听返回事件
		pushHistory();
		window.addEventListener("popstate", function(e) {
			location.href = "${ctx}/mobile/oa/oaNotify";
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
            <h4 class="weui-media-box__title">${oaNotify.title }</h4>
            <p class="weui-media-box__desc">发布人：${oaNotify.createBy.name}</p>
            <p class="weui-media-box__desc">发布时间：<fmt:formatDate value="${oaNotify.createDate}" pattern="yyyy-MM-dd"/></p>
          </div>
        </div>
      </div>
      <form:form id="inputForm" modelAttribute="oaNotify" action="${ctx}/oa/oaNotify/save" method="post" class="">
		<form:hidden path="id"/>
			<div class="weui-panel weui-panel_access">
        
		        <div class="weui-panel__bd">
		          
		          
		          <div class="weui-media-box weui-media-box_text">
		            
		            <p class="weui-body-box_desc">${oaNotify.content}</p>
		          </div>
		          
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">附件</h4>
		            <p class="weui-media-box__desc">
		            	<form:hidden id="files" path="files" htmlEscape="false" maxlength="255" class="form-control"/>
						<sys:ckfinder input="files" type="files" uploadPath="/oa" selectMultiple="true" readonly="true" />
								
		            </p>
		          </div>
		          
		        </div>
      		</div>
     </form:form>
    
     <div class="weui-tabbar">

		
	 </div>
</div>
</body>
</html>