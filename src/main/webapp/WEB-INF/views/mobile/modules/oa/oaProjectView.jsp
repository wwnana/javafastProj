<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
<html>
<head>
	<title>${oaProject.name }</title>
    <script type="text/javascript">
    $(function(){ 
    	//监听返回事件
		pushHistory();
		window.addEventListener("popstate", function(e) {
			location.href = "${ctx}/mobile/oa/oaProject";
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
            <h4 class="weui-media-box__title">${oaProject.name }</h4>
            <p class="weui-media-box__desc">负责人：${oaProject.ownBy.name}</p>
          </div>
        </div>
      </div>
    
			<div class="weui-panel weui-panel_access">
        
		        <div class="weui-panel__bd">
		          
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">项目编号</h4>
		            <p class="weui-media-box__desc">${oaProject.no}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">项目名称</h4>
		            <p class="weui-media-box__desc">${oaProject.name}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">开始日期</h4>
		            <p class="weui-media-box__desc"><fmt:formatDate value="${oaProject.startDate}" pattern="yyyy-MM-dd"/></p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">截止日期</h4>
		            <p class="weui-media-box__desc"><fmt:formatDate value="${oaProject.endDate}" pattern="yyyy-MM-dd"/></p>
		          </div>
		          
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">项目进度</h4>
		            <p class="weui-media-box__desc">${oaProject.schedule}%</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">项目状态</h4>
		            <p class="weui-media-box__desc">${fns:getDictLabel(oaProject.status, 'task_status', '')}</p>
		          </div>
		          
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">项目描述</h4>
		            <p class="weui-body-box_desc">${oaProject.content}</p>
		          </div>
		        </div>
      		</div>
    
    
     <div class="weui-tabbar">

		
	 </div>
</div>
</body>
</html>