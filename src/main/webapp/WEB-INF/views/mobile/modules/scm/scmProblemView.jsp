<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
<html>
<head>
	<title>${scmProblem.name }</title>
    <script type="text/javascript">
    $(function(){ 
    	//监听返回事件
		pushHistory();
		window.addEventListener("popstate", function(e) {
			location.href = "${ctx}/mobile/scm/scmProblem";
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
            <h4 class="weui-media-box__title">${scmProblem.name } <span class="title_label_primary">${scmProblem.scmProblemType.name}</span></h4>
            <p class="weui-media-box__desc">${scmProblem.createBy.name} <fmt:formatDate value="${scmProblem.createDate}" pattern="yyyy-MM-dd"/></p>
          </div>
        </div>
      </div>
    
		
      		<div class="weui-panel weui-panel_access">
        
		        <div class="weui-panel__bd">
		        	<div class="weui-media-box weui-media-box_text">
			           
			            <p class="weui-body-box_desc">${scmProblem.content }</p>
			          </div>
		        </div>
		    </div>
      		
    		
    
     <div class="weui-tabbar">
     	
     	
     	<shiro:hasPermission name="scm:scmProblem:edit">
		<a href="${ctx}/mobile/scm/scmProblem/form?id=${scmProblem.id}" class="weui-tabbar__item weui-navbar__item">
	          <p class="">编辑</p>
		</a>
		</shiro:hasPermission>
		
		
		
	 </div>
</div>
</body>
</html>