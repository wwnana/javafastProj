<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<!DOCTYPE html>
<html>
  <head>
  	<title>客户查询</title>
    <%@ include file="/WEB-INF/views/include/weuihead.jsp"%>
    <script type="text/javascript">
    	function doSubmit(){
    		
    		$("#inputForm").submit();
    	}
    </script>
  </head>
  <body ontouchstart>
  	
     <div class="page-content">
     	<form:form id="inputForm" modelAttribute="crmCustomer" action="${ctx}/mobile/crm/crmCustomer/" method="post" class="form-horizontal">
		
		<div class="weui-cells weui-cells_form">
	      	<div class="weui-cell">
	        	<div class="weui-cell__hd"><label class="weui-label">客户名称</label></div>
		        <div class="weui-cell__bd">
		          <form:input path="name" htmlEscape="false" maxlength="50" class="weui-input" placeholder="请输入客户名称"/>
		        </div>
	      	</div>
	      	<div class="weui-cell weui-cell_select weui-cell_select-after">
	        	<div class="weui-cell__hd"><label class="weui-label">客户分类</label></div>
		        <div class="weui-cell__bd">
		          <form:select path="customerType" class="weui-select">
		          	<form:option value="" label="---请选择---"/>
						<form:options items="${fns:getDictList('customer_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				  </form:select>
		        </div>
	      	</div>
	      	<div class="weui-cell weui-cell_select weui-cell_select-after">
	        	<div class="weui-cell__hd"><label class="weui-label">客户状态</label></div>
		        <div class="weui-cell__bd">
		          <form:select path="customerStatus" class="weui-select">
		          	<form:option value="" label="---请选择---"/>
								<form:options items="${fns:getDictList('customer_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
		        </div>
	      	</div>
	      	<div class="weui-cell weui-cell_select weui-cell_select-after">
	        	<div class="weui-cell__hd"><label class="weui-label">客户级别</label></div>
		        <div class="weui-cell__bd">
		          	<form:select path="customerLevel" class="weui-select">
		          		<form:option value="" label="---请选择---"/>
						<form:options items="${fns:getDictList('customer_level')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
		        </div>
	      	</div>
	      	<div class="weui-cell weui-cell_select weui-cell_select-after">
                <div class="weui-cell__hd">
                    <label for="" class="weui-label">负责人</label>
                </div>
                <div class="weui-cell__bd">
                    <form:select path="ownBy.id" class="weui-select">
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
		<a href="${ctx}/mobile/crm/crmCustomer" class="weui-tabbar__item weui-navbar__item">
	          	返回
		</a>
	 </div>
  </body>
</html>
