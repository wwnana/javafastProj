<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>工资明细列表选择器</title>
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
						<form:form id="searchForm" modelAttribute="hrSalaryDetail" action="${ctx}/hr/hrSalaryDetail/selectList" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 查询栏隐藏 -->
								<div class="form-group"><span>员工：</span>
									<form:input path="hrEmployeeId" htmlEscape="false" maxlength="30" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>姓名：</span>
									<form:input path="name" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
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
							<th class="sort-column a.name">姓名</th>
							<th class="sort-column a.must_work_days">应出勤天数</th>
							<th class="sort-column a.real_work_days">实际出勤天数</th>
							<th class="sort-column a.extra_work_days">加班天数</th>
							<th class="sort-column a.leave_days">请假天数</th>
							<th class="sort-column a.absent_days">旷工天数</th>
							<th class="sort-column a.base_salary">基本工资</th>
							<th class="sort-column a.post_salary">岗位工资</th>
							<th class="sort-column a.bonus_salary">奖金</th>
							<th class="sort-column a.overtime_salary">加班费</th>
							<th class="sort-column a.should_amt">应发合计</th>
							<th class="sort-column a.social_amt">社保</th>
							<th class="sort-column a.fund_amt">公积金</th>
							<th class="sort-column a.tax_amt">个税</th>
							<th class="sort-column a.seduct_salary">应扣工资</th>
							<th class="sort-column a.real_amt">实发工资</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="hrSalaryDetail">
						<tr>
							<td><input type="checkbox" id="${hrSalaryDetail.id}" class="i-checks"></td>
							<td class="codelabel">${hrSalaryDetail.name}</td>
							<td>${hrSalaryDetail.mustWorkDays}</td>
							<td>${hrSalaryDetail.realWorkDays}</td>
							<td>${hrSalaryDetail.extraWorkDays}</td>
							<td>${hrSalaryDetail.leaveDays}</td>
							<td>${hrSalaryDetail.absentDays}</td>
							<td>${hrSalaryDetail.baseSalary}</td>
							<td>${hrSalaryDetail.postSalary}</td>
							<td>${hrSalaryDetail.bonusSalary}</td>
							<td>${hrSalaryDetail.overtimeSalary}</td>
							<td>${hrSalaryDetail.shouldAmt}</td>
							<td>${hrSalaryDetail.socialAmt}</td>
							<td>${hrSalaryDetail.fundAmt}</td>
							<td>${hrSalaryDetail.taxAmt}</td>
							<td>${hrSalaryDetail.seductSalary}</td>
							<td>${hrSalaryDetail.realAmt}</td>
							<td>
								<shiro:hasPermission name="hr:hrSalaryDetail:view">
									<a href="#" onclick="openDialogView('查看工资明细', '${ctx}/hr/hrSalaryDetail/view?id=${hrSalaryDetail.id}','800px', '500px')" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
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