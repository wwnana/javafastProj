<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
  <head>
  	<title><c:if test="${empty crmMarket.id}">新建</c:if><c:if test="${not empty crmMarket.id}">编辑</c:if>市场活动</title>
    <%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
    <script type="text/javascript">
    	function doSubmit(){
    		
    		var name = $("#name").val();
    		if(name==null||name==undefined||name==""){
    			
    			alertMsgBox("请输入活动名称");
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
     	
	     
     	<form:form id="inputForm" modelAttribute="crmMarket" action="${ctx}/mobile/crm/crmMarket/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		
		<div class="weui-cells__title">市场活动信息</div>
		<div class="weui-cells weui-cells_form">
	      	<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">活动名称<font class="red">*</font></label></div>
		        <div class="weui-cell__bd">
		          <form:input path="name" htmlEscape="false" maxlength="50" class="weui-input" placeholder="请输入活动名称"/>
		        </div>
	      	</div>
	      	<div class="weui-cell weui-cell_select weui-cell_select-after">
	        	<div class="weui-cell__hd"><label class="weui-label">开始时间</label></div>
		        <div class="weui-cell__bd">
		        	<input name="startDate" class="weui-select" type="date" value="<fmt:formatDate value="${crmMarket.startDate}" pattern="yyyy-MM-dd"/>">
		        </div>
	      	</div>
	      	<div class="weui-cell weui-cell_select weui-cell_select-after">
	        	<div class="weui-cell__hd"><label class="weui-label">结束时间</label></div>
		        <div class="weui-cell__bd">
		        	<input name="endDate" class="weui-select" type="date" value="<fmt:formatDate value="${crmMarket.endDate}" pattern="yyyy-MM-dd"/>">
		        </div>
	      	</div>
	      	
	      	<div class="weui-cell weui-cell_select weui-cell_select-after">
	        	<div class="weui-cell__hd"><label class="weui-label">活动类型<font class="red">*</font></label></div>
		        <div class="weui-cell__bd">
		          <form:select path="marketType" class="weui-select">
						<form:options items="${fns:getDictList('market_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				  </form:select>
		        </div>
	      	</div>
	      	
	      	<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">预计成本(元)</label></div>
		        <div class="weui-cell__bd">
		          <form:input path="estimateCost" htmlEscape="false" maxlength="10" class="weui-input" type="number" pattern="[0-9]*" placeholder="请输入预计成本"/>
		        </div>
	      	</div>
	      	<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">实际成本(元)</label></div>
		        <div class="weui-cell__bd">
		          <form:input path="actualCost" htmlEscape="false" maxlength="10" class="weui-input" type="number" pattern="[0-9]*" placeholder="请输入实际成本"/>
		        </div>
	      	</div>
	      	<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">预计收入(元)</label></div>
		        <div class="weui-cell__bd">
		          <form:input path="estimateAmount" htmlEscape="false" maxlength="10" class="weui-input" type="number" pattern="[0-9]*" placeholder="请输入预计收入"/>
		        </div>
	      	</div>
	      	<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">实际收入(元)</label></div>
		        <div class="weui-cell__bd">
		          <form:input path="actualAmount" htmlEscape="false" maxlength="10" class="weui-input" type="number" pattern="[0-9]*" placeholder="请输入实际收入"/>
		        </div>
	      	</div>
	      	<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">邀请人数</label></div>
		        <div class="weui-cell__bd">
		          <form:input path="inviteNum" htmlEscape="false" maxlength="10" class="weui-input" type="number" pattern="[0-9]*" placeholder="请输入邀请人数"/>
		        </div>
	      	</div>
	      	<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">实际人数</label></div>
		        <div class="weui-cell__bd">
		          <form:input path="actualNum" htmlEscape="false" maxlength="10" class="weui-input" type="number" pattern="[0-9]*" placeholder="请输入实际人数"/>
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
	    <div class="weui-cells__title">活动描述</div>
		<div class="weui-cells weui-cells_form">
	    <div class="weui-cell">
		        <div class="weui-cell__bd">
		        	<form:textarea path="remarks" htmlEscape="false" rows="3" maxlength="200" class="weui-textarea" placeholder="请输入市场活动描述"/>
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
