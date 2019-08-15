<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>面试列表选择器</title>
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
						<form:form id="searchForm" modelAttribute="hrInterview" action="${ctx}/hr/hrInterview/selectList" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 查询栏隐藏 -->
								<div class="form-group"><span>邀约状态 0 未邀约，1 已邀约：</span>
									<form:select path="inviteStatus" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('invite_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>面试地点：</span>
									<form:input path="address" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>签到状态 0： 未签到，1：已签到：</span>
									<form:select path="signStatus" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('sign_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>对应简历ID：</span>
									<form:input path="hrResumeId" htmlEscape="false" maxlength="64" class="form-control input-medium"/>
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
							<th class="sort-column a.position">岗位</th>
							<th class="sort-column a.interview_date">面试日期</th>
							<th class="sort-column a.interview_time">面试时间1520</th>
							<th class="sort-column a.invite_status">邀约状态 0 未邀约，1 已邀约</th>
							<th class="sort-column a.address">面试地点</th>
							<th class="sort-column a.sign_status">签到状态 0： 未签到，1：已签到</th>
							<th class="sort-column a.sign_time">签到时间1520</th>
							<th class="sort-column a.interview">面试人</th>
							<th class="sort-column a.interview_status">反馈状态</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="hrInterview">
						<tr>
							<td><input type="checkbox" id="${hrInterview.id}" class="i-checks"></td>
							<td class="codelabel">${hrInterview.position}</td>
							<td><fmt:formatDate value="${hrInterview.interviewDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
							<td><fmt:formatDate value="${hrInterview.interviewTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
							<td>${fns:getDictLabel(hrInterview.inviteStatus, 'invite_status', '')}</td>
							<td>${hrInterview.address}</td>
							<td>${fns:getDictLabel(hrInterview.signStatus, 'sign_status', '')}</td>
							<td><fmt:formatDate value="${hrInterview.signTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
							<td>${hrInterview.interviewBy.name}</td>
							<td>${hrInterview.status}</td>
							<td>
								<shiro:hasPermission name="hr:hrInterview:view">
									<a href="#" onclick="openDialogView('查看面试', '${ctx}/hr/hrInterview/view?id=${hrInterview.id}','800px', '500px')" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
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