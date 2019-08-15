<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>离职列表选择器</title>
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
						<form:form id="searchForm" modelAttribute="hrQuit" action="${ctx}/hr/hrQuit/selectList" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 查询栏隐藏 -->
								<div class="form-group"><span>离职时间：</span>
									<div class="input-group date datepicker">
				                     	<input name="beginQuitDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${hrQuit.beginQuitDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
							         - 
							        <div class="input-group date datepicker">
				                     	<input name="endQuitDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${hrQuit.endQuitDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
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
							<th class="sort-column a.quit_type">离职类型</th>
							<th class="sort-column a.quit_date">离职时间</th>
							<th class="sort-column a.quit_cause">离职原因</th>
							<th class="sort-column a.apply_quit_cause">申请离职原因</th>
							<th class="sort-column a.compensation">补偿金</th>
							<th class="sort-column a.social_over_month">社保减员月</th>
							<th class="sort-column a.fund_over_month">公积金减员月</th>
							<th class="sort-column a.annual_leave">剩余年假</th>
							<th class="sort-column a.rest_leave">剩余调休</th>
							<th class="sort-column a.work_status">工作交接完成情况</th>
							<th class="sort-column a.status">状态</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="hrQuit">
						<tr>
							<td><input type="checkbox" id="${hrQuit.id}" class="i-checks"></td>
							<td class="codelabel">${fns:getDictLabel(hrQuit.quitType, 'quit_type', '')}</td>
							<td><fmt:formatDate value="${hrQuit.quitDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
							<td>${hrQuit.quitCause}</td>
							<td>${hrQuit.applyQuitCause}</td>
							<td>${hrQuit.compensation}</td>
							<td>${hrQuit.socialOverMonth}</td>
							<td>${hrQuit.fundOverMonth}</td>
							<td>${hrQuit.annualLeave}</td>
							<td>${hrQuit.restLeave}</td>
							<td>${fns:getDictLabel(hrQuit.workStatus, 'finish_status', '')}</td>
							<td>${fns:getDictLabel(hrQuit.status, 'audit_status', '')}</td>
							<td>
								<shiro:hasPermission name="hr:hrQuit:view">
									<a href="#" onclick="openDialogView('查看离职', '${ctx}/hr/hrQuit/view?id=${hrQuit.id}','800px', '500px')" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
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