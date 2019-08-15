<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>客户投诉列表</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		
	</script>
</head>
<body class="">
	<div class="">
		<div class="">
			<div class="row dashboard-header gray-bg">
				<h5>客户投诉 </h5>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 快速查询 -->
				<div class="row">
					<div class="col-sm-12">
						<div class="pull-left">	
							<div class="btn-group">
								<a class="btn btn-white btn-sm" href="${ctx}/scm/scmComplaint/list">全部</a>
								<a class="btn btn-white btn-sm" href="${ctx}/scm/scmComplaint/list?createBy.id=${fns:getUser().id}">我创建的</a>
								<a class="btn btn-white btn-sm" href="${ctx}/scm/scmComplaint/list?ownBy.id=${fns:getUser().id}">我负责的</a>
								<a class="btn btn-white btn-sm" href="${ctx}/scm/scmComplaint/list?beginCreateDate=${fns:getDate('yyyy-MM-dd')}&endCreateDate=${fns:getDayAfter(1)}">今日创建的</a>
								<a class="btn btn-white btn-sm" href="${ctx}/scm/scmComplaint/list?beginCreateDate=${fns:getDayAfter(-7)}&endCreateDate=${fns:getDayAfter(1)}">7天内创建的</a>
								<a class="btn btn-white btn-sm" href="${ctx}/scm/scmComplaint/list?beginCreateDate=${fns:getDayAfter(-30)}&endCreateDate=${fns:getDayAfter(1)}">30天内创建的</a>
							
								<a class="btn btn-white btn-sm" href="${ctx}/scm/scmComplaint/list?beginEndDate=${fns:getDate('yyyy-MM-dd')}&endEndDate=${fns:getDayAfter(1)}">今日到期的</a>
								<a class="btn btn-white btn-sm" href="${ctx}/scm/scmComplaint/list?beginEndDate=${fns:getDate('yyyy-MM-dd')}&endEndDate=${fns:getDayAfter(7)}">7天内到期的</a>
								<a class="btn btn-white btn-sm" href="${ctx}/scm/scmComplaint/list?beginEndDate=${fns:getDate('yyyy-MM-dd')}&endEndDate=${fns:getDayAfter(30)}">30天内到期的</a>
							</div>
						</div>
						<div class="pull-right">
						
							<button id="searchBtn" class="btn btn-white btn-sm" title="搜索"><i class="fa fa-search"></i> 搜索</button>
							
							<shiro:hasPermission name="scm:scmComplaint:add">
								<table:addRow url="${ctx}/scm/scmComplaint/form" title="客户投诉" pageModel="page"></table:addRow><!-- 增加按钮 -->
							</shiro:hasPermission>
							<%-- 
							<shiro:hasPermission name="scm:scmComplaint:edit">
							    <table:editRow url="${ctx}/scm/scmComplaint/form" title="客户投诉" id="contentTable" pageModel="page"></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="scm:scmComplaint:del">
								<table:delRow url="${ctx}/scm/scmComplaint/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							
							<shiro:hasPermission name="scm:scmComplaint:import">
								<table:importExcel url="${ctx}/scm/scmComplaint/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
							--%>
							<shiro:hasPermission name="scm:scmComplaint:export">
					       		<table:exportExcel url="${ctx}/scm/scmComplaint/export"></table:exportExcel><!-- 导出按钮 -->
					       	</shiro:hasPermission>
						</div>
					</div>
				</div>
				
				<!-- 查询条件 -->
				<div class="row m-t-sm">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="scmComplaint" action="${ctx}/scm/scmComplaint/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 查询栏 -->
								<div class="form-group"><span>主题：</span>
									<form:input path="name" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>订单合同：</span>
									<sys:tableselect id="omContract" name="omContract.id" value="${scmComplaint.omContract.id}" labelName="omContract.name" labelValue="${scmComplaint.omContract.name}" 
										title="订单" url="${ctx}/om/omContract/selectList" cssClass="form-control input-small" dataMsgRequired=""  allowClear="false" allowInput="false" disabled="disabled" />
							
								</div>
								<div class="form-group"><span>客户名称：</span>
									<form:input path="customer.name" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>负责人：</span>
									<sys:treeselect id="ownBy" name="ownBy.id" value="${scmComplaint.ownBy.id}" labelName="ownBy.name" labelValue="${scmComplaint.ownBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-small" dataMsgRequired="必选" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>优先级：</span>
									<form:select path="levelType" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('level_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>截止日期：</span>
									<div class="input-group date datepicker">
			                            <input name="beginEndDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${scmComplaint.beginEndDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
			                         - 
			                        <div class="input-group" data-autoclose="true">
			                        	 <input name="endEndDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${scmComplaint.endEndDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
			                            <span class="input-group-addon">
			                                    <span class="fa fa-calendar"></span>
			                            </span>
			                        </div>
								</div>
								<div class="form-group"><span>处理状态：</span>
									<form:select path="status" class="form-control input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('audit_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>满意度：</span>
									<form:select path="satisfyType" class="form-control input-small">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('satisfy_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group">
									<button class="btn btn-white btn-sm " onclick="search()"><i class="fa fa-search"></i> 查询</button>
									<button class="btn btn-white btn-sm " onclick="resetSearch()"><i class="fa fa-refresh"></i> 重置</button>
								</div>
						</form:form>
					</div>
				</div>
				
					
				<!-- 表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<th width="30px"><input type="checkbox" class="i-checks"></th>
							<th>主题</th>
							<th>订单合同</th>
							<th>客户</th>
							<th width="" class="sort-column a.own_by">负责人</th>
							<th width="" class="sort-column a.level_type">优先级</th>
							<th width="" class="sort-column a.end_date">截止日期</th>
							<th width="" class="sort-column a.status">处理状态</th>
							<th width="" class="sort-column a.deal_date">处理日期</th>
							<th width="" class="sort-column a.satisfy_type">满意度</th>
							<th width="" class="sort-column a.audit_by">审核人</th>
							<th width="" class="sort-column a.audit_date">审核日期</th>
							<th width="">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="scmComplaint">
						<tr>
							<td><input type="checkbox" id="${scmComplaint.id}" class="i-checks"></td>
							<td>
								<a href="${ctx}/scm/scmComplaint/view?id=${scmComplaint.id}">
								${scmComplaint.name}
							</a></td>
							<td>
								${scmComplaint.omContract.name}
							</td>
							<td>
								${scmComplaint.customer.name}
							</td>
							<td>
								${scmComplaint.ownBy.name}
							</td>
							<td>
								<span class="<c:if test='${scmComplaint.levelType == 2}'>badge badge-danger</c:if><c:if test='${scmComplaint.levelType == 1}'>badge badge-warning</c:if><c:if test='${scmComplaint.levelType == 0}'>badge badge-info</c:if>">
									${fns:getDictLabel(scmComplaint.levelType, 'level_type', '')}
								</span>
							</td>
							<td>
								<fmt:formatDate value="${scmComplaint.endDate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								<span class="<c:if test='${scmComplaint.status == 0}'>text-danger</c:if>">
									${fns:getDictLabel(scmComplaint.status, 'audit_status', '')}
								</span>
							</td>
							<td>
								<fmt:formatDate value="${scmComplaint.dealDate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								${fns:getDictLabel(scmComplaint.satisfyType, 'satisfy_type', '')}
							</td>
							<td>
								${scmComplaint.auditBy.name}
							</td>
							<td>
								<fmt:formatDate value="${scmComplaint.auditDate}" pattern="yyyy-MM-dd"/>
							</td>
							<td>
								<shiro:hasPermission name="scm:scmComplaint:view">
									<a href="${ctx}/scm/scmComplaint/view?id=${scmComplaint.id}" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> </a>
								</shiro:hasPermission>
								
								<c:if test="${scmComplaint.status == 0}">
								
								<shiro:hasPermission name="scm:scmComplaint:edit">
			    					<a href="${ctx}/scm/scmComplaint/form?id=${scmComplaint.id}" class="btn btn-success btn-xs" title="修改"><i class="fa fa-edit"></i><span class="hidden-xs"></span></a>
								</shiro:hasPermission>
								
								<shiro:hasPermission name="scm:scmComplaint:del">
									<a href="${ctx}/scm/scmComplaint/delete?id=${scmComplaint.id}" onclick="return confirmx('确认要删除该客户投诉吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i><span class="hidden-xs"></span></a> 
								</shiro:hasPermission>
								
								
								<shiro:hasPermission name="scm:scmComplaint:audit">
			    					<a href="${ctx}/scm/scmComplaint/auditForm?id=${scmComplaint.id}" class="btn btn-success btn-xs" title="审核"><i class="fa fa-check"></i><span class="hidden-xs"></span></a>
								</shiro:hasPermission>
								</c:if>
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