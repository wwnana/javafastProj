<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
  <head>
  	<title>${not empty office.parent.name?office.parent.name:'组织机构'}</title>
    <%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
    <script type="text/javascript">
    	
    	function viewData(id, name){
    		window.location.href="${ctx}/mobile/sys/sysOffice/index?id="+id;
    	}
    </script>
  </head>
  <body ontouchstart>
  
  <div class="page">
    <div class="page__bd">
		<div class="weui-cells__title"></div>
		<c:if test="${fn:length(list)>0}">
        <div class="weui-cells">
			<c:forEach items="${list}" var="office">
            <a class="weui-cell weui-cell_access" href="${ctx}/mobile/sys/sysOffice/list?parent.id=${office.id}&parent.name=${office.name}">
                <div class="weui-cell__hd"><img src="${ctxStatic}/images/file.png" alt="" style="width:40px;margin-right:5px;display:block"></div>
                <div class="weui-cell__bd">
                    <p>${office.name }</p>
                </div>
                <div class="weui-cell__ft"><c:if test="${office.userNum > 0}">共${office.userNum }人</c:if></div>
            </a>
            </c:forEach>
        </div>
        </c:if>
        <div class="weui-cells">
			<c:forEach items="${userList}" var="user">
            <a class="weui-cell weui-cell_access" href="${ctx}/mobile/sys/sysUser/view?id=${user.id}">
                <div class="weui-cell__hd"><img src="${ctxStatic}/images/user.png" alt="" style="width:40px;margin-right:5px;display:block"></div>
                <div class="weui-cell__bd">
                    <p>${user.name }</p>
                </div>
                <div class="weui-cell__ft"></div>
            </a>
            </c:forEach>
        </div>
     </div>
     
     <div class="weui-tabbar">
     	
	 </div>
	</div>
  </body>
</html>
