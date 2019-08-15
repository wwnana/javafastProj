<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>客户管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {

	    	$('#contentTable thead tr th input.i-checks').on('ifChecked', function(event){ //ifCreated 事件应该在插件初始化之前绑定 
	    		$('#contentTable tbody tr td input.i-checks').iCheck('check');
	    	});

	    	$('#contentTable thead tr th input.i-checks').on('ifUnchecked', function(event){ //ifCreated 事件应该在插件初始化之前绑定 
	    		$('#contentTable tbody tr td input.i-checks').iCheck('uncheck');
	    	});
		});
		
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#searchForm").submit();
        	return false;
        }
		
		function getSelectedItem(){
			var size = $("#contentTable tbody tr td input.i-checks:checked").size();
			  if(size == 0 ){
					top.layer.alert('请至少选择一条数据!', {icon: 0, title:'警告'});
					return "-1";
				  }

			  if(size > 1 ){
					top.layer.alert('只能选择一条数据!', {icon: 0, title:'警告'});
					return "-1";
				  }
			    var id =  $("#contentTable tbody tr td input.i-checks:checkbox:checked").attr("id");
			    
				var label = $("#contentTable tbody tr td input.i-checks:checkbox:checked").parent().parent().parent().find(".codelabel").html();

				return id+"_item_"+label;
		}
	</script>
</head>
<body class="">
<div class="">
		<div class="">
			
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="crmCustomer" action="${ctx}/crm/crmCustomer/selectList" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							
								<div class="form-group"><span>客户名称：</span>
									<form:input path="name" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>客户分类</span>
									<form:select path="customerType" class="form-control" cssClass="">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('customer_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>客户状态：</span>
									<form:select path="customerStatus" class="form-control">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('customer_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>客户级别：</span>
									<form:select path="customerLevel" class="form-control">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('customer_level')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<%-- 
								<div class="form-group"><span>首要联系人：</span>
									<form:input path="contacterName" htmlEscape="false" maxlength="30" class="form-control input-small"/>
								</div>
								<div class="form-group"><span>联系手机：</span>
									<form:input path="mobile" htmlEscape="false" maxlength="20" class="form-control input-small"/>
								</div>
								--%>
								<div class="form-group">
									<button class="btn btn-white btn-sm " onclick="search()"><i class="fa fa-search"></i> 查询</button>
									<button class="btn btn-white btn-sm " onclick="resetSearch()"><i class="fa fa-refresh"></i> 重置</button>
								</div>
						</form:form>
					</div>
				</div>
				
					
				<!-- 表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<th><input type="checkbox" class="i-checks"></th>
							<th>客户名称</th>
							<th>客户状态</th>
							<th>客户级别</th>
							
							<th>负责人</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="crmCustomer">
						<tr>
							<td>
								<input type="checkbox" id="${crmCustomer.id}" class="i-checks">
							</td>
							<td class="codelabel">${fns:abbr(crmCustomer.name,50)}</td>	
							<td>
								${fns:getDictLabel(crmCustomer.customerStatus, 'customer_status', '')}
							</td>
							<td>
								${fns:getDictLabel(crmCustomer.customerLevel, 'customer_level', '')}
							</td>
							
							<td>
								${crmCustomer.ownBy.name}
							</td>
							<td>
								<shiro:hasPermission name="crm:crmCustomer:view">
									<a href="#" onclick="openDialogView('查看客户', '${ctx}/crm/crmCustomer/detail?id=${crmCustomer.id}','800px', '500px')" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
								</shiro:hasPermission>
							</td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
				<table:page page="${page}"></table:page>
				</div>
			</div>
		</div>
	</div>
</body>
</html>