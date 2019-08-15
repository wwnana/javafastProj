<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>每日打卡明细列表选择器</title>
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
				<!-- 查询栏 -->
				<div class="row">
					<div class="col-sm-12">
						<%--<form:form id="searchForm" modelAttribute="hrCheckReportDetail" action="${ctx}/hr/hrCheckReportDetail/selectList" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 查询栏隐藏 -->
								<div class="form-group"><span>用户id：</span>
									<form:input path="userid" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>打卡日期：</span>
									<div class="input-group date datepicker">
				                     	<input name="beginCheckinDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${hrCheckReportDetail.beginCheckinDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
							         - 
							        <div class="input-group date datepicker">
				                     	<input name="endCheckinDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${hrCheckReportDetail.endCheckinDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
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
						</form:form>--%>
					</div>
				</div>
				<!-- 工具栏
				<div class="row">
					<div class="col-sm-12">
						<div class="pull-right">
							<div class="btn-group">
								<button id="searchBtn" class="btn btn-white btn-sm" title="搜索"><i class="fa fa-search"></i></button>
								<table:refreshRow></table:refreshRow>
							</div>
						</div>
					</div>
				</div>-->
				<div class="row">
					<div class="col-sm-12">
						<div class="form-horizontal">
							<div class="row">
				            	<div class="pull-left">
				            		<img alt="" src="${hrCheckReportDetail.user.photo}" style="width: 40px;height: 40px">
				            	</div>
				            	<div class="media-body">
				            		<strong>&nbsp;&nbsp;${hrCheckReportDetail.user.name}</strong>
				            		<p class="form-control-static">&nbsp;&nbsp;${hrCheckReportDetail.office.name} | 所属规则：${hrCheckReportDetail.groupname}</p>
				            	</div>
				            	<h4 class="page-header"></h4>
				            </div>
						</div>
					</div>
				</div>
				<!-- 表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<%--<th><input type="checkbox" class="i-checks"></th>--%>

							<th class="sort-column a.checkin_type">打卡类型</th>
							<th class="sort-column a.checkin_status">状态</th>
							<th class="sort-column a.checkin_time">打卡时间</th>
							<th class="sort-column a.location_title">地点</th>
							<th class="sort-column a.location_detail">详细地址</th>
							<th class="sort-column a.notes">备注</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="hrCheckReportDetail">
						<tr>
							<%--<td><input type="checkbox" id="${hrCheckReportDetail.id}" class="i-checks"></td>--%>
							<td>${hrCheckReportDetail.checkinType}</td>
							<td><span <c:if test='${hrCheckReportDetail.checkinStatus==1}'>class="text-danger"</c:if>>
									${fns:getDictLabel(hrCheckReportDetail.checkinStatus, 'checkin_status', '')}
							</span></td>
							<td><fmt:formatDate value="${hrCheckReportDetail.checkinDate}" pattern="HH:mm"/></td>
							<td>${hrCheckReportDetail.locationTitle}</td>
							<td>${hrCheckReportDetail.locationDetail}</td>
							<td>${hrCheckReportDetail.notes}</td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
				<%--<table:page page="${page}"></table:page>--%>
				</div>
			</div>
		</div>
	</div>
</body>
</html>