<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>打卡规则列表</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	</script>
</head>
<body class="">
	<div class="">
		<div class="">
			<div class="ibox-title">
				<h5>打卡规则列表 </h5>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>				
				<!-- 查询栏 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="hrCheckRule" action="${ctx}/hr/hrCheckRule/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 查询栏隐藏 -->
								
						</form:form>
					</div>
				</div>
				<!-- 工具栏 -->
				<div class="row">
					<div class="col-sm-12 m-b-sm">
						<div class="pull-left">
							<%--<shiro:hasPermission name="hr:hrCheckReport:add">
								<table:addRow url="${ctx}/hr/hrCheckRule/form" title="打卡规则表" pageModel="page"></table:addRow><!-- 增加按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="hr:hrCheckReport:edit">
							    <table:editRow url="${ctx}/hr/hrCheckRule/form" title="打卡规则表" id="contentTable" pageModel="page"></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="hr:hrCheckReport:del">
								<table:delRow url="${ctx}/hr/hrCheckRule/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="hr:hrCheckReport:import">
								<table:importExcel url="${ctx}/hr/hrCheckRule/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="hr:hrCheckReport:export">
					       		<table:exportExcel url="${ctx}/hr/hrCheckRule/export"></table:exportExcel><!-- 导出按钮 -->
					       	</shiro:hasPermission>--%>
							<a class="btn btn-white btn-sm" href="${ctx}/hr/hrCheckRule/synch" title="同步企业微信打卡规则"><i class="fa fa-repeat"></i> 同步企业微信打卡规则</a>
						</div>
					</div>
				</div>					
				<!-- 数据表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							
							<th>打卡名称</th>
							<th width="200px">打卡规则类型<%--。1：固定时间上下班；2：按班次上下班；3：自由上下班--%></th>
							<th width="200px">打卡日期</th>
							<th width="100px">操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${hrCheckRuleList}" var="hrCheckRule">
						<tr>
							
							<td>
								<a href="${ctx}/hr/hrCheckRule/view?id=${hrCheckRule.id}" title="查看">${hrCheckRule.groupname}</a>
							</td>
							<td>
								${fns:getDictLabel(hrCheckRule.groupType, 'check_rule_type', '')}
								
								
							</td>
							<td>
								${hrCheckRule.workdays}
								<c:if test="${hrCheckRule.workdays eq '[1,2,3,4,5]'}">周一至周五</c:if>
								<c:if test="${hrCheckRule.workdays eq '[1,2,3,4,5,6]'}">周一至周六</c:if>
								<c:if test="${hrCheckRule.workdays eq '[1,2,3,4,5,6,7]'}">周一至周日</c:if>
							</td>
							<td>
								<shiro:hasPermission name="hr:hrCheckReport:view">
									<a href="${ctx}/hr/hrCheckRule/view?id=${hrCheckRule.id}" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
								</shiro:hasPermission>
								<%--<shiro:hasPermission name="hr:hrCheckReport:edit">
			    					<a href="${ctx}/hr/hrCheckRule/form?id=${hrCheckRule.id}" class="btn btn-success btn-xs" title="修改"><i class="fa fa-pencil"></i> 修改</a>
								</shiro:hasPermission>
								
								<shiro:hasPermission name="hr:hrCheckReport:del">
									<a href="${ctx}/hr/hrCheckRule/delete?id=${hrCheckRule.id}" onclick="return confirmx('确认要删除该打卡规则表吗？', this.href)" class="btn btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i> 删除</a> 
								</shiro:hasPermission>--%>
							</td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
				
				</div>
			</div>
		</div>
	</div>
</body>
</html>