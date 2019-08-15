<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
  <head>
  	<title><c:if test="${empty wmsProduct.id}">新建</c:if><c:if test="${not empty wmsProduct.id}">编辑</c:if>产品</title>
    <%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
    <script type="text/javascript">
    	function doSubmit(){
    		
    		var name = $("#name").val();
    		if(name==null||name==undefined||name==""){
    			
    			alertMsgBox("请输入产品名称");
    			return false;
    		}
    		var no = $("#no").val();
    		if(no==null||no==undefined||no==""){
    			
    			alertMsgBox("请输入产品编号");
    			return false;
    		}
    		var salePrice = $("#salePrice").val();
    		if(salePrice==null||salePrice==undefined||salePrice==""){
    			
    			alertMsgBox("请输入产品售价");
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
     	
	     
     	<form:form id="inputForm" modelAttribute="wmsProduct" action="${ctx}/mobile/wms/wmsProduct/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		
		
		<div class="weui-cells__title">产品信息</div>
		<div class="weui-cells weui-cells_form">
	      	<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">产品名称<font class="red">*</font></label></div>
		        <div class="weui-cell__bd">
		          <form:input path="name" htmlEscape="false" maxlength="50" class="weui-input" placeholder="请输入产品名称"/>
		        </div>
	      	</div>
	      	<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">产品编号<font class="red">*</font></label></div>
		        <div class="weui-cell__bd">
		          <form:input path="no" htmlEscape="false" maxlength="50" class="weui-input" placeholder="请输入产品编号"/>
		        </div>
	      	</div>
	      	<div class="weui-cell weui-cell_select weui-cell_select-after">
	        	<div class="weui-cell__hd"><label class="weui-label">产品分类<font class="red">*</font></label></div>
		        <div class="weui-cell__bd">
		          <form:select path="productType.id" class="weui-select">
						<form:options items="${wmsProductTypeList}" itemLabel="name" itemValue="id" htmlEscape="false"/>
				  </form:select>
		        </div>
	      	</div>
	      	<div class="weui-cell weui-cell_select weui-cell_select-after">
	        	<div class="weui-cell__hd"><label class="weui-label">基本单位<font class="red">*</font></label></div>
		        <div class="weui-cell__bd">
        				<form:select path="unitType" class="weui-select">
							<form:options items="${fns:getDictList('unit_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
						</form:select>
		        </div>
	      	</div>
	      	<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">产品规格</label></div>
		        <div class="weui-cell__bd">
        				<form:input path="spec" htmlEscape="false" maxlength="50" class="weui-input" placeholder="请输入产品规格"/>
		        </div>
	      	</div>
	      	<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">售价<font class="red">*</font></label></div>
		        <div class="weui-cell__bd">
		          <form:input path="salePrice" htmlEscape="false" maxlength="50" class="weui-input" type="number" pattern="[0-9]*" placeholder="请输入产品售价"/>
		        </div>
	      	</div>
	      	
	      	<div class="weui-cell weui-cell_select weui-cell_select-after">
	        	<div class="weui-cell__hd"><label class="weui-label">状态</label></div>
		        <div class="weui-cell__bd">
		        	<form:select path="status" class="weui-select">
						<form:options items="${fns:getDictList('use_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
		        </div>
	      	</div>
	      	
	    </div>	
	    <div class="weui-cells__title">产品描述</div>
		<div class="weui-cells weui-cells_form">
		    <div class="weui-cell">
			        <div class="weui-cell__bd">
			        	<form:textarea path="wmsProductData.content" htmlEscape="false" rows="5" maxlength="200" class="weui-textarea" placeholder="请输入产品描述"/>
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
