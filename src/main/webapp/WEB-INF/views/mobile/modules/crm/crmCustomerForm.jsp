<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
  <head>
  	<title><c:if test="${empty crmCustomer.id}">新建</c:if><c:if test="${not empty crmCustomer.id}">编辑</c:if>客户</title>
    <%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
    <script src="${ctxStatic}/My97DatePicker/WdatePicker.js" type="text/javascript"></script>
    <script type="text/javascript">
    	
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
    	
    	function doSubmit(){    		
    		var name = $("#name").val();
    		if(name==null||name==undefined||name==""){        			
    			alertMsgBox("请输入客户名称");
    			return false;
    		}
    		if(name.length > 50){    			
    			alertMsgBox("客户名称必须小于50个字符");
    			return false;
    		}
    		
    		changeConent=false;
    		$("#inputForm").submit();
    	}
    	function showMore(){
    		$("#more_content").toggle();
    	}
    </script>
    
  </head>
  <body ontouchstart>
  	
     <div class="page-content">
     	<form:form id="inputForm" modelAttribute="crmCustomer" action="${ctx}/mobile/crm/crmCustomer/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<div class="weui-cells__title">客户信息</div>
		<div class="weui-cells weui-cells_form">
	      	<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">客户名称<font class="red">*</font></label></div>
		        <div class="weui-cell__bd">
		          <form:input path="name" htmlEscape="false" maxlength="50" class="weui-input" placeholder="请输入客户名称"/>
		        </div>
	      	</div>
	      	<div class="weui-cell weui-cell_select weui-cell_select-after">
	        	<div class="weui-cell__hd"><label class="weui-label">客户分类<font class="red">*</font></label></div>
		        <div class="weui-cell__bd">
		          <form:select path="customerType" class="weui-select">
						<form:options items="${fns:getDictList('customer_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				  </form:select>
		        </div>
	      	</div>
	      	<div class="weui-cell weui-cell_select weui-cell_select-after">
	        	<div class="weui-cell__hd"><label class="weui-label">客户状态</label></div>
		        <div class="weui-cell__bd">
		          <form:select path="customerStatus" class="weui-select">
								<form:options items="${fns:getDictList('customer_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
		        </div>
	      	</div>
	      	<div class="weui-cell weui-cell_select weui-cell_select-after">
	        	<div class="weui-cell__hd"><label class="weui-label">客户级别</label></div>
		        <div class="weui-cell__bd">
		          	<form:select path="customerLevel" class="weui-select">
						<form:options items="${fns:getDictList('customer_level')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
		        </div>
	      	</div>
	      	<div class="weui-cell weui-cell_select weui-cell_select-after">
	        	<div class="weui-cell__hd"><label class="weui-label">负责人</label></div>
		        <div class="weui-cell__bd">
		        	<form:select path="ownBy.id" class="weui-select">
						<form:options items="${fns:getUserList()}" itemLabel="name" itemValue="id" htmlEscape="false"/>
				    </form:select>
		        </div>
	      	</div>
	    </div>	
	    <c:if test="${empty crmCustomer.id}">
	    <div class="weui-cells__title">联系人信息</div>
	    <div class="weui-cells weui-cells_form">
	      	<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">姓名</label></div>
		        <div class="weui-cell__bd">
		          <form:input path="crmContacter.name" htmlEscape="false" maxlength="30" class="weui-input" placeholder="请输入联系人姓名"/>
		        </div>
	      	</div>
	      	<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">职务</label></div>
		        <div class="weui-cell__bd">
		          <form:input path="crmContacter.jobType" htmlEscape="false" maxlength="30" class="weui-input" placeholder="请输入联系人职务"/>
		        </div>
	      	</div>
	      	<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">手机</label></div>
		        <div class="weui-cell__bd">
		          <form:input path="crmContacter.mobile" htmlEscape="false" maxlength="11" class="weui-input" placeholder="请输入联系人手机"/>
		        </div>
	      	</div>
	   	</div>
	   	</c:if>
	   	<div class="weui-panel__ft">
          <a href="javascript:showMore();" class="weui-cell weui-cell_access weui-cell_link">
            <div class="weui-cell__bd">更多信息</div>
            <span class="weui-cell__ft"></span>
          </a>    
        </div>
        
        <div id="more_content" style="display: none;">
	   	<div class="weui-cells__title">客户详情</div>
	   	<div class="weui-cells weui-cells_form">
	   		<div class="weui-cell weui-cell_select weui-cell_select-after">
	        	<div class="weui-cell__hd"><label class="weui-label">客户行业</label></div>
		        <div class="weui-cell__bd">
		          <form:select path="industryType" cssClass="weui-select">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('industry_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				  </form:select>
		        </div>
	      	</div>
	      	<div class="weui-cell weui-cell_select weui-cell_select-after">
	        	<div class="weui-cell__hd"><label class="weui-label">客户来源</label></div>
		        <div class="weui-cell__bd">
		          <form:select path="sourType" cssClass="weui-select">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('sour_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				  </form:select>
		        </div>
	      	</div>
	      	<div class="weui-cell weui-cell_select weui-cell_select-after">
	        	<div class="weui-cell__hd"><label class="weui-label">公司性质</label></div>
		        <div class="weui-cell__bd">
		          <form:select path="natureType" cssClass="weui-select">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('nature_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				  </form:select>
		        </div>
	      	</div>
	      	<div class="weui-cell weui-cell_select weui-cell_select-after">
	        	<div class="weui-cell__hd"><label class="weui-label">企业规模</label></div>
		        <div class="weui-cell__bd">
		          <form:select path="scaleType" cssClass="weui-select">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('scale_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				  </form:select>
		        </div>
	      	</div>
	      	<div class="weui-cell">
		        <div class="weui-cell__bd">
		        	<form:textarea path="remarks" htmlEscape="false" rows="3" maxlength="200" class="weui-textarea" placeholder="请输入客户描述"/>
		        </div>
	      	</div>
	   	</div>
	   	<div class="weui-cells__title">下次联系提醒</div>
	   	<div class="weui-cells weui-cells_form">
	   		<div class="weui-cell weui-cell_select weui-cell_select-after">
	        	<div class="weui-cell__hd"><label class="weui-label">联系时间</label></div>
		        <div class="weui-cell__bd">
		        	<input name="nextcontactDate" class="weui-select" type="date" value="<fmt:formatDate value="${crmContactRecord.contactDate}" pattern="yyyy-MM-dd"/>">
		        </div>
	      	</div>
	      	<div class="weui-cell">
		        <div class="weui-cell__bd">
		        	<form:textarea path="nextcontactNote" htmlEscape="false" rows="3" maxlength="200" class="weui-textarea" placeholder="请输入下次联系内容"/>
		        </div>
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
