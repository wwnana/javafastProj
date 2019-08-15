<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
  <head>
  	<title><c:if test="${empty crmService.id}">新建</c:if><c:if test="${not empty crmService.id}">编辑</c:if>工单</title>
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
    			
    			alertMsgBox("请输入工单主题");
    			return false;
    		}
    		var content = $("#content").val();
    		if(content==null||content==undefined||content==""){
    			
    			alertMsgBox("请输入工单内容");
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
     	
	     
     	<form:form id="inputForm" modelAttribute="crmService" action="${ctx}/mobile/crm/crmService/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		
		
			<div class="weui-cells__title">客户名称 <font class="red">*</font></div>
			<div class="weui-panel weui-cell weui-cell_select weui-cell_select-after" onclick="selectCustomer()">
		        <div class="weui-cell__bd">
		        	<input id="customerId" name="customer.id" value="${crmService.customer.id}" class="weui-select" type="hidden">
		        	<input id="customerName" name="customer.name" value="${crmService.customer.name}" class="weui-select" type="text" readonly="readonly" placeholder="请选择客户">
		        </div>
	      	</div>
	      	
	      	
			<div class="weui-cells__title">工单信息 <font class="red">*</font></div>
			<div class="weui-cells weui-cells_form">
	      	<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">工单主题</label></div>
		        <div class="weui-cell__bd">
		          <form:input path="name" htmlEscape="false" maxlength="50" class="weui-input" placeholder="请输入工单主题"/>
		        </div>
	      	</div>
	      	<div class="weui-cell weui-cell_select weui-cell_select-after">
	        	<div class="weui-cell__hd"><label class="weui-label">工单类型</label></div>
		        <div class="weui-cell__bd">
		          <form:select path="serviceType" class="weui-select">
						<form:options items="${fns:getDictList('service_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				  </form:select>
		        </div>
	      	</div>
	      	<div class="weui-cell weui-cell_select weui-cell_select-after">
	        	<div class="weui-cell__hd"><label class="weui-label">优先级</label></div>
		        <div class="weui-cell__bd">
		          <form:select path="levelType" class="weui-select">
						<form:options items="${fns:getDictList('level_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				  </form:select>
		        </div>
	      	</div>
	      	
	      	
	      	<div class="weui-cell weui-cell_select weui-cell_select-after">
                <div class="weui-cell__hd"><label for="" class="weui-label">负责人</label></div>
                <div class="weui-cell__bd">
                    <form:select path="ownBy.id" class="weui-select">
							<form:options items="${fns:getUserList()}" itemLabel="name" itemValue="id" htmlEscape="false"/>
					</form:select>
                </div>
            </div>
	      	
	    </div>	
	    <div class="weui-cells__title">工单内容 <font class="red">*</font></div>
		<div class="weui-cells weui-cells_form">
		    <div class="weui-cell">
			        <div class="weui-cell__bd">
			        	<form:textarea path="content" htmlEscape="false" rows="3" maxlength="200" class="weui-textarea" placeholder="请输入工单内容"/>
			        </div>
		    </div>
		 </div>
		 <div class="weui-cells__title">期望结果</div>
		<div class="weui-cells weui-cells_form">
		    <div class="weui-cell">
			        <div class="weui-cell__bd">
			        	<form:textarea path="expecte" htmlEscape="false" rows="3" maxlength="50" class="weui-textarea" placeholder="请输入期望结果"/>
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
