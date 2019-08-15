<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
  <head>
  	<title><c:if test="${empty omOrderDetailDetail.id}">添加</c:if><c:if test="${not empty omOrderDetail.id}">编辑</c:if>订单明细</title>
    <%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
    <script type="text/javascript">
	    
    	function doSubmit(){
    		
    		var productId = $("#productId").val();
    		if(productId==null||productId==undefined||productId==""){
    			
    			alertMsgBox("请选择产品");
    			return false;
    		}
    		
    		var num = $("#num").val();
    		if(num==null||num==undefined||num==""){
    			
    			alertMsgBox("请输入数量");
    			return false;
    		}
    		
    		var price = $("#price").val();
    		if(price==null||price==undefined||price==""){
    			
    			alertMsgBox("请输入单价");
    			return false;
    		}
    		
    		var amount = $("#amount").val();
    		if(amount==null||amount==undefined||amount==""){
    			
    			alertMsgBox("请输入金额");
    			return false;
    		}
    		
    		if(num == "" || num < 1){
				alertMsgBox("数量不能小于1");
    			return false;
			}
			if(price == "" || price < 0){
				alertMsgBox("单价不能小于0");
    			return false;
			}
    		if(amount == "" || amount < 0){
				alertMsgBox("金额不能小于0");
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
    	//产品选择
		function selectProduct(){
			
			var iframeHeight = document.body.clientHeight + "px";
			var html = "<iframe src=\"${ctx}/mobile/wms/wmsProduct/selectList\" style=\"border:0;width: 100%;height: "+iframeHeight+"\"></iframe>";
			
			var pageii = layer.open({
				  type: 1
				  ,content: html
				  ,anim: 'up'
				  ,style: 'position:fixed; left:0; top:0; width:100%; height:100%; border: none; -webkit-animation-duration: .5s; animation-duration: .5s;'
				});
		}
		function comInput(){
			
			//数量		
			var num = $("#num").val();
			
			//单价
			var price = $("#price").val();									
			
			if(num == "" || num < 1){
    			return false;
			}
			if(price == "" || price < 0){
    			return false;
			}
			
			//计算金额
			if(price != null && price != '' && !isNaN(price) && num != null && num != '' && !isNaN(num)){	
				var amount = price * num;
				$("#amount").val(amount);
			}
			
		}
    </script>
  </head>
  <body ontouchstart>
  	
     <div class="page-content">
     	
     	<form:form id="inputForm" modelAttribute="omOrderDetail" action="${ctx}/mobile/om/omOrderDetail/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<form:hidden path="order.id"/>
		
		
      	
		<div class="weui-cells__title">产品名称</div>
		<div class="weui-cells weui-cells_form">
	      	
			<div class="weui-panel weui-cell weui-cell_select weui-cell_select-after" onclick="selectProduct()">
		        <div class="weui-cell__bd">
		        	<input id="productId" name="product.id" value="${omOrderDetail.product.id}" class="weui-select" type="hidden">
		        	<input id="productName" name="product.name" value="${omOrderDetail.product.name}" class="weui-select" type="text" readonly="readonly" placeholder="请选择产品">
		        </div>
	      	</div>
	      	<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">数量<font class="red">*</font></label></div>
		        <div class="weui-cell__bd">
		          <form:input path="num" htmlEscape="false" maxlength="10" class="weui-input" type="number" pattern="[0-9]*" placeholder="请输入数量" onkeyup="comInput()"/>
		        </div>
	      	</div>
	      	<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">单价(元)<font class="red">*</font></label></div>
		        <div class="weui-cell__bd">
		          <form:input path="price" htmlEscape="false" maxlength="10" class="weui-input" type="number" pattern="[0-9]*" placeholder="请输入单价" onkeyup="comInput()"/>
		        </div>
	      	</div>
	      	<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">金额(元)<font class="red">*</font></label></div>
		        <div class="weui-cell__bd">
		          <form:input path="amount" htmlEscape="false" maxlength="10" class="weui-input" type="number" pattern="[0-9]*" placeholder="请输入金额"/>
		        </div>
	      	</div>
	      	
	      	
	    </div>	
	    <div class="weui-cells__title">备注</div>
		<div class="weui-cells weui-cells_form">
	    <div class="weui-cell">
		        <div class="weui-cell__bd">
		        	<form:textarea path="remarks" htmlEscape="false" rows="3" maxlength="50" class="weui-textarea" placeholder="请输入备注"/>
		        </div>
	      	</div>
	    </div>
	    
	    
	    
		</form:form>
     </div> 
     <div class="weui-tabbar">
		<a id="btnSubmit" href="#" onclick="doSubmit()" class="weui-tabbar__item weui-navbar__item">
	          	保存
		</a>
		<a id="btnSubmit" href="#" onclick="doSubmit()" class="weui-tabbar__item weui-navbar__item">
	          	保存继续添加
		</a>
	 </div>
  </body>
</html>
