<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
  <head>
  	<title>报价单查询</title>
    <%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
    <script type="text/javascript">
    	function doSubmit(){
    		
    		$("#inputForm").submit();
    	}
    </script>
  </head>
  <body ontouchstart>
  	
     <div class="page-content">
     	<form:form id="inputForm" modelAttribute="crmQuote" action="${ctx}/mobile/crm/crmQuote/" method="post" class="form-horizontal">
		
		<div class="weui-cells weui-cells_form">
	      	<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">审核状态</label></div>
		        <div class="weui-cell__bd">
		          <form:select path="status" class="weui-input">
		          	<form:option value="" label="---请选择---"/>
						<form:options items="${fns:getDictList('audit_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				  </form:select>
		        </div>
	      	</div>
	      	
	    </div>
	    </form:form>	
     </div>
      
     
	 <div class="weui-tabbar">
		<a id="btnSubmit" href="#" onclick="doSubmit()" class="weui-tabbar__item weui-navbar__item">
	          	查询
		</a>
		<a href="${ctx}/mobile/crm/crmQuote" class="weui-tabbar__item weui-navbar__item">
	          	返回
		</a>
	 </div>
  </body>
</html>
