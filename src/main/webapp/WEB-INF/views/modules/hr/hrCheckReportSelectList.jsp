<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>月度打卡汇总列表选择器</title>
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
						<form:form id="searchForm" modelAttribute="hrCheckReport" action="${ctx}/hr/hrCheckReport/selectList" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 查询栏隐藏 -->
								<div class="form-group"><span>用户id：</span>
									<form:input path="userid" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>部门id：</span>
									<sys:treeselect id="office" name="office.id" value="${hrCheckReport.office.id}" labelName="office.name" labelValue="${hrCheckReport.office.name}"
										title="部门" url="/sys/office/treeData?type=2" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>统计月份：</span>
									<form:input path="checkMonth" htmlEscape="false" maxlength="11" class="form-control input-medium"/>
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
							<th class="sort-column a.groupname">规则名称</th>
							<th class="sort-column a.userid">用户id</th>
							<th class="sort-column a.office_id">部门id</th>
							<th class="sort-column a.attendance_day">应打卡天数</th>
							<th class="sort-column a.normal_day">正常天数</th>
							<th class="sort-column a.abnormal_day">异常天数</th>
							<th class="sort-column a.attendance_card">补卡</th>
							<th class="sort-column a.annual_leave">年假</th>
							<th class="sort-column a.unpaid_leave">事假</th>
							<th class="sort-column a.sick_leave">病假</th>
							<th class="sort-column a.check_month">统计月份</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="hrCheckReport">
						<tr>
							<td><input type="checkbox" id="${hrCheckReport.id}" class="i-checks"></td>
							<td class="codelabel">${hrCheckReport.groupname}</td>
							<td>${hrCheckReport.userid}</td>
							<td>${hrCheckReport.office.name}</td>
							<td>${hrCheckReport.attendanceDay}</td>
							<td>${hrCheckReport.normalDay}</td>
							<td>${hrCheckReport.abnormalDay}</td>
							<td>${hrCheckReport.attendanceCard}</td>
							<td>${hrCheckReport.annualLeave}</td>
							<td>${hrCheckReport.unpaidLeave}</td>
							<td>${hrCheckReport.sickLeave}</td>
							<td>${hrCheckReport.checkMonth}</td>
							<td>
								<shiro:hasPermission name="hr:hrCheckReport:view">
									<a href="#" onclick="openDialogView('查看月度打卡汇总', '${ctx}/hr/hrCheckReport/view?id=${hrCheckReport.id}','800px', '500px')" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
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