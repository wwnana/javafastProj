<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
  <head>
  	<title><c:if test="${empty crmChance.id}">新建</c:if><c:if test="${not empty crmChance.id}">编辑</c:if>商机</title>
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
    			
    			alertMsgBox("请输入商机名称");
    			return false;
    		}
    		
    		var saleAmount = $("#saleAmount").val();
    		if(saleAmount != "" && saleAmount !=null){
    			if(isNaN(saleAmount)){
        			
    				alertMsgBox("预计销售金额必须为数字类型");
        			return false;
        		}
    		}
    		if(saleAmount > 10000000000){
    			alertMsgBox("预计销售金额为0~10000000000之间的数字");
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
     	
     	<form:form id="inputForm" modelAttribute="crmChance" action="${ctx}/mobile/crm/crmChance/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		
		<div class="weui-cells__title">客户名称 <font class="red">*</font></div>
		<div class="weui-panel weui-cell weui-cell_select weui-cell_select-after" onclick="selectCustomer()">
	        <div class="weui-cell__bd">
	        	<input id="customerId" name="customer.id" value="${crmChance.customer.id}" class="weui-select" type="hidden">
	        	<input id="customerName" name="customer.name" value="${crmChance.customer.name}" class="weui-select" type="text" readonly="readonly" placeholder="请选择客户">
	        </div>
      	</div>
		
		
		<div class="weui-cells__title">商机信息</div>
		<div class="weui-cells weui-cells_form">
	      	<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">商机名称 <font class="red">*</font></label></div>
		        <div class="weui-cell__bd">
		          <form:input path="name" htmlEscape="false" maxlength="50" class="weui-input" placeholder="请输入商机名称"/>
		        </div>
	      	</div>
	      	<div class="weui-cell weui-cell_select weui-cell_select-after">
	        	<div class="weui-cell__hd"><label class="weui-label">商机类型</label></div>
		        <div class="weui-cell__bd">
		          <form:select path="changeType" class="weui-select">
						<form:options items="${fns:getDictList('change_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				  </form:select>
		        </div>
	      	</div>
	      	<div class="weui-cell weui-cell_select weui-cell_select-after">
	        	<div class="weui-cell__hd"><label class="weui-label">商机来源</label></div>
		        <div class="weui-cell__bd">
		          <form:select path="sourType" class="weui-select">
						<form:options items="${fns:getDictList('sour_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				  </form:select>
		        </div>
	      	</div>
	      	<div class="weui-cell weui-cell_select weui-cell_select-after">
	        	<div class="weui-cell__hd"><label class="weui-label">销售阶段</label></div>
		        <div class="weui-cell__bd">
		          <form:select path="periodType" class="weui-select">
						<form:options items="${fns:getDictList('period_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				  </form:select>
		        </div>
	      	</div>
	      	<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">销售金额(元)</label></div>
		        <div class="weui-cell__bd">
		          <form:input path="saleAmount" htmlEscape="false" maxlength="10" class="weui-input" type="number" pattern="[0-9]*" placeholder="请输入预计销售金额"/>
		        </div>
	      	</div>
	      	<div class="weui-cell weui-cell_select weui-cell_select-after">
	        	<div class="weui-cell__hd"><label class="weui-label">赢单率</label></div>
		        <div class="weui-cell__bd">
		        	<form:select path="probability" class="weui-select">
						<form:options items="${fns:getDictList('probability_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				  </form:select>
		        </div>
	      	</div>
	      	
	      	<div class="weui-cell weui-cell_select weui-cell_select-after">
                <div class="weui-cell__hd">
                    <label for="" class="weui-label">负责人</label>
                </div>
                <div class="weui-cell__bd">
                    <form:select path="ownBy.id" class="weui-select">
							<form:options items="${fns:getUserList()}" itemLabel="name" itemValue="id" htmlEscape="false"/>
					</form:select>
                </div>
            </div>
	      	
	    </div>	
	    <div class="weui-cells__title">商机描述</div>
		<div class="weui-cells weui-cells_form">
	    <div class="weui-cell">
		        <div class="weui-cell__bd">
		        	<form:textarea path="remarks" htmlEscape="false" rows="3" maxlength="200" class="weui-textarea" placeholder="请输入商机描述"/>
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
