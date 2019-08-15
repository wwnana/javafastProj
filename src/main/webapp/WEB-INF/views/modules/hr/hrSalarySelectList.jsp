<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>工资表列表选择器</title>
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
	<div class="wrapper-content">
		<div class="ibox">
			<div class="ibox-content">
			<sys:message content="${message}"/>
				<!-- 查询栏 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="hrSalary" action="${ctx}/hr/hrSalary/selectList" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 查询栏隐藏 -->
								<div class="form-group"><span>年份：</span>
									<form:input path="year" htmlEscape="false" maxlength="4" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>月份：</span>
									<form:input path="month" htmlEscape="false" maxlength="2" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>状态：</span>
									<form:select path="status" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('audit_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group">
									<button class="btn btn-white btn-sm " onclick="search()"><i class="fa fa-search"></i> 查询</button>
									<button class="btn btn-white btn-sm " onclick="resetSearch()"><i class="fa fa-refresh"></i> 重置</button>
								</div>
						</form:form>
					</div>
				</div>
				<!-- 工具栏 -->
				<div class="row">
					<div class="col-sm-12">
						<div class="pull-right">
							<div class="btn-group">
								<button id="searchBtn" class="btn btn-white btn-sm" title="搜索"><i class="fa fa-search"></i></button>
								<table:refreshRow></table:refreshRow>
							</div>
						</div>
					</div>
				</div>
					
				<!-- 表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<th><input type="checkbox" class="i-checks"></th>
							<th class="sort-column a.year">年份</th>
							<th class="sort-column a.month">月份</th>
							<th class="sort-column a.work_days">应出勤天数</th>
							<th class="sort-column a.status">状态</th>
							<th class="sort-column a.audit_by">审核人</th>
							<th class="sort-column a.audit_date">审核日期</th>
							<th class="sort-column a.create_by">制单人</th>
							<th class="sort-column a.create_date">制单日期</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="hrSalary">
						<tr>
							<td><input type="checkbox" id="${hrSalary.id}" class="i-checks"></td>
							<td class="codelabel">${hrSalary.year}</td>
							<td>${hrSalary.month}</td>
							<td>${hrSalary.workDays}</td>
							<td>${fns:getDictLabel(hrSalary.status, 'audit_status', '')}</td>
							<td>${hrSalary.auditBy.id}</td>
							<td><fmt:formatDate value="${hrSalary.auditDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
							<td>${hrSalary.createBy.id}</td>
							<td><fmt:formatDate value="${hrSalary.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
							<td>
								<shiro:hasPermission name="hr:hrSalary:view">
									<a href="#" onclick="openDialogView('查看工资表', '${ctx}/hr/hrSalary/view?id=${hrSalary.id}','800px', '500px')" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
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