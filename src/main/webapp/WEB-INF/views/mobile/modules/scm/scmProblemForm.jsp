<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
  <head>
  	<title><c:if test="${empty scmProblem.id}">新建</c:if><c:if test="${not empty scmProblem.id}">编辑</c:if>知识</title>
    <%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
    <script type="text/javascript">
    	function doSubmit(){
    		
    		var name = $("#name").val();
    		if(name==null||name==undefined||name==""){
    			
    			alertMsgBox("请输入标题");
    			return false;
    		}
    		
    		var content = $("#content").val();
    		if(content==null||content==undefined||content==""){
    			
    			alertMsgBox("请输入内容");
    			return false;
    		}
    		
    		changeConent=false;
    		$("#inputForm").submit();
    	}
    	
    	//离开页面提醒
    	var changeConent=false;  
    	$(function(){    	    
    	    //文本框内容改变  
    	    $("#name").change(function(){  
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
  <body ontouchstart>
  	
     <div class="page-content">
     	
	     
     	<form:form id="inputForm" modelAttribute="scmProblem" action="${ctx}/mobile/scm/scmProblem/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		
		
		<div class="weui-cells__title">知识信息</div>
		<div class="weui-cells weui-cells_form">
	      	<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">标题<font class="red">*</font></label></div>
		        <div class="weui-cell__bd">
		          <form:input path="name" htmlEscape="false" maxlength="50" class="weui-input" placeholder="请输入知识标题"/>
		        </div>
	      	</div>
	      	
	      	<div class="weui-cell weui-cell_select weui-cell_select-after">
	        	<div class="weui-cell__hd"><label class="weui-label">分类<font class="red">*</font></label></div>
		        <div class="weui-cell__bd">
		          <form:select path="scmProblemType.id" class="weui-select">
						<form:options items="${scmProblemTypeList}" itemLabel="name" itemValue="id" htmlEscape="false"/>
				  </form:select>
		        </div>
	      	</div>
	      	
	      	
	    </div>	
	    <div class="weui-cells__title">内容</div>
		<div class="weui-cells weui-cells_form">
		    <div class="weui-cell">
			        <div class="weui-cell__bd">
			        	<form:textarea path="content" htmlEscape="false" rows="8" maxlength="10000" class="weui-textarea" placeholder="请输入知识内容"/>
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
