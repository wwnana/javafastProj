<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>员工信息列表</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		function searchE(){
			var eStatus = $("#eStatus").val();
			$("#status").val(eStatus);
			search();
		}
	</script>
</head>
<body class="gray-bg">
	<div class="wrapper-content">
		<div class="ibox">
			<div class="ibox-title">
				<h5>员工信息列表 </h5>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>	
				<!-- 快速查询 -->
				<div class="row">
					<div class="col-sm-12">
						<div class="btn-toolbar breadcrumb">
							<div class="btn-group">
								<span class="btn-common"><i class="icon-reorder" style="color: gray;"></i> 查询视图</span>
								<a class="btn-common" href="${ctx}/hr/hrEmployee/list">全部</a>
								
								<a class="btn-common" href="${ctx}/hr/hrEmployee/list?beginEntryDate=${fns:getBeginDayOfWeekStr()}&endEntryDate=${fns:getEndDayOfWeekStr()}">本周入职</a>
								<a class="btn-common" href="${ctx}/hr/hrEmployee/list?beginEntryDate=${fns:getBeginDayOfMonthStr()}&endEntryDate=${fns:getEndDayOfMonthStr()}">本月入职</a>
								<a class="btn-common" href="${ctx}/hr/hrEmployee/list?beginContractEndDate=${fns:getBeginDayOfWeekStr()}&endContractEndDate=${fns:getEndDayOfWeekStr()}">本周合同到期</a>
								<a class="btn-common" href="${ctx}/hr/hrEmployee/list?beginContractEndDate=${fns:getBeginDayOfMonthStr()}&endContractEndDate=${fns:getEndDayOfMonthStr()}">本月合同到期</a>
							</div>
						</div>
					</div>
				</div>			
				<!-- 查询栏 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="hrEmployee" action="${ctx}/hr/hrEmployee/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 查询栏隐藏 -->
								<form:hidden path="status"/>
								<div class="form-group"><span>姓名：</span>
									<form:input path="name" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>性别：</span>
									<form:select path="sex" class="form-control input-mini">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('sex')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								
								<div class="form-group"><span>转正状态：</span>
									<form:select path="regularStatus" class="form-control input-mini">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('regular_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>聘用形式：</span>
									<form:select path="employType" class="form-control input-mini">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('employ_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								
								<div class="form-group"><span>入职日期：</span>
									<div class="input-group date datepicker">
				                     	<input name="beginEntryDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${hrEmployee.beginEntryDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
							         - 
							        <div class="input-group date datepicker">
				                     	<input name="endEntryDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${hrEmployee.endEntryDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
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
					<div class="col-sm-12 m-b-sm">
						<div class="pull-right">
							<shiro:hasPermission name="hr:hrEmployee:add">
								<table:addRow url="${ctx}/hr/hrEmployee/form" title="员工信息" pageModel="page"></table:addRow><!-- 增加按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="hr:hrEmployee:edit">
							    <table:editRow url="${ctx}/hr/hrEmployee/form" title="员工信息" id="contentTable" pageModel="page"></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							<%--
							<shiro:hasPermission name="hr:hrEmployee:del">
								<table:delRow url="${ctx}/hr/hrEmployee/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="hr:hrEmployee:import">
								<table:importExcel url="${ctx}/hr/hrEmployee/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
							--%>
							<shiro:hasPermission name="hr:hrEmployee:export">
					       		<table:exportExcel url="${ctx}/hr/hrEmployee/export"></table:exportExcel><!-- 导出按钮 -->
					       	</shiro:hasPermission>
					       	
					       	<button id="searchBtn" class="btn btn-white btn-sm" title="搜索"><i class="fa fa-search"></i> 搜索</button>
					       	<button class="btn btn-white btn-sm" onclick="sortOrRefresh()" title="刷新"><i class="fa fa-repeat"></i> 刷新</button>
							
						</div>
						<div class="pull-left">
							
							
							<select id="eStatus" name="eStatus" class="form-control input-mini" onchange="searchE()">
								<option value="0" <c:if test='${hrEmployee.status == 0}'>selected="selected"</c:if> >在职</option>
								<option value="1" <c:if test='${hrEmployee.status == 1}'>selected="selected"</c:if> >离职</option>
							</select>
							
							
                            
							
						</div>
					</div>
				</div>					
				<!-- 数据表格 -->
				<div class="table-responsive" style="min-height: 500px;">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<th width="50px"><input type="checkbox" class="i-checks"></th>
							<th width="100px" class="sort-column a.name">姓名</th>
							<th width="100px" class="sort-column a.mobile">联系手机</th>
							<th width="100px" class="sort-column s.no">工号</th>
							<th class="sort-column s.office_id">部门</th>
							<th class="sort-column a.position">职位</th>
							<th width="100px" class="sort-column a.entry_date">入职日期</th>
							<th width="100px" class="sort-column a.regular_date">转正日期</th>
							<th width="100px" class="sort-column a.regular_status">转正状态</th>
							<th width="100px" class="sort-column a.employ_type">聘用形式</th>
							
							<th width="100px" class="sort-column a.status">员工状态</th>
							<th width="50px">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="hrEmployee">
						<tr>
							<td><input type="checkbox" id="${hrEmployee.id}" class="i-checks"></td>
							<td>
								<a href="${ctx}/hr/hrEmployee/index?id=${hrEmployee.id}" title="查看">
								${hrEmployee.name}
							</a></td>
							<td>
								${hrEmployee.mobile}
							</td>
							<td>
								${hrEmployee.user.no}
							</td>
							<td>
								${hrEmployee.office.name}
							</td>
							<td>
								${hrEmployee.position}
							</td>
							<td>
								<fmt:formatDate value="${hrEmployee.entryDate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								<fmt:formatDate value="${hrEmployee.regularDate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								${fns:getDictLabel(hrEmployee.regularStatus, 'regular_status', '')}
							</td>
							<td>
								${fns:getDictLabel(hrEmployee.employType, 'employ_type', '')}
							</td>
							<td>
								${fns:getDictLabel(hrEmployee.status, 'employ_status', '')}
							</td>
							<td>
								<div class="btn-group">
			                    	<button data-toggle="dropdown" class="btn btn-default dropdown-toggle" aria-expanded="false"> <span class="caret"></span>
			                        </button>
			                        <ul class="dropdown-menu">
			                        	<shiro:hasPermission name="hr:hrEmployee:edit">
			                        		<shiro:hasPermission name="hr:hrEmployee:edit">
				                        		<c:if test="${hrEmployee.status==0}">
				                        		<c:if test="${hrEmployee.regularStatus!=1}">
				                        		<li>
				                        			<a href="${ctx}/hr/hrEmployee/regularForm?id=${hrEmployee.id}">转正</a>
				                        		</li>
				                        		</c:if>
				                        		<li>
				                        			<a href="${ctx}/hr/hrPositionChange/form?hrEmployee.id=${hrEmployee.id}">调岗</a>
				                        		</li>
				                        		<li>
				                        			<a href="${ctx}/hr/hrSalaryChange/form?hrEmployee.id=${hrEmployee.id}">调薪</a>
				                        		</li>
				                        		<li>
				                        			<a href="${ctx}/hr/hrQuit/form?hrEmployee.id=${hrEmployee.id}">离职</a>
				                        		</li>
				                        		<li class="divider"></li>
				                        		<li>
				                        			<a href="${ctx}/hr/hrEmployee/form?id=${hrEmployee.id}">修改</a>
				                        		</li>
				                        		</c:if>
			                        		</shiro:hasPermission>
			                        		<%-- 
			                        		<shiro:hasPermission name="hr:hrEmployee:del">
				                        		<li>
				                        			<a href="${ctx}/hr/hrEmployee/delete?id=${hrEmployee.id}" onclick="return confirmx('确认要删除该员工信息吗？', this.href)">删除</a>
				                        		</li>
			                        		</shiro:hasPermission>
			                        		--%>
			                        	</shiro:hasPermission>
			                      	</ul>
			                      </div>
			                    <%--     
								<shiro:hasPermission name="hr:hrEmployee:view">
									<a href="${ctx}/hr/hrEmployee/index?id=${hrEmployee.id}" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
								</shiro:hasPermission>
								<shiro:hasPermission name="hr:hrEmployee:edit">
			    					<a href="${ctx}/hr/hrEmployee/form?id=${hrEmployee.id}" class="btn btn-success btn-xs" title="修改"><i class="fa fa-pencil"></i> 修改</a>
								</shiro:hasPermission>
								
								<shiro:hasPermission name="hr:hrEmployee:del">
									<a href="${ctx}/hr/hrEmployee/delete?id=${hrEmployee.id}" onclick="return confirmx('确认要删除该员工信息吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i> 删除</a> 
								</shiro:hasPermission>
								--%>    
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