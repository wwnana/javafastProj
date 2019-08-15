<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
  <head>
  	<title>联系人查询</title>
    <%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
    <script type="text/javascript">
    	function doSubmit(){    		
    		$("#inputForm").submit();
    	}
    </script>
  </head>
  <body ontouchstart>
  	
     <div class="page-content">
     	<form:form id="inputForm" modelAttribute="crmContacter" action="${ctx}/mobile/crm/crmContacter/" method="post" class="form-horizontal">
		
		<div class="weui-cells weui-cells_form">
	      	<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">姓名</label></div>
		        <div class="weui-cell__bd">
		          <form:input path="name" htmlEscape="false" maxlength="50" class="weui-input" placeholder="请输入姓名"/>
		        </div>
	      	</div>
	      	<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">手机</label></div>
		        <div class="weui-cell__bd">
		          <form:input path="mobile" htmlEscape="false" maxlength="50" class="weui-input" placeholder="请输入手机"/>
		        </div>
	      	</div>
	    </div>
	    </form:form>	
     </div>
      
	 <div class="weui-tabbar">
		<a id="btnSubmit" href="#" onclick="doSubmit()" class="weui-tabbar__item weui-navbar__item">
	          	查询
		</a>
		<a href="${ctx}/mobile/crm/crmContacter" class="weui-tabbar__item weui-navbar__item">
	          	返回
		</a>
	 </div>
  </body>
</html>
