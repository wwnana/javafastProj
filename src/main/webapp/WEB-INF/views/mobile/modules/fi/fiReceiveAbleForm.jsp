<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
  <head>
  	<title>应收款管理</title>
    <%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
    <script type="text/javascript">
    	function doSubmit(){
    		
    		var customerId = $("#customerId").val();
    		if(customerId==null||customerId==undefined||customerId==""){
    			
    			alertMsgBox("请选择客户");
    			return false;
    		}
    		
    		var amount = $("#amount").val();
    		if(amount==null||amount==undefined||amount==""){
    			
    			alertMsgBox("请输入应收金额");
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
     	
	     
     	<form:form id="inputForm" modelAttribute="fiReceiveAble" action="${ctx}/mobile/fi/fiReceiveAble/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<form:hidden path="customer.id"/>
		
		<div class="weui-cells__title">所属客户</div>
		<div class="weui-panel weui-cell weui-cell_select weui-cell_select-after" onclick="selectCustomer()">
	        <div class="weui-cell__bd">
	        	<input id="customerId" name="customer.id" value="${fiReceiveAble.customer.id}" class="weui-select" type="hidden">
	        	<input id="customerName" name="customer.name" value="${fiReceiveAble.customer.name}" class="weui-select" type="text">
	        </div>
      	</div>
      	
		<div class="weui-cells__title">应收款信息</div>
		<div class="weui-cells weui-cells_form">
	      	<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">应收金额<font class="red">*</font></label></div>
		        <div class="weui-cell__bd">
		          <form:input path="amount" htmlEscape="false" maxlength="50" class="weui-input" type="number" pattern="[0-9]*" placeholder="请输入应收金额"/>
		        </div>
	      	</div>
	      
	      	
	      	
	      	<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">负责人</label></div>
		        <div class="weui-cell__bd">
		        	<form:select path="ownBy.id" class="weui-input">
							<form:options items="${fns:getUserList()}" itemLabel="name" itemValue="id" htmlEscape="false"/>
					</form:select>
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
