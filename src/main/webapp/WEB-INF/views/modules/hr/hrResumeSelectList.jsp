<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>简历列表选择器</title>
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
						<form:form id="searchForm" modelAttribute="hrResume" action="${ctx}/hr/hrResume/selectList" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 查询栏隐藏 -->
								<div class="form-group"><span>招聘任务：</span>
									<form:input path="hrRecruit.id" htmlEscape="false" maxlength="64" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>简历来源 1:智联，2:51job, 3:拉钩，10：其他：</span>
									<form:select path="resumeSource" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('resume_source')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>应聘岗位：</span>
									<form:input path="position" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>姓名：</span>
									<form:input path="name" htmlEscape="false" maxlength="20" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>手机号：</span>
									<form:input path="mobile" htmlEscape="false" maxlength="11" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>工作经验：</span>
									<form:select path="experience" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('experience_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>学历：</span>
									<form:select path="education" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('education_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>当前环节：0：简历，1：面试，2：录用：3：入职：4： 简历库：</span>
									<form:select path="currentNode" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>简历状态: 0新简历, 1已推荐, 2推荐通过,3未通过：</span>
									<form:select path="resumeStatus" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('resume_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>面试状态：已邀约0，1已签到, 2已面试 3: 已取消：</span>
									<form:select path="interviewStatus" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('interview_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>录用状态：0待确认,1已接受, 2已入职,3已拒绝：</span>
									<form:select path="employStatus" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('employ_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
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
							<th class="sort-column a.hr_recruit_id">招聘任务</th>
							<th class="sort-column a.resume_source">简历来源 1:智联，2:51job, 3:拉钩，10：其他</th>
							<th class="sort-column a.position">应聘岗位</th>
							<th class="sort-column a.name">姓名</th>
							<th class="sort-column a.mobile">手机号</th>
							<th class="sort-column a.experience">工作经验</th>
							<th class="sort-column a.education">学历</th>
							<th class="sort-column a.last_company">上家公司</th>
							<th class="sort-column a.university">毕业院校</th>
							<th class="sort-column a.specialty">专业</th>
							<th class="sort-column a.interview_num">面试次数</th>
							<th class="sort-column a.create_date">创建时间</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="hrResume">
						<tr>
							<td><input type="checkbox" id="${hrResume.id}" class="i-checks"></td>
							<td class="codelabel">${hrResume.hrRecruit.id}</td>
							<td>${fns:getDictLabel(hrResume.resumeSource, 'resume_source', '')}</td>
							<td>${hrResume.position}</td>
							<td>${hrResume.name}</td>
							<td>${hrResume.mobile}</td>
							<td>${fns:getDictLabel(hrResume.experience, 'experience_type', '')}</td>
							<td>${fns:getDictLabel(hrResume.education, 'education_type', '')}</td>
							<td>${hrResume.lastCompany}</td>
							<td>${hrResume.university}</td>
							<td>${hrResume.specialty}</td>
							<td>${hrResume.interviewNum}</td>
							<td><fmt:formatDate value="${hrResume.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
							<td>
								<shiro:hasPermission name="hr:hrResume:view">
									<a href="#" onclick="openDialogView('查看简历', '${ctx}/hr/hrResume/view?id=${hrResume.id}','800px', '500px')" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
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