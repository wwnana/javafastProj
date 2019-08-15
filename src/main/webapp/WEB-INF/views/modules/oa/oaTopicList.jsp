<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>话题列表</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	</script>
</head>
<body class="gray-bg">
	<div class="wrapper-content">
		<div class="ibox">
			<div class="ibox-title">
				<h5>话题列表 </h5>
			</div>
			<div class="ibox-content">
			<sys:message content="${message}"/>				
				<!-- 查询栏 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="oaTopic" action="${ctx}/oa/oaTopic/" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
							<table:searchRow></table:searchRow><!-- 查询栏隐藏 -->
								<div class="form-group"><span>标题：</span>
									<form:input path="title" htmlEscape="false" maxlength="50" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>创建者：</span>
									<sys:treeselect id="createBy" name="createBy.id" value="${oaTopic.createBy.id}" labelName="createBy.name" labelValue="${oaTopic.createBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-small" allowClear="true" notAllowSelectParent="true"/>
								</div>
								<div class="form-group"><span>创建时间：</span>
									<div class="input-group date datepicker">
				                     	<input name="beginCreateDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${oaTopic.beginCreateDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
				                     	<span class="input-group-addon">
				                             <span class="fa fa-calendar"></span>
				                     	</span>
							        </div>
							         - 
							        <div class="input-group date datepicker">
				                     	<input name="endCreateDate" type="text" readonly="readonly" class="form-control input-small" value="<fmt:formatDate value="${oaTopic.endCreateDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
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
							<div class="btn-group">
								<button id="searchBtn" class="btn btn-white btn-sm" title="搜索"><i class="fa fa-search"></i></button>
								<table:refreshRow></table:refreshRow>
							</div>
						</div>
						<div class="pull-left">
							<shiro:hasPermission name="oa:oaTopic:list">
								<table:addRow url="${ctx}/oa/oaTopic/form" title="话题" pageModel="page" label="创建话题"></table:addRow><!-- 增加按钮 -->
							</shiro:hasPermission>
							<%--
							<shiro:hasPermission name="oa:oaTopic:edit">
							    <table:editRow url="${ctx}/oa/oaTopic/form" title="话题" id="contentTable" pageModel="page"></table:editRow><!-- 编辑按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="oa:oaTopic:del">
								<table:delRow url="${ctx}/oa/oaTopic/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="oa:oaTopic:import">
								<table:importExcel url="${ctx}/oa/oaTopic/import"></table:importExcel><!-- 导入按钮 -->
							</shiro:hasPermission>
							<shiro:hasPermission name="oa:oaTopic:export">
					       		<table:exportExcel url="${ctx}/oa/oaTopic/export"></table:exportExcel><!-- 导出按钮 -->
					       	</shiro:hasPermission>
					       	 --%>
						</div>
					</div>
				</div>					
				<!-- 数据表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<%-- <th><input type="checkbox" class="i-checks"></th>--%>
							<th class="sort-column a.title">标题</th>
							<th width="200px" class="sort-column a.create_by">创建者</th>
							<th width="200px" class="sort-column a.create_date">创建时间</th>
							<%--<th width="150px">操作</th>--%>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="oaTopic">
						<tr>
							<%--<td><input type="checkbox" id="${oaTopic.id}" class="i-checks"></td>--%>
							<td>
								<a href="${ctx}/oa/oaTopic/view?id=${oaTopic.id}" title="查看">
								${oaTopic.title}
							</a></td>
							<td>
								${oaTopic.createBy.name}
							</td>
							<td>
								<fmt:formatDate value="${oaTopic.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
							<%--
							<td>
								
								<c:if test="${fns:getUser().id == oaTopic.createBy.id}">
									<a href="${ctx}/oa/oaTopic/form?id=${oaTopic.id}" class="btn btn-success btn-xs" title="修改"><i class="fa fa-pencil"></i></a>
									<a href="${ctx}/oa/oaTopic/delete?id=${oaTopic.id}" onclick="return confirmx('确认要删除该话题吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i></a> 
								</c:if>
								
								
								<shiro:hasPermission name="oa:oaTopic:view">
									<a href="${ctx}/oa/oaTopic/view?id=${oaTopic.id}" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i></a>
								</shiro:hasPermission>
								<shiro:hasPermission name="oa:oaTopic:edit">
			    					<a href="${ctx}/oa/oaTopic/form?id=${oaTopic.id}" class="btn btn-success btn-xs" title="修改"><i class="fa fa-pencil"></i></a>
								</shiro:hasPermission>
								
								<shiro:hasPermission name="oa:oaTopic:del">
									<a href="${ctx}/oa/oaTopic/delete?id=${oaTopic.id}" onclick="return confirmx('确认要删除该话题吗？', this.href)" class="btn  btn-danger btn-xs" title="删除"><i class="fa fa-trash"></i></a> 
								</shiro:hasPermission>
							</td>
							--%>
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