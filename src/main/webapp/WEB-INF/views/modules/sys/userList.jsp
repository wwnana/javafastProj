<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>用户管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		function searchE(){
			var eloginFlag = $("#eloginFlag").val();
			$("#loginFlag").val(eloginFlag);
			search();
		}
	</script>
</head>
<body class="">
	<div class="">
		<div class="">
			<div class="row dashboard-header gray-bg">
				<h5>用户列表 </h5>
				<div class="pull-right">
					<shiro:hasPermission name="sys:user:add">
			        	<a class="btn btn-success btn-sm" href="#" onclick="openDialog('新建用户', '${ctx}/sys/user/form','800px', '80%','officeContent')"  title="新建用户"><i class="fa fa-plus"></i> 新建用户</a>
			        	<a class="btn btn-white btn-sm" href="${ctx}/sys/user/loadQywxSystem" title="同步企业微信"><i class="fa fa-repeat"></i> 同步企业微信</a>
			        </shiro:hasPermission>
			        
					<shiro:hasPermission name="sys:user:edit">
					<%-- 
					    <table:editRow url="${ctx}/sys/user/form" id="contentTable" title="用户" width="800px" height="500px" target="officeContent" pageModel="page"></table:editRow><!-- 编辑按钮 -->
					--%>
						<table:batchRow url="${ctx}/sys/user/useAll" name="useAll" title="启用" id="contentTable" label="启用" icon="fa-check"></table:batchRow>
						<table:batchRow url="${ctx}/sys/user/unUseAll" name="unUseAll" title="禁用" id="contentTable" label="禁用" icon="fa-ban"></table:batchRow>
						
					</shiro:hasPermission>
					<%-- 
					<shiro:hasPermission name="sys:user:del">
						<table:delRow url="${ctx}/sys/user/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
					</shiro:hasPermission>
					
					<shiro:hasPermission name="sys:user:import">
						<table:importExcel url="${ctx}/sys/user/import"></table:importExcel><!-- 导入按钮 -->
					</shiro:hasPermission>
					--%>
					<shiro:hasPermission name="sys:user:export">
			       		<table:exportExcel url="${ctx}/sys/user/export"></table:exportExcel><!-- 导出按钮 -->
			        </shiro:hasPermission>
			        <%-- 
			        <table:batchRow url="${ctx}/sys/user/synQywxAll" name="synQywxAll" title="同步到企业微信" id="contentTable" label="同步到企业微信" icon="fa-folder-open-o"></table:batchRow>
			        --%>
			        
				</div>
			</div>
		<div class="ibox-content">
		    <sys:message content="${message}"/>
		    
			<!-- 查询条件 -->
			<div class="row">
				<div class="col-sm-12">
				<form:form id="searchForm" modelAttribute="user" action="${ctx}/sys/user/list" method="post" class="form-inline">
					<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
					<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
					<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
					<form:hidden path="loginFlag"/>
					<div class="form-group">
						<span>登录名：</span>
						<form:input path="loginName" htmlEscape="false" maxlength="50" class=" form-control input-small"/>
					</div>
					<div class="form-group">
						<span>姓名：</span>
						<form:input path="name" htmlEscape="false" maxlength="50" class=" form-control input-small"/>
					 </div>
					 <div class="form-group">
						<span>手机：</span>
						<form:input path="mobile" htmlEscape="false" maxlength="50" class=" form-control input-small"/>
					 </div>
					 <div class="form-group">
						<span>同步企业微信：</span>
						<form:select path="bindWx" cssClass="form-control input-mini">
							<form:option value="" label=""/>
							<form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
						</form:select>
					 </div>
					 <div class="form-group">
					 	 <span>状态：</span>
						 <select id="eloginFlag" name="eloginFlag" class="form-control input-mini" onchange="searchE()">
							<option value="1" <c:if test='${user.loginFlag == 1}'>selected="selected"</c:if> >激活</option>
							<option value="0" <c:if test='${user.loginFlag == 0}'>selected="selected"</c:if> >冻结</option>
						</select>
					 </div>
					 <div class="form-group">
						<button class="btn btn-white btn-sm" onclick="search()"><i class="fa fa-search"></i> 查询</button>
						<button class="btn btn-white btn-sm" onclick="resetSearch()"><i class="fa fa-refresh"></i> 重置</button>
					</div>
				</form:form>
				</div>
			</div>
			
			<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<th width="30px"><input type="checkbox" class="i-checks"></th>
							<th>登录名</th>
							<th class="sort-column name">姓名</th>	
							<th class="sort-column no">工号</th>			
							<th>手机</th>
							<th>公司</th>
							<th>部门</th>
							<th>数据权限</th>
							<th>状态</th>
							<th>企业微信</th>
							<th width="120px">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="user">
						<tr>
							<td> <input type="checkbox" id="${user.id}" class="i-checks"></td>
							<td><a  href="${ctx}/sys/user/view?id=${user.id}">${user.loginName}</a></td>
							<td>${user.name}</td>
							<td>${user.no}</td>
							<td>${user.mobile}</td>
							<td>${user.company.name}</td>
							<td>${user.office.name}</td>
							<td>${fns:getDictLabel(user.dataScope, 'sys_data_scope', '')}</td>
							<td>
								<c:if test="${user.loginFlag == 1}"><span class="text-success">激活</span></c:if>
								<c:if test="${user.loginFlag == 0}"><span class="text-danger">冻结</span></c:if>
							</td>
							<td>
								<c:if test="${user.bindWx == 1}"><span class="text-success">已同步</span></c:if>
								<c:if test="${user.bindWx == 2}"><span class="text-warning">已禁用</span></c:if>
								<c:if test="${user.bindWx == 0}"><span class="text-muted">未同步</span></c:if>
							</td>
							<td>
								<c:if test="${user.id!=1}">
								<shiro:hasPermission name="sys:user:edit">
									<a href="#" onclick="openDialog('修改用户', '${ctx}/sys/user/form?id=${user.id}','800px', '80%','officeContent')" class="" title="修改">修改</a>
								</shiro:hasPermission>
								<shiro:hasPermission name="sys:user:edit">
									<a href="#" onclick="openDialog('工作交接', '${ctx}/sys/user/overForm?id=${user.id}','500px', '350px')" class="" title="工作交接">交接</a>
									<a href="${ctx}/sys/user/delete?id=${user.id}" onclick="return confirmx('重要提示：你将要删除用户：${user.name}。（如果已开通企业微信，请先在企业微信管理后台中删除此员工）', this.href)" class="" title="删除">删除</a>
								</shiro:hasPermission>
								</c:if>
							</td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
				<table:page page="${page}"></table:page>
			</div>
			<br>
			<div class="alert alert-info alert-dismissable">
		    	<button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
		        	提示和建议：<br>
		        	1、删除用户之前请把用户负责的所有线索/客户/商机/合同等交接给新用户。<br>
		        	2、如果已开通企业微信，请在企业微信邀请用户加入即可。<br>
		        	3、“冻结”的用户依然属于有效用户，只是不允许该用户登录，数据等都不变
		     </div>	
		</div>
	</div>
	
</div>
</body>
</html>