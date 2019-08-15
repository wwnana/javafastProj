<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<jsp:useBean id="now" class="java.util.Date" />     
<fmt:formatDate value="${now}" type="both" dateStyle="long" pattern="yyyy-MM-dd" var="nowDate"/> 
<html>
<head>
	<title>客户管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript" src="${ctxStatic}/address/jsAddress.js"></script>
	<style type="text/css">
	
	</style>
	<script type="text/javascript">
		
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#searchForm").submit();
	    	return false;
	    }
		
		function saveCustomerStar(customerId){
	    	
	    	var is_star = $("#customerStar_"+customerId).hasClass("color-orange");
	    	    	
	    	$.ajax({
	    		url:"${ctx}/crm/crmCustomerStar/saveCustomerStar",
	    		type:"POST",
	    		async:true,    //或false,是否异步
	    		data:{customerId:customerId, isStar:is_star},
	    		dataType:'json',
	    		success:function(data){
	    			//alert(data);
	    			if(is_star == false){
	    				$("#customerStar_"+customerId).addClass("color-orange");
	    				$("#customerStar_"+customerId).removeClass("color-gray");
	    			}else{
	    				$("#customerStar_"+customerId).removeClass("color-orange");
	    				$("#customerStar_"+customerId).addClass("color-gray");
	    			}    				
	    		},
	    		error:function(){
	    			//alert("出错");
	    		}
	    	});
	    }
		//批量分配
		function batchShare(){
			  var str="";
			  var ids="";
			  $("${contentTable} tbody tr td input.i-checks:checkbox").each(function(){
			    if(true == $(this).is(':checked')){
			      str+=$(this).attr("id")+",";
			    }
			  });
			  if(str.substr(str.length-1)== ','){
			    ids = str.substr(0,str.length-1);
			  }
			  if(ids == ""){
				top.layer.alert('请至少选择一条数据!', {icon: 0, title:'警告'});
				return;
			  }
				
			  openDialog('批量指派客户', '${ctx}/crm/crmCustomer/batchShare?ids='+ids,'500px', '300px');
		}
		
		$(document).ready(function() {
			$("#toolbar").hide();
		    $('#contentTable tbody tr td input:checkbox').on('ifChecked', function(event){ //ifCreated 事件应该在插件初始化之前绑定 
		    	showToolbar();
		    });

		    $('#contentTable tbody tr td input:checkbox').on('ifUnchecked', function(event){ //ifCreated 事件应该在插件初始化之前绑定 
		    	showToolbar();
		   	});
		});
		function showToolbar(){
			var ids="";
			$("input[type='checkbox']:checkbox:checked").each(function(){ 
				ids+=$(this).val();
		  	});
			if(ids == ""){
				$("#toolbar").hide();
			}else{
				$("#toolbar").show();
			}
		}
	</script>
