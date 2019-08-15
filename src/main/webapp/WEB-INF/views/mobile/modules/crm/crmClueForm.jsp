<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
  <head>
  	<title><c:if test="${empty crmClue.id}">新建</c:if><c:if test="${not empty crmClue.id}">编辑</c:if>线索</title>
    <%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
    <script type="text/javascript">
    	function doSubmit(){
    		
    		var name = $("#name").val();
    		if(name==null||name==undefined||name==""){
    			
    			alertMsgBox("请输入公司");
    			return false;
    		}
    		
    		var contacterName = $("#contacterName").val();
    		if(contacterName==null||contacterName==undefined||contacterName==""){
    			
    			alertMsgBox("请输入姓名");
    			return false;
    		}
    		
    		var jobType = $("#jobType").val();
    		if(jobType==null||jobType==undefined||jobType==""){
    			
    			alertMsgBox("请输入职务");
    			return false;
    		}
    		
    		var mobile = $("#mobile").val();
    		if(mobile==null||mobile==undefined||mobile==""){
    			
    			alertMsgBox("请输入手机");
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
     	
     	<form:form id="inputForm" modelAttribute="crmClue" action="${ctx}/mobile/crm/crmClue/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		
		<div class="weui-cells__title">所属市场活动</div>
		<div class="weui-cells weui-cells_form">
			<div class="weui-cell weui-cell_select weui-cell_select-after">
                
                <div class="weui-cell__bd">
                    <form:select path="crmMarket.id" class="weui-select">
						<form:options items="${crmMarketList}" itemLabel="name" itemValue="id" htmlEscape="false"/>
					</form:select>
                </div>
            </div>
        </div>
            
		<div class="weui-cells__title">线索信息</div>
		<div class="weui-cells weui-cells_form">
	      	<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">公司<font class="red">*</font></label></div>
		        <div class="weui-cell__bd">
		          <form:input path="name" htmlEscape="false" maxlength="50" class="weui-input" placeholder="请输入公司"/>
		        </div>
	      	</div>
	      	<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">姓名<font class="red">*</font></label></div>
		        <div class="weui-cell__bd">
		          <form:input path="contacterName" htmlEscape="false" maxlength="30" class="weui-input" placeholder="请输入姓名"/>
		        </div>
	      	</div>
	      	<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">职务<font class="red">*</font></label></div>
		        <div class="weui-cell__bd">
		          <form:input path="jobType" htmlEscape="false" maxlength="20" class="weui-input" placeholder="请输入职务"/>
		        </div>
	      	</div>
	      	<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">手机<font class="red">*</font></label></div>
		        <div class="weui-cell__bd">
		          <form:input path="mobile" htmlEscape="false" maxlength="20" class="weui-input" type="number" pattern="[0-9]*" placeholder="请输入手机"/>
		        </div>
	      	</div>
	      	
	      	<div class="weui-cell weui-cell_select weui-cell_select-after">
                <div class="weui-cell__hd">
                    <label for="" class="weui-label">线索来源</label>
                </div>
                <div class="weui-cell__bd">
                    <form:select path="sourType" class="weui-select">
		        		<form:option value="" label=""/>
						<form:options items="${fns:getDictList('sour_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				  </form:select>
                </div>
            </div>
            <div class="weui-cell weui-cell_select weui-cell_select-after">
                <div class="weui-cell__hd">
                    <label for="" class="weui-label">所属行业</label>
                </div>
                <div class="weui-cell__bd">
                    <form:select path="industryType" class="weui-select">
		        		<form:option value="" label=""/>
						<form:options items="${fns:getDictList('industry_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
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
	    <div class="weui-cells__title">线索描述</div>
		<div class="weui-cells weui-cells_form">
	    <div class="weui-cell">
		        <div class="weui-cell__bd">
		        	<form:textarea path="remarks" htmlEscape="false" rows="3" maxlength="200" class="weui-textarea" placeholder="请输入线索描述"/>
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
