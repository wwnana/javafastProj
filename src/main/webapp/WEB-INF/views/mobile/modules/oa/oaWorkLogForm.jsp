<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
  <head>
  	<title><c:if test="${empty oaWorkLog.id}">新建</c:if><c:if test="${not empty oaWorkLog.id}">编辑</c:if>工作报告</title>
    <%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
    <script type="text/javascript">
    	function doSubmit(){    	
    		
    		
    		
    		var content = $("#content").val();
    		if(content==null||content==undefined||content==""){
    			
    			alertMsgBox("请输入工作报告内容");
    			return false;
    		}
    		
    		changeConent=false;
    		$("#inputForm").submit();
    	}
    	
    	var changeConent=false;  
    	$(function(){    	    
    	    //文本框内容改变  
    	    $("#content").change(function(){  
    	        changeConent=true;  
    	    });
    	});
    	
    	window.onbeforeunload=function(){  
	        if(changeConent){
	            return "亲~页面编辑的内容尚未保存";  
	        }  
	    }
    </script>
  </head>
  <body>
  	
     <div class="page-content">
     	<form:form id="inputForm" modelAttribute="oaWorkLog" action="${ctx}/mobile/oa/oaWorkLog/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		
		<div class="weui-cells__title">汇报信息</div>
		<div class="weui-cells weui-cells_form">
	      	
	      	
			<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">标题<font class="red">*</font></label></div>
		        <div class="weui-cell__bd">
		          <form:input path="title" htmlEscape="false" maxlength="50" class="weui-input" placeholder="请输入标题"/>
		        </div>
	      	</div>
	      	<div class="weui-cell weui-cell_select weui-cell_select-after">
	        	<div class="weui-cell__hd"><label class="weui-label">类型<font class="red">*</font></label></div>
		        <div class="weui-cell__bd">

		          <form:select path="workLogType" class="weui-select">
						<form:options items="${fns:getDictList('work_log_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				  </form:select>
		        </div>
	      	</div>
	      	<div class="weui-cell weui-cell_select weui-cell_select-after">
	        	<div class="weui-cell__hd"><label class="weui-label">汇报给<font class="red">*</font></label></div>
		        <div class="weui-cell__bd">
		          <form:select path="auditBy.id" class="weui-select">
		          	
						<form:options items="${fns:getUserList()}" itemLabel="name" itemValue="id" htmlEscape="false"/>
				  </form:select>
		        </div>
	      	</div>
			<div class="weui-cell">
	      		<div class="weui-cell__hd"><label class="weui-label">内容<font class="red">*</font></label></div>
	      	</div>
	      	<div class="weui-cell">
		        <div class="weui-cell__bd">
		        	<form:textarea path="content" htmlEscape="false" rows="8" maxlength="200" class="weui-textarea" placeholder="请输入工作报告内容"/>
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
