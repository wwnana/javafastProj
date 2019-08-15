<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>调薪列表选择器</title>
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
						<form:form id="searchForm" modelAttribute="hrSalaryChange" action="${ctx}/hr/hrSalaryChange/selectList" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 查询栏隐藏 -->
								<div class="form-group"><span>员工：</span>
									<form:input path="hrEmployee.id" htmlEscape="false" maxlength="30" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>调薪生效时间：</span>
									<div class="input-group date datepicker">
				                     	<input name="beginEffectDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${hrSalaryChange.beginEffectDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
							         - 
							        <div class="input-group date datepicker">
				                     	<input name="endEffectDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${hrSalaryChange.endEffectDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
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
							<th class="sort-column a.hr_employee_id">员工</th>
							<th class="sort-column a.old_base_salary">调薪前基本工资</th>
							<th class="sort-column a.base_salary">调薪后基本工资</th>
							<th class="sort-column a.change_range">调整幅度</th>
							<th class="sort-column a.effect_date">调薪生效时间</th>
							<th class="sort-column a.change_cause">调薪原因</th>
							<th class="sort-column a.status">状态</th>
							<th class="sort-column a.audit_by">审核人</th>
							<th class="sort-column a.audit_date">审核日期</th>
							<th class="sort-column a.create_by">制单人</th>
							<th class="sort-column a.create_date">制单日期</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="hrSalaryChange">
						<tr>
							<td><input type="checkbox" id="${hrSalaryChange.id}" class="i-checks"></td>
							<td class="codelabel">${hrSalaryChange.hrEmployee.id}</td>
							<td>${hrSalaryChange.oldBaseSalary}</td>
							<td>${hrSalaryChange.baseSalary}</td>
							<td>${hrSalaryChange.changeRange}</td>
							<td><fmt:formatDate value="${hrSalaryChange.effectDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
							<td>${hrSalaryChange.changeCause}</td>
							<td>${fns:getDictLabel(hrSalaryChange.status, 'audit_status', '')}</td>
							<td>${hrSalaryChange.auditBy.id}</td>
							<td><fmt:formatDate value="${hrSalaryChange.auditDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
							<td>${hrSalaryChange.createBy.id}</td>
							<td><fmt:formatDate value="${hrSalaryChange.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
							<td>
								<shiro:hasPermission name="hr:hrSalaryChange:view">
									<a href="#" onclick="openDialogView('查看调薪', '${ctx}/hr/hrSalaryChange/view?id=${hrSalaryChange.id}','800px', '500px')" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
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