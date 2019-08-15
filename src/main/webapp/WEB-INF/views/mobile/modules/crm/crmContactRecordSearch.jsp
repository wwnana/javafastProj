<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
  <head>
  	<title>跟进记录查询</title>
    <%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
    <script type="text/javascript">
    	function doSubmit(){
    		
    		$("#inputForm").submit();
    	}
    </script>
  </head>
  <body ontouchstart>
  	
     <div class="page-content">
     	<form:form id="inputForm" modelAttribute="crmContactRecord" action="${ctx}/mobile/crm/crmContactRecord/" method="post" class="form-horizontal">
		
		<div class="weui-cells weui-cells_form">
	      	<div class="weui-cell weui-cell_select weui-cell_select-after">
	        	<div class="weui-cell__hd"><label class="weui-label">沟通主题</label></div>
		        <div class="weui-cell__bd">
		          <form:select path="contactType" class="weui-select">
						<form:option value="" label="---请选择---"/>
						<form:options items="${fns:getDictList('contact_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				  </form:select>
		        </div>
	      	</div>
	      	<div class="weui-cell weui-cell_select weui-cell_select-after">
	        	<div class="weui-cell__hd"><label class="weui-label">沟通日期</label></div>
		        <div class="weui-cell__bd">
		        	<form:input path="contactDate" class="weui-select" type="date" />
		        </div>
	      	</div>
	      	<div class="weui-cell weui-cell_select weui-cell_select-after">
                <div class="weui-cell__hd">
                    <label for="" class="weui-label">负责人</label>
                </div>
                <div class="weui-cell__bd">
                    <form:select path="createBy.id" class="weui-select">
						<form:option value="" label="---请选择---"/>
						<form:options items="${fns:getUserList()}" itemLabel="name" itemValue="id" htmlEscape="false"/>
					</form:select>
                </div>
            </div>
	      	
	    </div>
	    </form:form>	
     </div>
      
     
	 <div class="weui-tabbar">
		<a id="btnSubmit" href="#" onclick="doSubmit()" class="weui-tabbar__item weui-navbar__item">
	          	查询
		</a>
		<a href="${ctx}/mobile/crm/crmChance" class="weui-tabbar__item weui-navbar__item">
	          	返回
		</a>
	 </div>
  </body>
</html>
