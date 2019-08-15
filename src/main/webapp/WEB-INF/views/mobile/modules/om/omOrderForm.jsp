<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
  <head>
  	<title><c:if test="${empty omOrder.id}">新建</c:if><c:if test="${not empty omOrder.id}">编辑</c:if>销售订单</title>
    <%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
    <script type="text/javascript">
	    
    	function doSubmit(){
    		
    		var customerId = $("#customerId").val();
    		if(customerId==null||customerId==undefined||customerId==""){
    			
    			alertMsgBox("请选择客户");
    			return false;
    		}
    		
    		var no = $("#no").val();
    		if(no==null||no==undefined||no==""){
    			
    			alertMsgBox("请输入订单编号");
    			return false;
    		}
    		
    		
    		var amount = $("#amount").val();
    		if(amount==null||amount==undefined||amount==""){
    			
    			alertMsgBox("请输入订单金额");
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
    	//商机选择器
		function selectChance(){
			
			var iframeHeight = document.body.clientHeight + "px";
			var html = "<iframe src=\"${ctx}/mobile/crm/crmChance/selectList\" style=\"border:0;width: 100%;height: "+iframeHeight+"\"></iframe>";
			
			var pageii = layer.open({
				  type: 1
				  ,content: html
				  ,anim: 'up'
				  ,style: 'position:fixed; left:0; top:0; width:100%; height:100%; border: none; -webkit-animation-duration: .5s; animation-duration: .5s;'
				});
		}
    </script>
  </head>
  <body ontouchstart>
  	
     <div class="page-content">
     	
     	<form:form id="inputForm" modelAttribute="omOrder" action="${ctx}/mobile/om/omOrder/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		
		<div class="weui-cells__title">客户名称 <font class="red">*</font></div>
		<div class="weui-panel weui-cell weui-cell_select weui-cell_select-after" onclick="selectCustomer()">
	        <div class="weui-cell__bd">
	        	<input id="customerId" name="customer.id" value="${omOrder.customer.id}" class="weui-select" type="hidden">
	        	<input id="customerName" name="customer.name" value="${omOrder.customer.name}" class="weui-select" type="text" readonly="readonly" placeholder="请选择客户">
	        </div>
      	</div>
		
		<div class="weui-cells__title">订单信息</div>
		<div class="weui-cells weui-cells_form">
	      	<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">订单编号 <font class="red">*</font></label></div>
		        <div class="weui-cell__bd">
		          <form:input path="no" htmlEscape="false" maxlength="50" class="weui-input" placeholder="请输入订单编号"/>
		        </div>
	      	</div>
	      	
	      	<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">订单金额(元) <font class="red">*</font></label></div>
		        <div class="weui-cell__bd">
		          <form:input path="amount" htmlEscape="false" maxlength="10" class="weui-input" type="number" pattern="[0-9]*" placeholder="请输入订单金额"/>
		        </div>
	      	</div>
	      	<div class="weui-cell weui-cell_select weui-cell_select-after">
	        	<div class="weui-cell__hd"><label class="weui-label">是否开票 <font class="red">*</font></label></div>
		        <div class="weui-cell__bd">
        				<form:select path="isInvoice" class="weui-select">
							<form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
						</form:select>
		        </div>
	      	</div>
	      	<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">开票金额(元)</label></div>
		        <div class="weui-cell__bd">
		          <form:input path="invoiceAmt" htmlEscape="false" maxlength="10" class="weui-input" type="number" pattern="[0-9]*" placeholder="请输入开票金额"/>
		        </div>
	      	</div>
	      	<div class="weui-cell weui-cell_select weui-cell_select-after">
                <div class="weui-cell__hd">
                    <label for="" class="weui-label">负责人</label>
                </div>
                <div class="weui-cell__bd">
                    <form:select path="dealBy.id" class="weui-select">
							<form:options items="${fns:getUserList()}" itemLabel="name" itemValue="id" htmlEscape="false"/>
					</form:select>
                </div>
            </div>
	      	
	    </div>	
	    <div class="weui-cells__title">订单描述</div>
		<div class="weui-cells weui-cells_form">
	    <div class="weui-cell">
		        <div class="weui-cell__bd">
		        	<form:textarea path="content" htmlEscape="false" rows="3" maxlength="50" class="weui-textarea" placeholder="请输入订单描述"/>
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
