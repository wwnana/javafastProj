<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
<html>
<head>
	<title>${fns:getDictLabel(oaWorkLog.workLogType, 'work_log_type', '')}</title>
	<style type="text/css">
		
		.weui-cells {
		    font-size: 12px;
		}
		.weui-cell-desc{
		padding: 0 15px;
		}
	</style>
    <script type="text/javascript">
    $(function(){ 
    	//监听返回事件
		pushHistory();
		window.addEventListener("popstate", function(e) {
			location.href = "${ctx}/mobile/oa/oaWorkLog";
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
            <h4 class="weui-media-box__title">${oaWorkLog.title}</h4>
            <p class="weui-media-box__desc">报告人：${oaWorkLog.createBy.name}</p>
            <p class="weui-media-box__desc">报告时间：<fmt:formatDate value="${oaWorkLog.createDate}" pattern="yyyy-MM-dd"/></p>
          </div>
        </div>
      </div>
    
			<div class="weui-panel weui-panel_access">
        
		        <div class="weui-panel__bd">
		          
		          <div class="weui-media-box weui-media-box_text">
		            <h4 class="weui-media-box__title">汇报内容</h4>
		            <p class="weui-body-box_desc">${oaWorkLog.content}</p>
		          </div>
		          
		        </div>
      		</div>
      		
      		<div class="weui-panel weui-panel_access">
			<div class="weui-cells__title">批阅人</div>	
		    <div class="weui-panel__bd">			    	        
		        <div class="weui-cells">
		        	<c:forEach items="${oaWorkLog.oaWorkLogRecordList}" var="oaWorkLogRecord">
		        	<a class="weui-cell weui-cell_access" href="javascript:;">
		                <div class="weui-cell__hd"><img src="${oaWorkLogRecord.user.photo}" alt="" style="width:20px;margin-right:5px;display:block"></div>
		                <div class="weui-cell__bd">
		                    <p>${oaWorkLogRecord.user.name}
		                    	• ${fns:getDictLabel(oaWorkLogRecord.readFlag, 'oa_notify_read', '')}<c:if test="${empty oaWorkLogRecord.readFlag}">未读</c:if>
		                    </p>
		                </div>
		                <div class="weui-media-box__desc"><fmt:formatDate value="${oaWorkLogRecord.readDate}" pattern="yyyy-MM-dd HH:mm:ss"/></div>
		            </a>
		            <div class="weui-cell-desc"><p class="weui-media-box__desc">${oaWorkLogRecord.auditNotes}</p></div>
		        	</c:forEach>
		        </div>
		    </div>
		    </div>
    
    
     <div class="weui-tabbar">
     	<c:if test="${fns:getUser().id == oaWorkLog.createBy.id && oaWorkLog.status==0}">
		<a href="${ctx}/mobile/oa/oaWorkLog/form?id=${oaWorkLog.id}" class="weui-tabbar__item weui-navbar__item">
	          <p class="">重新编辑</p>
		</a>
		</c:if>
		
	 </div>
</div>
</body>
</html>