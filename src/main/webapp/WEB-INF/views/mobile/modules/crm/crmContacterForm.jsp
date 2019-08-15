<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
  <head>
  	<title><c:if test="${empty crmContacter.id}">新建</c:if><c:if test="${not empty crmContacter.id}">编辑</c:if>联系人</title>
    <%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
    
    <script type="text/javascript">
    	function doSubmit(){
    		
    		var customerId = $("#customerId").val();
    		if(customerId==null||customerId==undefined||customerId==""){
    			
    			alertMsgBox("请选择客户");
    			return false;
    		}
    		
    		var name = $("#name").val();
    		if(name==null||name==undefined||name==""){
    			
    			alertMsgBox("请输入联系人姓名");
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
	     
     	<form:form id="inputForm" modelAttribute="crmContacter" action="${ctx}/mobile/crm/crmContacter/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		
		<div class="weui-cells__title">所属客户<font class="red">*</font></div>
		<div class="weui-panel weui-cell weui-cell_select weui-cell_select-after" onclick="selectCustomer()">
	        <div class="weui-cell__bd">
	        	<input id="customerId" name="customer.id" value="${crmContacter.customer.id}" class="weui-select" type="hidden">
	        	<input id="customerName" name="customer.name" value="${crmContacter.customer.name}" class="weui-select" type="text" placeholder="请选择客户">
	        </div>
      	</div>
		        
		<div class="weui-cells__title">联系人信息</div>
		<div class="weui-cells weui-cells_form">
	      	<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">姓名<font class="red">*</font></label></div>
		        <div class="weui-cell__bd">
		          <form:input path="name" htmlEscape="false" maxlength="30" class="weui-input" placeholder="请输入联系人姓名"/>
		        </div>
	      	</div>
	      	<div class="weui-cell weui-cell_select weui-cell_select-after">
	        	<div class="weui-cell__hd"><label class="weui-label">性别<font class="red">*</font></label></div>
		        <div class="weui-cell__bd">
		          <form:select path="sex" class="weui-select">
						<form:options items="${fns:getDictList('sex')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				  </form:select>
		        </div>
	      	</div>
	      	<div class="weui-cell weui-cell_select weui-cell_select-after">
	        	<div class="weui-cell__hd"><label class="weui-label">角色</label></div>
		        <div class="weui-cell__bd">
		          <form:select path="roleType" class="weui-select">
						<form:options items="${fns:getDictList('role_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				  </form:select>
		        </div>
	      	</div>
	      	<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">职务</label></div>
		        <div class="weui-cell__bd">
		          <form:input path="jobType" htmlEscape="false" maxlength="30" class="weui-input" placeholder="请输入联系人职务"/>
		        </div>
	      	</div>
	      	<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">手机</label></div>
		        <div class="weui-cell__bd">
		          <form:input path="mobile" htmlEscape="false" maxlength="11" class="weui-input" type="number" pattern="[0-9]*" placeholder="请输入联系人手机"/>
		        </div>
	      	</div>
	      	<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">QQ</label></div>
		        <div class="weui-cell__bd">
		          <form:input path="qq" htmlEscape="false" maxlength="16" class="weui-input" type="number" pattern="[0-9]*" placeholder="请输入联系人QQ"/>
		        </div>
	      	</div>
	      	
	      	
	    </div>	
	    <div class="weui-cells__title">联系人描述</div>
		<div class="weui-cells weui-cells_form">
	    <div class="weui-cell">
		        <div class="weui-cell__bd">
		        	<form:textarea path="remarks" htmlEscape="false" rows="3" maxlength="200" class="weui-textarea" placeholder="请输入联系人描述"/>
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
