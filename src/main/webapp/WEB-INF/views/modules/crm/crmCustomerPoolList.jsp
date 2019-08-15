<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>客户管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		
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
				
			  openDialog('批量指派客户', '${ctx}/crm/crmCustomerPool/batchShare?ids='+ids,'500px', '300px');
			  
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
					<a class="btn btn-link" href="${ctx}/crm/crmCustomerPool/list">全部</a>
					<a class="btn btn-link" href="${ctx}/crm/crmCustomerPool/list?createBy.id=${fns:getUser().id}">我创建的</a>
					<a class="btn btn-link" href="${ctx}/crm/crmCustomerPool/list?isStar=1">我关注过的</a>
					<a class="btn btn-link" href="${ctx}/crm/crmCustomerPool/list?beginCreateDate=${fns:getDate('yyyy-MM-dd')}&endCreateDate=${fns:getDayAfter(1)}">今日创建的</a>
					<a class="btn btn-link" href="${ctx}/crm/crmCustomerPool/list?beginCreateDate=${fns:getDayAfter(-7)}&endCreateDate=${fns:getDayAfter(1)}">7天内创建的</a>
					<a class="btn btn-link" href="${ctx}/crm/crmCustomerPool/list?beginCreateDate=${fns:getDayAfter(-30)}&endCreateDate=${fns:getDayAfter(1)}">30天内创建的</a>
				
					
				</div>
				<div class="pull-right">
					<div class="form-inline" style="padding-bottom: 0px;">
                         <div class="form-group">
                          	<form id="searchForm2" action="${ctx}/crm/crmCustomerPool/" method="post">
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
								<a class="btn btn-success btn-sm" href="#" onclick="openDialog('新建客户', '${ctx}/crm/crmCustomerPool/form','1000px', '80%')" title="新建客户"><i class="fa fa-plus"></i> 新建客户</a>
							</shiro:hasPermission>
							
							<div class="btn-group">
		                        <button data-toggle="dropdown" class="btn btn-white btn-sm dropdown-toggle" aria-expanded="false">更多 <span class="caret"></span>
		                        </button>
		                        <ul class="dropdown-menu">
		                            <li>
		                            	<shiro:hasPermission name="crm:crmCustomer:import">
											<table:importExcel url="${ctx}/crm/crmCustomerPool/import"></table:importExcel><!-- 导入按钮 -->
										</shiro:hasPermission>
		                            </li>
		                            <li>
		                            	<shiro:hasPermission name="crm:crmCustomer:export">
								       		<table:exportExcel url="${ctx}/crm/crmCustomerPool/export"></table:exportExcel><!-- 导出按钮 -->
								       	</shiro:hasPermission>
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
						<form:form id="searchForm" modelAttribute="crmCustomer" action="${ctx}/crm/crmCustomerPool/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 查询栏 -->
								<div class="form-group"><span>客户名称：</span>
									<form:input path="name" htmlEscape="false" maxlength="50" class="form-control input-small"/>
								</div>
								<div class="form-group"><span>客户状态：</span>
									<form:select path="customerStatus" class="form-control input-xmini" cssClass="">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('customer_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>客户级别：</span>
									<form:select path="customerLevel" class="form-control input-xmini" cssClass="">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('customer_level')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>客户分类：</span>
									<form:select path="customerType" class="form-control input-xmini" cssClass="">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('customer_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>首要联系人：</span>
									<form:input path="contacterName" htmlEscape="false" maxlength="30" class="form-control input-small"/>
								</div>
								<div class="form-group"><span>联系手机：</span>
									<form:input path="mobile" htmlEscape="false" maxlength="20" class="form-control input-small"/>
								</div>
								
								<div class="form-group"><span>创建者：</span>
									<sys:treeselect id="createBy" name="createBy.id" value="${crmCustomer.createBy.id}" labelName="createBy.name" labelValue="${crmCustomer.createBy.name}"
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
									<button class="btn btn-info btn-sm " onclick="search()"><i class="fa fa-search"></i> 查询</button>
									<button class="btn btn-white btn-sm " onclick="resetSearch()"><i class="fa fa-refresh"></i> 重置</button>
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
								<table:batchRow url="${ctx}/crm/crmCustomerPool/batchDraw" title="批量领取客户" id="contentTable" name="batchDraw" label="领取" icon="fa-arrow-down"></table:batchRow>
								<table:editRow url="${ctx}/crm/crmCustomerPool/form" title="客户" id="contentTable" width="800px" height="80%"></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="crm:crmCustomer:del">
								<table:delRow url="${ctx}/crm/crmCustomerPool/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
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
							<th style="min-width:250px;">客户名称</th>
							<th style="min-width:100px;width:100px;" class="sort-column customer_status">客户状态</th>
							<th style="min-width:100px;width:100px;" class="sort-column customer_level">客户级别</th>							
							<th style="min-width:100px;width:100px;">客户行业</th>
							<th style="min-width:100px;width:100px;">客户来源</th>
							
							<th style="min-width:100px;width:100px;" class="sort-column a.create_by">创建者</th>
							<th style="min-width:100px;width:100px;" class="sort-column a.create_date">创建时间</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="crmCustomer">
						<tr>
							<td><input type="checkbox" id="${crmCustomer.id}" class="i-checks"></td>
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
							
							<td>
								${crmCustomer.createBy.name}
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
</body>
</html>