</head>
<body class="">
	<div class="">
		<div class="">
			<div class="row dashboard-header gray-bg">
				<div class="pull-left">					
					<a class="btn btn-link" href="${ctx}/crm/crmCustomer/list">全部</a>
					<a class="btn btn-link" href="${ctx}/crm/crmCustomer/list?createBy.id=${fns:getUser().id}">我创建的</a>
					<a class="btn btn-link" href="${ctx}/crm/crmCustomer/list?ownBy.id=${fns:getUser().id}">我负责的</a>
					<a class="btn btn-link" href="${ctx}/crm/crmCustomer/list?isStar=1">我关注的</a>
					<a class="btn btn-link" href="${ctx}/crm/crmCustomer/list?ownBy.id=${fns:getUser().id}&customerStatus=2">我成交的</a>
				</div>
				<div class="pull-right">					
					<div class="form-inline" style="padding-bottom: 0px;">
                         <div class="form-group">
                          	<form id="searchForm2" action="${ctx}/crm/crmCustomer/" method="post">
	                    	<div class="input-group">	
	                        	<input type="text" id="keywords" name="keywords" value="${crmCustomer.keywords}"  class=" form-control input-sm" placeholder="搜索客户名称"/>
	                            <div class="input-group-btn">
	                                <button id="btnSubmit" type="submit" class="btn btn-sm btn-white">
	                                    	<i class="fa fa-search"></i>
	                                </button>
	                                <button id="searchBtn" type="button" class="btn btn-white btn-sm" title="筛选"><i class="fa fa-angle-double-down"></i> 筛选</button>
	                            </div>
	                        </div>
	                        </form>
                        </div>
                        
                        <div class="form-group">
                        	
                        	<shiro:hasPermission name="crm:crmCustomer:add">
								<a class="btn btn-success btn-sm" href="#" title="新建客户" onclick="openDialog('新建客户', '${ctx}/crm/crmCustomer/form','1000px', '80%')"><i class="fa fa-plus"></i> 新建客户</a>
							</shiro:hasPermission>
	                        <%--
							<shiro:hasPermission name="crm:crmCustomer:import">
								<table:importExcel url="${ctx}/crm/crmCustomer/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="crm:crmCustomer:export">
					       		<table:exportExcel url="${ctx}/crm/crmCustomer/export"></table:exportExcel><!-- 导出按钮 -->
					       	</shiro:hasPermission>
					       	--%>
					       	<%-- 
					       	<a class="btn btn-white btn-sm" href="${ctx}/crm/crmCustomer/list" title="刷新"><i class="fa fa-refresh"></i> 刷新</a>
					       	
							
                            <shiro:hasPermission name="crm:crmCustomer:edit">
							    <table:editRow url="${ctx}/crm/crmCustomer/form" title="客户" id="contentTable" pageModel="" width="1000px" height="600px"></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="crm:crmCustomer:del">
								<table:delRow url="${ctx}/crm/crmCustomer/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="crm:crmCustomer:edit">
								<table:formRow url="${ctx}/crm/crmCustomer/shareForm" name="shareForm" title="客户" id="contentTable" label="指派" icon="fa-hand-o-right" width="600px" height="400px"></table:formRow>
								<table:formRow url="${ctx}/crm/crmContactRecord/nextContactForm" name="nextContactForm" title="客户" id="contentTable" label="提醒" icon="fa-calendar-check-o" width="600px" height="400px"></table:formRow>
							</shiro:hasPermission>
							--%>
							
                            
							<div class="btn-group">
		                        <button data-toggle="dropdown" class="btn btn-white btn-sm dropdown-toggle" aria-expanded="false">更多 <span class="caret"></span>
		                        </button>
		                        <ul class="dropdown-menu">
		                            <li>
		                            	<shiro:hasPermission name="crm:crmCustomer:import">
											<table:importExcel url="${ctx}/crm/crmCustomer/import"></table:importExcel><!-- 导入按钮 -->
										</shiro:hasPermission>
		                            </li>
		                            <li>
		                            	<shiro:hasPermission name="crm:crmCustomer:export">
								       		<table:exportExcel url="${ctx}/crm/crmCustomer/export"></table:exportExcel><!-- 导出按钮 -->
								       	</shiro:hasPermission>
		                            </li>
		                            
		                            <li>
		                            	<a  class="btn btn-white btn-sm" href="${ctx}/crm/crmCustomer/delList">客户回收站</a>
		                            </li>
		                        </ul>
		                    </div>
		                    
                    	</div>	
				</div>			
			</div>
		</div>	
		<div class="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="crmCustomer" action="${ctx}/crm/crmCustomer/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 搜索栏 -->
							
								<div class="form-group"><span>客户名称：</span>
									<form:input path="name" htmlEscape="false" maxlength="50" class="form-control input-small"/>
								</div>
								
								<div class="form-group"><span>客户状态：</span>
									<form:select path="customerStatus" class="form-control input-small" cssClass="">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('customer_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>客户级别：</span>
									<form:select path="customerLevel" class="form-control input-small" cssClass="">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('customer_level')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>	
								<div class="form-group"><span>客户分类：</span>
									<form:select path="customerType" class="form-control input-small" cssClass="">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('customer_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>客户行业：</span>
									<form:select path="industryType" class="form-control input-small" cssClass="">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('industry_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>客户来源：</span>
									<form:select path="sourType" class="form-control input-small" cssClass="">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('sour_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>公司性质：</span>
									<form:select path="natureType" class="form-control input-small" cssClass="">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('nature_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>企业规模：</span>
									<form:select path="scaleType" class="form-control input-small" cssClass="">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('scale_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<%--
								<div class="form-group"><span>下次联系：</span>
									<div class="input-group date datepicker">
			                            <input name="beginNextcontactDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${crmCustomer.beginNextcontactDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
			                         - 
			                        <div class="input-group" data-autoclose="true">
			                        	 <input name="endNextcontactDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${crmCustomer.endNextcontactDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
								</div>
								 
								<div class="form-group"><span>客户标签：</span>
									<sys:tagselect id="tags" name="tags" value="${crmCustomer.tags}" labelName="crmCustomer.tags" labelValue="${crmCustomer.tags}" 
										title="客户标签" url="${ctx}/crm/crmTag/getSelectData" cssClass="form-control input-medium"></sys:tagselect>	
								</div>
								
								<div class="form-group"><span>客户地区：</span>
									<form:select path="province" id="province" class="form-control input-mini" ></form:select>
									<form:select path="city" id="city" class="form-control input-mini" ></form:select>
									<form:select path="dict" id="dict" class="form-control input-mini" ></form:select>
										     	
									<script type="text/javascript">
										addressInit('province', 'city', 'dict' , '${crmCustomer.province}', '${crmCustomer.city}', '${crmCustomer.dict}');
									</script>
								</div>
								
								<div class="form-group"><span>联系手机：</span>
									<form:input path="mobile" htmlEscape="false" maxlength="20" class="form-control input-small"/>
								</div>
								 
								
								<div class="form-group"><span>创建者：</span>
									<sys:treeselect id="createBy" name="createBy.id" value="${crmCustomer.createBy.id}" labelName="createBy.name" labelValue="${crmCustomer.createBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
								</div>
								
								--%>
								<div class="form-group"><span>销售负责：</span>
									<sys:treeselect id="ownBy" name="ownBy.id" value="${crmCustomer.ownBy.id}" labelName="ownBy.name" labelValue="${crmCustomer.ownBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-xmini" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>创建时间：</span>
									<div class="input-group date datepicker">
			                            <input name="beginCreateDate" type="text" readonly="readonly" class="form-control input-xmini" value="<fmt:formatDate value="${crmCustomer.beginCreateDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
			                         - 
			                        <div class="input-group" data-autoclose="true">
			                        	 <input name="endCreateDate" type="text" readonly="readonly" class="form-control input-xmini" value="<fmt:formatDate value="${crmCustomer.endCreateDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
								</div>
								<div class="form-group">
									<button class="btn btn-white btn-sm" onclick="search()"><i class="fa fa-search"></i> 查询</button>
									<button class="btn btn-white btn-sm" onclick="resetSearch()"><i class="fa fa-refresh"></i> 重置</button>
								</div>
						</form:form>
					</div>
				</div>
				<!-- 工具栏 -->
				<div id="toolbar" class="row m-b-sm">
					<div class="col-sm-12">
						<div class="pull-left">
							
							<shiro:hasPermission name="crm:crmCustomer:share">
								<button class="btn btn-white btn-sm " onclick="batchShare()" title="批量指派客户" ><i class="fa fa-share"></i> 指派</button>
							</shiro:hasPermission>
							<shiro:hasPermission name="crm:crmCustomer:edit">
								<table:batchRow url="${ctx}/crm/crmCustomer/batchToPool" id="contentTable" title="放入公海" label="放入公海" icon="fa-reply"></table:batchRow>
								<table:editRow url="${ctx}/crm/crmCustomerPool/form" title="客户" id="contentTable" width="800px" height="80%"></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="crm:crmCustomer:del">
								<table:delRow url="${ctx}/crm/crmCustomer/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
						</div>
						
					</div>
				</div>	
				<!-- 表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<th width="30px"><input type="checkbox" class="i-checks"></th>
							<th align="center" style="min-width:50px;width:50px;">关注</th>
							<th style="min-width:250px;">客户名称</th>
							
							<th style="min-width:100px;width:100px;" class="sort-column customer_status">客户状态</th>
							<th style="min-width:100px;width:100px;" class="sort-column customer_level">客户级别</th>
							<th style="min-width:100px;width:100px;">客户行业</th>
							<th style="min-width:100px;width:100px;">客户来源</th>
							<%--
							<th style="min-width:100px;width:100px;">首要联系人</th>
							<th style="min-width:100px;width:100px;">联系手机</th>
							--%>
							<th style="min-width:100px;width:100px;" class="sort-column nextcontact_date">下次联系</th>
							
							<th style="min-width:100px;width:100px;">负责人</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.create_date">创建时间</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="crmCustomer">
						<tr>
							<td><input type="checkbox" id="${crmCustomer.id}" class="i-checks"></td>
							<td align="center">
								<a href="#" onclick="saveCustomerStar('${crmCustomer.id}');"><i id="customerStar_${crmCustomer.id}" class="fa fa-star <c:if test='${not empty crmCustomer.isStar}'>color-orange</c:if><c:if test='${empty crmCustomer.isStar}'>color-gray</c:if>"></i></a>
							</td>
							<td>
								<a href="${ctx}/crm/crmCustomer/index?id=${crmCustomer.id}">
									${fns:abbr(crmCustomer.name,50)}
								</a>
							</td>
							<td>
								<span class="<c:if test='${crmCustomer.customerStatus == 1}'>text-success</c:if><c:if test='${crmCustomer.customerStatus == 2}'>text-info</c:if><c:if test='${crmCustomer.customerStatus == 3}'>text-danger</c:if>">
									${fns:getDictLabel(crmCustomer.customerStatus, 'customer_status', '')}
								</span>
							</td>
							<td>
								${fns:getDictLabel(crmCustomer.customerLevel, 'customer_level', '')}
							</td>
							<td>
								${fns:getDictLabel(crmCustomer.industryType, 'industry_type', '')}
							</td>
							<td>
								${fns:getDictLabel(crmCustomer.sourType, 'sour_type', '')}
							</td>
							<%-- 
							<td>
								${crmCustomer.contacterName}
							</td>
							<td>
								${crmCustomer.mobile}
							</td>
							--%>
							<td>
								<fmt:formatDate value="${crmCustomer.nextcontactDate}" type="both" dateStyle="long" pattern="yyyy-MM-dd" var="trainDate"/>   
								<c:if test="${not empty crmCustomer.nextcontactDate && nowDate == trainDate}" var="rs">  
									<span class="text-danger"><fmt:formatDate value="${crmCustomer.nextcontactDate}" pattern="yyyy-MM-dd"/></span>  
								</c:if>  
								<c:if test="${!rs}">  
									<fmt:formatDate value="${crmCustomer.nextcontactDate}" pattern="yyyy-MM-dd"/> 
								</c:if> 
								
							</td>
							<td>
								${crmCustomer.ownBy.name}
							</td>
							<td>
								<fmt:formatDate value="${crmCustomer.createDate}" pattern="yyyy-MM-dd"/>
							</td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
				</div>
				<table:page page="${page}"></table:page>
				
			</div>
		</div>
	</div>
	  
	
<script type="text/javascript">

function openMainDialog(title,url){
	
	var width = $(window).width()-300;
	var height = $(window).height();
	
	top.layer.open({
	    type: 2,  
	    shadeClose: true,
	    shade: 0.3,
	    offset: 'rb', //右弹出
	    area: [width+"px", height+"px"],
	    title: title,
        maxmin: false, //开启最大化最小化按钮
	    content: url ,
	    btn: ['关闭'],
	    cancel: function(index){ 
	       }
	}); 
}
</script>
</body>
</html>