<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
  <head>
  	<title>客户指派</title>
    <%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
    <script src="${ctxStatic}/My97DatePicker/WdatePicker.js" type="text/javascript"></script>
    <script type="text/javascript">
    	function doSubmit(){    		
    		
    		$("#inputForm").submit();
    	}
    </script>
    
  </head>
  <body ontouchstart>
  	
     <div class="page-content">
     	<form:form id="inputForm" modelAttribute="crmCustomer" action="${ctx}/mobile/crm/crmCustomer/saveShare" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<div class="weui-cells__title">将客户指派给</div>
		<div class="weui-cells weui-cells_form">
	      	
	      	<div class="weui-cell weui-cell_select weui-cell_select-after">
		        <div class="weui-cell__bd">
		        	<form:select path="ownBy.id" class="weui-select">
						<form:options items="${fns:getUserList()}" itemLabel="name" itemValue="id" htmlEscape="false"/>
				    </form:select>
		        </div>
	      	</div>
	    </div>	
	   
		</form:form>
     </div> 
     <div class="weui-tabbar">
		<a id="btnSubmit" href="#" onclick="doSubmit()" class="weui-tabbar__item weui-navbar__item">
	          	提交
		</a>
		
	 </div>
  </body>
</html>
