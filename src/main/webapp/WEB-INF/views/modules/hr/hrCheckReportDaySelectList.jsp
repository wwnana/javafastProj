<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>每日打卡汇总列表选择器</title>
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
						<form:form id="searchForm" modelAttribute="hrCheckReportDay" action="${ctx}/hr/hrCheckReportDay/selectList" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 查询栏隐藏 -->
								<div class="form-group"><span>日期：</span>
									<div class="input-group date datepicker">
				                     	<input name="beginCheckinDate" type="text" readonly="readonly" class="form-control input-small" value="${hrCheckReportDay.sdate}" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
							         - 
							        <div class="input-group date datepicker">
				                     	<input name="endCheckinDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${hrCheckReportDay.endCheckinDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
								</div>
								<div class="form-group"><span>姓名：</span>
									<sys:treeselect id="user" name="user.id" value="${hrCheckReportDay.user.id}" labelName="user.name" labelValue="${hrCheckReportDay.user.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>部门：</span>
									<sys:treeselect id="office" name="office.id" value="${hrCheckReportDay.office.id}" labelName="office.name" labelValue="${hrCheckReportDay.office.name}"
										title="部门" url="/sys/office/treeData?type=2" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>状态：</span>
									<form:select path="checkinStatus" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('checkin_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
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
							<th class="sort-column a.checkin_date">日期</th>
							<th class="sort-column a.sys_user_id">姓名</th>
							<th class="sort-column a.office_id">部门</th>
							<th class="sort-column a.groupname">所属规则</th>
							<th class="sort-column a.first_checkin_time">最早</th>
							<th class="sort-column a.last_checkin_time">最晚</th>
							<th class="sort-column a.checkin_num">次数</th>
							<th class="sort-column a.work_hours">工作时长</th>
							<th class="sort-column a.oa_audit_id">审批单</th>
							<th class="sort-column a.checkin_status">状态</th>
							<th class="sort-column a.audit_status">校准状态</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="hrCheckReportDay">
						<tr>
							<td><input type="checkbox" id="${hrCheckReportDay.id}" class="i-checks"></td>
							<td class="codelabel"><fmt:formatDate value="${hrCheckReportDay.checkinDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
							<td>${hrCheckReportDay.user.name}</td>
							<td>${hrCheckReportDay.office.name}</td>
							<td>${hrCheckReportDay.groupname}</td>
							<td><fmt:formatDate value="${hrCheckReportDay.firstCheckinTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
							<td><fmt:formatDate value="${hrCheckReportDay.lastCheckinTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
							<td>${hrCheckReportDay.checkinNum}</td>
							<td>${hrCheckReportDay.workHours}</td>
							<td>${hrCheckReportDay.hrApproval.name}</td>
							<td>${fns:getDictLabel(hrCheckReportDay.checkinStatus, 'checkin_status', '')}</td>
							<td>${hrCheckReportDay.auditStatus}</td>
							<td>
								<shiro:hasPermission name="hr:hrCheckReport:view">
									<a href="#" onclick="openDialogView('查看每日打卡汇总', '${ctx}/hr/hrCheckReportDay/view?id=${hrCheckReportDay.id}','800px', '500px')" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
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