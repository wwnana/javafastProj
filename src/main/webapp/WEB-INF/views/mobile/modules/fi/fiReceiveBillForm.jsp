<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
  <head>
  	<title><c:if test="${empty fiReceiveBill.id}">新建</c:if><c:if test="${not empty fiReceiveBill.id}">编辑</c:if>收款单</title>
    <%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
    <script type="text/javascript">
    	function doSubmit(){
    		
    		var no = $("#no").val();
    		if(no==null||no==undefined||no==""){
    			
    			alertMsgBox("请输入收款单号");
    			return false;
    		}
    		var amount = $("#amount").val();
    		if(amount==null||amount==undefined||amount==""){
    			
    			alertMsgBox("请输入收款金额");
    			return false;
    		}
    		if(isNaN(amount)){
    			
    			alertMsgBox("金额必须为数字类型");
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
     	
     	<form:form id="inputForm" modelAttribute="fiReceiveBill" action="${ctx}/mobile/fi/fiReceiveBill/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<form:hidden path="fiReceiveAble.id"/>
		<form:hidden path="customer.id"/>
		
		<div class="weui-cells__title">所属客户</div>
		<div class="weui-panel weui-cell">
	        <div class="weui-cell__bd">
	        	${fiReceiveBill.customer.name}
	        </div>
      	</div>
      	<div class="weui-cells__title">所属收款单</div>
		<div class="weui-panel weui-cell">
	        <div class="weui-cell__bd">
	        	${fiReceiveBill.fiReceiveAble.no}
	        </div>
      	</div>
      	
		
		
		<div class="weui-cells__title">收款单信息</div>
		<div class="weui-cells weui-cells_form">
	      	<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">收款单号<font class="red">*</font></label></div>
		        <div class="weui-cell__bd">
		          <form:input path="no" htmlEscape="false" maxlength="50" class="weui-input" placeholder="请输入收款单号"/>
		        </div>
	      	</div>
	      	<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">收款金额<font class="red">*</font></label></div>
		        <div class="weui-cell__bd">
		          <form:input path="amount" htmlEscape="false" maxlength="50" class="weui-input" type="number" pattern="[0-9]*" placeholder="请输入收款金额"/>
		        </div>
	      	</div>
	      	<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">收款日期<font class="red">*</font></label></div>
		        <div class="weui-cell__bd">
		          <input name="dealDate" class="weui-input" type="date" value="<fmt:formatDate value="${fiReceiveBill.dealDate}" pattern="yyyy-MM-dd"/>">
		        </div>
	      	</div>
	      	<div class="weui-cell weui-cell_select weui-cell_select-after">
	        	<div class="weui-cell__hd"><label class="weui-label">收款账户<font class="red">*</font></label></div>
		        <div class="weui-cell__bd">
		          <sys:spinnerselect id="fiAccount" name="fiAccount.id" value="${fiPaymentBill.fiAccount.id}" labelName="fiaccount.name" labelValue="${fiPaymentBill.fiAccount.name}" 
							title="结算账户" url="${ctx}/fi/fiFinanceAccount/getSelectData"  cssClass="weui-select" allowEmpty="false"></sys:spinnerselect>
		        </div>
	      	</div>
	      	<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">开票金额</label></div>
		        <div class="weui-cell__bd">
		          <form:input path="invoiceAmt" htmlEscape="false" maxlength="50" class="weui-input" type="number" pattern="[0-9]*" placeholder="请输入开票金额"/>
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
