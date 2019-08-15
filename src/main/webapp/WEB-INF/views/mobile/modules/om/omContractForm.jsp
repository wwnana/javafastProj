<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
  <head>
  	<title><c:if test="${empty omContract.id}">新建</c:if><c:if test="${not empty omContract.id}">编辑</c:if>合同订单</title>
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
    			
    			alertMsgBox("请输入合同编号");
    			return false;
    		}
    		
    		var name = $("#name").val();
    		if(name==null||name==undefined||name==""){
    			
    			alertMsgBox("请输入合同主题");
    			return false;
    		}
    		
    		var amount = $("#amount").val();
    		if(amount==null||amount==undefined||amount==""){
    			
    			alertMsgBox("请输入合同金额");
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
    		
			var customerId = $("#customerId").val();
    		if(customerId==null||customerId==undefined||customerId==""){
    			
    			alertMsgBox("请选择客户");
    			return false;
    		}
    		
			var iframeHeight = document.body.clientHeight + "px";
			var html = "<iframe src=\"${ctx}/mobile/crm/crmChance/selectList?customer.id="+customerId+"\" style=\"border:0;width: 100%;height: "+iframeHeight+"\"></iframe>";
			
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
     	
     	<form:form id="inputForm" modelAttribute="omContract" action="${ctx}/mobile/om/omContract/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<form:hidden path="order.id"/>
		<div class="weui-cells__title">客户名称 <font class="red">*</font></div>
		<div class="weui-panel weui-cell weui-cell_select weui-cell_select-after" onclick="selectCustomer()">
	        <div class="weui-cell__bd">
	        	<input id="customerId" name="customer.id" value="${omContract.customer.id}" class="weui-select" type="hidden">
	        	<input id="customerName" name="customer.name" value="${omContract.customer.name}" class="weui-select" type="text" readonly="readonly" placeholder="请选择客户">
	        </div>
      	</div>
      	<div class="weui-cells__title">关联商机</div>
		<div class="weui-panel weui-cell weui-cell_select weui-cell_select-after" onclick="selectChance()">
	        <div class="weui-cell__bd">
	        	<input id="chanceId" name="chance" value="${omContract.chance.id}" class="weui-select" type="hidden">
	        	<input id="chanceName" name="chance" value="${omContract.chance.name}" class="weui-select" type="text" readonly="readonly" placeholder="请选择商机">
	        </div>
      	</div>
		
		
		<div class="weui-cells__title">合同信息</div>
		<div class="weui-cells weui-cells_form">
	      	<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">合同编号 <font class="red">*</font></label></div>
		        <div class="weui-cell__bd">
		          <form:input path="no" htmlEscape="false" maxlength="50" class="weui-input" placeholder="请输入合同编号"/>
		        </div>
	      	</div>
	      	<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">合同主题 <font class="red">*</font></label></div>
		        <div class="weui-cell__bd">
		          <form:input path="name" htmlEscape="false" maxlength="50" class="weui-input" placeholder="请输入合同主题"/>
		        </div>
	      	</div>
	      	<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">合同金额 <font class="red">*</font></label></div>
		        <div class="weui-cell__bd">
		          <form:input path="amount" htmlEscape="false" maxlength="10" class="weui-input" type="number" pattern="[0-9]*" placeholder="请输入合同金额(元)"/>
		        </div>
	      	</div>
	      	<div class="weui-cell weui-cell_select weui-cell_select-after">
	        	<div class="weui-cell__hd"><label class="weui-label">签约日期 <font class="red">*</font></label></div>
		        <div class="weui-cell__bd">
		        	<input name="dealDate" class="weui-select" type="date" value="<fmt:formatDate value="${omContract.dealDate}" pattern="yyyy-MM-dd"/>">
		        </div>
	      	</div>
	      	<div class="weui-cell weui-cell_select weui-cell_select-after">
	        	<div class="weui-cell__hd"><label class="weui-label">交付日期</label></div>
		        <div class="weui-cell__bd">
		        	<input name="deliverDate" class="weui-select" type="date" value="<fmt:formatDate value="${omContract.deliverDate}" pattern="yyyy-MM-dd"/>">
		        </div>
	      	</div>
	      	<div class="weui-cell weui-cell_select weui-cell_select-after">
	        	<div class="weui-cell__hd"><label class="weui-label">生效时间</label></div>
		        <div class="weui-cell__bd">
		        	<input name="startDate" class="weui-select" type="date" value="<fmt:formatDate value="${omContract.startDate}" pattern="yyyy-MM-dd"/>">
		        </div>
	      	</div>
	      	<div class="weui-cell weui-cell_select weui-cell_select-after">
	        	<div class="weui-cell__hd"><label class="weui-label">到期时间</label></div>
		        <div class="weui-cell__bd">
		        	<input name="endDate" class="weui-select" type="date" value="<fmt:formatDate value="${omContract.endDate}" pattern="yyyy-MM-dd"/>">
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
	    <div class="weui-cells__title">合同内容</div>
		<div class="weui-cells weui-cells_form">
	    <div class="weui-cell">
		        <div class="weui-cell__bd">
		        	<form:textarea path="notes" htmlEscape="false" rows="3" maxlength="10000" class="weui-textarea" placeholder="请输入合同内容"/>
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
