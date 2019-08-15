<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
  <head>
  	<title>审核工单</title>
    <%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
    <script type="text/javascript">
    	function doSubmit(){
    		
    		
    		 //询问框
    		  layer.open({
    		    content: '您确认审核该工单吗？'
    		    ,btn: ['确定', '取消']
    		    ,yes: function(index){
    		      
    		    	$("#inputForm").submit();
    		    }
    		  });
    		
    	}
    	
    	
    	
    </script>
  </head>
  <body ontouchstart>
  	
  	
     <div class="page-content">
     	
	     
     	<form:form id="inputForm" modelAttribute="crmService" action="${ctx}/mobile/crm/crmService/audit" method="post" class="form-horizontal">
		<form:hidden path="id"/>

	      	<div class="weui-cell weui-cell_select weui-cell_select-after">
	        	<div class="weui-cell__hd"><label class="weui-label">满意度<font class="red">*</font></label></div>
		        <div class="weui-cell__bd">
		          <form:select path="satisfyType" class="weui-select">
						<form:options items="${fns:getDictList('satisfy_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				  </form:select>
		        </div>
	      	</div>
	      	
	      	
	    </div>	
	    <div class="weui-cells__title">备注</div>
		<div class="weui-cells weui-cells_form">
		    <div class="weui-cell">
			        <div class="weui-cell__bd">
			        	<form:textarea path="remarks" htmlEscape="false" rows="3" maxlength="50" class="weui-textarea" placeholder="请输入工单备注"/>
			        </div>
		    </div>
		 </div>
		 
		</form:form>
     </div> 
     <div class="weui-tabbar">
		<a id="btnSubmit" href="#" onclick="doSubmit()" class="weui-tabbar__item weui-navbar__item">
	          	保存
		</a>
		
	 </div>
  </body>
</html>
