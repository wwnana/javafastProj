<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>联系人管理</title>
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
<body class="gray-bg">
<div class="">
		<div class="ibox">
			
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="crmContacter" action="${ctx}/crm/crmContacter/selectList" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
								<form:hidden path="customer.id"/>
								<div class="form-group"><span>姓名：</span>
									<form:input path="name" htmlEscape="false" maxlength="30" class="form-control input-small"/>
								</div>
								<div class="form-group"><span>手机：</span>
									<form:input path="mobile" htmlEscape="false" maxlength="30" class="form-control input-small"/>
								</div>
								<div class="form-group"><span>QQ：</span>
									<form:input path="qq" htmlEscape="false" maxlength="30" class="form-control input-small"/>
								</div>
								<div class="form-group">
									<button class="btn btn-white btn-sm" onclick="search()"><i class="fa fa-search"></i> 查询</button>
									<button class="btn btn-white btn-sm" onclick="resetSearch()"><i class="fa fa-refresh"></i> 重置</button>
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
							<th>姓名</th>
							<th>所属客户</th>
							<th>性别</th>
							<th>职务</th>
							<th>手机</th>
							
							<th>QQ</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="crmContacter">
						<tr>
							<td>
								<input type="checkbox" id="${crmContacter.id}" class="i-checks">
							</td>
							<td class="codelabel">${crmContacter.name}</td>							
							<td>
								${crmContacter.customer.name}
							</td>
							<td>
								${fns:getDictLabel(crmContacter.sex, 'sex', '')}
							</td>
							<td>
								${crmContacter.jobType}
							</td>
							<td>
								${crmContacter.mobile}
							</td>
							
							<td>
								${crmContacter.qq}
							</td>
							<td>
								<shiro:hasPermission name="crm:crmContacter:view">
									<a href="#" onclick="openDialogView('查看联系人', '${ctx}/crm/crmContacter/view?id=${crmContacter.id}','800px', '500px')" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
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