<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
<html>
<head>
	<title>${oaTask.name }</title>
    <script type="text/javascript">

	</script>
</head>
<body ontouchstart>
<mobile:message content="${message}"/>
<div class="page-content">
	<div class="weui-panel weui-panel_access">
        <div class="weui-panel__bd">
          <div class="weui-media-box weui-media-box_text">
            <h4 class="weui-media-box__title">${oaTask.name }</h4>
            <p class="weui-media-box__desc">负责人：${oaTask.ownBy.name}</p>
          </div>
        </div>
      </div>
    
			<div class="weui-panel weui-panel_access">
        
		        <div class="weui-panel__bd">
		          
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">任务编号</h4>
		            <p class="weui-media-box__desc">${oaTask.no}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">任务名称</h4>
		            <p class="weui-media-box__desc">${oaTask.name}</p>
		          </div>
		          <c:if test="${not empty oaTask.relationName}">
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">关联${fns:getDictLabel(oaTask.relationType, 'relation_type', '')}</h4>
		            <p class="weui-media-box__desc">${oaTask.relationName}</p>
		          </div>
		          </c:if>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">截止日期</h4>
		            <p class="weui-media-box__desc"><fmt:formatDate value="${oaTask.endDate}" pattern="yyyy-MM-dd"/></p>
		          </div>
		          
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">任务进度</h4>
		            <p class="weui-media-box__desc">${oaTask.schedule}%</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">任务状态</h4>
		            <p class="weui-media-box__desc">${fns:getDictLabel(oaTask.status, 'task_status', '')}</p>
		          </div>
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">任务描述</h4>
		            <p class="weui-body-box_desc">${oaTask.content}</p>
		          </div>
		          
		        </div>
      		</div>
    
    
     <div class="weui-tabbar">

		
	 </div>
</div>
</body>
</html>