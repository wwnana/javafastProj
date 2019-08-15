<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
  <head>
  	<title><c:if test="${empty crmContactRecord.id}">新建</c:if><c:if test="${not empty crmContactRecord.id}">编辑</c:if>跟进记录</title>
    <%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
    <script type="text/javascript">
    	function doSubmit(){    		
    		var customerId = $("#targetId").val();
    		if(customerId==null||customerId==undefined||customerId==""){
    			
    			alertMsgBox("请选择客户");
    			return false;
    		}
    		var content = $("#content").val();
    		if(content==null||content==undefined||content==""){
    			
    			alertMsgBox("请输入沟通内容");
    			return false;
    		}
    		changeConent=false;
    		$("#inputForm").submit();
    	}
    	
    	//离开页面提醒
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
    	//客户选择器
    	function selectCustomer(){
    		
    		var iframeHeight = document.body.clientHeight + "px";
    		var html = "<iframe src=\"${ctx}/mobile/crm/crmCustomer/selectListForRecord\" style=\"border:0;width: 100%;height: "+iframeHeight+"\"></iframe>";
    		
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
     	
	     
     	<form:form id="inputForm" modelAttribute="crmContactRecord" action="${ctx}/mobile/crm/crmContactRecord/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<form:hidden path="targetType"/>
		
		<div class="weui-cells__title">客户名称 <font class="red">*</font></div>
			<div class="weui-panel weui-cell weui-cell_select weui-cell_select-after" onclick="selectCustomer()">
		        <div class="weui-cell__bd">
		        	<input id="targetId" name="targetId" value="${crmContactRecord.targetId}" class="weui-select" type="hidden">
		        	<input id="targetName" name="targetName" value="${crmContactRecord.targetName}" class="weui-select" type="text" readonly="readonly" placeholder="请选择客户">
		        </div>
	      	</div>
	     
		<div class="weui-cells__title">沟通信息 <font class="red">*</font></div>
		<div class="weui-cells weui-cells_form">
	      	
	      	<div class="weui-cell weui-cell_select weui-cell_select-after">
	        	<div class="weui-cell__hd"><label class="weui-label">沟通主题</label></div>
		        <div class="weui-cell__bd">
		          <form:select path="contactType" class="weui-select">
						<form:options items="${fns:getDictList('contact_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				  </form:select>
		        </div>
	      	</div>
	      	<div class="weui-cell weui-cell_select weui-cell_select-after">
	        	<div class="weui-cell__hd"><label class="weui-label">沟通日期</label></div>
		        <div class="weui-cell__bd">
		        	<input name="contactDate" class="weui-select" type="date" value="<fmt:formatDate value="${crmContactRecord.contactDate}" pattern="yyyy-MM-dd"/>">
		        </div>
	      	</div>
	      	
	    </div>	
	    <div class="weui-cells__title">沟通内容 <font class="red">*</font></div>
		<div class="weui-cells weui-cells_form">
	    <div class="weui-cell">
		        <div class="weui-cell__bd">
		        	<form:textarea path="content" htmlEscape="false" rows="5" maxlength="200" class="weui-textarea" placeholder="请输入沟通内容"/>
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
